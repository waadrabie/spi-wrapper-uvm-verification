interface spi_wrapper_if(clk);

input clk;
logic  MOSI, SS_n, rst_n;
logic  MISO;
logic  MISO_ref;

modport SVA (input MOSI,MISO,SS_n,clk,rst_n);
endinterface
