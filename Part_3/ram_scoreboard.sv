package ram_scoreboard_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_seq_item_pkg::*;

class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)
uvm_analysis_export #(ram_seq_item) sb_export;
uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
ram_seq_item seq_item_sb;

int error_count = 0;
int correct_count = 0;

function  new(string name ="ram_scoreboard",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  sb_export = new("sb_export", this);
  sb_fifo = new("sb_fifo", this);

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);
endfunction

  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    sb_fifo.get(seq_item_sb);
    if((seq_item_sb.dout != seq_item_sb.dout_ref) || (seq_item_sb.tx_valid != seq_item_sb.tx_valid_ref)) begin
     `uvm_error("run_phase",$sformatf("comparison failed, Transaction recieved by DUT:%s while reference doutput:%b,reference tx_valid=%b",
                                        seq_item_sb.convert2string(),seq_item_sb.dout_ref,seq_item_sb.tx_valid_ref));
     error_count++;
    end
    else begin
        `uvm_info("run_phase",$sformatf("Correct data out:%s",seq_item_sb.convert2string()),UVM_HIGH);
        correct_count++;
    end
  end
  endtask

  function void report_phase(uvm_phase phase);
  super.report_phase(phase);
  `uvm_info("report_phase",$sformatf("Total successful transactions: %d",correct_count),UVM_MEDIUM);
  `uvm_info("report_phase",$sformatf("Total failed transactions: %d",error_count),UVM_MEDIUM);
  endfunction
endclass
endpackage
