import spi_wrapper_pkg::*;
module spi_wrapper_sva(spi_wrapper_if.SVA spi_wrapperif);
//SPI_WRAPPER_1
reset_assert: assert property (@(posedge spi_wrapperif.clk) (!spi_wrapperif.rst_n)|->##1 (spi_wrapperif.MISO == 0));
reset_cover:  cover property  (@(posedge spi_wrapperif.clk) (!spi_wrapperif.rst_n)|->##1 (spi_wrapperif.MISO == 0));

//SPI_WRAPPER_7
stable_miso_assert:assert property (@(posedge spi_wrapperif.clk) disable iff(!spi_wrapperif.rst_n)
(((cs != READ_DATAA) && (SS_n_counter >= 3)) |-> ##[0:$] $stable(spi_wrapperif.MISO)));
stable_miso_cover: cover  property (@(posedge spi_wrapperif.clk) disable iff(!spi_wrapperif.rst_n)
(((cs != READ_DATAA) && (SS_n_counter >= 3)) |-> ##[0:$] $stable(spi_wrapperif.MISO)));
endmodule
