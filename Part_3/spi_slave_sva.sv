
import spi_slave_pkg::*;

module spi_slave_sva(spi_slave_if.SVA spi_slaveif);


 reset_assert: assert property (@(posedge spi_slaveif.clk) (!spi_slaveif.rst_n) |=> (spi_slaveif.MISO == 0 && spi_slaveif.rx_data == 0 && spi_slaveif.rx_valid == 0));
 reset_cover:  cover property  (@(posedge spi_slaveif.clk) (!spi_slaveif.rst_n) |=> (spi_slaveif.MISO == 0 && spi_slaveif.rx_data == 0 && spi_slaveif.rx_valid == 0));
 
 write_add_seq_assert: assert property (@(posedge spi_slaveif.clk) disable iff(!spi_slaveif.rst_n)(($fell(spi_slaveif.SS_n) ##1 !spi_slaveif.MOSI ##1 !spi_slaveif.MOSI ##1 !spi_slaveif.MOSI) |=>##10 (spi_slaveif.rx_valid == 1) ##0 spi_slaveif.SS_n[->1]));
 write_add_seq_cover:  cover  property (@(posedge spi_slaveif.clk) disable iff(!spi_slaveif.rst_n)(($fell(spi_slaveif.SS_n) ##1 !spi_slaveif.MOSI ##1 !spi_slaveif.MOSI ##1 !spi_slaveif.MOSI) |=>##10 (spi_slaveif.rx_valid == 1) ##0 spi_slaveif.SS_n[->1]));

 write_data_seq_assert: assert property (@(posedge spi_slaveif.clk) disable iff(!spi_slaveif.rst_n)(($fell(spi_slaveif.SS_n) ##1 !spi_slaveif.MOSI ##1 !spi_slaveif.MOSI ##1 spi_slaveif.MOSI) |=>##10 (spi_slaveif.rx_valid == 1) ##0 spi_slaveif.SS_n[->1]));
 write_data_seq_cover:  cover  property (@(posedge spi_slaveif.clk) disable iff(!spi_slaveif.rst_n)(($fell(spi_slaveif.SS_n) ##1 !spi_slaveif.MOSI ##1 !spi_slaveif.MOSI ##1 spi_slaveif.MOSI) |=>##10 (spi_slaveif.rx_valid == 1) ##0 spi_slaveif.SS_n[->1]));


endmodule
