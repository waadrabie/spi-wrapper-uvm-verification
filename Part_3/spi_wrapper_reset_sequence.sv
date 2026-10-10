package spi_wrapper_reset_sequence_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_seq_item_pkg::*;
import spi_wrapper_pkg::*;

class spi_wrapper_reset_sequence extends uvm_sequence #(spi_wrapper_seq_item);

`uvm_object_utils(spi_wrapper_reset_sequence)
spi_wrapper_seq_item seq_item;

function  new(string name ="spi_wrapper_reset_sequence");
    super.new(name);
endfunction

task body;
 seq_item = spi_wrapper_seq_item::type_id::create("seq_item");
 start_item(seq_item);
 seq_item.rst_n  = 0;
 seq_item.MOSI   = 0;
 seq_item.SS_n   = 0;
 finish_item(seq_item);

endtask

endclass
endpackage
