module spr_sync(clk,rst_n,din,rx_valid,dout,tx_valid);

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input clk,rst_n;
input [9:0] din;
input rx_valid;
output reg [7:0] dout;
output reg tx_valid;
reg [ADDR_SIZE -1 :0] temp_read,temp_write;
reg [7:0] MEM [MEM_DEPTH-1 :0];

always @(posedge clk ) begin
    if(~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        temp_read <= 0;
        temp_write <= 0;
    end
    else begin
     if (rx_valid) begin  
      case(din[9:8])
       2'b 00 : begin
                  temp_write <= din[7:0];
                  tx_valid <= 0;
                end
       2'b 01 :  begin
                  MEM[temp_write] <= din [7:0];
                  tx_valid <= 0;
                end
                
       2'b 10 : begin
                  temp_read <= din[7:0];
                  tx_valid <= 0;
                end                 
        default : begin
                   dout <= MEM[temp_read];
                   tx_valid <= 1;
                  end
       endcase
      end
    else begin
      if (!(din[9] && din[8]))begin
          tx_valid <= 0;
      end
      end
end
end
/*always @(posedge clk ) begin
    if(~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        temp_read <= 0;
        temp_write <= 0;
    end
 else begin                                          
        if (rx_valid) begin
            case (din[9:8])
                2'b00 : temp_write <= din[7:0];
                2'b01 : MEM[temp_write] <= din[7:0];
                2'b10 : temp_read <= din[7:0];
                2'b11 : dout <= MEM[temp_read]; //
                default : dout <= 0;
            endcase
            tx_valid <= (din[9] && din[8])? 1'b1 : 1'b0;
        end
        
    end
end*/
endmodule



