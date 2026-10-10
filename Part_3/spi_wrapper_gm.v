module spi_wrapper(MISO,MOSI,SS_n,clk,rst_n);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input MOSI,SS_n,clk,rst_n;
output MISO;

wire tx_valid,rx_valid;
wire [7:0] tx_data;
wire [9:0] rx_data;
spr_sync #(.MEM_DEPTH(MEM_DEPTH),.ADDR_SIZE(ADDR_SIZE))RAM(clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
SLAVE_golden spi(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
 
endmodule
