### TDC implamentation on a RedPitaya STEMLab 125-14 ZYNQ 7000 board using a CARRY4 chain as a delay line.

 Work in progress using Vivado 2019.1

 Added measurement & readout of coarse and two fine-time intervals.

 The TDC is readout using the Periphery module in python using the MMAP addresses of the 2 AXI_GPIO modules created in Vivado 
 The code is in the file TDC-Test.ipynb to run with Jupyter Notebook on the RedPytaya 

 To do: Test and add calibration scheme
