# UART Communication Module

This project implements a UART Transmitter and Receiver in Verilog.

## Features
- Baud Rate: 9600
- Data bits: 8
- Stop bits: 1
- No parity
- Clock: 50MHz

## Folder Structure

## Simulation Steps

### Using Icarus Verilog:
```bash
iverilog -o uart_sim sim/uart_tb.v rtl/uart_tx.v rtl/uart_rx.v rtl/uart_top.v
vvp uart_sim

vlib work
vlog rtl/*.v sim/uart_tb.v
vsim uart_tb
run -all