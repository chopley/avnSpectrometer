#!/bin/env ipython

"""
NOTE: Deprecated - this script's functionality has been incorporated into the Broad script with the -n flag.
It has none of the newer features.

Displays a debug-version of the AVN wideband spectrometer, with data
from the coarse FFT and a selected fine FFT channel. The data is retrieved
via the snap_debug block.
"""

# Revision History:
# 17 March 2015 - James Smith - Initial version, assembled from three other scripts which I'd written previously for doing just this.

import corr, time, sys, logging, struct, numpy
import avn_spectrometer as avn # Uses v0.4 of avn_spectrometer.py
import matplotlib.pyplot as plt

boffile = 'c09f12_12avn_2015_Feb_25_1753.bof' # Original working bof file. A bit slow but we're confident of the data that it produces.
#boffile = 'c09f12_16avn_2015_Mar_11_1756.bof' # Charles's modified one. Reads snap blocks more frequently but somehow misaligns the data. I (JNS) modified it sligtly to try and rectify this but then timing wouldn't work, and I haven't had the courage to face that hurdle quite yet.

katcp_port = 7147
adc_atten = 5
verbose = False
accumulation_length = 1 # For the time being. Once we figure out how to make the boffile faster we can do some longer accumulations.

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
    p.set_usage('python avnSpecrometerDisplay.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    p.add_option('', '--noprogram', dest='noprogram', action='store_true',
        help='Don\'t write the boffile to the FPGA.')
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    p.add_option('-b', '--boffile', dest='bof', type='str', default=boffile,
        help='Specify the bof file to load')
    p.add_option('-p', '--katcpport', dest='kcp', type='int', default=katcp_port,
        help='Specify the KatCP port through which to communicate with the ROACH, default 7147')
    p.add_option('-t', '--atten', dest='atn', type='int', default=adc_atten,
        help='Specify the amount by which the ADC should attenuate the input power, with zero being unattenuated and 63 being the maximum of 31.5 dB, in 0.5 dB steps. default 10 (5 dB)')
    p.add_option('-a', '--acclen', dest='accum_len', type='int', default=accumulation_length,
        help='Specify the number of accumlations to do before plotting, default %d'%(accumulation_length))
    p.add_option('-c', '--coarsechan', dest='coarse_chan', type='int',
        help='Specify the coarse channel from which to make the fine FFT')
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



    if verbose:
        print 'ROACH %s armed and ready.'%(roach)
        sys.stdout.flush()

    plt.ion()

    while 1:
        LCP_coarse_accumulator = numpy.zeros(avn.coarse_fft_size)
        RCP_coarse_accumulator = numpy.zeros(avn.coarse_fft_size)

        LCP_fine_accumulator = numpy.zeros(avn.fine_fft_size)
        RCP_fine_accumulator = numpy.zeros(avn.fine_fft_size)

        for i in range(0, accumulation_length):
            if verbose:
                print 'Accumulation %d...'%(i)
                sys.stdout.flush()
            LCP_coarse_data, RCP_coarse_data = avn.retrieve_coarse_FFT_snap(fpga, verbose=verbose)
            LCP_coarse_accumulator += LCP_coarse_data
            RCP_coarse_accumulator += RCP_coarse_data

            LCP_fine_data, RCP_fine_data = avn.retrieve_fine_FFT_snap(fpga, coarse_channel, verbose=verbose)
            LCP_fine_accumulator += LCP_fine_data
            RCP_fine_accumulator += RCP_fine_data

        plt.close()
        f, axarr = plt.subplots(2)

        axarr[0].plot(LCP_coarse_accumulator , 'b-')
        axarr[0].plot(RCP_coarse_accumulator , 'r-')
        axarr[0].set_title('Coarse FFT')
        axarr[0].set_xlim(-1,avn.coarse_fft_size)

        axarr[1].plot(LCP_fine_accumulator , 'b-')
        axarr[1].plot(RCP_fine_accumulator , 'r-')
        axarr[1].set_title('Fine FFT of channel %d'%(coarse_channel))
        axarr[1].set_xlim(-1,avn.fine_fft_size)
        plt.draw()

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()
