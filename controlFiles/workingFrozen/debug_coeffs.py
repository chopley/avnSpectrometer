#!/bin/env ipython

'''Loops through values of the quantiser coefficients in powers of two, then saves pngs of the various snaps.
Uses Test Vector Generators (TVGs), so no actual input is required.

The quantiser is likely to be removed fom subsequent iterations of the spectrometer.
'''

import corr
import time
import sys
import logging
import struct
import numpy as np
import matplotlib.pyplot as plt
import avn_spectrometer as avn

boffile = 'c09f12_21avn_2015_Mar_23_1645.bof'

katcp_port = 7147
verbose = False

dest_ip = 10<<24 | 0<<16 | 0<<8 | 3<<0
fabric_port = 60000
source_ip = 10<<24 | 0<<16 | 0<<8 | 2<<0
mac_base = 2<<40 | 2<<32

coarse_channel = 128 # It was easier to simply define this, even though TVGs are running, since the snapping function needs it.


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
    p.set_usage('python initRoach.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    #p.add_option('', '--noprogram', dest='noprogram', action='store_true',
    #    help='Don\'t write the boffile to the FPGA.')
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    #p.add_option('-b', '--boffile', dest='bof', type='str', default=boffile,
    #    help='Specify the bof file to load')
    p.add_option('-p', '--katcpport', dest='kcp', type='int', default=katcp_port,
        help='Specify the KatCP port through which to communicate with the ROACH, default 7147')
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        exit()
    else:
        roach = args[0]
    #if opts.bof != '':
    #    boffile = opts.bof
    if opts.kcp != '':
        katcp_port = opts.kcp
    if opts.verbose:
        verbose = True

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
        print 'ERROR connecting to server %s.\n'%(roach)
        exit_fail()

    #if not opts.noprogram:
    if verbose:
        print '------------------------'
        print 'Programming FPGA...',
        sys.stdout.flush()
    fpga.progdev(boffile)
    time.sleep(5)
    if verbose:
        print 'ok'

    if verbose:
        print 'Enabling debug snap block...'
        sys.stdout.flush()
    fpga.write_int('snap_debug_ctrl', 1<<0)

    #if verbose:
    #    print 'Setting 10GbE source and destination addresses...'
    #fpga.write_int('gbe_ip0',dest_ip)
    #fpga.write_int('gbe_port',fabric_port)

    #if verbose:
    #    print 'Enabling 10GbE...'
    #fpga.tap_start('tap0','gbe0', mac_base+source_ip, source_ip, fabric_port)

    # Uncomment the line with the TVG desired
    # Should probably stop being lazy and make this a command line option, but for now this will do...
    control_reg = avn.control_reg_bitstruct.parse('\x00\x00\x00\x00')
    # Pulse arm and clr_status high, along with setting gbe_enable and adc_protect_disable high
    control_reg.gbe_enable = True
    control_reg.adc_protect_disable = True # Not actually sure whether this is necessary for the sync to come through
    control_reg.tvg_en = True
    control_reg.fine_tvg_en = True
    #control_reg.ct_tvg = True #not this one, since it comes after the quantiser...
    control_reg.clr_status = True
    control_reg.arm = True
    fpga.write_int('control', struct.unpack('>I', avn.control_reg_bitstruct.build(control_reg))[0])

    control_reg.clr_status = False
    control_reg.arm = False
    fpga.write_int('control', struct.unpack('>I',avn.control_reg_bitstruct.build(control_reg))[0])

    fpga.write_int('fine_ctrl',0)

    if verbose:
        print 'ROACH %s armed and ready, proceeding with debug snap run...'%(roach)
        sys.stdout.flush()

    # This is for practical purposes - I discovered that often the first time you snap things,
    # the data which comes out of the snap block is nonsensical. This is just to get past that
    # before the important stuff starts.
    foo_bar = avn.retrieve_coarse_FFT_snap(fpga)

    for gain_factor in np.arange(0,16):
        if verbose:
            print 'Gain is now 2^%d.'%(gain_factor)
            # 2^gain factor because in essence the quantiser is bit-shifting.
            # No point in in-between values.

        quantiser_gain = np.ones(avn.fine_fft_size, dtype=int)
        quantiser_gain = np.left_shift(quantiser_gain, gain_factor)
        quantiser_gain = np.bitwise_or(quantiser_gain, np.left_shift(quantiser_gain, 16))
        avn.setGainCoefficients(fpga, quantiser_gain)

        #LCP, RCP = avn.retrieve_fine_FFT_snap(fpga, coarse_channel, verbose=verbose)
        #f, axarr = plt.subplots(2)
        #axarr[0].plot(LCP, 'b-')
        #axarr[0].set_title('LCP')
        #axarr[0].set_xlim(-1,avn.fine_fft_size)
        #axarr[0].grid()
        #axarr[1].plot(RCP, 'r-')
        #axarr[1].set_title('RCP')
        #axarr[1].set_xlim(-1,avn.fine_fft_size)
        #axarr[1].grid()
        #plt.savefig(str(2**gain_factor).zfill(2) + '_fine_fft.png' )
        #plt.close('all')

        left_data, right_data = avn.retrieve_quant_snap(fpga, 128, verbose=verbose)
        left_data = np.array(left_data)
        right_data = np.array(right_data)
        f = plt.figure()
        ax = f.add_subplot(111)
        #ax.plot(np.arange(avn.fine_fft_size), abs(left_data), 'b-')
        #ax.plot(np.arange(avn.fine_fft_size), np.real(left_data), 'r-')
        #ax.plot(np.arange(avn.fine_fft_size), np.imag(left_data), 'g-')
        ax.plot(np.imag(left_data), 'g-', label='left')
        ax.plot(np.imag(right_data), 'r-', label='right')
        ax.set_title('Quantiser data')
        ax.grid()
        plt.savefig(str(2**gain_factor).zfill(2) + '_quantiser.png' )
        plt.close('all')

        left_data, right_data = avn.retrieve_ct_snap(fpga, 128, verbose=verbose)
        left_data = np.array(left_data)
        right_data = np.array(right_data)
        f = plt.figure()
        ax = f.add_subplot(111)
        #ax.plot(np.arange(avn.fine_fft_size), abs(left_data), 'b-')
        #ax.plot(np.arange(avn.fine_fft_size), np.real(left_data), 'r-')
        #ax.plot(np.arange(avn.fine_fft_size), np.imag(left_data), 'g-')
        ax.plot(np.imag(left_data), 'g-', label='left')
        ax.plot(np.imag(right_data), 'r-', label='right')
        ax.set_title('Corner turner data')
        ax.grid()
        plt.savefig(str(2**gain_factor).zfill(2) + '_corner_turner.png')
        plt.close('all')

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()

