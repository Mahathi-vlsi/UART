UART (Universal Asynchronous Receiver Transmitter)
Overview
This project implements a basic UART Transmitter and Receiver using Verilog HDL. UART is a serial communication protocol

Objectives
Design a UART Transmitter (TX)
Design a UART Receiver (RX)
Verify functionality using a testbench
Simulate the design and analyze waveforms
Features
8-bit Data Transmission
1 Start Bit
1 Stop Bit
Serial Communication
RTL Design in Verilog
Functional Verification using Testbench
Project Files
uart_tx.v : UART Transmitter
uart_rx.v : UART Receiver
uart_TOP.v : Top Module
uart_TB.v : Testbench
README.md : Project Documentation
UART Frame Format
Start Bit | Data Bits (8-bit) | Stop Bit

  0    D0 D1 D2 D3 D4 D5 D6 D7    1
Tools Used
Verilog HDL
EDA Playground
GTKWave / EPWave
 ## Waveform

The following waveform shows the simulation results of the UART
![UART Waveform](waveform.jpg)



