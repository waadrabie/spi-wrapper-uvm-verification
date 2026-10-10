//import alsu_pkg::*;
interface spi_slave_if(clk);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
input clk;
logic       MOSI, rst_n, SS_n, tx_valid;
logic [7:0] tx_data;
logic [9:0] rx_data;
logic       rx_valid, MISO;
logic [9:0] rx_data_ref;
logic       rx_valid_ref, MISO_ref;
modport SVA (input MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

endinterface
