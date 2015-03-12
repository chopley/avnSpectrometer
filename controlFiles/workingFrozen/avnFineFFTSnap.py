#!/bin/env ipython
'''
Script to perform software accumulation from snaps of the fine FFT data.
Initial revision: Dec. 2014 Charles Copley
Updated: 09 March 2015 James Smith

Usage:
python initRoach.py -v catseye
python -v avnFineFFTSnap.py #This script. It is suggested to | grep Tone if you're looking for a specific bin, or >> into a log file, otherwise the amount of output that the -v flag produces gets large quickly.

An iPython session can be used to set the valon to the optimum frequency for this script to pick up:
a.set_frequency(8,197.75,1) Note the third argument is important to set the correct channel spacing.
'''

import numpy, corr, time, struct, sys, logging, socket, pylab, construct
import avn_spectrometer as avn

verbose = False

accumulation_length = 1



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
try:
    lh = corr.log_handlers.DebugLogHandler()
    logger = logging.getLogger(roach)
    logger.addHandler(lh)
    logger.setLevel(10)

    print('Connecting to server %s... '%(roach)),
    fpga = corr.katcp_wrapper.FpgaClient(roach, logger=logger)
    time.sleep(1)

    #No boffile is written here, assumes that the FPGA has been programmed already...
    if fpga.is_connected():
        if verbose:
            print 'ok\n'
    else:
        print 'ERROR connecting to ROACH %s.\n'%(roach)
        exit_fail()

#TODO: Something will be different here. The fine_ctrl looks the same, but the coarse_ctrl will need to be different, as will the control, to select a different snap
    fpga.write_int('coarse_ctrl', 128<<10|31) # Set the coarse channel on which to fineFFT here, 128 selects 200 MHz
    fpga.write_int('snap_debug_trig_offset',0)
    fpga.write_int('fine_ctrl',0)

    fpga.write_int('control',1<<9|1<<10|1<<25) # Haven't quite gotten 'round to setting this up properly yet.

    while 1:
        accumulator = numpy.zeros(avn.fine_fft_size)
        
        for i in range(0,accumulation_length):
            if verbose:
                print 'Beginning accumulation %d...'%(i)

            avn.trigger_snap(fpga, verbose=verbose)
            bram_data = avn.retrieve_fine_FFT_snap(fpga, verbose=verbose)

            print 'BRAM data length: %d'%(len(bram_data))
            sys.stdout.flush()
            accumulator += bram_data # Could even include this in the previous one...
        
        plot_array = numpy.zeros((4,256))
        for i in range(0,4):
            for j in range(0,256):
                plot_array[i,j] = accumulator[j*4 + i]

        pylab.close()
        pylab.ion()
        pylab.figure(figsize=(10,8), dpi=80)
       
        #First plot: ADC input I, even channels
        pylab.subplot(411)
        pylab.plot(plot_array[0,:])
        pylab.grid()
        
        #Second plot: ADC input Q, even channels
        pylab.subplot(412)
        pylab.plot(plot_array[1,:])
        pylab.grid()
        
        #Third plot: ADC input I, odd channels
        pylab.subplot(413)
        pylab.plot(plot_array[2,:])
        pylab.grid()
        
        #Fourth plot: ADC input Q, odd channels
        pylab.subplot(414)
        pylab.plot(plot_array[3,:])
        pylab.grid()

        # pylab.plot(accumulator)
        pylab.draw()
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

