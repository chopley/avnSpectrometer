#!/bin/env ipython

"""Initialises the FPGA with the most up-to-date AVN Spectrometer
bof file, and sets up the control register so that the ADCs and the 10GbE
are enabled.
"""

# Usage can be easily obtained by running 'python initRoach.py --help'

# Revision History:
# 26 March 2015 - Q&D addition of source and destination IP variables to write to the ROACH, so that the UDP works properly.
# 06 March 2015 - First proper working version created by James Smith.
# Originally adapted (somewhat) from Jason Manley's script for Tutorial 3.

import corr, time, sys, logging, struct
import numpy as np
import avn_spectrometer as avn

#boffile = 'c09f12_12avn_2015_Feb_25_1753.bof' # Original working bof file. A bit slow but we're confident of the data that it produces.
#boffile = 'c09f12_16avn_2015_Mar_11_1756.bof' # Charles's modified one. Reads snap blocks more frequently but somehow misaligns the data. I (JNS) modified it sligtly to try and rectify this but then timing wouldn't work, and I haven't had the courage to face that hurdle quite yet.
#boffile = 'c09f12_21avn_2015_Mar_23_1645.bof' # Updated faster one, correct alignment of bins.
boffile = 'c09f12_22avn_2015_Apr_21_1313.bof' # corner turner output not 'interleaved' for several different X-engines. This makes the CT data easier to deal with.


katcp_port = 7147
adc_atten = 10
verbose = False

# Q&D but it works and it's easy enough to understand I think.
dest_ip = 10<<24 | 0<<16 | 0<<8 | 3<<0
fabric_port = 60000
source_ip = 10<<24 | 0<<16 | 0<<8 | 2<<0
mac_base = 2<<40 | 2<<32

coarse_channel = 128

gain_factor = 1

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
    p.add_option('', '--noprogram', dest='noprogram', action='store_true',
        help='Don\'t write the boffile to the FPGA.')
    p.add_option('-v', '--verbose', dest = 'verbose', action='store_true',
        help='Show verbose information on what\'s happening')
    p.add_option('-b', '--boffile', dest='bof', type='str', default=boffile,
        help='Specify the bof file to load')
    p.add_option('-p', '--katcpport', dest='kcp', type='int', default=katcp_port,
        help='Specify the KatCP port through which to communicate with the ROACH, default 7147')
    p.add_option('-a', '--atten', dest='atn', type='int', default=adc_atten,
        help='Specify the amount by which the ADC should attenuate the input power, with zero being unattenuated and 63 being the maximum of 31.5 dB, in 0.5 dB steps. default %d'%(adc_atten))
    p.add_option('-g', '--gain', dest='gain', type='int', default=gain_factor,
        help='Specify the quantiser gain coefficients. At the moment, this script assigns the same coefficient to all channels, default %d. Only powers of 2 really useful.'%(gain_factor))
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
    if opts.atn != '':
        if (opts.atn < 64) and (opts.atn >= 0):
            adc_atten = opts.atn
        else:
            print 'Please enter an attenuation number between 0 and 63 (inclusive).\nExiting.'
            exit()
    if opts.gain != '':
        if (opts.atn < 2**16) and (opts.atn >= 0):
            quantiser_gain = opts.gain
        else:
            print 'Please enter a quantiser gain number between 0 and  %d (inclusive).\nExiting.'%(2**16)
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
        print 'ERROR connecting to server %s.\n'%(roach)
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

    # <snap_name>/ctrl bit description: (Taken from snap block itself)
    # 3 - continuously capture data until we get an external stop command
    # 2 - ignore external write enable and capture on every FPGA clock
    # 1 - ignore external trigger and trigger immediately
    # 0 - Put a posedge here to enable a new capture
    # Usage: fpga.write_int('<snap_name>_ctrl',x<<3|x<<2|x<<1|x<<0)
    # replace x with 1 where needed, remove the rest or replace with 0
    if verbose:
        print 'Enabling snap blocks...'
        sys.stdout.flush()
    fpga.write_int('snap_debug_ctrl', 1<<0)
    fpga.write_int('adc_snap0_ctrl',  1<<0)
    fpga.write_int('adc_snap1_ctrl',  1<<0)

    # adc_ctrl bit description:
    # MSB (31) - enable (goes through an AND gate with adc_protect_disable from 'control' register)
    # 6 LSBs - atten control - how much the ADC input should be attenuated.
    if verbose:
        print 'Enabling ADCs, setting attentuation to level %d.'%(adc_atten)
        sys.stdout.flush()
    fpga.write_int('adc_ctrl0',1<<31|adc_atten)
    fpga.write_int('adc_ctrl1',1<<31|adc_atten)

    if verbose:
        print 'Setting 10GbE source and destination addresses...'
    fpga.write_int('gbe_ip0',dest_ip)
    fpga.write_int('gbe_port',fabric_port)

    if verbose:
        print 'Enabling 10GbE...'
    fpga.tap_start('tap0','gbe0', mac_base+source_ip, source_ip, fabric_port)

    control_reg = avn.control_reg_bitstruct.parse('\x00\x00\x00\x00') # Just create a blank one to use...
    # Pulse arm and clr_status high, along with setting gbe_enable and adc_protect_disable high
    control_reg.gbe_enable = True
    control_reg.adc_protect_disable = True
    control_reg.tvg_en = True
    #control_reg.ct_tvg = True
    control_reg.fine_tvg_en = True
    control_reg.clr_status = True
    control_reg.arm = True
    fpga.write_int('control', struct.unpack('>I', avn.control_reg_bitstruct.build(control_reg))[0])

    control_reg.clr_status = False
    control_reg.arm = False
    fpga.write_int('control', struct.unpack('>I',avn.control_reg_bitstruct.build(control_reg))[0])

    if verbose:
        print 'Configuring coarse_ctrl register...'
    coarse_ctrl_reg = avn.coarse_ctrl_reg_bitstruct.parse('\x00\x00\x00\x00') # Starting a clean one here, previous data not of interest.
    coarse_ctrl_reg.coarse_chan_select = coarse_channel
    coarse_ctrl_reg.coarse_fft_shift = 341 # 341 translates to 0101010101 in binary.
    fpga.write_int('coarse_ctrl',struct.unpack('>I', avn.coarse_ctrl_reg_bitstruct.build(coarse_ctrl_reg))[0])
    fpga.write_int('fine_ctrl',0)

    quantiser_gain = np.ones(avn.fine_fft_size, dtype=int)
    quantiser_gain = np.left_shift(quantiser_gain, gain_factor)
    quantiser_gain = np.bitwise_or(quantiser_gain, np.left_shift(quantiser_gain, 16))
    avn.setGainCoefficients(fpga, quantiser_gain)

    if verbose:
        print 'ROACH %s armed and ready.'%(roach)
        sys.stdout.flush()
    #time.sleep(2)

except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()
