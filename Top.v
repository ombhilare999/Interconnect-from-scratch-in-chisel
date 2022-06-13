module Transmitter(
  input         clock,
  input         reset,
  input         io_START,
  output        io_WR,
  output [31:0] io_ADD,
  output [31:0] io_WDATA
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg  r_start; // @[transmitter.scala 24:24]
  reg  r_wr; // @[transmitter.scala 25:21]
  reg [31:0] r_add; // @[transmitter.scala 27:22]
  reg [31:0] r_wdata; // @[transmitter.scala 28:24]
  reg [1:0] state; // @[transmitter.scala 35:22]
  wire  _T_2 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_6 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_9 = 2'h2 == state; // @[Conditional.scala 37:30]
  wire  _T_12 = 2'h3 == state; // @[Conditional.scala 37:30]
  wire  _GEN_1 = _T_12 ? 1'h0 : r_wr; // @[Conditional.scala 39:67]
  wire  _GEN_8 = _T_9 ? r_wr : _GEN_1; // @[Conditional.scala 39:67]
  wire  _GEN_10 = _T_6 | _GEN_8; // @[Conditional.scala 39:67]
  assign io_WR = r_wr; // @[transmitter.scala 65:9]
  assign io_ADD = r_add; // @[transmitter.scala 67:10]
  assign io_WDATA = r_wdata; // @[transmitter.scala 68:12]
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
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r_start = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  r_wr = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  r_add = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  r_wdata = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  state = _RAND_4[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      r_start <= 1'h0;
    end else begin
      r_start <= io_START;
    end
    if (reset) begin
      r_wr <= 1'h0;
    end else if (!(_T_2)) begin
      r_wr <= _GEN_10;
    end
    if (reset) begin
      r_add <= 32'h0;
    end else if (!(_T_2)) begin
      if (_T_6) begin
        r_add <= 32'h1e;
      end else if (_T_9) begin
        r_add <= 32'h1f;
      end else if (_T_12) begin
        r_add <= 32'h0;
      end
    end
    if (reset) begin
      r_wdata <= 32'h0;
    end else if (!(_T_2)) begin
      if (_T_6) begin
        r_wdata <= 32'h14;
      end else if (_T_9) begin
        r_wdata <= 32'h16;
      end else if (_T_12) begin
        r_wdata <= 32'h0;
      end
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_2) begin
      if (r_start) begin
        state <= 2'h1;
      end
    end else if (_T_6) begin
      state <= 2'h2;
    end else if (_T_9) begin
      state <= 2'h3;
    end
  end
endmodule
module Receiver(
  input         clock,
  input         reset,
  input         io_WR,
  input  [31:0] io_ADD,
  input  [31:0] io_WDATA,
  output [31:0] io_CDATA
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg  r_wr; // @[receiver.scala 20:21]
  reg [31:0] r_add; // @[receiver.scala 22:22]
  reg [31:0] r_wdata; // @[receiver.scala 23:24]
  reg [31:0] r_cdata; // @[receiver.scala 25:24]
  reg [1:0] state; // @[receiver.scala 31:22]
  wire  _T_2 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_4 = r_add == 32'h1e; // @[receiver.scala 36:20]
  wire  _T_7 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_9 = r_add == 32'h1f; // @[receiver.scala 44:20]
  wire  _T_12 = 2'h2 == state; // @[Conditional.scala 37:30]
  assign io_CDATA = r_cdata; // @[receiver.scala 61:12]
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
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r_wr = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  r_add = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  r_wdata = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  r_cdata = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  state = _RAND_4[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      r_wr <= 1'h0;
    end else begin
      r_wr <= io_WR;
    end
    if (reset) begin
      r_add <= 32'h0;
    end else begin
      r_add <= io_ADD;
    end
    if (reset) begin
      r_wdata <= 32'h0;
    end else begin
      r_wdata <= io_WDATA;
    end
    if (reset) begin
      r_cdata <= 32'h0;
    end else if (_T_2) begin
      if (r_wr) begin
        if (_T_4) begin
          r_cdata <= r_wdata;
        end
      end
    end else if (_T_7) begin
      if (r_wr) begin
        if (_T_9) begin
          r_cdata <= r_wdata;
        end
      end
    end else if (_T_12) begin
      r_cdata <= 32'h0;
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_2) begin
      if (r_wr) begin
        if (_T_4) begin
          state <= 2'h1;
        end
      end
    end else if (_T_7) begin
      if (r_wr) begin
        if (_T_9) begin
          state <= 2'h2;
        end
      end
    end
  end
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_start,
  output [31:0] io_cdata_check
);
  wire  Tx_clock; // @[Main.scala 19:18]
  wire  Tx_reset; // @[Main.scala 19:18]
  wire  Tx_io_START; // @[Main.scala 19:18]
  wire  Tx_io_WR; // @[Main.scala 19:18]
  wire [31:0] Tx_io_ADD; // @[Main.scala 19:18]
  wire [31:0] Tx_io_WDATA; // @[Main.scala 19:18]
  wire  Rx_clock; // @[Main.scala 20:18]
  wire  Rx_reset; // @[Main.scala 20:18]
  wire  Rx_io_WR; // @[Main.scala 20:18]
  wire [31:0] Rx_io_ADD; // @[Main.scala 20:18]
  wire [31:0] Rx_io_WDATA; // @[Main.scala 20:18]
  wire [31:0] Rx_io_CDATA; // @[Main.scala 20:18]
  Transmitter Tx ( // @[Main.scala 19:18]
    .clock(Tx_clock),
    .reset(Tx_reset),
    .io_START(Tx_io_START),
    .io_WR(Tx_io_WR),
    .io_ADD(Tx_io_ADD),
    .io_WDATA(Tx_io_WDATA)
  );
  Receiver Rx ( // @[Main.scala 20:18]
    .clock(Rx_clock),
    .reset(Rx_reset),
    .io_WR(Rx_io_WR),
    .io_ADD(Rx_io_ADD),
    .io_WDATA(Rx_io_WDATA),
    .io_CDATA(Rx_io_CDATA)
  );
  assign io_cdata_check = Rx_io_CDATA; // @[Main.scala 32:18]
  assign Tx_clock = clock;
  assign Tx_reset = reset;
  assign Tx_io_START = io_start; // @[Main.scala 29:15]
  assign Rx_clock = clock;
  assign Rx_reset = reset;
  assign Rx_io_WR = Tx_io_WR; // @[Main.scala 24:12]
  assign Rx_io_ADD = Tx_io_ADD; // @[Main.scala 26:13]
  assign Rx_io_WDATA = Tx_io_WDATA; // @[Main.scala 27:15]
endmodule
