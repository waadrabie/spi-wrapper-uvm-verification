package spi_wrapper_monitor_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_seq_item_pkg::*;
import spi_wrapper_pkg::*;
class spi_wrapper_monitor extends uvm_monitor ;
`uvm_component_utils(spi_wrapper_monitor)
virtual spi_wrapper_if spi_wrapper_monitor_vif;
spi_wrapper_seq_item rsp_seq_item;
uvm_analysis_port #(spi_wrapper_seq_item) mon_ap;

function  new(string name ="spi_wrapper_monitor",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon_ap = new("mon_ap", this);
endfunction
  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    rsp_seq_item = spi_wrapper_seq_item::type_id::create("rsp_seq_item");
    repeat(2)@(negedge spi_wrapper_monitor_vif.clk);
    rsp_seq_item.SS_n      = spi_wrapper_monitor_vif.SS_n;
    rsp_seq_item.MOSI      = spi_wrapper_monitor_vif.MOSI;
    rsp_seq_item.rst_n     = spi_wrapper_monitor_vif.rst_n;
    rsp_seq_item.MISO      = spi_wrapper_monitor_vif.MISO;
    rsp_seq_item.MISO_ref  = spi_wrapper_monitor_vif.MISO_ref;
    
    mon_ap.write(rsp_seq_item);
   `uvm_info("run_phase",rsp_seq_item.convert2string(), UVM_HIGH);
  end
  endtask
endclass
endpackage
