module ram_sva(ram_if.SVA ramif);


 reset_assert: assert property (@(posedge ramif.clk) (!ramif.rst_n)|->##1 (ramif.tx_valid == 0 && ramif.dout == 0));
 reset_cover:  cover property  (@(posedge ramif.clk) (!ramif.rst_n)|->##1 (ramif.tx_valid == 0 && ramif.dout == 0));

 tx_valid_off_assert: assert property (@(posedge ramif.clk) disable iff(!ramif.rst_n) (!(ramif.din[9] && ramif.din[8]) |->##1 (ramif.tx_valid == 0)));
 tx_valid_off_cover:  cover  property (@(posedge ramif.clk) disable iff(!ramif.rst_n) (!(ramif.din[9] && ramif.din[8]) |->##1 (ramif.tx_valid == 0)));

 tx_valid_on_assert: assert property (@(posedge ramif.clk) disable iff(!ramif.rst_n) ((ramif.din[9] && ramif.din[8] && ramif.rx_valid) |->##1 $rose(ramif.tx_valid) ##[1:$] $fell(ramif.tx_valid)));
 tx_valid_on_cover:  cover  property (@(posedge ramif.clk) disable iff(!ramif.rst_n) ((ramif.din[9] && ramif.din[8] && ramif.rx_valid) |->##1 $rose(ramif.tx_valid) ##[1:$] $fell(ramif.tx_valid)));

 write_address_data_assert: assert property (@(posedge ramif.clk) disable iff(!ramif.rst_n) ((ramif.din[9:8] == 2'b00) |-> ##[1:$] (ramif.din[9:8] == 2'b01)));
 write_address_data_cover:  cover  property (@(posedge ramif.clk) disable iff(!ramif.rst_n) ((ramif.din[9:8] == 2'b00) |-> ##[1:$] (ramif.din[9:8] == 2'b01)));

 read_address_data_assert: assert property (@(posedge ramif.clk) disable iff(!ramif.rst_n) ((ramif.din[9:8] == 2'b10) |-> ##[1:$] (ramif.din[9:8] == 2'b11)));
 read_address_data_cover:  cover  property (@(posedge ramif.clk) disable iff(!ramif.rst_n) ((ramif.din[9:8] == 2'b10) |-> ##[1:$] (ramif.din[9:8] == 2'b11)));

endmodule
