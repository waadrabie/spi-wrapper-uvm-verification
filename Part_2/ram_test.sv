package ram_test_pkg;

import ram_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_config_obj_pkg::*;
import ram_reset_sequence_pkg::*;
import ram_write_sequence_pkg::*;
import ram_read_sequence_pkg::*;
import ram_write_read_sequence_pkg::*;

class ram_test extends uvm_test;
`uvm_component_utils(ram_test)

  ram_env env;
  ram_config_obj ram_cfg;
  virtual ram_if ram_vif;
  ram_write_sequence write_seq;
  ram_reset_sequence reset_seq;
  ram_read_sequence read_seq;
  ram_write_read_sequence write_read_seq;
  
  function  new(string name ="ram_test",uvm_component parent = null);
    super.new(name,parent);
endfunction

  task run_phase(uvm_phase phase );
  super.run_phase(phase);
  phase.raise_objection(this);
   `uvm_info("run_phase","Reset Asserted",UVM_LOW)
   reset_seq.start(env.agt.sqr);
   `uvm_info("run_phase","Reset Deasserted",UVM_LOW)

  `uvm_info("run_phase","Stimulus of write generation started",UVM_LOW)
   write_seq.start(env.agt.sqr);
  `uvm_info("run_phase","Stimulus of write generation finished",UVM_LOW)

  `uvm_info("run_phase","Stimulus of read generation started",UVM_LOW)
   read_seq.start(env.agt.sqr);
  `uvm_info("run_phase","Stimulus of read generation finished",UVM_LOW)

  `uvm_info("run_phase","Stimulus of write & read generation started",UVM_LOW)
   write_read_seq.start(env.agt.sqr);
  `uvm_info("run_phase","Stimulus of write & read generation finished",UVM_LOW)
  phase.drop_objection(this);
  endtask

    function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = ram_env::type_id::create("env",this);
  ram_cfg = ram_config_obj::type_id::create("ram_cfg");
  write_seq = ram_write_sequence::type_id::create("write_seq");
  read_seq = ram_read_sequence::type_id::create("read_seq");
  reset_seq = ram_reset_sequence::type_id::create("reset_seq");
  write_read_seq = ram_write_read_sequence::type_id::create("write_read_seq");
  
  if(!uvm_config_db#(virtual ram_if)::get(this,"","RAM_IF",ram_cfg.ram_config_vif))
   `uvm_fatal("build_phase","TEST-Unable to get virtual interface");
   uvm_config_db#(ram_config_obj)::set(this,"*","RAM_CFG",ram_cfg);
  endfunction
endclass
endpackage
