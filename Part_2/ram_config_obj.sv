package ram_config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_config_obj extends uvm_object;
`uvm_object_utils(ram_config_obj)

virtual ram_if ram_config_vif;
function  new(string name ="ram_config_obj");
    super.new(name);
endfunction

endclass
endpackage
