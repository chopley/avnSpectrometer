#!/bin/env ipython
'''
Script to retrieve the data from after the quantiser block through the snap.
Initial version: 30 March, James Smith
'''

import numpy
import corr
import time
import struct
import sys
import logging
import socket
import construct
import avn_spectrometer as avn
import matplotlib.pyplot as plt

verbose = False
coarse_channel = 128 # 128 is 200 MHz, a tone at 200 MHz exactly would be in bin 0, and 201 MHz will be around bin 1900 or so.

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
    p.set_usage('avnQuantSnap.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    p.add_option('-c', '--coarsechan', dest='coarse_chan', type='int', default=coarse_channel,
        help='Specify the coarse channel from which to make the fine FFT, default %d'%(coarse_channel))
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        sys.stdout.flush()
        exit()
    else:
        roach = args[0]
    if opts.verbose:
        verbose = True
    if opts.coarse_chan!= '':
        coarse_channel = opts.coarse_chan
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

    left_data, right_data = avn.retrieve_quant_snap(fpga, 128, verbose=verbose)
    left_data = numpy.array(left_data)
    right_data = numpy.array(right_data)

    #f = open('results.txt','w')
    #f.write(str(left_data))
    #f.write('\n')
    #f.write(str(right_data))
    #f.write('\n')
    #f.close()

    plt.ion()
    plt.close('all')
    f = plt.figure()
    ax = f.add_subplot(111)
    ax.plot(numpy.arange(avn.fine_fft_size), abs(left_data), 'b-')
    ax.plot(numpy.arange(avn.fine_fft_size), abs(right_data), 'r-')
    ax.xaxis.set_ticks(numpy.arange(0,avn.fine_fft_size,128))
    ax.set_title('Quantiser data')
    ax.grid()
    plt.draw() # Use this instead of show(). For some reason.
    print 'LCP RMS value for this snap: %f'%(avn.calculate_RMS(left_data))
    print 'RCP RMS value for this snap: %f'%(avn.calculate_RMS(right_data))
    wait = raw_input('enter to continue')

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    sys.stdout.flush()
    exit_fail()

exit_clean()

