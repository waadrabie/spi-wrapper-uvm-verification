interface ram_if(clk);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input clk;
logic [9:0] din;
logic       rst_n, rx_valid;
logic [7:0] dout;
logic       tx_valid;
logic [7:0] dout_ref;
logic       tx_valid_ref;

modport SVA (input din,clk,rst_n,rx_valid,dout,tx_valid);
endinterface
