import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_test_pkg::*;

module top();
bit clk;
  initial begin
    clk = 1;
forever 
    #1 clk = ~clk;
  end

spi_wrapper_if spi_wrapperif(clk);
WRAPPER     DUT (spi_wrapperif.MOSI,    spi_wrapperif.MISO,  spi_wrapperif.SS_n, clk, spi_wrapperif.rst_n);
spi_wrapper REF (spi_wrapperif.MISO_ref, spi_wrapperif.MOSI, spi_wrapperif.SS_n, clk, spi_wrapperif.rst_n);

spi_slave_if spi_slaveif(clk);
ram_if ramif(clk);


assign spi_slaveif.MOSI      = spi_wrapperif.MOSI;
assign spi_slaveif.SS_n      = spi_wrapperif.SS_n;
assign spi_slaveif.rst_n     = spi_wrapperif.rst_n;
assign spi_slaveif.tx_data   = DUT.tx_data_dout;
assign spi_slaveif.tx_valid  = DUT.tx_valid;
assign spi_slaveif.MISO  = DUT.MISO ;     
assign spi_slaveif.rx_valid = DUT.rx_valid;   
assign spi_slaveif.rx_data  = DUT.rx_data_din;
assign spi_slaveif.MISO_ref     = REF.MISO  ;  
assign spi_slaveif.rx_valid_ref = REF.rx_valid;
assign spi_slaveif.rx_data_ref  = REF.rx_data; 
assign ramif.dout     =   DUT.tx_data_dout; 
assign ramif.tx_valid =   DUT.tx_valid;     
assign ramif.din            = DUT.rx_data_din;
assign ramif.rx_valid       = DUT.rx_valid;
assign ramif.rst_n          = spi_wrapperif.rst_n;
assign ramif.dout_ref     =  REF.tx_data; 
assign ramif.tx_valid_ref =  REF.tx_valid; 

bind WRAPPER spi_wrapper_sva spi_wrapper_sva_inst (spi_wrapperif.SVA);
bind RAM ram_sva ram_sva_inst (ramif.SVA);
bind SLAVE spi_slave_sva spi_slave_sva_inst (spi_slaveif.SVA);
initial begin
  uvm_config_db#(virtual spi_wrapper_if)::set(null,"uvm_test_top","SPI_WRAPPER_IF",spi_wrapperif);
  uvm_config_db#(virtual spi_slave_if)::set(null,"uvm_test_top","SPI_SLAVE_IF",spi_slaveif);  
  uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","RAM_IF",ramif); 
    run_test("spi_wrapper_test");
end
endmodule
