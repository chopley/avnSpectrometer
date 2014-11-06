import pylab
import time
import numpy

pylab.ion()
while(1):
				time.sleep(0.01)
				pylab.clf()
				I1total=numpy.loadtxt('I1total.csv')
				I2total=numpy.loadtxt('I2total.csv')
			#	pylab.plot(10*numpy.log10(I1total),'b')
			#	pylab.plot(10*numpy.log10(I2total),'g')
				pylab.plot(I1total,'b')
				pylab.plot(I2total,'g')
				print I1total
				pylab.draw()
