package spi_wrapper_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_seq_item_pkg::*;
class spi_wrapper_driver extends uvm_driver #(spi_wrapper_seq_item);
`uvm_component_utils(spi_wrapper_driver)
virtual spi_wrapper_if spi_wrapper_driver_vif;
spi_wrapper_seq_item stim_seq_item;
function  new(string name ="spi_wrapper_driver",uvm_component parent = null);
    super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);

    forever begin
    stim_seq_item = spi_wrapper_seq_item::type_id::create("stim_seq_item");
    seq_item_port.get_next_item(stim_seq_item);
 
    spi_wrapper_driver_vif.SS_n   = stim_seq_item.SS_n;
    spi_wrapper_driver_vif.MOSI   = stim_seq_item.MOSI;   
    spi_wrapper_driver_vif.rst_n  = stim_seq_item.rst_n;
    @(negedge spi_wrapper_driver_vif.clk); 
     seq_item_port.item_done();
   `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(), UVM_HIGH);      
    end

  endtask
  endclass
  endpackage
