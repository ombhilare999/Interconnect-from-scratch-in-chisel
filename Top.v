module Transmitter(
  input         io_START,
  input         io_TOP_WR,
  input         io_TOP_RD,
  input  [3:0]  io_TOP_ADDRESS,
  input  [31:0] io_TOP_WDATA,
  output [31:0] io_TOP_RDATA,
  output        io_WR,
  output        io_RD,
  output [3:0]  io_ADDRESS,
  output [31:0] io_WDATA,
  input  [31:0] io_RDATA
);
  wire  _GEN_0 = io_TOP_RD & io_TOP_WR; // @[transmitter.scala 70:40]
  wire [3:0] _GEN_2 = io_TOP_RD ? io_TOP_ADDRESS : 4'h0; // @[transmitter.scala 70:40]
  wire [31:0] _GEN_3 = io_TOP_RD ? io_RDATA : 32'h0; // @[transmitter.scala 70:40]
  wire  _GEN_5 = io_TOP_WR ? io_TOP_WR : _GEN_0; // @[transmitter.scala 64:33]
  wire [3:0] _GEN_7 = io_TOP_WR ? io_TOP_ADDRESS : _GEN_2; // @[transmitter.scala 64:33]
  wire [31:0] _GEN_8 = io_TOP_WR ? io_TOP_WDATA : 32'h0; // @[transmitter.scala 64:33]
  wire [31:0] _GEN_9 = io_TOP_WR ? 32'h0 : _GEN_3; // @[transmitter.scala 64:33]
  assign io_TOP_RDATA = io_START ? _GEN_9 : 32'h0; // @[transmitter.scala 47:16 transmitter.scala 75:24]
  assign io_WR = io_START & _GEN_5; // @[transmitter.scala 48:16 transmitter.scala 66:22 transmitter.scala 72:24]
  assign io_RD = io_START & io_TOP_RD; // @[transmitter.scala 49:16 transmitter.scala 67:22 transmitter.scala 73:24]
  assign io_ADDRESS = io_START ? _GEN_7 : 4'h0; // @[transmitter.scala 50:16 transmitter.scala 68:22 transmitter.scala 74:24]
  assign io_WDATA = io_START ? _GEN_8 : 32'h0; // @[transmitter.scala 51:16 transmitter.scala 69:22]
endmodule
module Receiver(
  input         clock,
  input         io_WR,
  input         io_RD,
  input  [3:0]  io_ADD,
  input  [31:0] io_WDATA,
  output [31:0] io_RDATA
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] mem [0:9]; // @[receiver.scala 39:24]
  wire [31:0] mem__T_9_data; // @[receiver.scala 39:24]
  wire [3:0] mem__T_9_addr; // @[receiver.scala 39:24]
  wire [31:0] mem__T_4_data; // @[receiver.scala 39:24]
  wire [3:0] mem__T_4_addr; // @[receiver.scala 39:24]
  wire  mem__T_4_mask; // @[receiver.scala 39:24]
  wire  mem__T_4_en; // @[receiver.scala 39:24]
  reg  mem__T_9_en_pipe_0;
  reg [3:0] mem__T_9_addr_pipe_0;
  wire [31:0] _GEN_7 = io_RD ? mem__T_9_data : 32'h0; // @[receiver.scala 54:36]
  assign mem__T_9_addr = mem__T_9_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign mem__T_9_data = mem[mem__T_9_addr]; // @[receiver.scala 39:24]
  `else
  assign mem__T_9_data = mem__T_9_addr >= 4'ha ? _RAND_1[31:0] : mem[mem__T_9_addr]; // @[receiver.scala 39:24]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign mem__T_4_data = io_WDATA;
  assign mem__T_4_addr = io_ADD;
  assign mem__T_4_mask = 1'h1;
  assign mem__T_4_en = io_WR;
  assign io_RDATA = io_WR ? 32'h0 : _GEN_7; // @[receiver.scala 36:16 receiver.scala 56:20]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {1{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    mem[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  mem__T_9_en_pipe_0 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  mem__T_9_addr_pipe_0 = _RAND_3[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(mem__T_4_en & mem__T_4_mask) begin
      mem[mem__T_4_addr] <= mem__T_4_data; // @[receiver.scala 39:24]
    end
    if (io_WR) begin
      mem__T_9_en_pipe_0 <= 1'h0;
    end else begin
      mem__T_9_en_pipe_0 <= io_RD;
    end
    if (io_WR ? 1'h0 : io_RD) begin
      mem__T_9_addr_pipe_0 <= io_ADD;
    end
  end
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_start,
  input         io_top_wr,
  input         io_top_rd,
  input  [3:0]  io_top_address,
  input  [31:0] io_top_wdata,
  output [31:0] io_top_rdata
);
  wire  Tx_io_START; // @[Main.scala 23:18]
  wire  Tx_io_TOP_WR; // @[Main.scala 23:18]
  wire  Tx_io_TOP_RD; // @[Main.scala 23:18]
  wire [3:0] Tx_io_TOP_ADDRESS; // @[Main.scala 23:18]
  wire [31:0] Tx_io_TOP_WDATA; // @[Main.scala 23:18]
  wire [31:0] Tx_io_TOP_RDATA; // @[Main.scala 23:18]
  wire  Tx_io_WR; // @[Main.scala 23:18]
  wire  Tx_io_RD; // @[Main.scala 23:18]
  wire [3:0] Tx_io_ADDRESS; // @[Main.scala 23:18]
  wire [31:0] Tx_io_WDATA; // @[Main.scala 23:18]
  wire [31:0] Tx_io_RDATA; // @[Main.scala 23:18]
  wire  Rx_clock; // @[Main.scala 24:18]
  wire  Rx_io_WR; // @[Main.scala 24:18]
  wire  Rx_io_RD; // @[Main.scala 24:18]
  wire [3:0] Rx_io_ADD; // @[Main.scala 24:18]
  wire [31:0] Rx_io_WDATA; // @[Main.scala 24:18]
  wire [31:0] Rx_io_RDATA; // @[Main.scala 24:18]
  Transmitter Tx ( // @[Main.scala 23:18]
    .io_START(Tx_io_START),
    .io_TOP_WR(Tx_io_TOP_WR),
    .io_TOP_RD(Tx_io_TOP_RD),
    .io_TOP_ADDRESS(Tx_io_TOP_ADDRESS),
    .io_TOP_WDATA(Tx_io_TOP_WDATA),
    .io_TOP_RDATA(Tx_io_TOP_RDATA),
    .io_WR(Tx_io_WR),
    .io_RD(Tx_io_RD),
    .io_ADDRESS(Tx_io_ADDRESS),
    .io_WDATA(Tx_io_WDATA),
    .io_RDATA(Tx_io_RDATA)
  );
  Receiver Rx ( // @[Main.scala 24:18]
    .clock(Rx_clock),
    .io_WR(Rx_io_WR),
    .io_RD(Rx_io_RD),
    .io_ADD(Rx_io_ADD),
    .io_WDATA(Rx_io_WDATA),
    .io_RDATA(Rx_io_RDATA)
  );
  assign io_top_rdata = Tx_io_TOP_RDATA; // @[Main.scala 32:21]
  assign Tx_io_START = io_start; // @[Main.scala 40:15]
  assign Tx_io_TOP_WR = io_top_wr; // @[Main.scala 28:21]
  assign Tx_io_TOP_RD = io_top_rd; // @[Main.scala 29:21]
  assign Tx_io_TOP_ADDRESS = io_top_address; // @[Main.scala 30:21]
  assign Tx_io_TOP_WDATA = io_top_wdata; // @[Main.scala 31:21]
  assign Tx_io_RDATA = Rx_io_RDATA; // @[Main.scala 39:15]
  assign Rx_clock = clock;
  assign Rx_io_WR = Tx_io_WR; // @[Main.scala 35:12]
  assign Rx_io_RD = Tx_io_RD; // @[Main.scala 36:12]
  assign Rx_io_ADD = Tx_io_ADDRESS; // @[Main.scala 37:13]
  assign Rx_io_WDATA = Tx_io_WDATA; // @[Main.scala 38:15]
endmodule
