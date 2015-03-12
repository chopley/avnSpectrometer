#!/bin/env ipython

"""
Module with stuff related to controlling the AVN c09f12 spectrometer

"""

# Revision history:
# 0.2 - Updated by James Smith to include the fine FFT debug snap relevant bits. In this revision we discovered that the coarse FFT only retrieves one polarisation at a time, but the fine data is interleaved with both polarisations (I on 0, 2, etc. and Q on 1, 3, etc.) This version of the script doesn't do anything with them except retrieve and plot.
# 0.1 - Created by James Smith, contains functions relating to initialising the FPGA
#       and the coarse FFT debug snap scripts.

import construct, numpy, time, struct
version_string = '0.2 (09 March 2015)'

snap_size = 8192 # Bytes, I think.
snap_word_size = 128 # Bits
coarse_fft_size = 256
fine_fft_size = 2048/2
    
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
    construct.BitField("d1_r", 18),
    construct.BitField("d1_i", 18))
    
snap_coarse_repeater = construct.GreedyRange(snap_fengine_debug_coarse_fft)

# Bitstruct for pulling fine FFT data from the debug snap block
snap_fengine_debug_fine_fft = construct.BitStruct('snap_debug',
    construct.Padding(snap_word_size - (4*31)),
    construct.BitField("d0_r", 31),
    construct.BitField("d0_i", 31),
    construct.BitField("d1_r", 31),
    construct.BitField("d1_i", 31))

snap_fine_repeater = construct.GreedyRange(snap_fengine_debug_fine_fft)

def return_uint32(x):
    '''Return a uint32 value (which can be written to the FPGA's registers) from a bitstruct (which can't be written directly).
    
    @x is a bitfield which should be passed the output of the "build()" function from the constructs.
    '''
    #TODO: might want to figure out how to do the reverse of this...
    return struct.unpack('>I',x)[0] # [0] because for some reason struct.unpack returns a tuple.

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
    return float(numpy.square(r) + numpy.square(i))/(2**exp)

def trigger_snap(fpga, verbose=False):
    '''Write a posedge to the 'snap_debug_ctrl' register on the FPGA in order to start it up, then wait for it to be ready.
    '''
    if verbose:
        print "Triggering positive edge on snap_debug/ctrl..."
    fpga.write_int('snap_debug_ctrl',1) #bring this high to trigger capture
    time.sleep(0.01)
    fpga.write_int('snap_debug_ctrl',0) #and take it low again
    snap_status = fpga.read_uint('snap_debug_status')
    if verbose:
        print "Waiting for snap to be ready..."
    while snap_status <> 16384:
        snap_status = fpga.read_uint('snap_debug_status')
    if verbose:
        print "Snap ready, proceed..."

def retrieve_coarse_FFT_snap(fpga, exp=17, verbose=False, tone_detection_level=1, super_verbose=False):
    '''Retrieve coarse FFT data from the fpga.
    Returns a numpy array with floating-point data in it, four frames' worth.
    
    @exp is the power of 2 by which the power levels are divided before they're added to the accumulator
    @tone_detection_level is only important if verbose is true, because it'll flag a signal of greater value than whatever its value is (arbitrarily 1). Useful for debugging, if a tone from a synthesiser is input to the ADCs.
    @super_verbose spits far too much data out, useful to check whether the snap blocks are being filled with numbers as expected.
    '''
    #Charles had exp at 17 so I'm tentatively keeping it there...
    
    if verbose:
        print 'Retrieving coarse FFT snap data...'
    
    num_array = []
    accumulator = numpy.zeros(coarse_fft_size)
    bram_data = snap_coarse_repeater.parse(fpga.read('snap_debug_bram',snap_size))
       
    for a in bram_data:
        num_array.append(ri2power(uint2sint_coarse(a['d0_r']), uint2sint_coarse(a['d0_i']), exp=exp))
        num_array.append(ri2power(uint2sint_coarse(a['d1_r']), uint2sint_coarse(a['d1_i']), exp=exp))
   
    accumulator += numpy.array(num_array[0:256])
    if super_verbose:
        print num_array[0]
    accumulator += numpy.array(num_array[256:512])
    if super_verbose:
        print num_array[256]
    accumulator += numpy.array(num_array[512:768])
    if super_verbose:
        print num_array[512]
    accumulator += numpy.array(num_array[768:1024])
    if super_verbose:
        print num_array[768]
    
    if verbose:
        for i in range(0,len(accumulator)):
            if accumulator[i] > tone_detection_level:
                print "Tone detected, bin %d, %f"%(i, accumulator[i])
        print 'Coarse FFT snap retrieval complete.'
    
    return accumulator

def retrieve_fine_FFT_snap(fpga, exp=17, verbose=False, tone_detection_level=20000, super_verbose=False):
    '''Retrieve fine FFT data from the fpga.
    Returns a numpy array with floating-point data in it, half a frame's worth.
    
    @exp is the power of 2 by which the power levels are divided before they're added to the accumulator
    @tone_detection_level is only important if verbose is true, because it'll flag a signal of greater value than whatever its value is (arbitrarily 1). Useful for debugging, if a tone from a synthesiser is input to the ADCs.
    @super_verbose spits far too much data out, useful to check whether the snap blocks are being filled with numbers as expected.
    '''
    
    if verbose:
        print 'Retrieving fine FFT snap data...'
    
    num_array = []
    accumulator = numpy.zeros(fine_fft_size)
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
            if super_verbose:
                print a # Not necessary unless you _really_ need detailed information about what's going on.
            if ((ri2power(uint2sint_fine(a['d1_r']), uint2sint_fine(a['d1_i']), exp=17)) > tone_detection_level):
                print 'Tone detected, bin %d, %f' %(len(num_array) - 1, num_array[-1])
    
    accumulator += numpy.array(num_array)
    if super_verbose:
        print num_array[0]
    
    if verbose:
        print 'Fine FFT snap retrieval complete.'
    
    return accumulator


if __name__ == '__main__':
    print 'This is version %s of the avn_spectrometer module.'%(version_string)
    
    
#Things that may warrant further investigation in future versions:
# pps_count and clk_frequency registers
# adc_snap0 and adc_snap1 blocks 
