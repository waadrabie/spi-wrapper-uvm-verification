package spi_wrapper_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_wrapper_pkg::*;
class spi_wrapper_seq_item extends uvm_sequence_item;
`uvm_object_utils(spi_wrapper_seq_item)

rand logic  MOSI, SS_n, rst_n;

logic  MISO;
logic  MISO_ref;
rand logic arr_mosi [11] ;
rand op_e ns;

function  new(string name ="spi_wrapper_seq_item");
    super.new(name);
endfunction
//SPI_WRAPPER_1
 constraint c_rst_n{ rst_n dist {1:=99 , 0:=1}; }
//SPI_WRAPPER_2
 constraint c_ss_n 
 { if(rst_n){
      if(((cs != READ_DATAA) && (SS_n_counter < 13)) || ((cs == READ_DATAA) && (SS_n_counter < 23)))
          SS_n == 0;
      else
          SS_n == 1;}
          
          }
//Spi_WRAPPER_3
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
//Spi_WRAPPER_4
 constraint c_write_only 
   { ns inside {WRITE_ADDRESS,WRITE_DATA};
    if ((cs == WRITE_ADDRESS) && (SS_n_counter==13))   ns inside {WRITE_ADDRESS,WRITE_DATA}; }
//Spi_WRAPPER_5
constraint c_read_only   
 { ns inside {READ_ADDRESS,READ_DATAA};
   if      ((cs == READ_ADDRESS)  &&(SS_n_counter==13))  ns == READ_DATAA;
   else if ((cs == READ_DATAA)    &&(SS_n_counter==23))  ns == READ_ADDRESS;}
//Spi_WRAPPER_6
constraint c_write_read   
{ ns inside {READ_ADDRESS,READ_DATAA,WRITE_ADDRESS,WRITE_DATA};
  if      ((cs == WRITE_ADDRESS)&&(SS_n_counter==13)) ns inside {WRITE_ADDRESS,WRITE_DATA};
  else if ((cs == WRITE_DATA)   &&(SS_n_counter==13)) ns dist   {READ_ADDRESS:=60, WRITE_ADDRESS:=40};
  else if ((cs == READ_ADDRESS) &&(SS_n_counter==13)) ns inside {READ_ADDRESS, READ_DATAA};
  else if ((cs == READ_DATAA)     &&(SS_n_counter==23)) ns dist   {WRITE_ADDRESS:=60, READ_ADDRESS:=40}; } 
   

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
return $sformatf("%s rst_n=%b,MOSI=%b,SS_n=%b,MISO=%b ",super.convert2string(),rst_n,MOSI,SS_n,MISO);
endfunction

function string convert2string_stimulus();
return $sformatf(" rst_n=%b,MOSI=%b,SS_n=%b, ",rst_n,MOSI,SS_n);
endfunction
endclass
endpackage
