import socket
import struct
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
s.bind(("10.0.0.1",60000))
while True:
				data,addr=s.recvfrom(1024)
				print struct.unpack("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",data[0:40])



								
