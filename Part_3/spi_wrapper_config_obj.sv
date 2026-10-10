package spi_wrapper_config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_wrapper_config_obj extends uvm_object;
`uvm_object_utils(spi_wrapper_config_obj)

virtual spi_wrapper_if spi_wrapper_config_vif;
uvm_active_passive_enum is_active;

function  new(string name ="spi_wrapper_config_obj");
    super.new(name);
endfunction

endclass
endpackage
