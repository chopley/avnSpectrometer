#!/usr/bin/env python
# -*- coding: utf-8 -*- 
'''
This script demonstrates grabbing data off an already configured FPGA and plotting it using Python. Designed for use with CASPER workshop Tutorial 4.
\n\n 

This script is based off an example from Jason and modified for the corner turn FFtA

Author: Charles Copley, August 2014.
'''

#TODO: add support for coarse delay change
#TODO: add support for ADC histogram plotting.
#TODO: add support for determining ADC input level 

import corr,time,numpy,struct,sys,logging,pylab,matplotlib,bitstring,curses

katcp_port=7147
run = 0
logprint = False
prev_integration = 0
#screen

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

def get_data():
    global run
    global logprint
    global screen
    global prev_integration
    logdata = False
    savedir = ""
    acc_n = fpga.read_uint('acc_num') 
    while (acc_n == prev_integration):
       acc_n = fpga.read_uint('acc_num') 
    
    prev_integration = acc_n
    print str(acc_n)
    #screen.clear()
 
    #screen.addstr('Grabbing integration number %i'%acc_n)

    #cr0 = fpga.read_uint('cr0')
    #cr1 = fpga.read_uint('cr1')
    #screen.addstr( "\ncr0: " + str(cr0)+  " cr1: " + str(cr1))

    #adc_valid = fpga.read_uint('adc_valid')
    #screen.addstr( "\nadc valid: ", adc_valid)

    overflow_p = fpga.read_uint('p_fft_overflow')
    overflow_q = fpga.read_uint('q_fft_overflow')
    print "overflow" + str(overflow_p) + " " + str(overflow_q)
    #screen.addstr( "\nOverflow p: " + str(overflow_p) + " Overflow q: " + str(overflow_q))
    #screen.addstr("\nEst Clock rate: " +str(fpga.est_brd_clk()) + "MHz")
    print ("Est Clock rate: " +str(fpga.est_brd_clk()) + "MHz")

    aa_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_aa_real_high',4096,0)))
    aa_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_aa_real_low',4096,0)))
    bb_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_bb_real_high',4096,0)))
    bb_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_bb_real_low',4096,0)))
    cc_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_cc_real_high',4096,0)))
    cc_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_cc_real_low',4096,0)))
    dd_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_dd_real_high',4096,0)))
    dd_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_dd_real_low',4096,0)))

    ac_im_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_ac_imag_low',4096,0)))
    ac_im_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_ac_imag_high',4096,0)))
    bd_im_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_bd_imag_low',4096,0)))
    bd_im_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_bd_imag_high',4096,0)))
    ac_re_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_ac_real_low',4096,0)))
    ac_re_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_ac_real_high',4096,0)))
    bd_re_l=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_bd_real_low',4096,0)))
    bd_re_h=numpy.uint32(struct.unpack('>1024l',fpga.read('mult_bd_real_high',4096,0)))
    
    interleave_a=[]
    interleave_b=[]
    interleave_c=[]
    interleave_d=[]

    if (logdata):
        run = run + 1
    interleave_a = numpy.zeros(2*1024, dtype = numpy.float64)
    interleave_b = numpy.zeros(2*1024, dtype = numpy.float64)
    interleave_c = numpy.zeros(2*1024, dtype = numpy.float64)
    interleave_d = numpy.zeros(2*1024, dtype = numpy.float64)

    for i in range(1024):
        interleave_a[i*2] =bitstring.pack("uint:32, uint:32",  aa_h[i],aa_l[i]).int#even data
        interleave_a[i*2+1] = bitstring.pack("uint:32, uint:32", bb_h[i], bb_l[i]).int#odd data

        interleave_b[i*2] = bitstring.pack("uint:32, uint:32",  cc_h[i],cc_l[i]).int#even data
        interleave_b[i*2+1] = bitstring.pack("uint:32, uint:32", dd_h[i], dd_l[i]).int#odd data

        interleave_c[i*2] = (bitstring.pack("uint:32, uint:32",  ac_re_h[i],ac_re_l[i])).int#even data
        interleave_c[i*2+1] = (bitstring.pack("uint:32, uint:32", bd_re_h[i], bd_re_l[i])).int#odd data

        interleave_d[i*2] = bitstring.pack("uint:32, uint:32",  ac_im_h[i],ac_im_l[i]).int#even data
        interleave_d[i*2+1] = bitstring.pack("uint:32, uint:32", bd_im_h[i], bd_im_l[i]).int#odd data
        
    if (logdata):
        numpy.savetxt("a_"+str(run)+".gz" ,interleave_a)
        numpy.savetxt("b_"+str(run)+".gz" ,interleave_b)
        numpy.savetxt("c_"+str(run)+".gz" ,interleave_c)
        numpy.savetxt("d_"+str(run)+".gz" ,interleave_d)

    stokes_I = (interleave_a) + (interleave_b)
    stokes_Q = (interleave_a) - (interleave_b)
    interleave_a = stokes_I
    interleave_b = stokes_Q
    interleave_c = 2*interleave_c
    interleave_d = 2*interleave_d
    for i in range(2*1024):
        if (logprint):
            try:
                numpy.seterr(all='ignore')
                interleave_a[i] = 10*(numpy.log10(abs(interleave_a[i]))-numpy.log10(numpy.float64(2.0**34)))
                interleave_b[i] = 10*(numpy.log10(abs(interleave_b[i]))-numpy.log10(numpy.float64(2.0**34)))
                interleave_c[i] = 10*(numpy.log10(abs(interleave_c[i]))-numpy.log10(numpy.float64(2.0**34)))
                interleave_d[i] = 10*(numpy.log10(abs(interleave_d[i]))-numpy.log10(numpy.float64(2.0**34)))
                numpy.seterr(all='warn')
            except:
                screen.addstr("Unexpected error:" + str(sys.exc_info()[0]))
        else:
            interleave_a[i] = ((interleave_a[i]))/float(2.0**34)#+2**-1000) #/pow(2, 30))
            interleave_b[i] = ((interleave_b[i]))/float(2.0**34)#+2**-1000) #/pow(2, 30))
            interleave_c[i] = ((interleave_c[i]))/float(2.0**34)#+2**-1000) #/pow(2, 30))
            interleave_d[i] = ((interleave_d[i]))/float(2.0**34)#+2**-1000) #/pow(2, 30))

    #screen.addstr(str(interleave_a.max()))
    #screen.refresh() 
    return acc_n,interleave_a,interleave_b,interleave_c,interleave_d

def drawData_animate():
    #matplotlib.pyplot.ion()
    fig= matplotlib.pyplot.figure(num=1)
    acc_n,interleave_a,interleave_b,interleave_c,interleave_d = get_data()

    #matplotlib.pyplot.subplot(411)
    ax1 = fig.add_subplot(4,1,1)
    ax1.set_title('Integration number %i \n(I)'%acc_n)	
    if ifch:
        plot1, = matplotlib.pyplot.plot(interleave_a)
        matplotlib.pyplot.xlim(0,4096)
    else:
        plot1, = matplotlib.pyplot.plot(xaxis,interleave_a)
    matplotlib.pyplot.grid()
    #matplotlib.pyplot.title('Integration number %i \nAA'%acc_n)
    matplotlib.pyplot.ylabel('Power (arbitrary units)')

    ax2 = fig.add_subplot(412)
    if ifch:
        plot2, = matplotlib.pyplot.plot(interleave_b)
        matplotlib.pyplot.xlim(0,4096)
    else:
        plot2, = matplotlib.pyplot.plot(xaxis,interleave_b)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('(Q)')

    ax3 = fig.add_subplot(413)
    if ifch:
        plot3, = matplotlib.pyplot.plot(interleave_c)
        matplotlib.pyplot.xlim(0,4096)
    else:
        plot3, = matplotlib.pyplot.plot(xaxis,interleave_c)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('(U)')

    ax4 = fig.add_subplot(414)
    if ifch:
        plot4, = matplotlib.pyplot.plot(interleave_d)
        matplotlib.pyplot.xlim(0,2048)
        matplotlib.pyplot.xlabel('Channel')
    else:
        plot4, = matplotlib.pyplot.plot(xaxis,interleave_d)
        matplotlib.pyplot.xlabel('Frequency')
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('(V)')

    def init():
	if ifch:
		plot1.set_ydata(numpy.zeros(1,2048))
		plot2.set_ydata(numpy.zeros(1,2048))
		plot3.set_ydata(numpy.zeros(1,2048))
		plot4.set_ydata(numpy.zeros(1,2048))
	else:
		plot1.set_ydata(numpy.zeros(1,size(xaxis)+1))
		plot2.set_ydata(numpy.zeros(1,size(xaxis)+1))
		plot3.set_ydata(numpy.zeros(1,size(xaxis)+1))
		plot4.set_ydata(numpy.zeros(1,size(xaxis)+1))
	return ax, plot1, plot2, plot3, plot4,

    def update():
	acc_n,interleave_a,interleave_b,interleave_c,interleave_d = get_data()
	plot1.set_ydata(interleave_a)
	ax.set_title('Integration number %i \nAA'%acc_n)
	plot2.set_ydata(interleave_b)
	plot3.set_ydata(interleave_c)
	plot4.set_ydata(interleave_d)
	return ax, plot1, plot2, plot3, plot4,

    ani = matplotlib.animation.FuncAnimation(fig, update, init_func = init, interval = 10, blit = True)
    matplotlib.pyplot.show()



def drawDataLoop():
    global logprint
    matplotlib.pyplot.ion()
    fig = matplotlib.pyplot.figure(num = 1, figsize=(18,12))
    acc_n,interleave_a,interleave_b,interleave_c,interleave_d = get_data()
    zoom_lin = 10**-7

    ax1 = fig.add_subplot(411)

    #ax1.set_autoscaley_on(False)
    #ax1.set_ylim([0,10**(-7)])
    
    if(logprint):
         matplotlib.pyplot.ylim(ymax = 10, ymin = -110)
    else:
         matplotlib.pyplot.ylim(ymax = zoom_lin, ymin = -zoom_lin)
    
    if ifch:
        plot1, = matplotlib.pyplot.plot(interleave_a)
        matplotlib.pyplot.xlim(0,2048)
    else:
        plot1, = matplotlib.pyplot.plot(xaxis,interleave_a)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.title('Auto-Correlation \nIntegration :%ith cycle \n(I)'%acc_n)
    matplotlib.pyplot.ylabel('Power (arbitrary units)')

    matplotlib.pyplot.subplot(412)

    if(logprint):
         matplotlib.pyplot.ylim(ymax = 10, ymin = -110)
    else:
         matplotlib.pyplot.ylim(ymax = zoom_lin, ymin = -zoom_lin)

    if ifch:
        plot2, = matplotlib.pyplot.plot(interleave_b)
        matplotlib.pyplot.xlim(0,2048)
    else:
        plot2, = matplotlib.pyplot.plot(xaxis,interleave_b)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('(Q)')

    matplotlib.pyplot.subplot(413)

    if(logprint):
         matplotlib.pyplot.ylim(ymax = 10, ymin = -110)
    else:
         matplotlib.pyplot.ylim(ymax = zoom_lin, ymin = -zoom_lin)

    if ifch:
        plot3, = matplotlib.pyplot.plot(interleave_c)
        matplotlib.pyplot.xlim(0,2048)
    else:
        plot3, = matplotlib.pyplot.plot(xaxis,interleave_c)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('(U)')

    matplotlib.pyplot.subplot(414)

    if(logprint):
         matplotlib.pyplot.ylim(ymax = 10, ymin = -110)
    else:
         matplotlib.pyplot.ylim(ymax = zoom_lin, ymin = -zoom_lin)

    if ifch:
        plot4, = matplotlib.pyplot.plot(interleave_d)
        matplotlib.pyplot.xlim(0,2048)
        matplotlib.pyplot.xlabel('Channel')
    else:
        plot4, = matplotlib.pyplot.plot(xaxis,interleave_d)
        matplotlib.pyplot.xlabel('Frequency (MHz)')
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('(V)')

    while(1):
	try:
		acc_n,interleave_a,interleave_b,interleave_c,interleave_d = get_data()
		ax1.set_title('Auto-Correlation \nIntegration :%ith cycle \n(I)'%acc_n)
		plot1.set_ydata(interleave_a)
		matplotlib.pyplot.hold(False)
		matplotlib.pyplot.draw()
		matplotlib.pyplot.hold(True)
		plot2.set_ydata(interleave_b)
		matplotlib.pyplot.hold(False)
		matplotlib.pyplot.draw()
		matplotlib.pyplot.hold(True)
		plot3.set_ydata(interleave_c)
		matplotlib.pyplot.hold(False)
		matplotlib.pyplot.draw()
		matplotlib.pyplot.hold(True)
		plot4.set_ydata(interleave_d)
		matplotlib.pyplot.hold(False)
		matplotlib.pyplot.draw()
		matplotlib.pyplot.hold(True)
		#tget_data()ime.sleep(1)
	except (KeyboardInterrupt, SystemExit):
		print '\nKeyboard interrupt caught, exiting...\n'
		break


def drawDataCallback():
    matplotlib.pyplot.clf()
    acc_n,interleave_a,interleave_b,interleave_c,interleave_d = get_data()



    matplotlib.pyplot.subplot(411)
    if ifch:
        matplotlib.pyplot.plot(interleave_a)
        matplotlib.pyplot.xlim(0,2048)
    else:
        matplotlib.pyplot.plot(xaxis,interleave_a)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.title('Integration number %i \nI'%acc_n)
    matplotlib.pyplot.ylabel('Power (arbitrary units)')

    matplotlib.pyplot.subplot(412)
    if ifch:
        matplotlib.pyplot.plot(interleave_b)
        matplotlib.pyplot.xlim(0,2048)
    else:
        matplotlib.pyplot.plot(xaxis,interleave_b)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('Q')

    matplotlib.pyplot.subplot(413)
    if ifch:
        matplotlib.pyplot.plot(interleave_c)
        matplotlib.pyplot.xlim(0,2048)
    else:
        matplotlib.pyplot.plot(xaxis,interleave_c)
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('U')

    matplotlib.pyplot.subplot(414)
    if ifch:
        matplotlib.pyplot.plot(interleave_d)
        matplotlib.pyplot.xlim(0,2048)
        matplotlib.pyplot.xlabel('Channel')
    else:
        matplotlib.pyplot.plot(xaxis,interleave_d)
        matplotlib.pyplot.xlabel('Frequency')
    matplotlib.pyplot.grid()
    matplotlib.pyplot.ylabel('Power (arbitrary units)')
    matplotlib.pyplot.title('V')

    #matplotlib.pyplot.show()
    fig.canvas.manager.window.after(1000, drawDataCallback)


if __name__ == '__main__':
    from optparse import OptionParser
    p = OptionParser()
    p.set_usage('spectrometer.py <ROACH_HOSTNAME_or_IP> [options]')
    p.set_description(__doc__)
    #p.add_option('-l', '--acc_len', dest='acc_len', type='int',default=2*(2**28)/2048,
        #help='Set the number of vectors to accumulate between dumps. default is 2*(2^28)/2048, or just under 2 seconds.')
    #p.add_option('-g', '--gain', dest='gain', type='int',default=0xffffffff,
        #help='Set the digital gain (6bit quantisation scalar). Default is 0xffffffff (max), good for wideband noise. Set lower for CW tones.')
    p.add_option('-s', '--skip', dest='skip', action='store_true',
        help='Skip reprogramming the FPGA and configuring EQ.')
    p.add_option('-b', '--bof', dest='boffile',type='str', default='',
        help='Specify the bof file to load')
    p.add_option('-p', '--parameter', dest='stokesp', type='str', default='',
        help='Specify the Stokes parameter')
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH board. Run with the -h flag to see all options.\nExiting.'
        exit()
    else:
        roach = args[0] 
    if opts.boffile != '':
        bitstream = opts.boffile
    if opts.stokesp != '':
        sparameter = opts.stokesp

# What to be shown on X axis while ploting
# ifch means if the X axis is channel number

try:
    loggers = []
    lh=corr.log_handlers.DebugLogHandler()
    logger = logging.getLogger(roach)
    logger.addHandler(lh)
    logger.setLevel(10)


    print('Connecting to server %s on port %i... '%(roach,katcp_port)),
    fpga = corr.katcp_wrapper.FpgaClient(roach, katcp_port, timeout=10,logger=logger)
    time.sleep(1)

    if fpga.is_connected():
        print 'ok\n'
    else:
        print 'ERROR connecting to server %s on port %i.\n'%(roach,katcp_port)
        exit_fail()

    print '------------------------'
    print 'Programming FPGA with %s...' %bitstream,
    if not opts.skip:
        fpga.progdev(bitstream)
        print 'done'
    else:
        print 'Skipped.'
    
    time.sleep(4)
    
    sum_adc0 = fpga.read_uint('adc_sum_sq0')
    fpga.write_int('fft_shift_coars',255) 
    print 'Configuring overflow',
    clockSpeed=fpga.est_brd_clk()
		##for the coarse FFT the layout is debug_chan 22-27, debug_chan_sel 21, debu_pol_sel 20,coarse_chan_select 10-19,fftShift 0-10
    ##choose the debug channel
    debug_chan=25
		#do we get data from the channel or just get value 1?
    debug_chan_sel=1
		##which of the two polarizations do we choose?
    debug_pol_sel=0
    coarse_chan_select=25
    fine_chan_select=25
    fftShift=255
		

	# control register is set up as debug_snap_select 25-27, N/A 24, fine_tvg_en 21, adv_tvg 20, fd_fs_tvg 19, packetizer tvg 18, ct_tvg 17, tvg_en 16, fancy_en 11, adc_protect_enable 10, gbe_en 9 , gbe_rst 8, clr_status 3, ar 2, man_sync 1, sys_rst 0
## snap selections coarse72, fine_128, quant_16, ct_64, xiaui_128, gbetx0_128, buffer_72,finepfb_72
		fpga.write_int('control',0<<25) 
		fpga.write_int('snap_debug_ctrl',0)
		##addrs=numpy.uint32(struct.unpack('>1024l',fpga.read('snap_debug_addr',4096,0)))
		data=numpy.uint32(struct.unpack('>1024l',fpga.read('snap_debug_bram',4096,0)))
		##set up the coarse control register
		fpga.write_int('coarse_ctrl',debug_chan<<22|debug_chan_sel<<21|debug_pol_sel<<20,coarse_chan_select<<10|fftShift<<0) 
		fpga.write_int('fine_ctrl',fine_chan_select) 
     pps_count = fpga.read_uint('pps_count')

		
		#fpga.write_int('q_fft',0b101001010010) 
    #fpga.write_int('p_fft',0b00000000)
    #fpga.write_int('q_fft',0b00000000)
    print 'done' 

    print 'Configuring accumulation period...',
    #fpga.write_int('sync_gen_sync_period_var',81920*8000)
    #fpga.write_int('sync_gen_sync_period_sel', 1)
    print 'done'

    #print 'Set digital gain...',
    #fpga.write_int('gain_I',0x0fffffff)
    #fpga.write_int('gain_V',0x0fffffff)
    #fpga.write_int('gain_U',0x0fffffff)
    #fpga.write_int('gain_Q',0x0fffffff)
    #print 'done'


    print 'enable ADC lines',
    #fpga.write_int('q_en', 1)
    #fpga.write_int('p_en', 1)
    print 'done'

    print 'Set attenuation',
    #fpga.write_int('q_atten',0b0) 
    #fpga.write_int('p_atten',0b0)
    print 'done'

    print 'Sync',
    #fpga.write_int('sync_gen_sync', 1)
    #fpga.write_int('sync_gen_sync', 0)
    print 'done'

    print 'setup',
    ifch = False
    logprint = True
    loggain = 1
    maxfr = 400.0
    xaxis = numpy.arange(0.0, maxfr, maxfr*1./4096)
    print 'done'

    '''screen = curses.initscr()
    curses.noecho()
    curses.curs_set(0)
    screen.keypad(1) 
    screen.addstr("Test\n\n")
    screen.refresh() 
    '''
    prev_integration = fpga.read_uint('acc_num')
    

    # set up the figure with a subplot for each polarisation to be plotted
    #fig = matplotlib.pyplot.figure()
    #ax = fig.add_subplot(4,1,1)

    # start the process
    #fig.canvas.manager.window.after(1000, drawDataCallback)
    #matplotlib.pyplot.show()
    #while (1): 
    #   get_data()
    print 'loop start'
    drawDataLoop()
    #drawData_animate()
    #curses.endwin()
    print 'Exiting...'


except KeyboardInterrupt:
    #curses.endwin()
    exit_clean()
except:
    #curses.endwin()
    exit_fail()

exit_clean()
