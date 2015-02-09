import socket
import struct
import numpy
import threading
import time



def udpHandler(dataReady):

				s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
				s.bind(("10.0.0.1",60000))
				newTime=0
				while True:
								list_len=264-8
								data,addr=s.recvfrom(1024)
								format_str='<'+'BBBBBBBB'+'b'*list_len
								dd=struct.unpack(format_str,data)
								for i in range(6,50):
												ttimag = dd[i]&0x0f
												ttreal = dd[i]>>4&0x0f
												tt = ttreal + ttimag*1j
												ttPow = tt**2
								timeStamp = ((dd[3]<<4)+((dd[4]>>4&0x0f)))<<12
								timeStamp2 = ((dd[5]))<<4
								timeStamp3 = dd[4]&0x0f
								oldTime=newTime
								newTime = timeStamp+timeStamp2+timeStamp3
								#print ttPow
								if(oldTime+1!=newTime):
										 print newTime



threads = []
dataReady=threading.Event()
t=threading.Thread(name='udpHandler',target=udpHandler,args=(dataReady,))
t.start()

while(1):
				sleep(1)
	#			tt=numpy.array(dd[6:256])
		#		ttcomplex=tt&0x0f
		#		ttreal=tt>>4&0x0f
	#			ttVals=ttreal+1j*ttcomplex
			#	power=numpy.abs(ttVals)
		#		Pol1Complex = ttVals[0::2]
		#		Pol2Complex = ttVals[1::2]
			#	I1 = Pol1Complex*Pol1Complex
			#	I2 = Pol2Complex*Pol2Complex
	#			Q=numpy.real(Pol1Complex[0:124]*Pol2Complex[0:124])
		#		U=numpy.imag(Pol1Complex[0:124]*Pol2Complex[0:124])
#				print dd[0],dd[1],dd[2],dd[3],dd[4]>>4&0x0f,dd[5],dd[4]&0x0f,I1[0:10],I2[0:10],Q[0:10],U[0:10]
#				print dd[0],dd[1],dd[2],dd[3],dd[4]>>4&0x0f,dd[4]&0x0f,dd[5],dd[6],dd[7],dd[8],numpy.size(Pol1Complex)
		#		print dd[0],dd[1],dd[2],dd[3],dd[4]>>4&0x0f,dd[4]&0x0f,dd[5],dd[6],dd[7],dd[8]

								
