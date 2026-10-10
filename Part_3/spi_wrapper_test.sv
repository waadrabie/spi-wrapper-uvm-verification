package spi_wrapper_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_env_pkg::*;
import spi_wrapper_config_obj_pkg::*;
import spi_wrapper_reset_sequence_pkg::*;
import spi_wrapper_read_sequence_pkg::*;
import spi_wrapper_write_sequence_pkg::*;
import spi_wrapper_write_read_sequence_pkg::*;


import spi_slave_env_pkg::*;
import spi_slave_config_obj_pkg::*;

import ram_env_pkg::*;
import ram_config_obj_pkg::*;

class spi_wrapper_test extends uvm_test;
`uvm_component_utils(spi_wrapper_test)

  spi_wrapper_env env;
  spi_wrapper_config_obj spi_wrapper_cfg;
  virtual spi_wrapper_if spi_wrapper_vif;
  spi_wrapper_reset_sequence reset_seq;
  spi_wrapper_write_sequence write_seq;
  spi_wrapper_read_sequence read_seq;
  spi_wrapper_write_read_sequence write_read_seq;

  spi_slave_env slave_env;
  spi_slave_config_obj slave_cfg;

  ram_env r_env;
  ram_config_obj r_cfg;
  
  function  new(string name ="spi_wrapper_test",uvm_component parent = null);
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
  env             = spi_wrapper_env::type_id::create("env",this);
  spi_wrapper_cfg = spi_wrapper_config_obj::type_id::create("spi_wrapper_cfg");
  write_seq       = spi_wrapper_write_sequence::type_id::create("write_seq");
  read_seq        = spi_wrapper_read_sequence::type_id::create("read_seq");
  reset_seq       = spi_wrapper_reset_sequence::type_id::create("reset_seq");
  write_read_seq  = spi_wrapper_write_read_sequence::type_id::create("write_read_seq");
  slave_env       = spi_slave_env::type_id::create("slave_env",this); 
  slave_cfg       = spi_slave_config_obj::type_id::create("slave_cfg");
  r_env           = ram_env::type_id::create("r_env",this); 
  r_cfg           = ram_config_obj::type_id::create("r_cfg");

  spi_wrapper_cfg.is_active = UVM_ACTIVE;
  slave_cfg.is_active = UVM_PASSIVE;
  r_cfg.is_active = UVM_PASSIVE;

  if(!uvm_config_db#(virtual spi_wrapper_if)::get(this,"","SPI_WRAPPER_IF",spi_wrapper_cfg.spi_wrapper_config_vif))
   `uvm_fatal("build_phase","TEST-Unable to get virtual interface");
   uvm_config_db#(spi_wrapper_config_obj)::set(this,"env.*","SPI_WRAPPER_CFG",spi_wrapper_cfg);

  if(!uvm_config_db#(virtual spi_slave_if)::get(this,"","SPI_SLAVE_IF",slave_cfg.spi_slave_config_vif))
   `uvm_fatal("build_phase","TEST-Unable to get virtual interface");
   uvm_config_db#(spi_slave_config_obj)::set(this,"slave_env.*","SPI_SLAVE_CFG",slave_cfg); 

  if(!uvm_config_db#(virtual ram_if)::get(this,"","RAM_IF",r_cfg.ram_config_vif))
   `uvm_fatal("build_phase","TEST-Unable to get virtual interface");
   uvm_config_db#(ram_config_obj)::set(this,"r_env.*","RAM_CFG",r_cfg); 
  endfunction
endclass
endpackage
