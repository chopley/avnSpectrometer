#!/bin/env ipython

"""
Module with stuff related to controlling the AVN c09f12 spectrometer

"""

# Revision history:
# 0.5 - Added a few misc things to enable capturing some more data from the ROACH for debugging and commissioning purposes. No changes to existing stuff.
# 0.4 - Revised both the Coarse and the Fine FFT snap functions to retrieve and return both polarities. Also included snap triggering functionality within the aforementioned functions, so that the user doesn't have to do it manually.
# 0.3 - Modified power function to return abs(square()) values instead of just
#       square() to ensure positive outputs.
# 0.2 - Updated by James Smith to include the fine FFT debug snap relevant bits. In this revision we discovered that the coarse FFT only retrieves one polarisation at a time, but the fine data is interleaved with both polarisations (I on 0, 2, etc. and Q on 1, 3, etc.) This version of the script doesn't do anything with them except retrieve and plot.
# 0.1 - Created by James Smith, contains functions relating to initialising the FPGA
#       and the coarse FFT debug snap scripts.

import corr, construct, numpy, time, struct, sys
version_string = '0.5 (24 March 2015)'

snap_word_size = 128 # Bits.
snap_size = 2**10 * snap_word_size / 8 # 2^10 = 1024 samples of 128 bits (/8 to get bytes).  BitStructs describing these detailed below.
snap_size_adc = 4096
coarse_fft_size = 256 # Frequency bins
fine_fft_size = 4096 # Frequency bins
offset_shift_size = snap_size # For the fine FFT, when the whole thing can't be measured at once.
num_offset_shifts = 4 # In case this later needs to be changed, perhaps for a different size fine FFT.

# Variables relevant only to the corner turner
snaps_per_spectrum = 128
channels_per_snap = 32
words_per_channel = 32

# Bitstruct to control the control register on the ROACH
# Each bit documented on Google Drive.
control_reg_bitstruct = construct.BitStruct('control_reg',
    construct.Padding(4),                           # 28-31
    construct.BitField('debug_snap_select',3),      # 25-27
    construct.Padding(3),                           # 22-24
    construct.Flag('fine_tvg_en'),                  # 21
    construct.Flag('adc_tvg'),                      # 20
    construct.Flag('fd_fs_tvg'),                    # 19
    construct.Flag('packetiser_tvg'),               # 18
    construct.Flag('ct_tvg'),                       # 17
    construct.Flag('tvg_en'),                       # 16
    construct.Padding(4),                           # 12-15
    construct.Flag('fancy_en'),                     # 11
    construct.Flag('adc_protect_disable'),          # 10
    construct.Flag('gbe_enable'),                   # 09
    construct.Flag('gbe_rst'),                      # 08
    construct.Padding(4),                           # 04-07
    construct.Flag('clr_status'),                   # 03
    construct.Flag('arm'),                          # 02
    construct.Flag('man_sync'),                     # 01
    construct.Flag('sys_rst') )                     # 00

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
    construct.BitField('d0_r', 18),
    construct.BitField('d0_i', 18),
    construct.BitField('d1_r', 18), # Worth noting here that d0 and d1 are neigbouring even and odd samples from a SINGLE polarity,
    construct.BitField('d1_i', 18)) # in contrast to the fine block.

snap_coarse_repeater = construct.GreedyRange(snap_fengine_debug_coarse_fft)

# Bitstruct for pulling fine FFT data from the debug snap block
snap_fengine_debug_fine_fft = construct.BitStruct('snap_debug',
    construct.Padding(snap_word_size - (4*31)),
    construct.BitField('d0_r', 31),
    construct.BitField('d0_i', 31), # In this block, d0 is a sample from the ADC's I input (LCP), while
    construct.BitField('d1_r', 31), # d1 is a sample from the ADC's Q input (RCP).
    construct.BitField('d1_i', 31))

snap_fine_repeater = construct.GreedyRange(snap_fengine_debug_fine_fft)

# Bitstruct for pulling quantiser data from the debug snap block.
snap_fengine_debug_quant = construct.BitStruct('snap_debug',
    construct.Padding(snap_word_size - 16),
    construct.BitField('p0_r', 4),
    construct.BitField('p0_i', 4),
    construct.BitField('p1_r', 4),
    construct.BitField('p1_i', 4))

snap_fengine_debug_quant_repeater = construct.GreedyRange(snap_fengine_debug_quant)

# Bitstruct for pulling corner-turner data from the debug snap block
snap_fengine_debug_ct = construct.BitStruct('snap_debug',
    construct.Padding(snap_word_size - 64),
    construct.BitField("p00_r", 4), construct.BitField("p00_i", 4), construct.BitField("p10_r", 4), construct.BitField("p10_i", 4),
    construct.BitField("p01_r", 4), construct.BitField("p01_i", 4), construct.BitField("p11_r", 4), construct.BitField("p11_i", 4),
    construct.BitField("p02_r", 4), construct.BitField("p02_i", 4), construct.BitField("p12_r", 4), construct.BitField("p12_i", 4),
    construct.BitField("p03_r", 4), construct.BitField("p03_i", 4), construct.BitField("p13_r", 4), construct.BitField("p13_i", 4))

snap_fengine_debug_ct_repeater = construct.GreedyRange(snap_fengine_debug_ct)

# Bitstruct for getting stuff from the ADC snap blocks
snap_fengine_adc = construct.BitStruct('adc_snap',
    construct.BitField('d0_0', 8), # 1st sample (they arrive 4-at-a-time of 8-bit samples, remember?
    construct.BitField('d0_1', 8), # 2nd sample
    construct.BitField('d0_2', 8), # 3rd sample
    construct.BitField('d0_3', 8), # 4th sample
    construct.BitField('d1_0', 8), # 5th sample
    construct.BitField('d1_1', 8), # 6th sample
    construct.BitField('d1_2', 8), # 7th sample
    construct.BitField('d1_3', 8)) # 8th sample

snap_fengine_adc_repeater = construct.GreedyRange(snap_fengine_adc)

# status register
register_fengine_fstatus = construct.BitStruct('fstatus0',
    construct.BitField('coarse_bits', 5),       # 27-31 2^x - the number of points in the coarse FFT.
    construct.BitField('fine_bits', 5),         # 22-26 2^y - the number of points in the fine FFT.
    construct.BitField('sync_val', 2),          # 20-21 On which ADC cycle did the sync happen?
    construct.Padding(2),                       # 18-19
    construct.Flag('xaui_lnkdn'),               # 17    The 10GBE link is down.
    construct.Flag('xaui_over'),                # 16    The 10GBE link has overflows.
    construct.Padding(9),                       # 7-15
    construct.Flag('clk_err'),                  # 6     The board frequency is calculated out of bounds.
    construct.Flag('adc_disabled'),             # 5     The ADC has been disabled.
    construct.Flag('ct_error'),                 # 4     There is a QDR error from the corner-turner.
    construct.Flag('adc_overrange'),            # 3     The ADC is reporting over-ranging.
    construct.Flag('fine_fft_overrange'),       # 2     Not used currently.
    construct.Flag('coarse_fft_overrange'),     # 1     The coarse FFT is over-range.
    construct.Flag('quant_overrange'))          # 0     The quantiser is over-range.


def uint2sint_coarse(uint):
    '''Return the correct signed value interpreted from the value interpreted as unsigned from the ROACH using the bit-lengths of the coarse FFT. Necessary because of signed values getting concatenated together to come through via the snap blocks.
    '''
    sint = uint
    if sint >= 131072:
        sint -= 262144
    return sint

def uint2sint_fine(uint):
    '''Return the correct signed value interpreted from the value interpreted as unsigned from the ROACH using the bit-lengths of the fine FFT. Necessary because of signed values getting concatenated together to come through via the snap blocks.
    '''
    sint = uint
    if sint >= 1073741824:
        sint -= 2147483648
    return sint

def us4(uint):
    '''Return correct signed value for a 4-bit number.
    '''
    sint = uint
    if sint >= 8:
        sint -= 16
    return sint

def ri2power(r, i, exp = 0):
    '''Return power (r^2 + i^2) given a real and imaginary variable
    '''
    return float(numpy.abs((numpy.square(r) + numpy.square(i))/(2<<exp))) # Without the abs() this sometimes returned negative numbers. No idea why, possibly something done wrong in previous iterations. Not too expensive computationally though so left in for the time being.

def trigger_snap(fpga, verbose=False):
    '''Write a posedge to the 'snap_debug_ctrl' register on the FPGA in order to start it up, then wait for it to be ready.
    '''
    if verbose:
        print 'Triggering positive edge on snap_debug/ctrl...'
    fpga.write_int('snap_debug_ctrl',1) #bring this high to trigger capture
    time.sleep(1e-6)
    fpga.write_int('snap_debug_ctrl',0) #and take it low again
    snap_status = fpga.read_uint('snap_debug_status')
    if verbose:
        print 'Waiting for snap to be ready...'
    while snap_status <> 16384:
        snap_status = fpga.read_uint('snap_debug_status')
    if verbose:
        print 'Snap ready, proceed...'


def retrieve_coarse_FFT_snap(fpga, exp=17, verbose=False, tone_detection_level=1):
    '''Retrieve coarse FFT data from the fpga.
    Returns two numpy arrays with floating-point data, four frames' worth of LCP and RCP in that order.

    @fpga is a corr.katcp_wrapper.FpgaClient object
    @exp is the power of 2 by which the power levels are divided before they're added to the accumulator
    @tone_detection_level is only important if verbose is true, because it'll flag a signal of greater value than whatever its value is (arbitrarily 1). Useful for debugging, if a tone from a synthesiser is input to the ADCs.
    '''
    # Default exp=17 selected heuristically, no specific reason for it at this stage.

    # LCP first

    if verbose:
        print 'Configuring control register to pass coarseFFT data to the snap_debug block...'
    # GENERAL REGISTER WRITING PROCEDURE: Read the value of the control register so that only the necessary bits are changed,
    # modify the bits necessary, and write the number back into the register.
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
    LCP = numpy.zeros(coarse_fft_size)
    trigger_snap(fpga, verbose=verbose)
    bram_data = snap_coarse_repeater.parse(fpga.read('snap_debug_bram',snap_size))

    for a in bram_data:
        num_array.append(ri2power(uint2sint_coarse(a['d0_r']), uint2sint_coarse(a['d0_i']), exp=exp))
        num_array.append(ri2power(uint2sint_coarse(a['d1_r']), uint2sint_coarse(a['d1_i']), exp=exp))

    LCP += numpy.array(num_array[0:256])
    LCP += numpy.array(num_array[256:512])
    LCP += numpy.array(num_array[512:768])
    LCP += numpy.array(num_array[768:1024])

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
    RCP = numpy.zeros(coarse_fft_size)
    trigger_snap(fpga, verbose=verbose)
    bram_data = snap_coarse_repeater.parse(fpga.read('snap_debug_bram',snap_size))

    for a in bram_data:
        num_array.append(ri2power(uint2sint_coarse(a['d0_r']), uint2sint_coarse(a['d0_i']), exp=exp))
        num_array.append(ri2power(uint2sint_coarse(a['d1_r']), uint2sint_coarse(a['d1_i']), exp=exp))

    RCP += numpy.array(num_array[0:256])
    RCP += numpy.array(num_array[256:512])
    RCP += numpy.array(num_array[512:768])
    RCP += numpy.array(num_array[768:1024])

    if verbose:
        for i in range(0,len(LCP)):
            if LCP[i] > tone_detection_level:
                print 'Tone detected,LCP, bin %d, %f'%(i, LCP[i])
            if RCP[i] > tone_detection_level:
                print 'Tone detected,RCP, bin %d, %f'%(i, LCP[i])
        print 'Coarse FFT snap retrieval complete.'

    return LCP, RCP

def retrieve_fine_FFT_snap(fpga, coarse_channel, exp=17, verbose=False, tone_detection_level=10000):
    '''Retrieve fine FFT data from the fpga.
    Returns two fft_length numpy arrays, LCP and RCP, in that order.

    @tone_detection_level is only important if verbose is true, because it'll flag a signal of greater value than whatever its value is (arbitrarily 1). Useful for debugging, if a tone from a synthesiser is input to the ADCs.
    @exp As in the coarse function, this is the power of two by which the numbers are divided before they come out, otherwise they get very very large.
    '''

    if verbose:
        print 'Configuring control to pass fine_128 channel to snap...'
        sys.stdout.flush()
    control_reg = control_reg_bitstruct.parse(struct.pack('>I',fpga.read_uint('control')))
    control_reg.debug_snap_select = debug_snap_select['fine_128']
    fpga.write_int('control', struct.unpack('>I',control_reg_bitstruct.build(control_reg))[0])

    if verbose:
        print 'Configuring coarse_ctrl to pass channel %d...'%(coarse_channel)
        sys.stdout.flush()
    coarse_ctrl_reg = coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00')
    coarse_ctrl_reg.coarse_chan_select = coarse_channel
    coarse_ctrl_reg.coarse_fft_shift = 341 # 101010101 in binary
    fpga.write_int('coarse_ctrl', struct.unpack('>I', coarse_ctrl_reg_bitstruct.build(coarse_ctrl_reg))[0])

   # Still don't know about this one. Need to characterise properly.
    fpga.write_int('fine_ctrl',0)

    LCP = []
    RCP = []

    for offset_shift_counter in range(0,num_offset_shifts):
        if verbose:
            print 'Section %d'%(offset_shift_counter)
        fpga.write_int('snap_debug_trig_offset',offset_shift_counter*offset_shift_size)
        trigger_snap(fpga, verbose=verbose)
        bram_data = snap_fine_repeater.parse(fpga.read('snap_debug_bram',snap_size))

        for a in bram_data:
            LCP.append(ri2power(uint2sint_fine(a['d0_r']), uint2sint_fine(a['d0_i']), exp=exp))
            RCP.append(ri2power(uint2sint_fine(a['d1_r']), uint2sint_fine(a['d1_i']), exp=exp))
            if verbose:
                print '%d LCP/RCP elements captured'%(len(LCP))
                if ((ri2power(uint2sint_fine(a['d0_r']), uint2sint_fine(a['d0_i']), exp=17)) > tone_detection_level):
                    print 'Tone detected, LCP fine bin %d, %f' %(len(LCP) - 1, LCP[-1])
                if ((ri2power(uint2sint_fine(a['d1_r']), uint2sint_fine(a['d1_i']), exp=17)) > tone_detection_level):
                    print 'Tone detected, RCP fine bin %d, %f' %(len(RCP) - 1, RCP[-1])

    LCP = numpy.array(LCP)
    RCP = numpy.array(RCP)

    if verbose:
        print 'Fine FFT snap retrieval complete.'

    return LCP, RCP

def retrieve_adc_snap(fpga, verbose=False):
    '''Retrieve the raw ADC data from the ADC snap blocks.
    '''
    if verbose:
        print 'Triggering positive edge on adc_snap0 and 1/ctrl...'
    fpga.write_int('adc_snap0_ctrl',1) #bring this high to trigger capture
    fpga.write_int('adc_snap1_ctrl',1)
    time.sleep(1e-6)
    fpga.write_int('adc_snap0_ctrl',0) #and take it low again
    fpga.write_int('adc_snap1_ctrl',0)
    snap_status = fpga.read_uint('adc_snap0_status')
    if verbose:
        print 'Waiting for snap to be ready...'
    while snap_status <> 4096: # It's a bit smaller in this block.
        snap_status = fpga.read_uint('adc_snap0_status')
    adc_LCP = snap_fengine_adc_repeater.parse(fpga.read('adc_snap0_bram',snap_size_adc))

    snap_status = fpga.read_uint('adc_snap1_status') # Just in case the other one isn't ready at the same time.
    while snap_status <> 4096:
        snap_status = fpga.read_uint('adc_snap1_status')
    adc_RCP = snap_fengine_adc_repeater.parse(fpga.read('adc_snap1_bram',snap_size_adc))

    if verbose:
        print 'Snap complete.'


    LCP_timestream = []
    RCP_timestream = []

    for a in adc_LCP:
        LCP_timestream.append(a.d0_0)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d0_1)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d0_2)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d0_3)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d1_0)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d1_1)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d1_2)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        LCP_timestream.append(a.d1_3)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8

    for a in adc_RCP:
        RCP_timestream.append(a.d0_0)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d0_1)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d0_2)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d0_3)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d1_0)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d1_1)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d1_2)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8
        RCP_timestream.append(a.d1_3)
        if (LCP_timestream[-1] >= 2**7):
            LCP_timestream[-1] -= 2**8

    return LCP_timestream, RCP_timestream

def retrieve_quant_snap(fpga, coarse_channel, verbose=False):
    '''Retrieve quantiser debug data from the FPGA.
    '''

    if verbose:
        print 'Configuring control register to pass quantiser data to the snap_debug block...'
    control_reg = control_reg_bitstruct.parse(struct.pack('>I',fpga.read_uint('control')))
    control_reg.debug_snap_select = debug_snap_select['quant_16']
    fpga.write_int('control', struct.unpack('>I', control_reg_bitstruct.build(control_reg))[0])

    if verbose:
        print 'Configuring coarse_ctrl to pass channel %d through...'%(coarse_channel)
    coarse_ctrl_reg = coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00') # Starting a clean one here, previous data not of interest.
    coarse_ctrl_reg.coarse_fft_shift = 341 # 341 translates to 0101010101 in binary.
    coarse_ctrl_reg.coarse_chan_select = coarse_channel
    fpga.write_int('coarse_ctrl',struct.unpack('>I', coarse_ctrl_reg_bitstruct .build(coarse_ctrl_reg))[0])
    fpga.write_int

    if verbose:
        print 'Retrieving quantiser snap data...'
    left_data = []
    right_data = []

    for offset_shift_counter in range(0,num_offset_shifts):
    #for offset_shift_counter in range(0,1):
        if verbose:
            print 'Section %d'%(offset_shift_counter)
        fpga.write_int('snap_debug_trig_offset',offset_shift_counter*offset_shift_size)
        trigger_snap(fpga, verbose=verbose)
        bram_data = snap_fengine_debug_quant_repeater .parse(fpga.read('snap_debug_bram',snap_size))

        for a in bram_data:
            left_r = a['p0_r']
            if left_r >= 8:
                left_r -= 16
            left_i = a['p0_i']
            if left_i >= 8:
                left_i -= 16
            left = left_r + left_i*1j
            left_data.append(left)

            right_r = a['p1_r']
            if right_r >= 8:
                right_r -= 16
            right_i = a['p1_i']
            if right_i >= 8:
                right_i -= 16
            right = right_r + right_i*1j
            right_data.append(right)

    print 'Quantiser snap retrieval complete.'

    return left_data, right_data

def retrieve_ct_snap(fpga, coarse_channel, verbose=False):
    '''Retrieve corner turner debug data from the FPGA.
    This function needs to be completely rewritten as I'd misunderstood the logic behind the thing with it.
    '''

    if verbose:
        print 'Configuring control register to pass corner turner data to the snap_debug block...'
    control_reg = control_reg_bitstruct.parse(struct.pack('>I',fpga.read_uint('control')))
    control_reg.debug_snap_select = debug_snap_select['ct_64']
    fpga.write_int('control', struct.unpack('>I', control_reg_bitstruct.build(control_reg))[0])

    if verbose:
        print 'Configuring coarse_ctrl to pass channel %d through...'%(coarse_channel)
    coarse_ctrl_reg = coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00') # Starting a clean one here, previous data not of interest.
    coarse_ctrl_reg.coarse_fft_shift = 341 # 341 translates to 0101010101 in binary.
    coarse_ctrl_reg.coarse_chan_select = coarse_channel
    fpga.write_int('coarse_ctrl',struct.unpack('>I', coarse_ctrl_reg_bitstruct .build(coarse_ctrl_reg))[0])
    fpga.write_int

    if verbose:
        print 'Retrieving corner turner snap data... (Be patient. This may take a while.)'
    spectrum_left = []
    spectrum_right = []

    for offset_shift_counter in range(0,snaps_per_spectrum):
        if verbose:
            print 'Section %d'%(offset_shift_counter)

        fpga.write_int('snap_debug_trig_offset',offset_shift_counter*offset_shift_size)
        trigger_snap(fpga, verbose=verbose)
        bram_data = snap_fengine_debug_ct_repeater.parse(fpga.read('snap_debug_bram',snap_size))

        for channel in range(0, channels_per_snap):

            channel_left = 0+0j
            channel_right = 0+0j

            for word in range(0, words_per_channel):
                current_index = channel*words_per_channel + word

                p00 = us4(bram_data[current_index].p00_r) + us4(bram_data[current_index].p00_i)*1j
                p01 = us4(bram_data[current_index].p01_r) + us4(bram_data[current_index].p01_i)*1j
                p02 = us4(bram_data[current_index].p02_r) + us4(bram_data[current_index].p02_i)*1j
                p03 = us4(bram_data[current_index].p03_r) + us4(bram_data[current_index].p03_i)*1j
                channel_left += (p00 + p01 + p02 + p03)

                p10 = us4(bram_data[current_index].p10_r) + us4(bram_data[current_index].p10_i)*1j
                p11 = us4(bram_data[current_index].p11_r) + us4(bram_data[current_index].p11_i)*1j
                p12 = us4(bram_data[current_index].p12_r) + us4(bram_data[current_index].p12_i)*1j
                p13 = us4(bram_data[current_index].p13_r) + us4(bram_data[current_index].p13_i)*1j
                channel_right += (p10 + p11 + p12 + p13)

            spectrum_left.append(channel_left)
            spectrum_right.append(channel_right)

    if verbose:
        print 'Corner turner snap retrieval complete.'

    return spectrum_left, spectrum_right

def calculate_RMS(data):
    '''Return the RMS value of the data passed to it.
    @data is frequency-domain data! See the following URL for an explanation of the subtle
    difference between freq. and time-domain RMS calculation:
    https://en.wikipedia.org/wiki/Root_mean_square#RMS_in_frequency_domain
    '''
    data_RMS = numpy.sqrt( (abs(data**2)).sum()/(len(data)**2) )
    return data_RMS

# This comes from the original corr files but I've modified it to take an extra parameter.
def setGainCoefficients(fpga, coeffs):
    '''Set gain coefficients for the quantiser.
    '''

    bramwUnsignedLong(fpga, 'eq0', coeffs, 2**12)
    bramwUnsignedLong(fpga, 'eq1', coeffs, 2**12)

## These functions come from Charles's scripts: I've copited them as-is and not really looked too closely.
## I corrected the indentation and added docstrings though.
def bramw(fpga,bname,odata,samples=1024):
    '''Write 16-bit signed int data to the bram using blindwrite.
    '''
    b_0=struct.pack('>'+str(samples)+'h',*odata) # The asterisk unpacks the arguments: https://docs.python.org/2/tutorial/controlflow.html#unpacking-argument-lists
    fpga.blindwrite(bname,b_0)

def bramwUnsignedLong(fpga,bname,odata,samples=1024):
    '''Write 32-bit unsigned int data to the bram.
    '''
    b_0=struct.pack('>'+str(samples)+'I',*odata)
    fpga.blindwrite(bname,b_0)

def readBram(fpga,bram,size):
    '''Read @size amount of data from @bram on @fpga.
    '''
    a=fpga.read(bram,size,0)
    return a

if __name__ == '__main__':
    print 'This is version %s of the avn_spectrometer module.'%(version_string)


    #Things that may warrant further investigation in future versions:
    # pps_count and clk_frequency registers
    # adc_snap0 and adc_snap1 blocks
