#!/bin/env ipython

"""
Module with stuff related to controlling the AVN c09f12 spectrometer

"""

# Revision history:
# 0.3 - Modified power function to return abs(square()) values instead of just square() to ensure positive outputs.
# 0.2 - Updated by James Smith to include the fine FFT debug snap relevant bits. In this revision we discovered that the coarse FFT only retrieves one polarisation at a time, but the fine data is interleaved with both polarisations (I on 0, 2, etc. and Q on 1, 3, etc.) This version of the script doesn't do anything with them except retrieve and plot.
# 0.1 - Created by James Smith, contains functions relating to initialising the FPGA
#       and the coarse FFT debug snap scripts.

import corr, construct, numpy, time, struct
version_string = '0.3 (no date yet)'

snap_size = 8192 # Bytes, I think.
snap_word_size = 128 # Bits
coarse_fft_size = 256
fine_fft_size = 4096/4

# Bitstruct to control the control register on the ROACH
control_reg_bitstruct = construct.BitStruct('control_reg',
    construct.Padding(4),                           #28-31
    construct.BitField('debug_snap_select',3),      #25-27
    construct.Padding(3),                           #22-24
    construct.Flag('fine_tvg_en'),                  #21
    construct.Flag('adc_tvg'),                      #20
    construct.Flag('fd_fs_tvg'),                    #19
    construct.Flag('packetiser_tvg'),               #18
    construct.Flag('ct_tvg'),                       #17
    construct.Flag('tvg_en'),                       #16
    construct.Padding(4),                           #12-15
    construct.Flag('fancy_en'),                     #11
    construct.Flag('adc_protect_disable'),          #10
    construct.Flag('gbe_enable'),                   #09
    construct.Flag('gbe_rst'),                      #08
    construct.Padding(4),                           #04-07
    construct.Flag('clr_status'),                   #03
    construct.Flag('arm'),                          #02
    construct.Flag('man_sync'),                     #01
    construct.Flag('sys_rst') )                     #00

# Dictionary for selecting the debug_snap_select bit
debug_snap_select = {
    'coarse_72':   0,
    'fine_128':    1,
    'quant_16':    2,
    'ct_64':       3,
    'xaui_128':    4,
    'gbetx0_128':  5,
    'buffer_72':   6,
    'finepfb_72':  7 }

# Bitstruct to control the coarse_ctrl register on the ROACH
coarse_ctrl_reg_bitstruct = construct.BitStruct('coarse_ctrl',
    construct.Padding(4),                           #28-31
    construct.BitField('cdebug_chan',6),            #22-27
    construct.Flag('cdebug_chan_sel'),              #21
    construct.Flag('cdebug_pol_sel'),               #20
    construct.BitField('coarse_chan_select',10),    #10-19
    construct.BitField('coarse_fft_shift',10))      #0-9

# Bitstruct for pulling coarse FFT data from the debug snap block.
snap_fengine_debug_coarse_fft = construct.BitStruct('snap_debug',
    construct.Padding(snap_word_size - (4*18)),
    construct.BitField("d0_r", 18),
    construct.BitField("d0_i", 18),
    construct.BitField("d1_r", 18), # Worth noting here that d0 and d1 are neigbouring even and odd samples from a SINGLE polarity,
    construct.BitField("d1_i", 18)) # in contrast to the fine block.

snap_coarse_repeater = construct.GreedyRange(snap_fengine_debug_coarse_fft)

# Bitstruct for pulling fine FFT data from the debug snap block
snap_fengine_debug_fine_fft = construct.BitStruct('snap_debug',
    construct.Padding(snap_word_size - (4*31)),
    construct.BitField("d0_r", 31),
    construct.BitField("d0_i", 31), # In this block, d0 is a sample from the ADC's I input (LCP), while
    construct.BitField("d1_r", 31), # d1 is a sample from the ADC's Q input (RCP).
    construct.BitField("d1_i", 31))

snap_fine_repeater = construct.GreedyRange(snap_fengine_debug_fine_fft)

def uint2sint_coarse(uint):
    '''Return the correct signed value interpreted from the value interpreted as unsigned from the ROACH using the bit-lengths of the coarse FFT. Necessary because of signed values getting concatenated together to come through via the snap blocks.
    '''
    sint = uint
    if sint > 131072:
        sint -= 262144
    return sint

def uint2sint_fine(uint):
    '''Return the correct signed value interpreted from the value interpreted as unsigned from the ROACH using the bit-lengths of the fine FFT. Necessary because of signed values getting concatenated together to come through via the snap blocks.
    '''
    sint = uint
    if sint > 1073741824:
        sint -= 2147483648
    return sint


def ri2power(r, i, exp = 0):
    '''Return power (r^2 + i^2) given a real and imaginary variable
    '''
    return float(numpy.abs((numpy.square(r) + numpy.square(i))/(2**exp))) # Without the abs() this sometimes returned negative numbers. Wierdly, because it shouldn't have.

def trigger_snap(fpga, verbose=False):
    '''Write a posedge to the 'snap_debug_ctrl' register on the FPGA in order to start it up, then wait for it to be ready.
    '''
    if verbose:
        print "Triggering positive edge on snap_debug/ctrl..."
    fpga.write_int('snap_debug_ctrl',1) #bring this high to trigger capture
    time.sleep(1e-6)
    fpga.write_int('snap_debug_ctrl',0) #and take it low again
    snap_status = fpga.read_uint('snap_debug_status')
    if verbose:
        print "Waiting for snap to be ready..."
    while snap_status <> 16384:
        snap_status = fpga.read_uint('snap_debug_status')
    if verbose:
        print "Snap ready, proceed..."


def retrieve_coarse_FFT_snap(fpga, exp=17, verbose=False, tone_detection_level=1):
    '''Retrieve coarse FFT data from the fpga.
    Returns a numpy array with floating-point data in it, four frames' worth.

    @fpga is a corr.katcp_wrapper.FpgaClient object
    @exp is the power of 2 by which the power levels are divided before they're added to the accumulator
    @tone_detection_level is only important if verbose is true, because it'll flag a signal of greater value than whatever its value is (arbitrarily 1). Useful for debugging, if a tone from a synthesiser is input to the ADCs.
    '''
    #Charles had exp at 17 so I'm tentatively keeping it there...

    # LCP first

    if verbose:
        print 'Configuring control register to pass coarseFFT data to the snap_debug block...'
    control_reg = control_reg_bitstruct.parse(struct.pack('>I',fpga.read_uint('control')))
    control_reg.debug_snap_select = debug_snap_select['coarse_72']
    fpga.write_int('control', struct.unpack('>I', control_reg_bitstruct.build(control_reg))[0])

    if verbose:
        print 'Configuring coarse_ctrl register for LCP...'
    coarse_ctrl_reg = coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00') # Starting a clean one here, previous data not of interest.
    coarse_ctrl_reg.cdebug_pol_sel = 0 # Select I input (LCP)
    coarse_ctrl_reg.cdebug_chan_sel = 0 # Pass all the channels through to the debug
    coarse_ctrl_reg.coarse_fft_shift = 341 # 341 translates to 0101010101 in binary.
    fpga.write_int('coarse_ctrl',struct.unpack('>I', coarse_ctrl_reg_bitstruct.build(coarse_ctrl_reg))[0])

    if verbose:
        print 'Retrieving coarse FFT LCP snap data...'
    num_array = []
    LCP_accumulator = numpy.zeros(coarse_fft_size)
    trigger_snap(fpga, verbose=verbose)
    bram_data = snap_coarse_repeater.parse(fpga.read('snap_debug_bram',snap_size))

    for a in bram_data:
        num_array.append(ri2power(uint2sint_coarse(a['d0_r']), uint2sint_coarse(a['d0_i']), exp=exp))
        num_array.append(ri2power(uint2sint_coarse(a['d1_r']), uint2sint_coarse(a['d1_i']), exp=exp))

    LCP_accumulator += numpy.array(num_array[0:256])
    LCP_accumulator += numpy.array(num_array[256:512])
    LCP_accumulator += numpy.array(num_array[512:768])
    LCP_accumulator += numpy.array(num_array[768:1024])

    # Now for the RCP

    if verbose:
        print 'Configuring coarse_ctrl register for RCP...'
    coarse_ctrl_reg = coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00') # Starting a clean one here, previous data not of interest.
    coarse_ctrl_reg.cdebug_pol_sel = 1 # Select Q input (RCP)
    coarse_ctrl_reg.cdebug_chan_sel = 0 # Pass all the channels through to the debug
    coarse_ctrl_reg.coarse_fft_shift = 341 # 341 translates to 0101010101 in binary.
    fpga.write_int('coarse_ctrl',struct.unpack('>I', coarse_ctrl_reg_bitstruct.build(coarse_ctrl_reg))[0])

    if verbose:
        print 'Retrieving coarse FFT RCP snap data...'
    num_array = []
    RCP_accumulator = numpy.zeros(coarse_fft_size)
    trigger_snap(fpga, verbose=verbose)
    bram_data = snap_coarse_repeater.parse(fpga.read('snap_debug_bram',snap_size))

    for a in bram_data:
        num_array.append(ri2power(uint2sint_coarse(a['d0_r']), uint2sint_coarse(a['d0_i']), exp=exp))
        num_array.append(ri2power(uint2sint_coarse(a['d1_r']), uint2sint_coarse(a['d1_i']), exp=exp))

    RCP_accumulator += numpy.array(num_array[0:256])
    RCP_accumulator += numpy.array(num_array[256:512])
    RCP_accumulator += numpy.array(num_array[512:768])
    RCP_accumulator += numpy.array(num_array[768:1024])



    if verbose:
        for i in range(0,len(LCP_accumulator)):
            if LCP_accumulator[i] > tone_detection_level:
                print "Tone detected,LCP, bin %d, %f"%(i, LCP_accumulator[i])
            if RCP_accumulator[i] > tone_detection_level:
                print "Tone detected,RCP, bin %d, %f"%(i, LCP_accumulator[i])
        print 'Coarse FFT snap retrieval complete.'

    return LCP_accumulator, RCP_accumulator

# TODO: This function needs fixing!!!!! It's using the _size_ variable all wrongly.
# There's a perfectly good reason for this, I just haven't updated it as such yet, because I've only just recently figured out properly how it works.

def retrieve_fine_FFT_snap(fpga, exp=17, verbose=False, tone_detection_level=1000):
    '''Retrieve fine FFT data from the fpga.
    Returns a numpy array with floating-point data in it, half a frame's worth.

    @exp is the power of 2 by which the power levels are divided before they're added to the accumulator
    @tone_detection_level is only important if verbose is true, because it'll flag a signal of greater value than whatever its value is (arbitrarily 1). Useful for debugging, if a tone from a synthesiser is input to the ADCs.
    '''

    if verbose:
        print 'Retrieving fine FFT snap data...'

    num_array = []
    accumulator = numpy.zeros(fine_fft_size)
    trigger_snap(fpga, verbose=verbose)
    bram_data = snap_fine_repeater.parse(fpga.read('snap_debug_bram',snap_size))

    for a in bram_data:
        num_array.append(ri2power(uint2sint_fine(a['d0_r']), uint2sint_fine(a['d0_i']), exp=exp))
        if verbose:
            print '%d elements captured'%(len(num_array))
            if (ri2power(uint2sint_fine(a['d0_r']), uint2sint_fine(a['d0_i']), exp=17) > tone_detection_level):
                print 'Tone detected, bin %d, %f' %(len(num_array) - 1, num_array[-1])
        num_array.append(ri2power(uint2sint_fine(a['d1_r']), uint2sint_fine(a['d1_i']), exp=exp))
        if verbose:
            print '%d elements captured'%(len(num_array))
            if ((ri2power(uint2sint_fine(a['d1_r']), uint2sint_fine(a['d1_i']), exp=17)) > tone_detection_level):
                print 'Tone detected, bin %d, %f' %(len(num_array) - 1, num_array[-1])

    accumulator += numpy.array(num_array)

    if verbose:
        print 'Fine FFT snap retrieval complete.'

    return accumulator


if __name__ == '__main__':
    print 'This is version %s of the avn_spectrometer module.'%(version_string)


    #Things that may warrant further investigation in future versions:
    # pps_count and clk_frequency registers
    # adc_snap0 and adc_snap1 blocks
