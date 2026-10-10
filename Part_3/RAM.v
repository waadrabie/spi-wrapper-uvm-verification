module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input      [9:0] din;
input       clk, rst_n, rx_valid;

output reg [7:0] dout;
output reg       tx_valid;

reg [7:0] MEM [MEM_DEPTH -1:0];
reg [ADDR_SIZE - 1 :0] Rd_Addr, Wr_Addr;

always @(posedge clk ) begin
    if(~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
 /*else begin                                          
        if (rx_valid) begin
            case (din[9:8])
                2'b00 : Wr_Addr <= din[7:0];
                2'b01 : MEM[Wr_Addr] <= din[7:0];
                2'b10 : Rd_Addr <= din[7:0];
                2'b11 : dout <= MEM[Rd_Addr]; //
                default : dout <= 0;
            endcase
            tx_valid <= (din[9] && din[8])? 1'b1 : 1'b0;
        end
        
    end
end

endmodule*/


 else begin
     if (rx_valid) begin  
      case(din[9:8])
       2'b00 : begin
                  Wr_Addr <= din[7:0];
                  tx_valid <= 0;
                end
       2'b01 :  begin
                  MEM[Wr_Addr] <= din [7:0];
                  tx_valid <= 0;
                end
                
       2'b10 : begin
                  Rd_Addr <= din[7:0];
                  tx_valid <= 0;
                end                 
      2'b11 : begin
                 dout <= MEM[Rd_Addr];
                 tx_valid <= 1;
                end
       endcase
      end
     else begin
      if ( !(din[9] && din[8]))begin
          tx_valid <= 0;
      end
      end
    end
 end
endmodule
