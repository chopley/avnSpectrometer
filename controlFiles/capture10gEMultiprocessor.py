import socket
import struct
import numpy
import multiprocessing as mp
import time
import pylab

dataQueue=mp.Queue()

def udpHandler(dataQ):

				s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
				s.bind(("10.0.0.1",60000))
				newTimeQ=numpy.zeros(4096)
				newTime=0
				iCount=0
				test="";
				dataIn=();
				dataFrame=numpy.array([]);
				dataPackets=0
				while True:
								list_len=264-8
								data,addr=s.recvfrom(1024)
								test +=data[8:264]
								format_str='<'+'BBBBBBBB'+'b'*list_len
								dd=struct.unpack(format_str,data)
							#	dataIn=dataIn + dd[6:50]
								#numpy.array(dd[6:50])
							#	dataFrame=numpy.append(dataFrame,dataIn)
							#	for i in range(6,50):
							#					ttimag = dd[i]&0x0f
							#					ttreal = dd[i]>>4&0x0f
							#					tt = ttreal + ttimag*1j
							#					ttPow = tt**2
								timeStamp = ((dd[3]<<4)+((dd[4]>>4&0x0f)))<<12
								timeStamp2 = ((dd[5]))<<4
								timeStamp3 = dd[4]&0x0f
								##the header is defined as follows
								#bits 0-15 antenna base
								#bits 16-27 pcnt
								#bits 29-63 timestamp
				#				print 'antenna base',dd[7],dd[6]
				#				print 'pcnt',dd[5],dd[4]>>4&0x0f
				#				print 'timestamp',dd[4]&0x0f,dd[3],dd[2],dd[1],dd[0]
								oldTime=newTime
								newTime = timeStamp+timeStamp2+timeStamp3
								newTimeQ[iCount]=newTime
								iCount=iCount+1
							#	print oldTime,newTime
								if iCount>=32:
												datamsg=numpy.append(dataPackets, newTimeQ)
												dataQ.put(datamsg)
												dataQ.put(test)
												dataIn=()
												#print len(test)
												test=""
												dataPackets=dataPackets+1
												iCount=0
											#	print 'iCount=',iCount
								#print ttPow
					#			if((oldTime+15!=newTime) | (oldTime+1!=newTime)):
					#							print 'tt',oldTime,newTime

def dataProcessor(dataQ):
				i=0
				accumulations=100
				accCnt=0
				data=numpy.zeros(4096,dtype=numpy.complex)
				I1total=numpy.zeros(4096,dtype=numpy.complex)
				I2total=numpy.zeros(4096,dtype=numpy.complex)
				Qtotal=numpy.zeros(4096,dtype=numpy.complex)
				Utotal=numpy.zeros(4096,dtype=numpy.complex)
				while(1):
								t=dataQ.get()
								tstring=dataQ.get()
								print 'gotcha',t[0]
								list_len=264-8
								format_str=('<'+'B'*32*list_len)
								dd=struct.unpack(format_str,tstring)
								tt=numpy.array(dd)
								ttimag = ((tt&0x0f))
								ttreal = (((tt>>4)&0x0f))
								tt = ttreal + ttimag*1j
							#	print t[0]				
								Pol2Complex = tt[1::2]
								Pol1Complex = tt[0::2]
								I1 = Pol1Complex*numpy.conj(Pol1Complex)
								I2 = Pol2Complex*numpy.conj(Pol2Complex)
							#	I1 = numpy.real(Pol1Complex)
							#	I2 = numpy.real(Pol2Complex)
								Q=numpy.real(Pol1Complex*Pol2Complex)
								U=numpy.imag(Pol1Complex*Pol2Complex)
								I1total+=I1
								I2total+=I2
								Qtotal+=Q
								Utotal+=U
								if i>=accumulations:
									print I1total
									print I2total
									numpy.savetxt("I1total.csv", numpy.real(I1total), delimiter=",",fmt='%10.5f')
									numpy.savetxt("I2total.csv", numpy.real(I2total), delimiter=",",fmt='%10.5f')
									I1total=numpy.zeros(4096,dtype=numpy.complex)
									I2total=numpy.zeros(4096,dtype=numpy.complex)
									Qtotal=numpy.zeros(4096,dtype=numpy.complex)
									Utotal=numpy.zeros(4096,dtype=numpy.complex)
									i=0
								i=i+1
								
							#	print(dd[0:1024])

udpH=mp.Process(target=udpHandler,args=(dataQueue,))
dataP=mp.Process(target=dataProcessor,args=(dataQueue,))
udpH.start()
dataP.start()

while(1):
				time.sleep(1)
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

								
