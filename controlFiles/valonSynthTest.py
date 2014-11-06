import valon_synth
import time

a=valon_synth.Synthesizer('/dev/ttyUSB1')

for i in range(1,200):
				freq=190+i*0.1
				b=a.set_frequency(8,freq)
				print b,freq
				time.sleep(0.1)

