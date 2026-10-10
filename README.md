# SPI Wrapper UVM Verification (SystemVerilog)

This project implements and verifies an SPI-controlled single-port RAM using SystemVerilog and UVM. The SPI Slave and the RAM are each verified with their own UVM environment, then both environments are reused as passive agents in a top-level SPI Wrapper testbench. The project focuses on RTL debugging, reference model checking, and reusable UVM verification.

## Features

* SPI Slave with a five-state FSM (`IDLE`, `CHK_CMD`, `WRITE`, `READ_ADD`, `READ_DATA`)
* Command decoding from the first 3 MOSI bits (`000` write address, `001` write data, `110` read address, `111` read data)
* 10-bit serial-to-parallel conversion with `rx_data` and `rx_valid`
* Parallel-to-serial read data on `MISO` driven by `tx_data` and `tx_valid`
* Single-port RAM with default `MEM_DEPTH = 256` and `ADDR_SIZE = 8`
* Active-low synchronous reset
* RTL debugging and correction of SPI Slave and RAM control logic
* Golden and reference models written as Verilog modules
* Modular UVM environment for each part, including:
   * Interface and shared package
   * Configuration object
   * Sequence item
   * Reset, main, write, read, and write/read sequences
   * Sequencer, driver, and monitor
   * Agent (active and passive)
   * Scoreboard
   * Coverage collector
   * Environment, test, and top module
* Environment reuse: the SPI Wrapper test instantiates the SPI Slave and RAM environments with passive agents
* SystemVerilog Assertions (SVA) bound to the DUTs, with FSM assertions guarded by `` `ifdef SIM ``

## Verification

* Simulated using QuestaSim 2021.1 with UVM 1.1d
* Verification plan covers:
   * Reset and initialization
   * `SS_n` timing (high for one cycle every 13 cycles, every 23 cycles for read data)
   * Valid command sequences only (000, 001, 110, 111)
   * `rx_valid` assertion exactly 10 cycles after a valid command
   * `tx_valid` behavior during read data
   * FSM transitions
   * Write address followed by write data
   * Read address followed by read data
   * Weighted write/read ordering (60% / 40%)
   * Stable `MISO` outside of read data operations
* Constrained-random stimulus using `pre_randomize`, `post_randomize`, and per-sequence `constraint_mode`
* Scoreboard-based checking of DUT outputs against the reference models
* Code coverage and functional coverage analysis
* Assertion coverage and simulation waveform inspection

### Results

| Part | Successful transactions | Failed transactions | Functional coverage |
|------|------------------------|---------------------|---------------------|
| SPI Slave | 50,001 | 0 | 96.25% |
| RAM | 30,001 | 0 | 100% |
| SPI Wrapper | 15,000 (wrapper), 30,001 (RAM), 30,001 (slave) | 0 | Slave 96.25%, RAM 97.14% |

All assertion cover directives reached 100%, and no `UVM_ERROR` or `UVM_FATAL` was reported.

## Bugs Fixed

* **SPI Slave:** corrected the `received_address` condition to `!received_address`, reset `counter` to zero, and changed the `READ_DATA` counter from 8 to 9 so `rx_valid` asserts at the right time
* **RAM:** added the `MEM_DEPTH` and `ADDR_SIZE` parameters, read from `MEM[Rd_Addr]` instead of `MEM[Wr_Addr]`, moved `tx_valid` assignments inside the case items, and added the missing `begin`/`end` on the reset `else` branch

## Tools

* HDL: SystemVerilog
* Simulation: QuestaSim
* Verification: UVM testbench, scoreboard, functional coverage, and assertions

## Project Documentation

The project report includes the UVM diagrams, verification plans, original and modified RTL, golden models, UVM code, simulation snippets for each sequence, coverage reports, and assertion tables for all three parts.

## Authors

* Waad Rabie Mahmoud
* Rawan Khaled Yahia

