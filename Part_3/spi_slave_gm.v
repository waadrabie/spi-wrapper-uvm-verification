module SLAVE_golden(MOSI,MISO,SS_n,CLK,rst_n,rx_data,rx_valid,tx_data,tx_valid);

input MOSI ,CLK ,rst_n, SS_n,tx_valid;
input [7:0]tx_data;

output reg [9:0]rx_data;
output reg rx_valid,MISO;

reg read_phase; 
reg [3:0]counter; 
reg[9:0] SER_PAR; 
reg[2:0] NS,CS;   

parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;


always @(posedge CLK ) begin
    if(~rst_n) begin
       CS<=IDLE;
    end
    else begin
        CS<=NS;
    end
end 

always @(*) begin
    case (CS)
       IDLE: NS=(SS_n==0)?CHK_CMD:IDLE; 
       CHK_CMD:begin
        if ((SS_n==0)&&(MOSI==1)&&(read_phase==1)) begin
            NS=READ_DATA;
        end
        else if ((SS_n==0)&&(MOSI==1)&&(read_phase==0)) begin
            NS=READ_ADD;
        end
        else if ((SS_n==0)&&(MOSI==0)) begin
            NS=WRITE;
        end
        else if (SS_n==1) begin
            NS=IDLE;
        end
        else begin
            NS=CHK_CMD;
        end                
       end
      WRITE:NS=(SS_n==0)?WRITE:IDLE;
      READ_DATA:NS=(SS_n==0)?READ_DATA:IDLE ;
      READ_ADD:NS=(SS_n==0)?READ_ADD:IDLE ;
    endcase
end

always @(posedge CLK) begin
    if (~rst_n) begin
        rx_data<=0;
        rx_valid<=0;
        counter<=0;
        read_phase<=0;
        MISO<=0;
    end
    else begin
        case (CS)
            WRITE: begin
                if (counter==10) begin  
                rx_valid<=1;
                end 
                else begin           
                   rx_data[9-counter] <= MOSI;
                   counter<=counter+1;
                end                
            end
            READ_ADD:begin
              if (counter==10) begin
                rx_valid<=1;
                read_phase<=1;
              end
              else begin            
                rx_data[9-counter] <= MOSI;
                counter<=counter+1;
              end
            end
            READ_DATA:begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter < 10) begin
                        MISO <= tx_data[9-counter];
                        counter <= counter + 1;
                    end
                    else begin
                        read_phase <= 0;
                    end
                end
                else begin
                    if (counter < 10) begin
                        rx_data[9-counter] <= MOSI;
                        counter <= counter + 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 1;
                    end
                end
            end
            IDLE: begin 
                rx_valid<=0;
            end
            CHK_CMD: begin
            rx_valid<=0;
            counter<=0;
            end
        endcase
    end

end
endmodule






