import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_test_pkg::*;

module top();
bit clk;
  initial begin
    clk = 1;
forever 
    #1 clk = ~clk;
  end

spi_slave_if spi_slaveif(clk);
SLAVE DUT (spi_slaveif.MOSI,spi_slaveif.MISO,spi_slaveif.SS_n,clk,spi_slaveif.rst_n,spi_slaveif.rx_data,spi_slaveif.rx_valid,spi_slaveif.tx_data,spi_slaveif.tx_valid);
SLAVE_golden REF (spi_slaveif.MOSI, spi_slaveif.MISO_ref, spi_slaveif.SS_n, clk, spi_slaveif.rst_n,spi_slaveif.rx_data_ref,spi_slaveif.rx_valid_ref,spi_slaveif.tx_data,spi_slaveif.tx_valid);
bind SLAVE spi_slave_sva spi_slave_sva_inst (spi_slaveif.SVA);


initial begin
  uvm_config_db#(virtual spi_slave_if)::set(null,"uvm_test_top","SPI_SLAVE_IF",spi_slaveif);
    run_test("spi_slave_test");
end
endmodule
