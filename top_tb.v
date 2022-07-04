/////////////////////////////////////////////////////////////////////////
// Module top_tb.v
//
// Info:  Testbench for simple two FSMs communication
//
////////////////////////////////////////////////////////////////////////

`include "Top.v"
`include "memory_slave/memory_top.vhd"
`timescale 1ns / 1ps

module top_tb();

  //Signals from the top
  reg clock;
  reg reset;
  
  reg io_TOP_WR;
  reg io_TOP_RD;
  reg [5:0] io_TOP_ADDRESS;
  reg [31:0] io_TOP_WDATA;
  wire [31:0] io_TOP_RDATA;
  reg [5:0] io_TOP_LENGTH;
  reg [1:0] io_TOP_BURST;
  reg [2:0] io_TOP_SIZE; 

  //AW Channel:
  reg [1:0] io_AW_BURST; 
  reg [5:0] io_AW_ADDR; 
  reg [7:0] io_AW_LEN; 
  reg [2:0] io_AW_SIZE; 
  reg io_AW_ID; 
  wire io_AW_READY; 
  reg io_AW_VALID; 
  reg [2:0] io_AW_PROT; 

  //W Channel:
  reg [31:0] io_W_DATA; 
  reg io_W_LAST; 
  reg [3:0] io_W_STRB; 
  wire io_W_READY; 
  reg io_W_VALID; 

  //B Channel:
  wire io_B_ID; 
  wire io_B_RESP; 
  reg io_B_READY;
  wire io_B_VALID; 

  //AR Channel:
  reg [1:0] io_AR_BURST; 
  reg [5:0] io_AR_ADDR; 
  reg [7:0] io_AR_LEN; 
  reg [3:0] io_AR_SIZE; 
  reg io_AR_ID; 
  wire io_AR_READY;
  reg io_AR_VALID; 
  reg [2:0] io_AR_PROT;

  //R Channel:
  wire [31:0] io_R_DATA; 
  wire io_R_LAST; 
  wire io_R_ID; 
  wire io_R_RESP; 
  reg io_R_READY; 
  wire io_R_VALID;

  always
  begin
    clock = 1'b0;
    forever
      #5 clock = ~clock;
  end


  // Ready_from Receiver
  initial
  begin
    #5
    //Toggling Reset Once
    #10 reset = 1'b1;
    io_TOP_WR = 1'b1;
    io_TOP_RD = 1'b0;
    io_TOP_ADDRESS = 6'h38;
    io_TOP_WDATA   = 32'h07563314;
    io_TOP_LENGTH  = 1'h0;
    io_TOP_BURST   = 2'h1;
    io_TOP_SIZE    = 3'h0;
    #100 $finish;
  end

  initial
  begin
    $dumpfile("top_dump.vcd");
    $dumpvars(0, top_tb);
  end
 
  memory_top 
  #(
    .G_ADDR_WIDTH(6),
    .G_DATA_WIDTH(32),
    .G_ID_WIDTH(1) 
  )
  memory_top_0 (
    .ACLK(clock),
    .ARESETn(reset),

    //AXI Write Address Channel
    .S_AXI_AWADDR(io_AW_ADDR),
    .S_AXI_AWBURST(io_AW_BURST),
    .S_AXI_AWID(io_AW_ID),
    .S_AXI_AWLEN(io_AW_LEN),
    .S_AXI_AWPROT(io_AW_PROT),
    .S_AXI_AWREADY(io_AW_READY),
    .S_AXI_AWSIZE(io_AW_SIZE),
    .S_AXI_AWVALID(io_AW_VALID),

    //AXI Write Data Channel
    .S_AXI_WDATA(io_W_DATA),
    .S_AXI_WLAST(io_W_LAST),
    .S_AXI_WREADY(io_W_READY),
    .S_AXI_WSTRB(io_W_STRB),
    .S_AXI_WVALID(io_W_VALID),

    //AXI Write Response Channel
    .S_AXI_BID(io_B_ID),
    .S_AXI_BREADY(io_B_READY),
    .S_AXI_BRESP(io_B_RESP),
    .S_AXI_BVALID(io_B_VALID),

    //AXI Read Address Channel
    .S_AXI_ARADDR(io_AR_ADDR),
    .S_AXI_ARBURST(io_AR_BURST),
    .S_AXI_ARID(io_AR_ID),
    .S_AXI_ARLEN(io_AR_LEN),
    .S_AXI_ARPROT(io_AR_PROT),
    .S_AXI_ARREADY(io_AR_READY),
    .S_AXI_ARSIZE(io_AR_SIZE),
    .S_AXI_ARVALID(io_AR_VALID),

    //AXI Read Data/Response Channel
    .S_AXI_RDATA(io_R_DATA),
    .S_AXI_RID(io_R_ID),
    .S_AXI_RLAST(io_R_LAST),
    .S_AXI_RREADY(io_R_READY),
    .S_AXI_RRESP(io_R_RESP),
    .S_AXI_RVALID(io_R_VALID)
  );


  Top Top_0 (
    // Signals from Top:  
    .clock (clock ),
    .reset (reset ),

    .io_TOP_WR (io_TOP_WR ),
    .io_TOP_RD (io_TOP_RD ),
    .io_TOP_ADDRESS (io_TOP_ADDRESS ),
    .io_TOP_WDATA (io_TOP_WDATA ),
    .io_TOP_RDATA (io_TOP_RDATA ),
    .io_TOP_LENGTH (io_TOP_LENGTH ),
    .io_TOP_BURST (io_TOP_BURST ),
    .io_TOP_SIZE (io_TOP_SIZE ),

    //AXI Write Address Channel
    .io_AW_BURST (io_AW_BURST ),
    .io_AW_ADDR (io_AW_ADDR ),
    .io_AW_LEN (io_AW_LEN ),
    .io_AW_SIZE (io_AW_SIZE ),
    .io_AW_ID (io_AW_ID ),
    .io_AW_READY (io_AW_READY ),
    .io_AW_VALID (io_AW_VALID ),
    .io_AW_PROT (io_AW_PROT ),

    //AXI Write Data Channel
    .io_W_DATA (io_W_DATA ),
    .io_W_LAST (io_W_LAST ),
    .io_W_STRB (io_W_STRB ),
    .io_W_READY (io_W_READY ),
    .io_W_VALID (io_W_VALID ),

    //AXI Write Response Channel
    .io_B_ID (io_B_ID ),
    .io_B_RESP (io_B_RESP ),
    .io_B_READY (io_B_READY ),
    .io_B_VALID (io_B_VALID ),

    //AXI Read Address Channel
    .io_AR_BURST (io_AR_BURST ),
    .io_AR_ADDR (io_AR_ADDR ),
    .io_AR_LEN (io_AR_LEN ),
    .io_AR_SIZE (io_AR_SIZE ),
    .io_AR_ID (io_AR_ID ),
    .io_AR_READY (io_AR_READY ),
    .io_AR_VALID (io_AR_VALID ),
    .io_AR_PROT (io_AR_PROT ),

    //AXI Read Data/Response Channel
    .io_R_DATA (io_R_DATA ),
    .io_R_LAST (io_R_LAST ),
    .io_R_ID (io_R_ID ),
    .io_R_RESP (io_R_RESP ),
    .io_R_READY (io_R_READY ),
    .io_R_VALID  ( io_R_VALID)
  );


endmodule
