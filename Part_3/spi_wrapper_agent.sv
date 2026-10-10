package spi_wrapper_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_seq_item_pkg::*;
import spi_wrapper_config_obj_pkg::*;
import spi_wrapper_driver_pkg::*;
import spi_wrapper_monitor_pkg::*;
import spi_wrapper_sequencer_pkg::*;
class spi_wrapper_agent extends uvm_agent;
`uvm_component_utils(spi_wrapper_agent)
 spi_wrapper_sequencer sqr;
 spi_wrapper_driver drv;
 spi_wrapper_monitor mon;
 spi_wrapper_config_obj spi_wrapper_cfg;
 uvm_analysis_port #(spi_wrapper_seq_item) agt_ap;
function  new(string name ="spi_wrapper_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon = spi_wrapper_monitor::type_id::create("mon",this);
  agt_ap = new("agt_ap", this);
  spi_wrapper_cfg = spi_wrapper_config_obj::type_id::create("spi_wrapper_cfg");
  if(!uvm_config_db#(spi_wrapper_config_obj)::get(this,"","SPI_WRAPPER_CFG",spi_wrapper_cfg))
   `uvm_fatal("build_phase","Unable to get configuration object");
     if(spi_wrapper_cfg.is_active == UVM_ACTIVE) begin
  sqr = spi_wrapper_sequencer::type_id::create("sqr",this);
  drv = spi_wrapper_driver::type_id::create("drv",this);
  end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
mon.spi_wrapper_monitor_vif = spi_wrapper_cfg.spi_wrapper_config_vif;
mon.mon_ap.connect(agt_ap);
if(spi_wrapper_cfg.is_active == UVM_ACTIVE) begin
drv.spi_wrapper_driver_vif = spi_wrapper_cfg.spi_wrapper_config_vif;
drv.seq_item_port.connect(sqr.seq_item_export);
end
endfunction
endclass
endpackage
