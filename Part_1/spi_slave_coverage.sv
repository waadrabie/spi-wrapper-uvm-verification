package spi_slave_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_pkg::*;
import spi_slave_pkg::*;

class spi_slave_coverage extends uvm_component;

`uvm_component_utils(spi_slave_coverage)

uvm_analysis_export #(spi_slave_seq_item) cov_export;
uvm_tlm_analysis_fifo #(spi_slave_seq_item) cov_fifo;
spi_slave_seq_item seq_item_cov;

covergroup cvr_gp;
//SPI_SLAVE_2
rx_data_cp: coverpoint seq_item_cov.rx_data[9:8] {
    bins rx_values[] = {[2'b00:2'b11]};
    bins rx_transations[] =(2'b00 => 2'b00),(2'b00 => 2'b01), (2'b00 => 2'b10), (2'b00 => 2'b11),
                           (2'b01 => 2'b01),(2'b01 => 2'b00), (2'b01 => 2'b10), (2'b01 => 2'b11),
                           (2'b10 => 2'b10),(2'b10 => 2'b00), (2'b10 => 2'b01), (2'b10 => 2'b11),
                           (2'b11 => 2'b11),(2'b11 => 2'b00), (2'b11 => 2'b01), (2'b11 => 2'b10);

}

SS_n_cp: coverpoint seq_item_cov.SS_n iff(seq_item_cov.rst_n){
    bins normal_operations = (1 => 0[*13] => 1); 
    bins read_data         = (1 => 0[*23] => 1); 
}

//SPI_SLAVE_3
MOSI_cp: coverpoint seq_item_cov.MOSI iff(seq_item_cov.rst_n) {
    bins write_address  = (0 => 0 => 0); 
    bins write_data     = (0 => 0 => 1); 
    bins read_address   = (1 => 1 => 0); 
    bins read_data      = (1 => 1 => 1); 
}
Cross_SS_n_MOSI: cross SS_n_cp,MOSI_cp {
        
            ignore_bins ignore_normal_operation = binsof(SS_n_cp.normal_operations) && binsof(MOSI_cp.read_data);
            ignore_bins ignore_read_data        = binsof(SS_n_cp.read_data) && !binsof(MOSI_cp.read_data);}

endgroup
function  new(string name ="spi_slave_coverage",uvm_component parent = null);
    super.new(name,parent);
    cvr_gp = new;
endfunction
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  cov_export = new("cov_export", this);
  cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    cov_fifo.get(seq_item_cov);
    cvr_gp.sample();
  end
  endtask
endclass
endpackage
