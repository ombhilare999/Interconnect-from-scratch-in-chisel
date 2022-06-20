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
reg wr;
reg rd;
reg [3:0] length;
reg [3:0] address;
reg [31:0] wdata;
wire [31:0] rdata;

always begin 
    clock = 1'b0;
    forever  #5 clock = ~clock;
end 

/*
// Normal_Write_Read_Back
initial begin
    //Toggling Reset Once
    #10
    reset = 1'b1;
    start = 1'b0;
    #10 reset = 1'b0;
    start = 1'b1;
    #10
    @(posedge clock) 
    address = 4'h7;
    wdata = 32'hA;
    wr = 1'b1;
    rd = 1'b0;
    @(posedge clock) 
    address = 4'h8;
    wdata = 32'hB;
    wr = 1'b1;`include "Top.v"
    rd = 1'b0;   
    #10
    address = 4'h0;
    wdata = 32'h0;
    wr = 1'b0;
    rd = 1'b0; 
    #10
    @(posedge clock)  address = 4'h8;
    wdata = 32'h0;
    wr = 1'b0;
    rd = 1'b1;    
    #10
    address = 4'h0;
    #10
    @(posedge clock)  address = 4'h7;
    wdata = 32'h0;
    wr = 1'b0;
    rd = 1'b1;
    #10
    rd = 1'b1;  
    #10 start = 1'b0;
    wr = 1'b0;
    rd = 1'b0;
    #100 $finish;
end
*/

// Burst_Read_Write
initial begin
    #5
    //Toggling Reset Once
    #10 reset = 1'b1;
    start = 1'b0;
    #10 reset = 1'b0;
    start = 1'b1;
    
    @(posedge clock) 
    address = 4'h6;
    length = 4'h4;
    wdata = 4'hA;
    wr = 1'b1;
    rd = 1'b0;
    @(posedge clock)
    address = 4'h0;
    length = 4'h0;
    wdata = 4'hB;
    wr = 1'b0;
    rd = 1'b0;
    @(posedge clock) 
    address = 4'h0;
    length = 4'h0;
    wdata = 4'hC;
    wr = 1'b0;
    rd = 1'b0;
    @(posedge clock) 
    wdata = 4'hD;
    @(posedge clock) 
    wdata = 4'h0;
    
    @(posedge clock) 
    address = 4'h6;
    length = 4'h4;
    wr = 1'b0;
    rd = 1'b1;
    @(posedge clock) 
    address = 4'h0;
    length = 4'h0;
    wr = 1'b0;
    rd = 1'b0;
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
  .io_top_wr(wr),
  .io_top_rd(rd),
  .io_top_address(address),
  .io_top_wdata(wdata),
  .io_top_rdata(rdata),
  .io_top_length(length)
);

endmodule