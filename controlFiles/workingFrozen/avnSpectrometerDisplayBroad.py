#!/bin/env ipython

"""Displays a debug-version of the AVN wideband spectrometer, with data
from the coarse FFT and a selected fine FFT channel. The data is retrieved
via the snap_debug block.

The data is stored in numpy binary format along with a png of the displayed
plot. Along with the data is the output from the status registers and other
potentially useful debug information in human-readable text format. Results
from each accumulation are stored in timestamped folders for ease of sorting.

Suggested flags:
-c <channel> -e -v -T <snap recording interval>
"""
# For those trying to understand the inner workings of the script:
# I've tried to include enough information in the "verbose" messages
# that you can read them through and get a pretty good understanding
# of what's going on.

# Revision History:
# 17 March 2015 - James Smith - Initial version, assembled from three other scripts which I'd written previously for doing just this.
# 19 March 2015 - James Smith - Adapted to display a wider array of fine FFT samples, mostly for debugging purposes.
# 23 March 2015 - James Smith - Added the following functionality:
#   - write the results out to text files,
#   - turn on or off broad snapping (i.e. snap only the selected channel and not the four around it),
#   - read from the ADC's snap blocks, not graphing that but writing it to log files, and
#   - reading from and logging a few of the status registers with each capture.
# 14 April 2015 - JNS - Exported a PNG of the plot at the end of each round of data collection
#   - Changed text format to np binaries, uses only about 1/3 of the hard drive space.
#   - Added recording of ADC attenuation level and which coarse channel is being passed as well.
# 15 May 2015 - JNS - Went through everything with a fine-toothed comb to make sure it's understandable
#                     to the uninitiated. No functional changes.

# Suggestions for future developments: Figure out how that logging thing works.

import corr
import time
import sys
import logging
import struct
import os
import numpy as np
import avn_spectrometer as avn
import matplotlib.pyplot as plt

#boffile = 'c09f12_12avn_2015_Feb_25_1753.bof' # Original working bof file. A bit slow but we're confident of the data that it produces.
#boffile = 'c09f12_16avn_2015_Mar_11_1756.bof' # Charles's modified one. Reads snap blocks more frequently but somehow misaligns the data. I (JNS) modified it sligtly to try and rectify this but then timing wouldn't work, and I haven't had the courage to face that hurdle quite yet.
#boffile = 'c09f12_17avn_2015_Mar_13_1459.bof' #Faster but blocks misaligned still.
#boffile = 'c09f12_20avn_2015_Mar_23_1236.bof' #Still two bins out, but this time on the other side.
#boffile = 'c09f12_21avn_2015_Mar_23_1645.bof' # Correct bin!
boffile = 'c09f12_22avn_2015_Apr_21_1313.bof' # corner turner output not 'interleaved' for several different X-engines. This makes the CT data easier to deal with.

# These variables are described in the option parser text.
katcp_port = 7147
adc_atten = 0
verbose = False
accumulation_length = 1 # For the time being. Once we figure out how to make the boffile faster we can do some longer accumulations.
even_scales = False # Whether to display the adjacent fine FFT information on even scales. Otherwise each graph autoscales individually and it can be hard to compare them at a glance.
narrow = False
logfiles = True
recording_interval = 60 # seconds

def exit_fail():
    print 'FAILURE DETECTED. Log entries:\n', lh.printMessages()
    try:
        fpga.stop()
    except: pass
    raise
    exit()

def exit_clean():
    try:
        fpga.stop()
    except: pass
    exit()

if __name__ == '__main__':
    from optparse import OptionParser

    p = OptionParser()
    p.set_usage('python %s <ROACH_HOSTNAME_or_IP> [options]'%(os.path.basename(__file__)))
    p.set_description(__doc__)
    p.add_option('', '--noprogram', dest='noprogram', action='store_true',
        help='Don\'t write the boffile to the FPGA. If a compatible boffile is not already on the FPGA, this may cause the script to fail.')
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening, default off.')
    p.add_option('-b', '--boffile', dest='bof', type='str', default=boffile,
        help='Specify the bof file to load, default is %s'%(boffile))
    p.add_option('-p', '--katcpport', dest='kcp', type='int', default=katcp_port,
        help='Specify the KatCP port through which to communicate with the ROACH, default %d'%(katcp_port))
    p.add_option('-t', '--atten', dest='atn', type='int', default=adc_atten,
        help='Specify the amount by which the ADC should attenuate the input power, with zero being unattenuated and 63 being the maximum of 31.5 dB, in 0.5 dB steps. default %d (%s dB) '%(adc_atten, str(adc_atten*0.5)))
    p.add_option('-a', '--acclen', dest='accum_len', type='int', default=accumulation_length,
        help='Specify the number of frames to accumulate before plotting and recording, default %d'%(accumulation_length))
    p.add_option('-c', '--coarsechan', dest='coarse_chan', type='int',
        help='Specify the coarse channel from which to make the fine FFT')
    p.add_option('-e', '--evenscales', dest='evenscales', action='store_true',
        help='Display the adjacent fine FFT output on even scales, otherwise each graph autoscales itself.')
    p.add_option('-l', '--no-logging', dest='nolog', action='store_true',
        help='Turn off saving np files of the results, on by default.')
    p.add_option('-n', '--narrow', dest='narrow', action='store_true',
        help='Turn off the multiple-channel snap option, will reduce amount of channels visible (and data recorded) but will snap faster, for short T lengths. About 400kB used on a wide snap per capture, reduces to about 100kB for narrowband.')
    p.add_option('-T', '--time', dest='time', type='int', default=recording_interval,
        help='Define the interval (in seconds) at which everything must be snapped, default %d seconds.'%(recording_interval))
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        exit()
    else:
        roach = args[0]
    if opts.bof != '':
        boffile = opts.bof
    if opts.kcp != '':
        katcp_port = opts.kcp
    if opts.verbose:
        verbose = True
    if opts.narrow:
        narrow = True
    if opts.nolog:
        logfiles = False
    if opts.accum_len != '':
        accumulation_length = opts.accum_len
    if opts.atn != '':
        if (opts.atn < 64) and (opts.atn >= 0):
            adc_atten = opts.atn
        else:
            print 'Please enter an attenuation number between 0 and 63 (inclusive).\nExiting...'
            exit()
    if opts.coarse_chan != '' and (opts.coarse_chan >= 0) and (opts.coarse_chan < avn.coarse_fft_size):
        coarse_channel = opts.coarse_chan
    else:
        print 'Please enter the desired channel for the fine FFT! Valid options between 0 and %d.\nExiting...'%(avn.coarse_fft_size - 1)
        exit()
    if opts.evenscales:
       even_scales = True
    if opts.time != '':
        if opts.time >= 1:
            recording_interval = opts.time
        else:
            print 'Please enter a positive integer for the recording interval.\nExiting...'
            exit()

try:
    #Logging for debug purposes in the event of a crash
    lh = corr.log_handlers.DebugLogHandler()
    logger = logging.getLogger(roach)
    logger.addHandler(lh)
    logger.setLevel(10)

    if verbose:
        print('Connecting to ROACH %s... '%(roach)),
        sys.stdout.flush()
    fpga = corr.katcp_wrapper.FpgaClient(roach, katcp_port, logger=logger)
    time.sleep(1)

    if fpga.is_connected():
        if verbose:
            print 'ok\n'
    else:
        print 'ERROR connecting to ROACH %s.\n'%(roach)
        exit_fail()

    if not opts.noprogram:
        if verbose:
            print '------------------------'
            print 'Programming FPGA...',
            sys.stdout.flush()
        fpga.progdev(boffile)
        time.sleep(5)
        if verbose:
            print 'ok'
            sys.stdout.flush()

    # adc_ctrl bit description:
    # (This register is simple enough that we can get away without a construct for it)
    # MSB (31) - enable (goes through an AND gate with adc_protect_disable from 'control' register)
    # 6 LSBs - atten control - how much the ADC input should be attenuated.
    if verbose:
        print 'Enabling ADCs, setting attentuation to level %d.'%(adc_atten)
        sys.stdout.flush()
    fpga.write_int('adc_ctrl0',1<<31|adc_atten)
    fpga.write_int('adc_ctrl1',1<<31|adc_atten)

    if verbose:
        print 'Enabling ADC and GBE ports, doing initial arming on control register...'
        sys.stdout.flush()
    control_reg = avn.control_reg_bitstruct.parse('\x00\x00\x00\x00') # Just create a blank one to use...
    # Pulse arm and clr_status high, along with setting gbe_enable and adc_protect_disable high
    control_reg.gbe_enable = True
    control_reg.adc_protect_disable = True
    control_reg.clr_status = True
    control_reg.arm = True
    fpga.write_int('control', struct.unpack('>I', avn.control_reg_bitstruct.build(control_reg))[0])
    # and low again
    control_reg.clr_status = False
    control_reg.arm = False
    fpga.write_int('control', struct.unpack('>I',avn.control_reg_bitstruct.build(control_reg))[0])

    if logfiles:
        if not os.path.isdir('results'): # Check if the results directory exists,
            os.mkdir('results') # If not, create it.

    if verbose:
        print 'ROACH %s armed and ready.'%(roach)
        sys.stdout.flush()

    plt.ion()
    timestamp = ''
    previous_recording = time.time()

    while 1:
        previous_recording = time.time()

        # Record various debug information before everything else starts
        board_clock_estimate = fpga.est_brd_clk()
        clock_frequency = fpga.read_uint('clk_frequency')
        pps_count = fpga.read_uint('pps_count')
        fstatus0 = avn.register_fengine_fstatus.parse(struct.pack('>I',fpga.read_uint('fstatus0')))
        fstatus1 = avn.register_fengine_fstatus.parse(struct.pack('>I',fpga.read_uint('fstatus1')))

        if logfiles:
            timestamp = str(int(time.time())) + ' - ' + time.ctime()
            # Timestamp first with unix time then with a human-readable time
            # for ease of reading after-the-fact.
            os.mkdir('results/' + timestamp)
            if verbose:
                print 'Recording results in directory %s'%('results/' + timestamp)

        LCP_coarse_accumulator = np.zeros(avn.coarse_fft_size)
        RCP_coarse_accumulator = np.zeros(avn.coarse_fft_size)

        # Five of each of these: the requested channel and two on either side.
        LCP_fine_accumulator = []
        LCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        LCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        LCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        LCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        LCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))

        RCP_fine_accumulator = []
        RCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        RCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        RCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        RCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))
        RCP_fine_accumulator.append(np.zeros(avn.fine_fft_size))

        for i in range(0, accumulation_length):
            if verbose:
                print 'Accumulating frame number %d...'%(i)
                sys.stdout.flush()
            LCP_coarse_data, RCP_coarse_data = avn.retrieve_coarse_FFT_snap(fpga, verbose=verbose)
            if verbose:
                print 'debug data coarse: %f'%(LCP_coarse_data[coarse_channel]) # To satisfy myself that there is actually data coming through.
            LCP_coarse_accumulator += LCP_coarse_data
            RCP_coarse_accumulator += RCP_coarse_data

            # Sit back and relax. This one is going to take a while.
            if narrow:
                LCP_fine_data, RCP_fine_data = avn.retrieve_fine_FFT_snap(fpga, coarse_channel, verbose=verbose)
                LCP_fine_accumulator[2] += LCP_fine_data
                RCP_fine_accumulator[2] += RCP_fine_data

            else:
                for j in [-2,-1,0,1,2]:
                    LCP_fine_data, RCP_fine_data = avn.retrieve_fine_FFT_snap(fpga, coarse_channel + j, verbose=verbose)
                    if verbose:
                        print 'debug data fine: %f'%(LCP_fine_data[2]) # The 2 is a bit arbitrary, just so see if there's a number there.
                                                                       # If zeros are coming through consistently, there might be something wrong.
                    LCP_fine_accumulator[j + 2] += LCP_fine_data
                    RCP_fine_accumulator[j + 2] += RCP_fine_data

        LCP_timestream, RCP_timestream = avn.retrieve_adc_snap(fpga, verbose=verbose)

        plt.close('all')
        #fig = plt.figure(figsize=(23,12)) # Fills most of the screen
        fig = plt.figure(figsize=(18,12)) # Smaller so that terminal can still be seen

        if logfiles:
            np.save('results/' + timestamp + '/coarse_LCP', LCP_coarse_accumulator)
            np.save('results/' + timestamp + '/coarse_RCP', RCP_coarse_accumulator)
            np.save('results/' + timestamp + '/fine_LCP', LCP_fine_accumulator)
            np.save('results/' + timestamp + '/fine_RCP', RCP_fine_accumulator)
            np.save('results/' + timestamp + '/adc_LCP', LCP_timestream)
            np.save('results/' + timestamp + '/adc_RCP', RCP_timestream)

            f = open('results/' + timestamp + '/status_registers','w')

            f.write('adc_atten: %d\n'%(adc_atten))
            f.write('coarse_channel: %d\n'%(coarse_channel))
            f.write('board_clock_estimate: %d\n'%(board_clock_estimate))
            f.write('clock_frequency: %d\n'%(clock_frequency))
            f.write('pps_count: %d\n'%(pps_count))

            f.write('fstatus0:\n')
            f.write(str(fstatus0) + '\n')

            f.write('fstatus1:\n')
            f.write(str(fstatus1) + '\n')

            f.close()

        # TODO: Try to get it to dynamically increase the adc_atten in response to a True flag on
        # the fstatus overrange registers perhaps?

        ax = []
        ax.append(plt.subplot2grid((3,5), (0,0), colspan=5))    # 0 - coarse FFT
        ax.append(plt.subplot2grid((3,5), (1,0)))               # 1 - fine FFT channel - 2
        ax.append(plt.subplot2grid((3,5), (1,1)))               # 2 - fine FFT channel - 1
        ax.append(plt.subplot2grid((3,5), (1,2)))               # 3 - fine FFT channel
        ax.append(plt.subplot2grid((3,5), (1,3)))               # 4 - fine FFT channel + 1
        ax.append(plt.subplot2grid((3,5), (1,4)))               # 5 - fine FFT channel + 2
        ax.append(plt.subplot2grid((3,5), (2,0), colspan=5))    # 6 - fine FFT channel zoomed

        ax[0].plot(LCP_coarse_accumulator, 'b-')
        ax[0].plot(RCP_coarse_accumulator, 'r-')
        ax[0].set_title('Coarse FFT')
        ax[0].set_xlim(0, avn.coarse_fft_size-1)
        ax[0].xaxis.set_ticks(np.arange(0,avn.coarse_fft_size), 8)

        if (coarse_channel - 2) >=  0 and not narrow: # These if statements just to check that we haven't selected a channel right on the edge.
            ax[1].plot(LCP_fine_accumulator[0], 'b-')
            ax[1].plot(RCP_fine_accumulator[0], 'r-')
            ax[1].set_xlim(0, avn.fine_fft_size-1)
            ax[1].set_title('Fine ch %d'%(coarse_channel - 2))
            ax[1].xaxis.set_ticklabels([])

        if (coarse_channel - 1) >= 0 and not narrow:
            ax[2].plot(LCP_fine_accumulator[1], 'b-')
            ax[2].plot(RCP_fine_accumulator[1], 'r-')
            ax[2].set_xlim(0, avn.fine_fft_size-1)
            ax[2].set_title('Fine ch %d'%(coarse_channel - 1))
            ax[2].xaxis.set_ticklabels([])

        ax[3].plot(LCP_fine_accumulator[2], 'b-')
        ax[3].plot(RCP_fine_accumulator[2], 'r-')
        ax[3].set_xlim(0, avn.fine_fft_size-1)
        ax[3].set_title('Fine ch %d'%(coarse_channel))
        ax[3].xaxis.set_ticklabels([])

        if (coarse_channel + 1) < avn.fine_fft_size and not narrow:
            ax[4].plot(LCP_fine_accumulator[3], 'b-')
            ax[4].plot(RCP_fine_accumulator[3], 'r-')
            ax[4].set_xlim(0, avn.fine_fft_size-1)
            ax[4].set_title('Fine ch %d'%(coarse_channel + 1))
            ax[4].xaxis.set_ticklabels([])

        if (coarse_channel + 2) < avn.fine_fft_size - 1 and not narrow:
            ax[5].plot(LCP_fine_accumulator[4], 'b-')
            ax[5].plot(RCP_fine_accumulator[4], 'r-')
            ax[5].set_xlim(0, avn.fine_fft_size-1)
            ax[5].set_title('Fine ch %d'%(coarse_channel + 2))
            ax[5].xaxis.set_ticklabels([])

        ax[6].plot(LCP_fine_accumulator[2], 'b-')
        ax[6].plot(RCP_fine_accumulator[2], 'r-')
        ax[6].set_xlim(0, avn.fine_fft_size-1)
        ax[6].set_title('Fine FFT channel %d'%(coarse_channel))

        if even_scales and not narrow:
            ax[1].set_ylim(ax[3].get_ylim())
            ax[2].set_ylim(ax[3].get_ylim())
            ax[4].set_ylim(ax[3].get_ylim())
            ax[5].set_ylim(ax[3].get_ylim())

        plt.savefig('results/' + timestamp + '.png')
        plt.draw()

        while (previous_recording + recording_interval > time.time()):
            time.sleep(1) # Perhaps not the most elegant way of doing things...

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()

