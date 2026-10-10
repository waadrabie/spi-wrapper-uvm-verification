package ram_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_seq_item_pkg::*;
import ram_pkg::*;

class ram_coverage extends uvm_component;

`uvm_component_utils(ram_coverage)

uvm_analysis_export #(ram_seq_item) cov_export;
uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
ram_seq_item seq_item_cov;


covergroup cvr_gp;
din_cp: coverpoint seq_item_cov.din[9:8] {
    bins din_values[] = {[2'b00:2'b11]};
    bins din_write    = (2'b00 => 2'b01);
    bins din_read     = (2'b10 => 2'b11);
    bins din_sequence = (2'b00[*26] => 2'b01[*26] => 2'b10[*26] => 2'b11[*26]);
}

rx_valid_cp: coverpoint seq_item_cov.rx_valid; 
tx_valid_cp: coverpoint seq_item_cov.tx_valid;


Cross_din_rx_valid: cross din_cp,rx_valid_cp {
            option.cross_auto_bin_max = 0;
            bins write_address_rx_valid_high = binsof(din_cp) intersect {2'b00} && binsof(rx_valid_cp) intersect {1};
            bins write_data_rx_valid_high    = binsof(din_cp) intersect {2'b01} && binsof(rx_valid_cp) intersect {1};
            bins read_address_rx_valid_high  = binsof(din_cp) intersect {2'b10} && binsof(rx_valid_cp) intersect {1};
            bins read_data_rx_valid_high     = binsof(din_cp) intersect {2'b11} && binsof(rx_valid_cp) intersect {1};
            }

Cross_din_tx_valid: cross din_cp,tx_valid_cp {
            option.cross_auto_bin_max = 0;
            bins din_tx_valid_high = binsof(din_cp)  intersect {2'b11} && binsof(tx_valid_cp) intersect {1};
            }

endgroup

function  new(string name ="ram_coverage",uvm_component parent = null);
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
