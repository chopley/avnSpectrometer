'''Script to capture, convert to stokes, accumulate and store data from the AVN Spectrometer.

Doesn't actually store data in its present format, just prints a (numpy) abbreviated version of
it to the screen to prove that it can.
'''

import socket
import multiprocessing
import sys
import time
import struct
import numpy as np
import signal
import sys
import os

# Some constants for making the script easier to modify
packet_length = 264 # Size in bytes of the packet to be received over UDP. This is determined by the current boffile, the way the packetiser works.
accumulation_length = 1000 # This is somewhat arbitrary and can be tuned to suit needs.
frame_length = 4096 # This is how many packets make a 'frame'. In the current design, each packet corresponds to a frequency channel.
fft_group_size = 128 # This is how many actual FFTs come in each frame. This is because of the corner-turner.
# Explanation: each packet contains a header (8 bytes) and 256 bytes of data, 128 times LCP and RCP bytes, each 4-bit real, 4-bit imaginary.
# They're all the same channel - just subsequent samples. Doesn't make as much sense for single-dish observations but this round of the design
# was pirated (in a somewhat modified state) from KAT-7, and that's what was needed for their F-X engine architecture.

# This right here came as the culmination of basically two days of searching.
# Killing or terminating the socket causes problems, especially when it's within
# the 'while 1' loop. Couldn't get around this any way I tried. Eventually decided
# to have a global receive = True varible and use a 'while receive' loop instead.
# However, each process makes a kind of clone of the global environment when it
# starts, so if the signal handler which catches the KeyboardInterrupt interruption
# modifies the parent global variable, the children don't see it because they each
# have their own copy. For this purpose, multiprocessing provides a Value in a shared
# memory space which works almost like a pointer in C but not quite.
receive_UDP = multiprocessing.Value('B', 1)

def interpret_header(header):
    '''Read the header of the UDP packet and return a "timestamp" and a "packet number".
    '''
    timestamp = (header[0]<<28) + (header[1]<<20) + (header[2]<<12) + (header[3]<<4) + ((header[4]&0xf0)>>4)
    packet_number = (header[4]&0x0f) + (header[5]<<4)
    # I've discovered that for individual operations, python's built-in bitwise operations
    # are faster, but for large arrays, numpy's operations are faster than for-loops of these.
    return timestamp, packet_number


def signal_handler(signal, frame):
    '''Called when SIGINT received, aka KeyboardInterrupt exception.
    Sets the global receive_UDP flag to False so that the next process stops
    pulling in packets.
    '''
    print '\n##################\nCtrl+C pressed, exiting sanely...\n##################\n'
    receive_UDP.value = False


def UDP_handler(IP_address, port, output_queue):
    '''UDP handler function. Opens a UDP socket, catches packets and sticks them on an output queue.
    When the global receive_UDP flag goes to False, stops receiving, closes the socket and initiates
    the poison pill.
    '''
    print 'UDP handler PID is %d.'%(os.getpid())
    signal.signal(signal.SIGINT, signal.SIG_IGN) # Ignore KeyboardInterrupt! Let the parent process handle that one.
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((IP_address, port))

    # The script will probably start up somewhere during the course of a frame,
    # in which case we'll want to chuck away everythign up to and including the last
    # packet of the frame, so we can start with the first one of the next one.
    packet, addr = sock.recvfrom(packet_length)
    header = struct.unpack('>' + 'B'*8, packet[0:8])
    data = struct.unpack('>' + 'B'*256, packet[8:])
    timestamp, packet_number = interpret_header(header)
    while (packet_number <> (frame_length - 1)):
        packet, addr = sock.recvfrom(packet_length)
        header = struct.unpack('>' + 'B'*8, packet[0:8])
        data = struct.unpack('>' + 'B'*256, packet[8:])
        timestamp, packet_number = interpret_header(header)
    print 'Packet 0 of new frame found, starting...' # This sort of assumes that zero hasn't been skipped, but the next process can handle.

    while receive_UDP.value: # Keepin' it gangsta.
        packet, addr = sock.recvfrom(packet_length)
        output_queue.put(packet)

    print 'UDP handler detected Ctrl+C, starting the poison pill process...'
    sock.close()
    output_queue.put(None)

def packet_sorter(input_queue, output_queue):
    '''Packet sorter function.
    Gathers 4096 packets together into a group and spits 128 FFTs onto the next queue.
    Checks that there aren't any missing from a particular frame. Current behaviour is to
    discard the entire thing and wait for a next one.
    There may be a more elegant and less lossy way to do this, but I haven't thought of it yet.
    There is enough performance headroom to be able to perhaps do some sorting, but I suspect
    that if anything gets missed, it's actually the previous thread being too slow rather than
    packets arriving out-of-order.
    '''
    print 'packet sorter PID is %d.'%(os.getpid())
    signal.signal(signal.SIGINT, signal.SIG_IGN)

    successful_frames = 0
    failed_frames = 0

    loop = True # This is necessary to be able to break out of a nested loop.
    # Yes, I know, Python Zen says flat is better than nested, but this works
    # quite nicely anyway.
    while loop:
        frame_timestamp = 0 # Just so I'm certain that it actually exists
        data_array = []

        for i in range(frame_length):
            packet = input_queue.get()
            if packet == None:
                print 'Packet sorter detected poison pill, exiting sanely...'
                output_queue.put(None)
                loop = False
                break
            header = struct.unpack('>' + 'B'*8, packet[0:8])
            data = struct.unpack('>' + 'B'*256, packet[8:])
            timestamp, packet_number = interpret_header(header)

            if (packet_number == i):
                data_array.append(data)
            else:
                data_array = []
                packets_before_mistake = i + 1
                packets_after_mistake = 0
                print 'packet %d inappropriate, got %d instead - waiting for frame to empty...'%(i,packet_number)
                while  packet_number <> frame_length - 1:
                    packet = input_queue.get()
                    if packet == None:
                        print 'Packet sorter detected poison pill, exiting sanely...'
                        output_queue.put(None)
                        loop = False
                        break
                    header = struct.unpack('>' + 'B'*8, packet[0:8])
                    timestamp, packet_number = interpret_header(header)
                    packets_after_mistake += 1
                print 'frame empty, size would have been %d\ncontinuing...'%(packets_before_mistake + packets_after_mistake)
                break

            if (i == 0):
                frame_timestamp = timestamp
                print 'timestamping new frame: %d'%(frame_timestamp)

        if len(data_array) == frame_length: # i.e. if we haven't stopped partway through a frame.
            print 'frame of packets with timestamp %d received successfully, releasing individual ffts in order'%(frame_timestamp)
            data_array = np.array(data_array)
            data_array = data_array.transpose()
            for i in range(fft_group_size):
                fft_l = data_array[2*i]
                fft_r = data_array[2*i+1]
                fft_timestamp = frame_timestamp + i/1000.0 # Position of FFT in frame indicated by decimal point...
                output_queue.put((fft_timestamp, fft_l, fft_r))
            successful_frames += 1
        else:
            print 'frame incorrect length, discarding...'
            failed_frames += 1

    print 'Successful frames: %d\nFailed frames: %d\nLoss: %.2f percent.'%(successful_frames, failed_frames, 100*(float(failed_frames)/(failed_frames + successful_frames)))

def Stokes_converter(input_queue, output_queue):
    '''Stokes converter function
    Converts each individual FFT with LCP and RCP complex values into
    scalar-valued Stokes parameters and puts them onto the next queue, ready for accumulation.
    '''
    print 'stokes converter PID is %d.'%(os.getpid())
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    while 1: # Flat loop so no loop variable needed.
        #print 'queue2 size: %d'%(input_queue.qsize())
        fft = input_queue.get()
        if fft == None:
            print 'Stokes converter detected poison pill, exiting sanely...'
            output_queue.put(None)
            break
        timestamp = fft[0]

        fft_l = np.array(fft[1]) # need to convert this to complex.
        # Here the numpy stuff is faster because there are 4096 of them.
        fft_l_i = (np.bitwise_and(fft_l, 0x0f) << 4).astype(np.int8) >> 4
        fft_l_r = np.bitwise_and(fft_l, 0xf0).astype(np.int8) >> 4
        fft_l = fft_l_r + fft_l_i*1j

        fft_r = np.array(fft[2])
        fft_r_i = (np.bitwise_and(fft_r, 0x0f) << 4).astype(np.int8) >> 4
        fft_r_r = np.bitwise_and(fft_r, 0xf0).astype(np.int8) >> 4
        fft_r = fft_r_r + fft_r_i*1j

        # Wikipedia has a pretty good explanation of how these are calculated.
        stokes_I = np.square(np.abs(fft_l)) + np.square(np.abs(fft_r))
        stokes_Q = 2*np.real( np.multiply(np.conj(fft_l), fft_r) )
        stokes_U = -2*np.imag( np.multiply(np.conj(fft_l), fft_r) )
        stokes_V = np.square(np.abs(fft_r)) - np.square(np.abs(fft_l))

        output_queue.put((timestamp, stokes_I, stokes_Q, stokes_U, stokes_V))

def accumulator(input_queue, accum_length):
    '''Accumulator function
    Receives Stokes parameters one at a time, adds them together according to the
    specified accumulation length, then in the current iteration prints them to the
    screen. Next iteration will likely save numpy binaries. Possibly in the future,
    a new process after this one might receive the accumulated blocks and put them
    in an HDF-5 file.
    '''
    print 'accumulator PID is %d.'%(os.getpid())
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    loop = True
    while loop:
        #print 'queue3 size: %d'%(input_queue.qsize())
        stokes_set = input_queue.get()
        if stokes_set == None:
            print 'accumulator detected poison pill, exiting sanely...'
            # Close up files here.
            loop = False
            break
        timestamp = stokes_set[0]
        stokes_accumulator = np.array(stokes_set[1:])
        for i in range(accum_length -1):
            stokes_set = input_queue.get()
            if stokes_set == None:
                print 'accumulator detected poison pill, exiting sanely...'
                # Toss this one and close up files.
                loop = False
                break
            stokes_accumulator += np.array(stokes_set[1:])

        # Replace this with actually storing the data. When I get around to figuring out exactly how that should work.
        print stokes_accumulator


if __name__ == '__main__':
    from optparse import OptionParser
    p = OptionParser()

    # Haven't actually added any options yet, I initially thought that I might.
    # I may still do so later, e.g. for choosing the output format, or perhaps
    # the option to store something other than Stokes, in which case I'd need to
    # fire up a different process. If the need arises.
    p.set_usage('python avnSpectrometerAccumulator.py <ROACH 10GbE IP> <ROACH 10GbE Port> [options]')
    p.set_description(__doc__)
    opts, args = p.parse_args(sys.argv[1:])

    if args==[]:
        print 'Please specify a ROACH 10GbE IP address.\nExiting...'
        exit()
    else:
        roach_IP = args[0]
        roach_port = int(args[1])

    signal.signal(signal.SIGINT, signal_handler) # This catches KeyboardInterrupt signals and sends them to the handler.

    queue1 = multiprocessing.Queue()
    queue2 = multiprocessing.Queue()
    queue3 = multiprocessing.Queue()

    UDP_handler_process = multiprocessing.Process(name='UDP handler', target=UDP_handler, args=(roach_IP, roach_port, queue1))
    packet_sorter_process = multiprocessing.Process(name='packet sorter', target=packet_sorter, args=(queue1,queue2))
    stokes_converter_process = multiprocessing.Process(name='Stokes converter', target=Stokes_converter, args=(queue2,queue3))
    accumulator_process = multiprocessing.Process(name='accumulator', target=accumulator, args=(queue3, accumulation_length))

    # Start up...
    UDP_handler_process.start()
    packet_sorter_process.start()
    stokes_converter_process.start()
    accumulator_process.start()

    signal.pause() # Let the child processes do their thing until the signal is received...

    # Close everything up...
    print 'Waiting for child processes to join...'
    UDP_handler_process.join()
    packet_sorter_process.join()
    stokes_converter_process.join()
    accumulator_process.join()

    print 'Success! All child processes joined cleanly.'

