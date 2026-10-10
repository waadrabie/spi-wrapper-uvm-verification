package spi_slave_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_pkg::*;
class spi_slave_seq_item extends uvm_sequence_item;
`uvm_object_utils(spi_slave_seq_item)


rand bit       MOSI, rst_n, SS_n, tx_valid;
rand bit [7:0] tx_data;
logic      [9:0] rx_data;
logic            rx_valid, MISO;

logic      [9:0] rx_data_ref;
logic            rx_valid_ref, MISO_ref;

rand logic arr_mosi [11] ;
rand op_e ns;

function  new(string name ="spi_slave_seq_item");
    super.new(name);
endfunction

//SPI_SLAVE_1
 constraint c_rst_n{ rst_n dist {1:=99 , 0:=1}; }

//SPI_SLAVE_2
 constraint c_ss_n 
 { if(rst_n){
      if(((cs != READ_DATAA) && (SS_n_counter < 13)) || ((cs == READ_DATAA) && (SS_n_counter < 23)))
          SS_n == 0;
      else
          SS_n == 1;}
          
          }

//SPI_SLAVE_3
constraint ns_c {
    ns inside {WRITE_ADDRESS , WRITE_DATA, READ_ADDRESS ,READ_DATAA};
}

 constraint c_mosi
 { if(rst_n){
    {arr_mosi[0], arr_mosi[1], arr_mosi[2]} == cs;
      if (mosi_counter < 11 && !SS_n)
        MOSI == arr_mosi[mosi_counter];
    }   
 }

////SPI_SLAVE_4
 constraint c_tx_valid 
 { if(rst_n){
        if( cs == READ_DATAA && (SS_n_counter>13)  && (SS_n_counter<23))
        { tx_valid == 1; }
         else 
         { tx_valid == 0; }
        }}


function void post_randomize();
    if(rst_n == 1) begin
      if((cs == READ_DATAA && SS_n_counter == 23) || (cs != READ_DATAA && SS_n_counter == 13)) begin
          SS_n_counter = 0;
      end
      else begin
      SS_n_counter = SS_n_counter +1;
      end
      if((SS_n_counter == 1) || mosi_counter == 11 ) begin
        mosi_counter = 0;
      end
      else begin
        mosi_counter = mosi_counter + 1;
      end 

      if (SS_n_counter == 0) begin
          cs = ns;
      end       
    end
    else begin
        mosi_counter = 0;
        SS_n_counter = 0;
        cs = WRITE_ADDRESS;
    end
 endfunction
function string convert2string();
return $sformatf("%s rst_n=%b,MOSI=%b,SS_n=%b,tx_data=%b,tx_valid=%b,rx_data=%b,rx_valid=%b,MISO=%b ",
                 super.convert2string(),rst_n,MOSI,SS_n,tx_data,tx_valid,rx_data,rx_valid,MISO);
endfunction

function string convert2string_stimulus();
return $sformatf(" rst_n=%b,MOSI=%b,SS_n=%b,tx_data=%b,tx_valid=%b ",
                   rst_n,MOSI,SS_n,tx_data,tx_valid);
endfunction
endclass
endpackage
