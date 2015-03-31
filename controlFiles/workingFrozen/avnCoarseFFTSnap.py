#!/bin/env ipython
'''
Script to perform software accumulation from snaps of the coarse FFT data.
Initial revision: Dec. 2014 Charles Copley
Updated: 06 March 2015 James Smith
Updated: 13 March 2015 James Smith - re-working of avn_spectrometer module, changed to use pyplot instead of pylab.
'''

import numpy, corr, time, struct, sys, logging, socket, construct
import avn_spectrometer as avn
import matplotlib.pyplot as plt

verbose = False

accumulation_length = 10


def exit_fail():
    print 'FAILURE DETECTED. Log entries:\n',lh.printMessages()
    sys.stdout.flush()
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
    p.set_usage('avnCoarseFFTSnap.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    p.add_option('-a', '--acclen', dest='accum_len', type='int', default=accumulation_length,
        help='Specify the number of accumlations to do before plotting, default %d'%(accumulation_length))
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        sys.stdout.flush()
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

    if verbose:
        print('Connecting to ROACH %s... '%(roach)),
        sys.stdout.flush()
    fpga = corr.katcp_wrapper.FpgaClient(roach, logger=logger)
    time.sleep(1)

    if fpga.is_connected():
        if verbose:
            print 'ok\n'
            sys.stdout.flush()
    else:
        print 'ERROR connecting to ROACH %s.\n'%(roach)
        sys.stdout.flush()
        exit_fail()

    if verbose:
        print 'Writing control register with configuration data...'
        sys.stdout.flush()
    control_reg = avn.control_reg_bitstruct.parse('\x00\x00\x00\x00')
    control_reg.gbe_enable = True
    control_reg.adc_protect_disable = True
    control_reg.debug_snap_select = avn.debug_snap_select['coarse_72']
    fpga.write_int('control', struct.unpack('>I',avn.control_reg_bitstruct.build(control_reg))[0])

#    fpga.write_int('coarse1_crs_snap_setUp', 255) # This is just to compensate for the temporary error in the synchronisation of the snap in the boffile. Should be removed soon.

    plt.ion()

    LCP_accumulator = numpy.zeros(avn.coarse_fft_size)
    RCP_accumulator = numpy.zeros(avn.coarse_fft_size)

    for i in range(0,accumulation_length):
        if verbose:
            print "Beginning accumulation %d..."%(i)
            sys.stdout.flush()

        LCP_data, RCP_data = avn.retrieve_coarse_FFT_snap(fpga, verbose=verbose)

        LCP_accumulator += LCP_data
        RCP_accumulator += RCP_data

    plt.close('all')
    f = plt.figure()
    ax = f.add_subplot(111)
    ax.plot(numpy.arange(avn.coarse_fft_size), LCP_accumulator, 'b-')
    ax.plot(numpy.arange(avn.coarse_fft_size), RCP_accumulator, 'r-')
    ax.set_title('Coarse FFT')
    ax.set_xlim(-1, avn.coarse_fft_size)
    ax.grid()
    plt.draw() # Use this instead of show(). For some reason.

    f = raw_input('press enter to continue')

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    sys.stdout.flush()
    exit_fail()

exit_clean()

