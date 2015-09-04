# AVN Spectrometer c09f12_xxavn family control file documentation

In this directory are the actual working control files. In the parent directory are earlier development versions and most aren't useful anymore. Don't judge, we hadn't quite gotten the hang of this whole git thing yet...

## Using these files
The first file you're going to want is probably `initRoach.py`. This file initialises the targeted FPGA with the latest bof file, and can properly configure the desired frequency channel which will be output from the FPGA.

For snapshot functionality, mostly intended for debugging and commissioning, the all-purpose script avnSpectrometerDisplayBroad.py is provided here. The script follows the convention of all the other ones and extensive usage information along with suggested options for running it can be obtained from the script's docstring, or by running `python avnSpectrometerDisplayBroad.py --help`.

The same `--help` functionality exists in all the scripts except for `avn_spectrometer.py`, which is intended as a helper-module for the other scripts and is not intended to be executed by itself.

The bulk of the work of data collection will be done via 10GbE, this is handled by the `avnSpectrometerAccumulator.py` script. This script doesn't program the ROACH, it merely sets up a UDP socket and waits to receive data. The data sent by the ROACH comes in packets, each packet contains a header (8 bytes) and 256 bytes of data, 128 times LCP and RCP bytes, each 4-bit real, 4-bit imaginary. They're all the same channel - just subsequent samples.
This design doesn't make as much sense for single-dish observations but this round of the design was pirated (in a somewhat modified state) from KAT-7, and that's what was needed for their F-X engine architecture.

This script requires python's multpirocessing library and a fairly beefy machine (capable of at least 4 simultaneous threads, therefore a dual-core machine will suffice but quad-core is preferable). It is initialised as per usual, being passed the IP address and the port on which it should expect data from the ROACH, and the optional -a flag to specify an accumulation length.

The number of accumulations per frame saved depends on the requirements of the operator: the sampling frequency is 800 MHz, and a 512-point coarse and 4096-point fine FFT are performed, rendering each individual FFT worth around 10 ms of time.

Data from this script is also timestamped and saved as numpy binary format, along with a png plot of Stokes I for quick observations. See the script's docstring for more information.

## Data structures
The python [construct](http://construct.readthedocs.org/en/latest/) library is used in most cases to squash smaller (single- or multi-bit) pieces of data into a bigger binary word.

### register: control
#### Bit description:
Bits  | Name                 | Description
------|----------------------|--------------
25-27 | `debug_snap_select`  | Selects which of the streams are sent to the `snap_debug` block, defined in dictionary below.
21    | `fine_tvg_en`        | Enable test vector generator (TVG) on the fine FFT
20    | `adc_tvg`            | Not implemented in this design
19    | `fd_fs_tvg`          | Fine Delay Tracking and Fringe Stopping TVG
18    | `packetiser_tvg`     | Packetiser TVG
17    | `ct_tvg`             | Corner-turner TVG
16    | `tvg_en`             | TVG master-switch. If this is 0, the above will be ignored.
11    | `fancy_en`           | Not actually too sure what this does yet… goes to the LED block.
10    | `adc_protect_disable`| Must be high in order for the ADC to work.
09    | `gbe_enable`         | Must be high for the 10 Gb/s ethernet to work.
08    | `gbe_rst`            | Resets the 10 GbE
03    | `clr_status`         | Posedge here clears all status registers
02    | `arm`                | Posedge here gives everything the go-ahead.
01    | `man_sync`           | Seems to be a “manual sync” bit, not sure exactly how it works though.
00    | `sys_rst`            | Resets everything
####`debug_snap_select` dictionary:
number | data set to pass   | description
-------|--------------------|----------
7      | `fine_pfb_72`      |
6      | `buffer_72`        | 
5      | `gbetx0_128`       | xaui packetiser output, 10GbE block input
4      | `xaui_128`         | initial (spead-like) packetiser output, xaui input
3      | `ct_64`            | corner turner
2      | `quant_16`         | quantiser
1      | `fine_128`         | fine FFT
0      | `coarse_72`        | coarse FFT
The data structures are explained in the next section.

### register: `coarse_ctrl
#### Bit description:
Bits    | Name               | Description
--------|--------------------|-------------------------
22 - 27 | `cdebug_chan`        | Selects which channel to pass to the debug snap block. If bit 21 is 0 then this is effectively ignored.
21      | `cdebug_chan_sel`    | Selects whether only a single channel will be passed to the debug snap block. 0 passes all the channels, 1 passes only the selected channel.
20      | `cdebug_pol_sel`     | Selects polarisation passed to debug snap block. 0 passes I input (LCP), adc0 in the boffile, 1 passes Q input (RCP), adc1 in the boffile
10 - 19 | `coarse_chan_select` | 10 bits wide, but only lower bit used in coarse block. 0 allows even-numbered channels to pass, 1 allows odd-numbered channels to pass. All 10 bits are used in the fine block along with a counter and comparator to pass only the selected channel.
0 - 9   | `coarse_fft_shift`   | From the [CASPER wiki](https://casper.berkeley.edu/wiki/Fft_wideband_real): Sets the shifting schedule through the FFT to prevent overflow. Bit 0 specifies the behavior of stage 0, bit 1 of stage 1, and so on. If a stage is set to shift (with bit = 1), then every sample is divided by 2 at the output of that stage. 

### register: `fstatus0` and `fstatus1`
These two have the same structure, one just refers to the left and the other to the right polarisation. Some of these come out on the lights, but some don't.
Charles's picture in the ROACH setup document is useful for that.
#### Bit description:
Name                  | bits  | description
----------------------|-------|-------------------------------------------
`coarse_bits`          | 27-31 | 2^x - the number of points in the coarse FFT.
`fine_bits`            | 22-26 | 2^y - the number of points in the fine FFT.
`sync_val`             | 20-21 | On which ADC cycle did the sync happen?
                       | 18-19 |
`xaui_lnkdn`           | 17    | The 10GBE link is down.
`xaui_over`            | 16    | The 10GBE link has overflows.
                       | 7-15  |
`clk_err`              | 6     | The board frequency is calculated out of bounds.
`adc_disabled`         | 5     | The ADC has been disabled.
`ct_error`             | 4     | There is a QDR error from the corner-turner.
`adc_overrange`        | 3     | The ADC is reporting over-ranging.
`fine_fft_overrange`   | 2     | Not used currently. (As far as I can make out from the simulink model anyway.)
`coarse_fft_overrange` | 1     | The coarse FFT is over-range.
`quant_overrange`      | 0     | The quantiser is over-range.

### data structure: `coarse_72`
Each data word has 72 bits of data, an even and an odd channel both having 18-bit real and 18-bit imaginary components. Since the bram block is 1024 words in size, this means that each coarse FFT snap is actually an accumulation of 8 coarse FFTs all retrieved in the same snap.

Left and right polarities must be snapped seperately - the snap function handles this and returns both.
#### Bit description:
Bits | Name   | Description
-----|--------|------------
56   | -      | Padding
18   | `d0_r` | Even-numbered channel, real component
18   | `d0_i` | Even-numbered channel, imaginary component
18   | `d1_r` | Odd-numbered channel, real component
18   | `d1_i` | Odd-numbered channel, imaginary component

### data structure: `fine_128`
Though it's called `fine_128`, each word has 4x31-bit data, which technically makes it 124 bits. Since there are 4096 channels to retrieve instead of just 256, it takes 4 snaps in order to do that (including the relevant timed offsets for the second, third, etc.). The snap function handles this without having to get any extra input from the user, but naturally then takes longer to return. The two polarities are interleaved, not separate as in the coarse FFT.
#### Bit description:
Bits | Name   | Description
-----|--------|------------
 4   | -      | Padding
31   | `d0_r` | left-polarisation, real component
31   | `d0_i` | left-polarisation, imaginary component
31   | `d1_r` | right-polarisation, real component
31   | `d1_i` | right-polarisation, imaginary component

### data structure: `quant_16`
Essentially the same thing as the fine FFT going on here, though after coming out of the quantiser, the data is 4 bits instead of 31.
#### Bit description:
Bits | Name   | Description
-----|--------|------------
112  | -      | Padding
 4   | `d0_r` | left-polarisation, real component
 4   | `d0_i` | left-polarisation, imaginary component
 4   | `d1_r` | right-polarisation, real component
 4   | `d1_i` | right-polarisation, imaginary component

### data structure: `ct_64`
This is where it becomes interesting. The corner turner effectively performs a matrix transpose operation - rows of data go in, columns of data are read out. This isn't strictly necessary for the purposes of this exercise, but the FPGA image was scavenged from the KAT-7 project, to save us having to do a whole one from scratch (which would have taken many months...), so we needed to figure out how it works in order to proceed.

The data which is coming through here is organised as follows:
#### Bit description:
Bits| Name  |Description
----|-------|----------------------
64  | -     | padding
4   |`p00_r`| pol 0, sample 0, real
4   |`p00_i`| pol 0, sample 0, imag
4   |`p10_r`| pol 1, sample 0, real
4   |`p10_i`| pol 1, sample 0, imag
4   |`p01_r`| pol 0, sample 1, real
4   |`p01_i`| pol 0, sample 1, imag
4   |`p11_r`| pol 1, sample 1, real
4   |`p11_i`| pol 1, sample 1, imag
4   |`p02_r`| pol 0, sample 2, real
4   |`p02_i`| pol 0, sample 2, imag
4   |`p12_r`| pol 1, sample 2, real
4   |`p12_i`| pol 1, sample 2, imag
4   |`p03_r`| pol 0, sample 3, real
4   |`p03_i`| pol 0, sample 3, imag
4   |`p13_r`| pol 1, sample 3, real
4   |`p13_i`| pol 1, sample 3, imag
Pol 0 is left, pol 1 is right, and each word contains 4 samples. These samples are all in the same frequency channel! The corner-turner has 128 rows which go in, and outputs the colums, therefore we get 128 successive samples of channel 0, then 128 of channel 1, etc. Since there are 4 per word, this means 32 words per channel, and 32 channels come through in each snap. Therefore, in order to get the entire spectrum, 128 successive snaps have to be made. This of course is only valid if the spectrum of the data is not changing during the course of the function, as it does take quite a while to finish.

### data structure: adc
The ADC samples at 800 MHz, but the FPGA runs at 200 MHz, so the samples are delivered four at a time. There's a separate snap block for each polarisation
#### Bit description:
Bits | Name   | Description
-----|--------|------------
 8   | `d0_0` | first sample
 8   | `d0_1` | second sample
 8   | `d0_2` | third sample
 8   | `d0_3` | fourth sample
 8   | `d1_0` | fifth sample
 8   | `d1_1` | sixth sample
 8   | `d1_2` | seventh sample
 8   | `d1_3` | eigth sample

### Other data structures
The other snap data available from the `debug_snap` block isn't used in these scripts at all, so I haven't included it in `avn_spectrometer.py`, or this document. For those really interested, the code for the [corr library](http://www.github.com/ska-sa/corr) is where I got most of my information.

## Notes on the code
### General register writing procedure

Here is an example of some code used to write to a register:

```python
control_reg = control_reg_bitstruct.parse(struct.pack('>I',fpga.read_uint('control')))
control_reg.debug_snap_select = debug_snap_select['coarse_72']
fpga.write_int('control', struct.unpack('>I', control_reg_bitstruct.build(control_reg))[0])
```

A bitstruct conveniently detailing which bits of the control register are which is provided. Read the current value from the FPGA using `fpga.read_uint(<register name>)`. This is useful so that if you want to change only one or two parts of the register, then you can read in whatever values were previously there so that the other unrelated values which you're not changing aren't overwritten with whatever.

This value will be an integer. Pack it into a bit sequence using struct.pack, the `>I` is important because it indicates that the number is a 4-byte (32bit) big-endian number, which is not the default on Intel machines, so without this it’ll get things wrong.

Parse this bit sequence using <bitstruct name>.parse().

Assign the relevant values (whether boolean or integer of arbitrary length) using an object.parameter style assignment. In the example, a dictionary is used to aid in the clarity of the code (easier to know what is being assigned than the integer value 0).

Build the bit sequence into a string using bitstruct.build, then unpack it back to an integer using struct.unpack with the big-endian format sequence. This returns a tuple, so pass the first element `[0]` of the tuple which is the desired integer, to the fpga.write_int function where it can be written to the relevant register on the FPGA.
