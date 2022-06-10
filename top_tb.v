/////////////////////////////////////////////////////////////////////////
// Module top_tb.v  
//                                         
// Info:  Testbench for simple two FSMs communication
//  
////////////////////////////////////////////////////////////////////////

`include "Top.v"
`timescale 1ns / 1ps

module top_tb();

reg clock;
reg reset;
reg start;
wire [31:0] cdata_out;

always begin 
    clock = 1'b0;
    forever #5 clock = ~clock;
end 

initial begin
    #5 reset = 1'b1;
    start = 1'b0;
    #20 start = 1'b1;
    reset = 1'b0;
    #100 $finish;
end

initial
begin
    $dumpfile("top_dump.vcd");
    $dumpvars(0, top_tb);
end

Top uut
(
  .clock(clock),
  .reset(reset),
  .io_start(start),
  .io_cdata_check(cdata_out)
);

endmodule