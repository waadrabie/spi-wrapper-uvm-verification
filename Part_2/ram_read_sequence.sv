package ram_read_sequence_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_seq_item_pkg::*;
class ram_read_sequence extends uvm_sequence #(ram_seq_item);

`uvm_object_utils(ram_read_sequence)
ram_seq_item seq_item;


function  new(string name ="ram_read_sequence");
    super.new(name);
endfunction

task body;
 seq_item = ram_seq_item::type_id::create("seq_item");
  repeat(10000) begin
  start_item(seq_item);
  seq_item.c_write_only.constraint_mode(0);
  seq_item.c_write_read.constraint_mode(0);
  assert(seq_item.randomize);
  finish_item(seq_item);
 end
endtask
endclass
endpackage
