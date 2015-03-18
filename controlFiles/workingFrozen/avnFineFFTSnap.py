#!/bin/env ipython
'''
Script to perform software accumulation from snaps of the fine FFT data.

Usage:
python initRoach.py -v catseye
python -v avnFineFFTSnap.py #This script. It is suggested to | grep Tone if you're looking for a specific bin, or >> into a log file, otherwise the amount of output that the -v flag produces gets large quickly.

An iPython session can be used to set the valon to the optimum frequency for this script to pick up:
a.set_frequency(8,197.75,1) Note the third argument is important to set the correct channel spacing.
'''
# Initial revision: Dec. 2014 Charles Copley
# Updated: 09 March 2015 James Smith
# Updated: 13 March 2015 James Smith - re-working of avn_spectrometer module, plotting of both polarisations, using pyplot instead of pylab.
# Updated: 18 March 2015 James Smith - modified the function to be more agnostic as to the size of the data that it's receiving from the fpga read functions. The correspondingly updated avn_spectrometer functions now return the entire 4096 points of the FFT.


import numpy, corr, time, struct, sys, logging, socket, construct
import avn_spectrometer as avn
import matplotlib.pyplot as plt

verbose = False
accumulation_length = 1 # With the current (slow) bof file, longer accumulations than this take very long.
coarse_channel = 128 # 128 is 200 MHz, a tone at 200 MHz exactly would be in bin 0, and 201 MHz will be around bin 1900 or so.


def exit_fail():
    print 'FAILURE DETECTED. Log entries:\n',lh.printMessages()
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
    p.set_usage('avnFineFFTSnap.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    p.add_option('-a', '--acclen', dest='accum_len', type='int', default=accumulation_length,
        help='Specify the number of accumlations to do before plotting, default %d'%(accumulation_length))
    p.add_option('-c', '--coarsechan', dest='coarse_chan', type='int', default=coarse_channel,
        help='Specify the coarse channel from which to make the fine FFT, default %d'%(coarse_channel))
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        exit()
    else:
        roach = args[0]
    if opts.verbose:
        verbose = True
    if opts.accum_len != '':
        accumulation_length = opts.accum_len
    if opts.coarse_chan!= '':
        coarse_channel = opts.coarse_chan
try:
    lh = corr.log_handlers.DebugLogHandler()
    logger = logging.getLogger(roach)
    logger.addHandler(lh)
    logger.setLevel(10)

    print('Connecting to server %s... '%(roach)),
    fpga = corr.katcp_wrapper.FpgaClient(roach, logger=logger)
    time.sleep(1)

    if fpga.is_connected():
        if verbose:
            print 'ok\n'
    else:
        print 'ERROR connecting to ROACH %s.\n'%(roach)
        exit_fail()

    plt.ion()

    while 1:
        LCP_accumulator = numpy.zeros(avn.fine_fft_size)
        RCP_accumulator = numpy.zeros(avn.fine_fft_size)

        for i in range(0,accumulation_length):
            if verbose:
                print 'Beginning accumulation %d...'%(i)

            LCP, RCP = avn.retrieve_fine_FFT_snap(fpga, coarse_channel, verbose=verbose)
            LCP_accumulator += LCP
            RCP_accumulator += RCP

        plt.close()
        f, axarr = plt.subplots(2)
        #First plot: ADC input I (LCP)
        axarr[0].plot(LCP_accumulator , 'b-')
        axarr[0].set_title('LCP')
        axarr[0].set_xlim(-1,avn.fine_fft_size)
        #Second plot: ADC input Q (RCP)
        axarr[1].plot(RCP_accumulator , 'r-')
        axarr[1].set_title('RCP')
        axarr[1].set_xlim(-1,avn.fine_fft_size)
        plt.draw()

        # f = raw_input('press enter to continue') # In case you'd like to have the thing wait. Sometimes it can flash through the graph too quickly to be able to examine it properly.
        time.sleep(1)

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()

