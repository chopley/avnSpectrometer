#!/bin/env ipython

'''
This script demonstrates programming an FPGA, configuring 10GbE cores and checking transmitted and received data using the Python KATCP library along with the katcp_wrapper distributed in the corr package. Designed for use with TUT3 at the 2009 CASPER workshop.
\n\n 
Author: Jason Manley, August 2009.
Updated for CASPER 2013 workshop. This tut needs a rework to use new snap blocks and auto bit unpack.
'''
import numpy,corr, time, struct, sys, logging, socket,pylab

#Decide where we're going to send the data, and from which addresses:
dest_ip  =10*(2**24) + 0*(2**16) + 0*(2**8) + 1
fabric_port=60000         
source_ip= 10*(2**24) + 0*(2**16) + 0*(2**8) + 2
mac_base=(2<<40) + (2<<32)

bb=numpy.ones(10)
pkt_period = 16384  #how often to send another packet in FPGA clocks (200MHz)
payload_len = 128   #how big to make each packet in 64bit words

brams=['bram_msb','bram_lsb','bram_oob']
tx_snap = 'snap_gbe0_tx'
rx_snap = 'snap_gbe3_rx'

tx_core_name = 'gbe0'
test_core_bram = 'qdrBram'
test_QDRReg = 'testQDR'
test_fineFFT= 'vals_testQDR'


#boffile='c09f12_01_avn_acc_2014_Oct_20_1431.bof'
#boffile = 'c09f12_01_avn_coffs_2014_Oct_15_1534.bof'
#boffile = 'c09f12_01_avn_2014_Oct_13_1031.bof'
#boffile = 'c09f12_01_2014_Aug_08_1735.bof'
#boffile = 'c09f12_01_avn_2014_Oct_31_1038.bof'
boffile = 'c09f12_02_2014_Dec_05_1231.bof'
#boffile = 'c09f12_01_2014_Nov_11_1411.bof'
#boffile = 'c09f12_01_2014_Nov_11_1542.bof'
fpga=[]

def bramw(fpga,bname,odata,samples=1024):
		b_0=struct.pack('>'+str(samples)+'h',*odata)
		fpga.blindwrite(bname,b_0)

def bramwUnsignedLong(fpga,bname,odata,samples=1024):
		b_0=struct.pack('>'+str(samples)+'I',*odata)
		fpga.blindwrite(bname,b_0)

def setFineFFTCoefficients(fpga,val):
				a=numpy.ones(2**12)*1
				a[0:4000]=0
				fpga.write_int('quantisation_quant_v0_sel',val)
				fpga.write_int('quantisation_quant_v1_sel',val)
				bramw(fpga,'quantisation_quant_v0_Re1_val',a,2**12)
				bramw(fpga,'quantisation_quant_v0_Im1_val',a,2**12)
				bramw(fpga,'quantisation_quant_v1_Real1_val',a,2**12)
				bramw(fpga,'quantisation_quant_v1_Imag1_val',a,2**12)
				##the coefficients are written as 16 bit numbers.
				##eq0 has real0,imag0, and eq1 has real1, imag1
				#a=numpy.arange(0,2**12,1)
#				a[3845:3850]=[1,2,3,2,5]

def setQDRCoefficients(fpga,val):
				a=numpy.zeros(2**12)
				fpga.write_int(test_QDRReg,val)
				##the coefficients are written as 16 bit numbers.
				##eq0 has real0,imag0, and eq1 has real1, imag1
				#a=numpy.arange(0,2**12,1)
#				a[3845:3850]=[1,2,3,2,5]
				bramw(fpga,'qdrBram',a,2**12)
				bramw(fpga,'qdrBram',a,2**12)

def setGainCoefficients(fpga):
				#set the gain coefficients
				a=numpy.ones(2**12)
				a[:]=4095
				#a[10:500]=0

				##the coefficients are written as 16 bit numbers.
				##eq0 has real0,imag0, and eq1 has real1, imag1
#				a[10:11]=0.
#				a[6:7]=0.
#				a[2:3]=0.
				bramwUnsignedLong(fpga,'eq0',a,2**12)
				bramwUnsignedLong(fpga,'eq1',a,2**12)

def readBram(fpga,bram,size):
				a=fpga.read(bram,size,0)
				return a
def exit_fail():
    print 'FAILURE DETECTED. Log entries:\n',lh.printMessages()
#    try:
#        fpga.stop()
#    except: pass
#    raise
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
    p.add_option('', '--noprogram', dest='noprogram', action='store_true',
        help='Don\'t print the contents of the packets.')  
    p.add_option('-s', '--silent', dest='silent', action='store_true',
        help='Don\'t print the contents of the packets.')  
    p.add_option('-p', '--plot', dest='plot', action='store_true',
        help='Plot the TX and RX counters. Needs matplotlib/pylab.')  
    p.add_option('-a', '--arp', dest='arp', action='store_true',
        help='Print the ARP table and other interesting bits.')  
    p.add_option('-b', '--boffile', dest='bof', type='str', default=boffile,
        help='Specify the bof file to load')  
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        exit()
    else:
        roach = args[0]
    if opts.bof != '':
        boffile = opts.bof
try:
    lh = corr.log_handlers.DebugLogHandler()
    logger = logging.getLogger(roach)
    logger.addHandler(lh)
    logger.setLevel(10)

    print('Connecting to server %s... '%(roach)),
    fpga = corr.katcp_wrapper.FpgaClient(roach, logger=logger)
    time.sleep(1)

    if fpga.is_connected():
        print 'ok\n'
    else:
        print 'ERROR connecting to server %s.\n'%(roach)
        exit_fail()
    
    if not opts.noprogram:
        print '------------------------'
        print 'Programming FPGA...',
        sys.stdout.flush()
        fpga.progdev(boffile)
        time.sleep(10)
        print 'ok'

    print '---------------------------'    
    print 'Disabling output...',
    sys.stdout.flush()
  #  fpga.write_int('pkt_sim_enable', 0)
    print 'done'

    print '---------------------------'    
    print 'Port 0 linkup: ',
    sys.stdout.flush()
   #gbe0_link=bool(fpga.read_int('gbe0_linkup'))
  # print gbe0_link
   #if not gbe0_link:
    #   print 'There is no cable plugged into port0. Please plug a cable between ports 0 and 3 to continue demo. Exiting.'
     #  exit_clean()
    print 'Port 3 linkup: ',
    sys.stdout.flush()
   #gbe3_link=bool(fpga.read_int('gbe3_linkup'))
   #print gbe3_link
   #if not gbe0_link:
   #    print 'There is no cable plugged into port3. Please plug a cable between ports 0 and 3 to continue demo. Exiting.'
   #    exit_clean()

    print '---------------------------'
    print 'Configuring receiver core...',
    sys.stdout.flush()
    print 'Configuring transmitter core...',
    sys.stdout.flush()
    fpga.tap_start('tap3',tx_core_name,mac_base+source_ip,source_ip,fabric_port)
    print 'done'

    print '---------------------------'
    print 'Setting-up packet source...',
    sys.stdout.flush()
    print 'done'

    print 'Setting-up destination addresses...',
    sys.stdout.flush()
    fpga.write_int('gbe_ip0',dest_ip)
    fpga.write_int('gbe_port',fabric_port)
    print 'Resetting cores and counters...',
    sys.stdout.flush()
    print 'done'

    time.sleep(1)

    if opts.arp:
        print '\n\n==============================='
        print '10GbE Transmitter core details:'
        print '==============================='
        print "Note that for some IP address values, only the lower 8 bits are valid!"
        fpga.print_10gbe_core_details(tx_core_name,arp=True)
        print '\n\n============================'
        print '10GbE Receiver core details:'
        print '============================'
        print "Note that for some IP address values, only the lower 8 bits are valid!"
        fpga.print_10gbe_core_details(rx_core_name,arp=True)

    print 'Sent %i packets already.'%fpga.read_int('gbe_tx_cnt0')
  #  print 'Received %i packets already.'%fpga.read_int('gbe3_rx_frame_cnt')

    print '------------------------'
    print 'Triggering snap captures...',
    sys.stdout.flush()

    fpga.write_int('snap_debug_ctrl',1<<0)
    fpga.write_int('adc_snap0_ctrl',1)
    fpga.write_int('adc_ctrl0',1<<31|10)
    fpga.write_int('adc_ctrl1',1<<31|10)
    fpga.write_int('coarse_ctrl',0<<20|31)
    fpga.write_int('fine_ctrl',0)
		
    time.sleep(1)
    #fpga.write_int('control',1<<9|1<<10|0<<25|1<<2|1<<3)
    fpga.write_int('control',1<<9|1<<10|0<<25)


    time.sleep(2)


except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()

