#!/bin/env ipython
'''
Script to perform software accumulation from snaps of the coarse FFT data.
Initial revision: Dec. 2014 Charles Copley
Updated: 06 March 2015 James Smith
'''
#Suggested further revisions:
# - shift functions into external module
# - expand docstrings so that the functions' purposes are clear. Possibly their names as well.
# - replace numbers with a variable, to make their purposes more clear.


import numpy,corr, time, struct, sys, logging, socket,pylab,construct
import avn_spectrometer as avn

verbose = False

accumulation_length = 5


def exit_fail():
    print 'FAILURE DETECTED. Log entries:\n',lh.printMessages()
    try:
        fpga.stop()
    except: pass
    raise
    exit()

def exit_clean():
    try:
        for f in fpgas: f.stop()
    except: pass
    exit()

if __name__ == '__main__':
    from optparse import OptionParser

    p = OptionParser()
    p.set_usage('tut.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    p.add_option('-a', '--acclen', dest='accum_len', type='int', default=accumulation_length,
        help='Specify the number of accumlations to do before plotting, default 10')
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
    
    if verbose:
        print('Connecting to ROACH %s... '%(roach)),
    fpga = corr.katcp_wrapper.FpgaClient(roach, logger=logger)
    time.sleep(1)

    #No boffile is written here, so it assumes that the FPGA has been programmed already...
    if fpga.is_connected():
        if verbose:
            print 'ok\n'
    else:
        print 'ERROR connecting to ROACH %s.\n'%(roach)
        exit_fail()
    
    if verbose:
        print 'Writing coarse_ctrl register with configuration data...'
    coarse_ctrl_reg = avn.coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00')
    coarse_ctrl_reg.cdebug_pol_sel = 0 # Select I input
    coarse_ctrl_reg.cdebug_chan_sel = 0 # Pass all the channels through to the debug
    coarse_ctrl_reg.coarse_fft_shift = 31 # 31 translates to 0000011111 in binary.
    fpga.write_int('coarse_ctrl',avn.return_uint32(avn.coarse_ctrl_reg_bitstruct.build(coarse_ctrl_reg)))

    if verbose:
        print 'Writing control register with configuration data...'
    control_reg = avn.control_reg_bitstruct.parse('\x00\x00\x00\x00') 
    control_reg.gbe_enable = True
    control_reg.adc_protect_disable = True
    control_reg.debug_snap_select = 0 # Sends the 'coarse_72' stream to the snap_debug block
    fpga.write_int('control', avn.return_uint32(avn.control_reg_bitstruct.build(control_reg)))

    while 1:
        accumulator = numpy.zeros(256)
        
        for i in range(0,accumulation_length):
            if verbose:
                print "Beginning accumulation %d..."%(i)

            avn.trigger_snap(fpga, verbose=verbose)
            bram_data = avn.retrieve_coarse_FFP_snap(fpga, verbose=verbose)

            accumulator += bram_data # Could even include this in the previous one...

        pylab.close()
        pylab.ion()
        pylab.plot(accumulator)
        pylab.draw()

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()

