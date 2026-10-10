import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_test_pkg::*;

module top();
bit clk;
  initial begin
    clk = 1;
forever 
    #1 clk = ~clk;
  end

ram_if ramif(clk);
RAM DUT(ramif.din,clk,ramif.rst_n,ramif.rx_valid,ramif.dout,ramif.tx_valid);
spr_sync REF (clk,ramif.rst_n,ramif.din,ramif.rx_valid,ramif.dout_ref,ramif.tx_valid_ref);
bind RAM ram_sva ram_sva_inst (ramif.SVA);

initial begin
  uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","RAM_IF",ramif);
    run_test("ram_test");
end
endmodule
