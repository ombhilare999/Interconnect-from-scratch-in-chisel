module Transmitter(
  input         clock,
  input         reset,
  output        io_WR,
  output [31:0] io_ADD,
  output [31:0] io_WDATA
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg  r_wr; // @[fsm_comm.scala 27:30]
  reg [31:0] r_add; // @[fsm_comm.scala 29:30]
  reg [31:0] r_wdata; // @[fsm_comm.scala 30:30]
  reg [1:0] state; // @[fsm_comm.scala 37:28]
  wire  _T_2 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_6 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_9 = 2'h3 == state; // @[Conditional.scala 37:30]
  wire  _GEN_1 = _T_9 ? 1'h0 : r_wr; // @[Conditional.scala 39:67]
  wire  _GEN_6 = _T_6 | _GEN_1; // @[Conditional.scala 39:67]
  assign io_WR = r_wr; // @[fsm_comm.scala 62:15]
  assign io_ADD = r_add; // @[fsm_comm.scala 64:16]
  assign io_WDATA = r_wdata; // @[fsm_comm.scala 65:18]
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
  state = _RAND_3[1:0];
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
    end else if (!(_T_2)) begin
      r_wr <= _GEN_6;
    end
    if (reset) begin
      r_add <= 32'h0;
    end else if (!(_T_2)) begin
      if (_T_6) begin
        r_add <= 32'ha;
      end else if (_T_9) begin
        r_add <= 32'h0;
      end
    end
    if (reset) begin
      r_wdata <= 32'h0;
    end else if (!(_T_2)) begin
      if (_T_6) begin
        r_wdata <= 32'h14;
      end else if (_T_9) begin
        r_wdata <= 32'h0;
      end
    end
    if (reset) begin
      state <= 2'h0;
    end else if (!(_T_2)) begin
      if (_T_6) begin
        state <= 2'h2;
      end else if (_T_9) begin
        state <= 2'h0;
      end
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
  reg  r_wr; // @[fsm_comm.scala 82:30]
  reg [31:0] r_add; // @[fsm_comm.scala 84:30]
  reg [31:0] r_wdata; // @[fsm_comm.scala 85:30]
  reg [31:0] r_cdata; // @[fsm_comm.scala 87:30]
  reg [1:0] state; // @[fsm_comm.scala 94:28]
  wire  _T_2 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_6 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_8 = r_add == 32'ha; // @[fsm_comm.scala 105:32]
  wire  _T_11 = 2'h2 == state; // @[Conditional.scala 37:30]
  wire  _T_13 = r_add == 32'hb; // @[fsm_comm.scala 113:32]
  wire  _T_16 = 2'h3 == state; // @[Conditional.scala 37:30]
  assign io_CDATA = r_cdata; // @[fsm_comm.scala 129:18]
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
    end else if (!(_T_2)) begin
      if (_T_6) begin
        if (r_wr) begin
          if (_T_8) begin
            r_cdata <= r_wdata;
          end
        end
      end else if (_T_11) begin
        if (r_wr) begin
          if (_T_13) begin
            r_cdata <= r_wdata;
          end
        end
      end else if (_T_16) begin
        r_cdata <= 32'h0;
      end
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_2) begin
      if (r_wr) begin
        state <= 2'h1;
      end
    end else if (_T_6) begin
      if (r_wr) begin
        if (_T_8) begin
          state <= 2'h2;
        end
      end
    end else if (_T_11) begin
      if (r_wr) begin
        if (_T_13) begin
          state <= 2'h3;
        end
      end
    end
  end
endmodule
module Top(
  input         clock,
  input         reset,
  output [31:0] io_cdata_check
);
  wire  Tx_clock; // @[fsm_comm.scala 141:24]
  wire  Tx_reset; // @[fsm_comm.scala 141:24]
  wire  Tx_io_WR; // @[fsm_comm.scala 141:24]
  wire [31:0] Tx_io_ADD; // @[fsm_comm.scala 141:24]
  wire [31:0] Tx_io_WDATA; // @[fsm_comm.scala 141:24]
  wire  Rx_clock; // @[fsm_comm.scala 142:24]
  wire  Rx_reset; // @[fsm_comm.scala 142:24]
  wire  Rx_io_WR; // @[fsm_comm.scala 142:24]
  wire [31:0] Rx_io_ADD; // @[fsm_comm.scala 142:24]
  wire [31:0] Rx_io_WDATA; // @[fsm_comm.scala 142:24]
  wire [31:0] Rx_io_CDATA; // @[fsm_comm.scala 142:24]
  Transmitter Tx ( // @[fsm_comm.scala 141:24]
    .clock(Tx_clock),
    .reset(Tx_reset),
    .io_WR(Tx_io_WR),
    .io_ADD(Tx_io_ADD),
    .io_WDATA(Tx_io_WDATA)
  );
  Receiver Rx ( // @[fsm_comm.scala 142:24]
    .clock(Rx_clock),
    .reset(Rx_reset),
    .io_WR(Rx_io_WR),
    .io_ADD(Rx_io_ADD),
    .io_WDATA(Rx_io_WDATA),
    .io_CDATA(Rx_io_CDATA)
  );
  assign io_cdata_check = Rx_io_CDATA; // @[fsm_comm.scala 154:24]
  assign Tx_clock = clock;
  assign Tx_reset = reset;
  assign Rx_clock = clock;
  assign Rx_reset = reset;
  assign Rx_io_WR = Tx_io_WR; // @[fsm_comm.scala 146:18]
  assign Rx_io_ADD = Tx_io_ADD; // @[fsm_comm.scala 148:19]
  assign Rx_io_WDATA = Tx_io_WDATA; // @[fsm_comm.scala 149:21]
endmodule
