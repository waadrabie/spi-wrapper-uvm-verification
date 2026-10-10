package spi_wrapper_write_sequence_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_seq_item_pkg::*;


class spi_wrapper_write_sequence extends uvm_sequence #(spi_wrapper_seq_item);

`uvm_object_utils(spi_wrapper_write_sequence)
spi_wrapper_seq_item seq_item;

function  new(string name ="spi_wrapper_write_sequence");
    super.new(name);
endfunction

task body;
 seq_item = spi_wrapper_seq_item::type_id::create("seq_item");

 repeat(10000) begin
 start_item(seq_item);
 seq_item.c_read_only.constraint_mode(0);
 seq_item.c_write_read.constraint_mode(0);
 assert(seq_item.randomize() );
 finish_item(seq_item);
 end

endtask

endclass

endpackage
