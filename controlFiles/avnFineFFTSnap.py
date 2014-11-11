#!/bin/env ipython

import numpy,corr, time, struct, sys, logging, socket,pylab,construct


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


fpga=[]
snap_debug='snap_debug'
snap_fengine_debug_fine_fft = construct.BitStruct(snap_debug,
								construct.Padding(128 - (4*31)),
								construct.BitField("d0_r", 31),
								construct.BitField("d0_i", 31),
								construct.BitField("d1_r", 31),
								construct.BitField("d1_i", 31))

def bin2fp(bits, m = 8, e = 7): 
     if m > 32: 
         raise RuntimeError('Unsupported fixed format: %i.%i' % (m,e)) 
     shift = 32 - m 
     bits = bits << shift 
     m = m + shift 
     e = e + shift 
     return float(numpy.int32(bits)) / (2**e) 





def bram(bname,odata,samples=1024):
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
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. \nExiting.'
        exit()
    else:
        roach = args[0]
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
    


    fpga.write_int('snap_debug_ctrl',1<<0)
    fpga.write_int('adc_snap0_ctrl',1)
    fpga.write_int('adc_ctrl0',1<<31|10)
    fpga.write_int('adc_ctrl1',1<<31|10)
    fpga.write_int('coarse_ctrl',128<<20|31)
    fpga.write_int('fine_ctrl',0)
		
    fpga.write_int('control',1<<9|1<<10|1<<25)

    while 1:
						adc0=fpga.read_uint('adc_sum_sq0')
						adc1=fpga.read_uint('adc_sum_sq1')
						adc=readBram(fpga,'adc_snap1_bram',4*1024)
						snap_stat1=fpga.read_uint('snap_debug_status')
						snap_statadc=fpga.read_uint('adc_snap1_status')
						pps_count=fpga.read_uint('pps_count')
						clock_freq=fpga.read_uint('clk_frequency')
						fpga.write_int('adc_snap1_ctrl',0)
						fpga.write_int('adc_snap1_ctrl',1)
						fpga.write_int('adc_snap1_ctrl',0)
						fpga.write_int('snap_debug_ctrl',1) #bring this high to trigger capture
						fpga.write_int('snap_debug_ctrl',0) #and take it low again
						time.sleep(1.0)
				#		snap_stat2=fpga.read_uint('snap_debug_status')
				#	a=readBram(fpga,'snap_debug_bram',8*1024)
				#	print 'a',a
				#		a_0=struct.unpack('>16384b',a)
						adc_0=struct.unpack('>4096b',adc)
						repeater = construct.GreedyRange(snap_fengine_debug_fine_fft)
						bram_dmp=dict()
						bram_dmp['data']=[]
						bram_dmp['data'].append(fpga.read('snap_debug_bram',8192))
					#	print bram_dmp['data']
						d=bram_dmp['data'][0]
						tt=repeater.parse(d)
						val=numpy.zeros(512)
						for i in range(0,100):
										rd=[]
										bram_dmp['data']=[]
										bram_dmp['data'].append(fpga.read('snap_debug_bram',8192))
										d=bram_dmp['data'][0]
										tt=repeater.parse(d)
										fpga.write_int('snap_debug_ctrl',1) #bring this high to trigger capture
										fpga.write_int('snap_debug_ctrl',0) #and take it low again
					#					print numpy.size(val),numpy.size(numpy.array(rd))
										for a in tt:
																		coarsed=[]
																		aa=(a['d0_r'])
																		ab=(a['d0_i'])
																		shift = 32 - 31
																		if(aa>1073741824):
																						aa=aa-2147483648
																		if(ab>1073741824):
																						ab=ab-2147483648
																		print aa,ab
																		aa = aa<<(shift)
																		ab = ab<<(shift)
																		m=31
																		e=17+shift
																		power =  abs((float(aa)/(2**e)+(1j*float(ab)/(2**e))))
																		rd.append(power)
										val=val+numpy.array(rd)
					#	print len(rd)
						#print rd
						pylab.ion()
						pylab.clf()
						pylab.plot(val,'b')
						pylab.grid()
						pylab.draw()
						#print tt
						fstatus0=fpga.read_uint('fstatus0')
						fstatus1=fpga.read_uint('fstatus1')
						print adc0,adc1,fstatus0,fstatus1,snap_stat1,pps_count,clock_freq,snap_statadc
						time.sleep(1.0)

    time.sleep(2)
    fpga.write_int('control',0)
    print 'done'

    print 'Enabling output...',
    sys.stdout.flush()
    #fpga.write_int('pkt_sim_enable', 1)
    print 'done'

    time.sleep(2)


except KeyboardInterrupt:
    exit_clean()
except Exception as inst:
    print type(inst)
    print inst.args
    print inst
    exit_fail()

exit_clean()

