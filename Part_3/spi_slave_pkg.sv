package spi_slave_pkg;

typedef enum bit [0:2]  {WRITE_ADDRESS = 3'b000, WRITE_DATA = 3'b001, READ_ADDRESS = 3'b110, READ_DATAA = 3'b111} op_e;
int mosi_counter,SS_n_counter;
op_e cs;

endpackage
