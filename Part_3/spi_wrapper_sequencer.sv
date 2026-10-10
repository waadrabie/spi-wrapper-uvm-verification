package spi_wrapper_sequencer_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_seq_item_pkg::*;

class spi_wrapper_sequencer extends uvm_sequencer #(spi_wrapper_seq_item);
`uvm_component_utils(spi_wrapper_sequencer)
  function  new(string name ="spi_wrapper_sequencer",uvm_component parent = null);
    super.new(name,parent);
endfunction
endclass
endpackage
