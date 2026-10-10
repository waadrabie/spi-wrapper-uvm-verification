package ram_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_pkg::*;
class ram_seq_item extends uvm_sequence_item;
`uvm_object_utils(ram_seq_item)

rand logic [9:0] din;
rand logic       rst_n, rx_valid;

logic [7:0] dout;
logic       tx_valid;
logic [7:0] dout_ref;
logic       tx_valid_ref;

rw_e old_rw;
rand rw_e rw;

function  new(string name ="ram_seq_item");
    super.new(name);
endfunction

function string convert2string();
return $sformatf("%s rst_n=%b,din=%b,rx_valid=%b,dout=%b,tx_valid=%b",
                 super.convert2string(),rst_n,din,rx_valid,dout,tx_valid);
endfunction

function string convert2string_stimulus();
return $sformatf("rst_n=%b,din=%b,rx_valid=%b ",
                  rst_n,din,rx_valid);
endfunction

constraint c_rst_n        { rst_n   dist{1:=95,0:=5};}
constraint c_rx_valid     { rx_valid   dist{1:=95,0:=5};}
constraint c_write_only   { rw inside {WRITE_ADDRESS,WRITE_DATA};
                             if (old_rw == WRITE_ADDRESS) rw inside {WRITE_ADDRESS,WRITE_DATA}; }

constraint c_read_only    { rw inside {READ_ADDRESS,READ_DATA};
                            if (old_rw == READ_ADDRESS)  rw == READ_DATA;
                            else if (old_rw == READ_DATA)  rw == READ_ADDRESS;}

constraint c_write_read   { if      (old_rw == WRITE_ADDRESS) rw inside {WRITE_ADDRESS,WRITE_DATA};
                            else if (old_rw == WRITE_DATA)    rw dist   {READ_ADDRESS:=60, WRITE_ADDRESS:=40};
                            else if (old_rw == READ_ADDRESS)  rw inside {READ_ADDRESS, READ_DATA};
                            else                              rw dist   {WRITE_ADDRESS:=60, READ_ADDRESS:=40}; } 

function void post_randomize;
din[9:8] = rw;
old_rw = rw;
endfunction

endclass
endpackage
