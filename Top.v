module Top(
  input         clock,
  input         reset,
  input         io_TOP_WR,
  input         io_TOP_RD,
  input  [5:0]  io_TOP_ADDRESS,
  input  [31:0] io_TOP_WDATA,
  output [31:0] io_TOP_RDATA,
  input  [5:0]  io_TOP_LENGTH,
  input  [1:0]  io_TOP_BURST,
  input  [2:0]  io_TOP_SIZE,
  output [1:0]  io_AW_BURST,
  output [5:0]  io_AW_ADDR,
  output [7:0]  io_AW_LEN,
  output [2:0]  io_AW_SIZE,
  output        io_AW_ID,
  input         io_AW_READY,
  output        io_AW_VALID,
  output [2:0]  io_AW_PROT,
  output [31:0] io_W_DATA,
  output        io_W_LAST,
  output [3:0]  io_W_STRB,
  input         io_W_READY,
  output        io_W_VALID,
  input         io_B_ID,
  input  [1:0]  io_B_RESP,
  output        io_B_READY,
  input         io_B_VALID,
  output [1:0]  io_AR_BURST,
  output [5:0]  io_AR_ADDR,
  output [7:0]  io_AR_LEN,
  output [2:0]  io_AR_SIZE,
  output        io_AR_ID,
  input         io_AR_READY,
  output        io_AR_VALID,
  output [2:0]  io_AR_PROT,
  input  [31:0] io_R_DATA,
  input         io_R_LAST,
  input         io_R_ID,
  input  [1:0]  io_R_RESP,
  output        io_R_READY,
  input         io_R_VALID
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] r_AW_BURST; // @[Main.scala 66:33]
  reg [5:0] r_AW_ADDR; // @[Main.scala 67:33]
  reg [7:0] r_AW_LEN; // @[Main.scala 68:33]
  reg [2:0] r_AW_SIZE; // @[Main.scala 69:33]
  reg  r_AW_VALID; // @[Main.scala 71:33]
  reg [2:0] r_transaction_cnt; // @[Main.scala 73:40]
  reg [31:0] r_W_DATA; // @[Main.scala 76:33]
  reg  r_W_LAST; // @[Main.scala 77:33]
  reg [3:0] r_W_STRB; // @[Main.scala 78:33]
  reg  r_W_VALID; // @[Main.scala 79:33]
  reg  r_B_READY; // @[Main.scala 82:35]
  reg [7:0] r_len; // @[Main.scala 85:32]
  wire [1:0] _T = ~io_B_RESP; // @[Main.scala 90:46]
  wire [1:0] _GEN_74 = {{1'd0}, io_B_VALID}; // @[Main.scala 90:44]
  wire [1:0] _T_1 = _GEN_74 & _T; // @[Main.scala 90:44]
  reg [1:0] state; // @[Main.scala 108:28]
  wire  _T_4 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_6 = r_transaction_cnt == 3'h0; // @[Main.scala 114:45]
  wire [12:0] _GEN_75 = {{7'd0}, io_TOP_LENGTH}; // @[Main.scala 121:55]
  wire [12:0] _T_7 = _GEN_75 << io_TOP_SIZE; // @[Main.scala 121:55]
  wire [12:0] _T_9 = _T_7 + 13'h1; // @[Main.scala 121:72]
  wire [2:0] _T_12 = r_transaction_cnt + 3'h1; // @[Main.scala 131:68]
  wire [12:0] _GEN_17 = _T_6 ? _T_9 : {{5'd0}, r_len}; // @[Main.scala 114:53]
  wire  _GEN_19 = _T_6 | r_W_VALID; // @[Main.scala 114:53]
  wire [12:0] _GEN_29 = io_TOP_WR ? _GEN_17 : {{5'd0}, r_len}; // @[Main.scala 113:41]
  wire  _T_18 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_20 = r_len >= 8'h1; // @[Main.scala 156:33]
  wire [7:0] _T_22 = r_len - 8'h1; // @[Main.scala 157:45]
  wire  _GEN_36 = _T_20 | r_W_LAST; // @[Main.scala 161:44]
  wire [7:0] _GEN_37 = _T_20 ? _T_22 : r_len; // @[Main.scala 156:41]
  wire  _GEN_41 = _T_20 & _GEN_36; // @[Main.scala 156:41]
  wire  _GEN_42 = _T_20 & r_W_VALID; // @[Main.scala 156:41]
  wire [7:0] _GEN_43 = io_W_READY ? _GEN_37 : r_len; // @[Main.scala 155:42]
  wire  _T_26 = 2'h2 == state; // @[Conditional.scala 37:30]
  wire  write_response_ready = _T_1[0]; // @[Main.scala 86:41 Main.scala 89:30 Main.scala 90:30]
  wire  _GEN_50 = _T_26 | r_B_READY; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_52 = _T_18 ? _GEN_43 : r_len; // @[Conditional.scala 39:67]
  wire [12:0] _GEN_64 = _T_4 ? _GEN_29 : {{5'd0}, _GEN_52}; // @[Conditional.scala 40:58]
  assign io_TOP_RDATA = 32'h0; // @[Main.scala 93:23]
  assign io_AW_BURST = r_AW_BURST; // @[Main.scala 190:21]
  assign io_AW_ADDR = r_AW_ADDR; // @[Main.scala 191:21]
  assign io_AW_LEN = r_AW_LEN; // @[Main.scala 192:21]
  assign io_AW_SIZE = r_AW_SIZE; // @[Main.scala 193:21]
  assign io_AW_ID = 1'h0; // @[Main.scala 194:21]
  assign io_AW_VALID = r_AW_VALID; // @[Main.scala 195:21]
  assign io_AW_PROT = 3'h0; // @[Main.scala 196:21]
  assign io_W_DATA = r_W_DATA; // @[Main.scala 199:21]
  assign io_W_LAST = r_W_LAST; // @[Main.scala 200:21]
  assign io_W_STRB = r_W_STRB; // @[Main.scala 201:21]
  assign io_W_VALID = r_W_VALID; // @[Main.scala 202:21]
  assign io_B_READY = r_B_READY; // @[Main.scala 205:21]
  assign io_AR_BURST = 2'h0; // @[Main.scala 94:23]
  assign io_AR_ADDR = 6'h0; // @[Main.scala 95:23]
  assign io_AR_LEN = 8'h0; // @[Main.scala 96:23]
  assign io_AR_SIZE = 3'h0; // @[Main.scala 97:23]
  assign io_AR_ID = 1'h0; // @[Main.scala 98:23]
  assign io_AR_VALID = 1'h0; // @[Main.scala 99:23]
  assign io_AR_PROT = 3'h0; // @[Main.scala 100:23]
  assign io_R_READY = 1'h0; // @[Main.scala 101:23]
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
  r_AW_BURST = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  r_AW_ADDR = _RAND_1[5:0];
  _RAND_2 = {1{`RANDOM}};
  r_AW_LEN = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  r_AW_SIZE = _RAND_3[2:0];
  _RAND_4 = {1{`RANDOM}};
  r_AW_VALID = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  r_transaction_cnt = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  r_W_DATA = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  r_W_LAST = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  r_W_STRB = _RAND_8[3:0];
  _RAND_9 = {1{`RANDOM}};
  r_W_VALID = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  r_B_READY = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  r_len = _RAND_11[7:0];
  _RAND_12 = {1{`RANDOM}};
  state = _RAND_12[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      r_AW_BURST <= 2'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          r_AW_BURST <= io_TOP_BURST;
        end
      end
    end
    if (reset) begin
      r_AW_ADDR <= 6'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          r_AW_ADDR <= io_TOP_ADDRESS;
        end
      end
    end
    if (reset) begin
      r_AW_LEN <= 8'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          r_AW_LEN <= {{2'd0}, io_TOP_LENGTH};
        end
      end
    end
    if (reset) begin
      r_AW_SIZE <= 3'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          r_AW_SIZE <= io_TOP_SIZE;
        end
      end
    end
    if (reset) begin
      r_AW_VALID <= 1'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          if (io_AW_READY) begin
            r_AW_VALID <= 1'h0;
          end else begin
            r_AW_VALID <= 1'h1;
          end
        end else if (io_AW_READY) begin
          r_AW_VALID <= 1'h0;
        end else begin
          r_AW_VALID <= 1'h1;
        end
      end
    end
    if (reset) begin
      r_transaction_cnt <= 3'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          if (io_AW_READY) begin
            r_transaction_cnt <= 3'h0;
          end else begin
            r_transaction_cnt <= _T_12;
          end
        end else if (io_AW_READY) begin
          r_transaction_cnt <= 3'h0;
        end else begin
          r_transaction_cnt <= _T_12;
        end
      end
    end
    if (reset) begin
      r_W_DATA <= 32'h0;
    end else if (!(_T_4)) begin
      if (_T_18) begin
        if (io_W_READY) begin
          if (_T_20) begin
            r_W_DATA <= io_TOP_WDATA;
          end else begin
            r_W_DATA <= 32'h0;
          end
        end
      end
    end
    if (reset) begin
      r_W_LAST <= 1'h0;
    end else if (!(_T_4)) begin
      if (_T_18) begin
        if (io_W_READY) begin
          r_W_LAST <= _GEN_41;
        end
      end
    end
    if (reset) begin
      r_W_STRB <= 4'h0;
    end else if (!(_T_4)) begin
      if (_T_18) begin
        if (io_W_READY) begin
          r_W_STRB <= {{3'd0}, _T_20};
        end
      end
    end
    if (reset) begin
      r_W_VALID <= 1'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        r_W_VALID <= _GEN_19;
      end
    end else if (_T_18) begin
      if (io_W_READY) begin
        r_W_VALID <= _GEN_42;
      end
    end
    if (reset) begin
      r_B_READY <= 1'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          r_B_READY <= 1'h0;
        end
      end
    end else if (!(_T_18)) begin
      r_B_READY <= _GEN_50;
    end
    if (reset) begin
      r_len <= 8'h0;
    end else begin
      r_len <= _GEN_64[7:0];
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_4) begin
      if (io_TOP_WR) begin
        if (_T_6) begin
          if (io_AW_READY) begin
            state <= 2'h1;
          end
        end else if (io_AW_READY) begin
          state <= 2'h1;
        end
      end else begin
        state <= 2'h0;
      end
    end else if (_T_18) begin
      if (io_W_READY) begin
        if (_T_20) begin
          state <= 2'h1;
        end else begin
          state <= 2'h2;
        end
      end else begin
        state <= 2'h1;
      end
    end else if (_T_26) begin
      if (write_response_ready) begin
        state <= 2'h0;
      end
    end
  end
endmodule
