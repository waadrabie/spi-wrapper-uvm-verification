package ram_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_seq_item_pkg::*;
import ram_config_obj_pkg::*;
import ram_driver_pkg::*;
import ram_monitor_pkg::*;
import ram_sequencer_pkg::*;
class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)
 ram_sequencer sqr;
 ram_driver drv;
 ram_monitor mon;
 ram_config_obj ram_cfg;
 uvm_analysis_port #(ram_seq_item) agt_ap;

function  new(string name ="ram_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon = ram_monitor::type_id::create("mon",this);
  agt_ap = new("agt_ap", this);
  ram_cfg = ram_config_obj::type_id::create("ram_cfg");
  if(!uvm_config_db#(ram_config_obj)::get(this,"","RAM_CFG",ram_cfg))
   `uvm_fatal("build_phase","Unable to get configuration object");
  if(ram_cfg.is_active == UVM_ACTIVE) begin
   sqr = ram_sequencer::type_id::create("sqr",this);
   drv = ram_driver::type_id::create("drv",this);
  end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
mon.ram_monitor_vif = ram_cfg.ram_config_vif;
mon.mon_ap.connect(agt_ap);
if(ram_cfg.is_active == UVM_ACTIVE) begin
drv.seq_item_port.connect(sqr.seq_item_export);
drv.ram_driver_vif = ram_cfg.ram_config_vif;
end
endfunction
endclass
endpackage
