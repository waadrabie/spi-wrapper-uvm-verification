package spi_slave_main_sequence_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_pkg::*;


class spi_slave_main_sequence extends uvm_sequence #(spi_slave_seq_item);

`uvm_object_utils(spi_slave_main_sequence)
spi_slave_seq_item seq_item;

function  new(string name ="spi_slave_main_sequence");
    super.new(name);
endfunction

task body;
 seq_item = spi_slave_seq_item::type_id::create("seq_item");

 repeat(50000) begin
 start_item(seq_item);
 assert(seq_item.randomize);
 finish_item(seq_item);
 end

endtask
endclass
endpackage
