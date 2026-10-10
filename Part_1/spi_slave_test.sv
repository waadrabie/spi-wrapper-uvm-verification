package spi_slave_test_pkg;

import spi_slave_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_config_obj_pkg::*;
import spi_slave_reset_sequence_pkg::*;
import spi_slave_main_sequence_pkg::*;


class spi_slave_test extends uvm_test;
`uvm_component_utils(spi_slave_test)

  spi_slave_env env;
  spi_slave_config_obj spi_slave_cfg;
  virtual spi_slave_if spi_slave_vif;
  spi_slave_main_sequence main_seq;
  spi_slave_reset_sequence reset_seq;

  
  function  new(string name ="spi_slave_test",uvm_component parent = null);
    super.new(name,parent);
endfunction

  task run_phase(uvm_phase phase );
  super.run_phase(phase);
  phase.raise_objection(this);
   `uvm_info("run_phase","Reset Asserted",UVM_LOW)
   reset_seq.start(env.agt.sqr);
   `uvm_info("run_phase","Reset Deasserted",UVM_LOW)

  `uvm_info("run_phase","Stimulus of main generation started",UVM_LOW)
   main_seq.start(env.agt.sqr);
  `uvm_info("run_phase","Stimulus of main generation finished",UVM_LOW)
 
  phase.drop_objection(this);
  endtask

    function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = spi_slave_env::type_id::create("env",this);
  spi_slave_cfg = spi_slave_config_obj::type_id::create("spi_slave_cfg");
  main_seq = spi_slave_main_sequence::type_id::create("main_seq");
  reset_seq = spi_slave_reset_sequence::type_id::create("reset_seq");
  
  if(!uvm_config_db#(virtual spi_slave_if)::get(this,"","SPI_SLAVE_IF",spi_slave_cfg.spi_slave_config_vif))
   `uvm_fatal("build_phase","TEST-Unable to get virtual interface");
   uvm_config_db#(spi_slave_config_obj)::set(this,"*","SPI_SLAVE_CFG",spi_slave_cfg);
  endfunction
endclass
endpackage

