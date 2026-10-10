package spi_slave_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_pkg::*;
import spi_slave_config_obj_pkg::*;
import spi_slave_driver_pkg::*;
import spi_slave_monitor_pkg::*;
import spi_slave_sequencer_pkg::*;
class spi_slave_agent extends uvm_agent;

`uvm_component_utils(spi_slave_agent)
 spi_slave_sequencer sqr;
 spi_slave_driver drv;
 spi_slave_monitor mon;
 spi_slave_config_obj spi_slave_cfg;
 uvm_analysis_port #(spi_slave_seq_item) agt_ap;

function  new(string name ="spi_slave_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon = spi_slave_monitor::type_id::create("mon",this);
  agt_ap = new("agt_ap", this);
  spi_slave_cfg = spi_slave_config_obj::type_id::create("spi_slave_cfg");
  if(!uvm_config_db#(spi_slave_config_obj)::get(this,"","SPI_SLAVE_CFG",spi_slave_cfg))
   `uvm_fatal("build_phase","Unable to get configuration object");
  if(spi_slave_cfg.is_active == UVM_ACTIVE) begin
     drv = spi_slave_driver::type_id::create("drv",this);
     sqr = spi_slave_sequencer::type_id::create("sqr",this);
  end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
mon.spi_slave_monitor_vif = spi_slave_cfg.spi_slave_config_vif;
mon.mon_ap.connect(agt_ap);
if(spi_slave_cfg.is_active == UVM_ACTIVE) begin
drv.spi_slave_driver_vif = spi_slave_cfg.spi_slave_config_vif;
drv.seq_item_port.connect(sqr.seq_item_export);
end
endfunction
endclass
endpackage
