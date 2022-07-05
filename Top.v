module Top(
  input         clock,
  input         reset,
  input         io_TOP_WR,
  input         io_TOP_RD,
  input  [5:0]  io_TOP_ADDRESS,
  input  [31:0] io_TOP_WDATA,
  input  [7:0]  io_TOP_LENGTH,
  input  [1:0]  io_TOP_BURST,
  input  [2:0]  io_TOP_SIZE,
  output [31:0] io_TOP_RDATA,
  input  [5:0]  io_TOP_R_ADDRESS,
  input  [7:0]  io_TOP_R_LENGTH,
  input  [1:0]  io_TOP_R_BURST,
  input  [2:0]  io_TOP_R_SIZE,
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
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] r_AW_BURST; // @[Main.scala 72:33]
  reg [5:0] r_AW_ADDR; // @[Main.scala 73:33]
  reg [7:0] r_AW_LEN; // @[Main.scala 74:33]
  reg [2:0] r_AW_SIZE; // @[Main.scala 75:33]
  reg  r_AW_VALID; // @[Main.scala 77:33]
  reg [31:0] r_W_DATA; // @[Main.scala 81:33]
  reg  r_W_LAST; // @[Main.scala 82:33]
  reg [3:0] r_W_STRB; // @[Main.scala 83:33]
  reg  r_W_VALID; // @[Main.scala 84:33]
  reg  r_B_READY; // @[Main.scala 87:33]
  reg [1:0] r_AR_BURST; // @[Main.scala 90:33]
  reg [5:0] r_AR_ADDR; // @[Main.scala 91:33]
  reg [7:0] r_AR_LEN; // @[Main.scala 92:33]
  reg [2:0] r_AR_SIZE; // @[Main.scala 93:33]
  reg  r_AR_VALID; // @[Main.scala 96:33]
  reg [31:0] r_R_RDATA; // @[Main.scala 100:34]
  reg  r_R_READY; // @[Main.scala 101:33]
  reg [2:0] r_transaction_cnt; // @[Main.scala 104:44]
  reg [7:0] r_len; // @[Main.scala 105:44]
  reg [2:0] rx_transaction_cnt; // @[Main.scala 109:44]
  reg [7:0] rx_len; // @[Main.scala 110:44]
  wire [1:0] _T = ~io_B_RESP; // @[Main.scala 115:46]
  wire [1:0] _GEN_135 = {{1'd0}, io_B_VALID}; // @[Main.scala 115:44]
  wire [1:0] _T_1 = _GEN_135 & _T; // @[Main.scala 115:44]
  wire [1:0] _T_2 = ~io_R_RESP; // @[Main.scala 118:46]
  wire [1:0] _GEN_136 = {{1'd0}, io_R_VALID}; // @[Main.scala 118:44]
  wire [1:0] _T_3 = _GEN_136 & _T_2; // @[Main.scala 118:44]
  wire [1:0] _GEN_137 = {{1'd0}, io_R_LAST}; // @[Main.scala 118:57]
  wire [1:0] _T_4 = _T_3 & _GEN_137; // @[Main.scala 118:57]
  reg [1:0] state; // @[Main.scala 125:28]
  wire  _T_7 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_9 = r_transaction_cnt == 3'h0; // @[Main.scala 131:45]
  wire [14:0] _GEN_138 = {{7'd0}, io_TOP_LENGTH}; // @[Main.scala 138:55]
  wire [14:0] _T_10 = _GEN_138 << io_TOP_SIZE; // @[Main.scala 138:55]
  wire [14:0] _T_12 = _T_10 + 15'h1; // @[Main.scala 138:72]
  wire [2:0] _T_15 = r_transaction_cnt + 3'h1; // @[Main.scala 148:68]
  wire [14:0] _GEN_17 = _T_9 ? _T_12 : {{7'd0}, r_len}; // @[Main.scala 131:53]
  wire  _GEN_19 = _T_9 | r_W_VALID; // @[Main.scala 131:53]
  wire [14:0] _GEN_29 = io_TOP_WR ? _GEN_17 : {{7'd0}, r_len}; // @[Main.scala 130:41]
  wire  _T_21 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_23 = r_len >= 8'h1; // @[Main.scala 173:33]
  wire [7:0] _T_25 = r_len - 8'h1; // @[Main.scala 174:45]
  wire  _T_26 = r_len == 8'h1; // @[Main.scala 178:37]
  wire  _GEN_36 = _T_26 | r_W_LAST; // @[Main.scala 178:45]
  wire [7:0] _GEN_37 = _T_23 ? _T_25 : r_len; // @[Main.scala 173:41]
  wire  _GEN_41 = _T_23 & _GEN_36; // @[Main.scala 173:41]
  wire  _GEN_42 = _T_23 & r_W_VALID; // @[Main.scala 173:41]
  wire [7:0] _GEN_43 = io_W_READY ? _GEN_37 : r_len; // @[Main.scala 172:42]
  wire  _T_29 = 2'h2 == state; // @[Conditional.scala 37:30]
  wire  write_response_ready = _T_1[0]; // @[Main.scala 106:41 Main.scala 114:30 Main.scala 115:30]
  wire  _GEN_50 = _T_29 | r_B_READY; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_52 = _T_21 ? _GEN_43 : r_len; // @[Conditional.scala 39:67]
  wire [14:0] _GEN_64 = _T_7 ? _GEN_29 : {{7'd0}, _GEN_52}; // @[Conditional.scala 40:58]
  reg [1:0] rx_state; // @[Main.scala 210:31]
  wire  _T_33 = 2'h0 == rx_state; // @[Conditional.scala 37:30]
  wire  _T_35 = rx_transaction_cnt == 3'h0; // @[Main.scala 216:45]
  wire [14:0] _GEN_139 = {{7'd0}, io_TOP_R_LENGTH}; // @[Main.scala 222:56]
  wire [14:0] _T_36 = _GEN_139 << io_TOP_R_SIZE; // @[Main.scala 222:56]
  wire [14:0] _T_38 = _T_36 + 15'h1; // @[Main.scala 222:74]
  wire [2:0] _T_41 = rx_transaction_cnt + 3'h1; // @[Main.scala 232:70]
  wire  _GEN_84 = io_AR_READY ? r_R_READY : 1'h1; // @[Main.scala 235:50]
  wire [14:0] _GEN_91 = _T_35 ? _T_38 : {{7'd0}, rx_len}; // @[Main.scala 216:54]
  wire  _GEN_93 = _T_35 | _GEN_84; // @[Main.scala 216:54]
  wire [14:0] _GEN_102 = io_TOP_RD ? _GEN_91 : {{7'd0}, rx_len}; // @[Main.scala 215:41]
  wire  _T_47 = 2'h1 == rx_state; // @[Conditional.scala 37:30]
  wire  _T_49 = rx_len >= 8'h1; // @[Main.scala 258:34]
  wire [7:0] _T_51 = rx_len - 8'h1; // @[Main.scala 259:45]
  wire  read_response_ready = _T_4[0]; // @[Main.scala 111:40 Main.scala 117:30 Main.scala 118:30]
  wire  _GEN_110 = read_response_ready ? 1'h0 : 1'h1; // @[Main.scala 262:59]
  wire [7:0] _GEN_111 = _T_49 ? _T_51 : rx_len; // @[Main.scala 258:41]
  wire [7:0] _GEN_115 = io_R_VALID ? _GEN_111 : rx_len; // @[Main.scala 257:41]
  wire [7:0] _GEN_119 = _T_47 ? _GEN_115 : rx_len; // @[Conditional.scala 39:67]
  wire [14:0] _GEN_127 = _T_33 ? _GEN_102 : {{7'd0}, _GEN_119}; // @[Conditional.scala 40:58]
  assign io_TOP_RDATA = r_R_RDATA; // @[Main.scala 307:22]
  assign io_AW_BURST = r_AW_BURST; // @[Main.scala 277:21]
  assign io_AW_ADDR = r_AW_ADDR; // @[Main.scala 278:21]
  assign io_AW_LEN = r_AW_LEN; // @[Main.scala 279:21]
  assign io_AW_SIZE = r_AW_SIZE; // @[Main.scala 280:21]
  assign io_AW_ID = 1'h0; // @[Main.scala 281:21]
  assign io_AW_VALID = r_AW_VALID; // @[Main.scala 282:21]
  assign io_AW_PROT = 3'h0; // @[Main.scala 283:21]
  assign io_W_DATA = r_W_DATA; // @[Main.scala 286:21]
  assign io_W_LAST = r_W_LAST; // @[Main.scala 287:21]
  assign io_W_STRB = r_W_STRB; // @[Main.scala 288:21]
  assign io_W_VALID = r_W_VALID; // @[Main.scala 289:21]
  assign io_B_READY = r_B_READY; // @[Main.scala 292:21]
  assign io_AR_BURST = r_AR_BURST; // @[Main.scala 295:21]
  assign io_AR_ADDR = r_AR_ADDR; // @[Main.scala 296:21]
  assign io_AR_LEN = r_AR_LEN; // @[Main.scala 297:21]
  assign io_AR_SIZE = r_AR_SIZE; // @[Main.scala 298:21]
  assign io_AR_ID = 1'h0; // @[Main.scala 299:21]
  assign io_AR_VALID = r_AR_VALID; // @[Main.scala 300:21]
  assign io_AR_PROT = 3'h0; // @[Main.scala 301:21]
  assign io_R_READY = r_R_READY; // @[Main.scala 304:22]
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
  r_W_DATA = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  r_W_LAST = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  r_W_STRB = _RAND_7[3:0];
  _RAND_8 = {1{`RANDOM}};
  r_W_VALID = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  r_B_READY = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  r_AR_BURST = _RAND_10[1:0];
  _RAND_11 = {1{`RANDOM}};
  r_AR_ADDR = _RAND_11[5:0];
  _RAND_12 = {1{`RANDOM}};
  r_AR_LEN = _RAND_12[7:0];
  _RAND_13 = {1{`RANDOM}};
  r_AR_SIZE = _RAND_13[2:0];
  _RAND_14 = {1{`RANDOM}};
  r_AR_VALID = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  r_R_RDATA = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  r_R_READY = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  r_transaction_cnt = _RAND_17[2:0];
  _RAND_18 = {1{`RANDOM}};
  r_len = _RAND_18[7:0];
  _RAND_19 = {1{`RANDOM}};
  rx_transaction_cnt = _RAND_19[2:0];
  _RAND_20 = {1{`RANDOM}};
  rx_len = _RAND_20[7:0];
  _RAND_21 = {1{`RANDOM}};
  state = _RAND_21[1:0];
  _RAND_22 = {1{`RANDOM}};
  rx_state = _RAND_22[1:0];
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
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          r_AW_BURST <= io_TOP_BURST;
        end
      end
    end
    if (reset) begin
      r_AW_ADDR <= 6'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          r_AW_ADDR <= io_TOP_ADDRESS;
        end
      end
    end
    if (reset) begin
      r_AW_LEN <= 8'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          r_AW_LEN <= io_TOP_LENGTH;
        end
      end
    end
    if (reset) begin
      r_AW_SIZE <= 3'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          r_AW_SIZE <= io_TOP_SIZE;
        end
      end
    end
    if (reset) begin
      r_AW_VALID <= 1'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
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
      r_W_DATA <= 32'h0;
    end else if (!(_T_7)) begin
      if (_T_21) begin
        if (io_W_READY) begin
          if (_T_23) begin
            r_W_DATA <= io_TOP_WDATA;
          end else begin
            r_W_DATA <= 32'h0;
          end
        end
      end
    end
    if (reset) begin
      r_W_LAST <= 1'h0;
    end else if (!(_T_7)) begin
      if (_T_21) begin
        if (io_W_READY) begin
          r_W_LAST <= _GEN_41;
        end
      end
    end
    if (reset) begin
      r_W_STRB <= 4'h0;
    end else if (!(_T_7)) begin
      if (_T_21) begin
        if (io_W_READY) begin
          r_W_STRB <= {{3'd0}, _T_23};
        end
      end
    end
    if (reset) begin
      r_W_VALID <= 1'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        r_W_VALID <= _GEN_19;
      end
    end else if (_T_21) begin
      if (io_W_READY) begin
        r_W_VALID <= _GEN_42;
      end
    end
    if (reset) begin
      r_B_READY <= 1'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          r_B_READY <= 1'h0;
        end
      end
    end else if (!(_T_21)) begin
      r_B_READY <= _GEN_50;
    end
    if (reset) begin
      r_AR_BURST <= 2'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          r_AR_BURST <= io_TOP_R_BURST;
        end else if (!(io_AR_READY)) begin
          r_AR_BURST <= io_TOP_R_BURST;
        end
      end
    end
    if (reset) begin
      r_AR_ADDR <= 6'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          r_AR_ADDR <= io_TOP_R_ADDRESS;
        end else if (!(io_AR_READY)) begin
          r_AR_ADDR <= io_TOP_R_ADDRESS;
        end
      end
    end
    if (reset) begin
      r_AR_LEN <= 8'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          r_AR_LEN <= io_TOP_R_LENGTH;
        end else if (!(io_AR_READY)) begin
          r_AR_LEN <= io_TOP_R_LENGTH;
        end
      end
    end
    if (reset) begin
      r_AR_SIZE <= 3'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          r_AR_SIZE <= io_TOP_R_SIZE;
        end else if (!(io_AR_READY)) begin
          r_AR_SIZE <= io_TOP_R_SIZE;
        end
      end
    end
    if (reset) begin
      r_AR_VALID <= 1'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          if (io_AR_READY) begin
            r_AR_VALID <= 1'h0;
          end else begin
            r_AR_VALID <= 1'h1;
          end
        end else if (io_AR_READY) begin
          r_AR_VALID <= 1'h0;
        end else begin
          r_AR_VALID <= 1'h1;
        end
      end
    end
    if (reset) begin
      r_R_RDATA <= 32'h0;
    end else if (!(_T_33)) begin
      if (_T_47) begin
        if (io_R_VALID) begin
          if (_T_49) begin
            r_R_RDATA <= io_R_DATA;
          end
        end else begin
          r_R_RDATA <= 32'h0;
        end
      end
    end
    if (reset) begin
      r_R_READY <= 1'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        r_R_READY <= _GEN_93;
      end
    end else if (_T_47) begin
      if (io_R_VALID) begin
        if (_T_49) begin
          if (read_response_ready) begin
            r_R_READY <= 1'h0;
          end
        end
      end
    end
    if (reset) begin
      r_transaction_cnt <= 3'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          if (io_AW_READY) begin
            r_transaction_cnt <= 3'h0;
          end else begin
            r_transaction_cnt <= _T_15;
          end
        end else if (io_AW_READY) begin
          r_transaction_cnt <= 3'h0;
        end else begin
          r_transaction_cnt <= _T_15;
        end
      end
    end
    if (reset) begin
      r_len <= 8'h0;
    end else begin
      r_len <= _GEN_64[7:0];
    end
    if (reset) begin
      rx_transaction_cnt <= 3'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          if (io_AR_READY) begin
            rx_transaction_cnt <= 3'h0;
          end else begin
            rx_transaction_cnt <= _T_41;
          end
        end else if (io_AR_READY) begin
          rx_transaction_cnt <= 3'h0;
        end else begin
          rx_transaction_cnt <= _T_41;
        end
      end
    end
    if (reset) begin
      rx_len <= 8'h0;
    end else begin
      rx_len <= _GEN_127[7:0];
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_7) begin
      if (io_TOP_WR) begin
        if (_T_9) begin
          if (io_AW_READY) begin
            state <= 2'h1;
          end
        end else if (io_AW_READY) begin
          state <= 2'h1;
        end
      end else begin
        state <= 2'h0;
      end
    end else if (_T_21) begin
      if (io_W_READY) begin
        if (_T_23) begin
          state <= 2'h1;
        end else begin
          state <= 2'h2;
        end
      end else begin
        state <= 2'h1;
      end
    end else if (_T_29) begin
      if (write_response_ready) begin
        state <= 2'h0;
      end
    end
    if (reset) begin
      rx_state <= 2'h0;
    end else if (_T_33) begin
      if (io_TOP_RD) begin
        if (_T_35) begin
          if (io_AR_READY) begin
            rx_state <= 2'h1;
          end
        end else if (io_AR_READY) begin
          rx_state <= 2'h1;
        end
      end else begin
        rx_state <= 2'h0;
      end
    end else if (_T_47) begin
      if (io_R_VALID) begin
        if (_T_49) begin
          rx_state <= {{1'd0}, _GEN_110};
        end
      end else begin
        rx_state <= 2'h1;
      end
    end
  end
endmodule
