package spi_slave_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_pkg::*;
import spi_slave_pkg::*;
class spi_slave_monitor extends uvm_monitor ;
`uvm_component_utils(spi_slave_monitor)
virtual spi_slave_if spi_slave_monitor_vif;
spi_slave_seq_item rsp_seq_item;
uvm_analysis_port #(spi_slave_seq_item) mon_ap;

function  new(string name ="spi_slave_monitor",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon_ap = new("mon_ap", this);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    rsp_seq_item = spi_slave_seq_item::type_id::create("rsp_seq_item");
    @(negedge spi_slave_monitor_vif.clk);
    rsp_seq_item.tx_valid     = spi_slave_monitor_vif.tx_valid;
    rsp_seq_item.tx_data      = spi_slave_monitor_vif.tx_data;
    rsp_seq_item.SS_n         = spi_slave_monitor_vif.SS_n;
    rsp_seq_item.MOSI         = spi_slave_monitor_vif.MOSI;
    rsp_seq_item.rst_n        = spi_slave_monitor_vif.rst_n; 
    rsp_seq_item.MISO         = spi_slave_monitor_vif.MISO; 
    rsp_seq_item.rx_data      = spi_slave_monitor_vif.rx_data; 
    rsp_seq_item.rx_valid     = spi_slave_monitor_vif.rx_valid; 
    rsp_seq_item.MISO_ref     = spi_slave_monitor_vif.MISO_ref; 
    rsp_seq_item.rx_data_ref  = spi_slave_monitor_vif.rx_data_ref; 
    rsp_seq_item.rx_valid_ref = spi_slave_monitor_vif.rx_valid_ref; 
    mon_ap.write(rsp_seq_item);
   `uvm_info("run_phase",rsp_seq_item.convert2string(), UVM_HIGH);
  end
endtask
endclass
endpackage
