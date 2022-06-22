module Transmitter(
  input         clock,
  input         reset,
  input         io_TOP_WR,
  input         io_TOP_RD,
  input  [3:0]  io_TOP_ADDRESS,
  input  [31:0] io_TOP_WDATA,
  output [31:0] io_TOP_RDATA,
  input  [3:0]  io_TOP_LENGTH,
  output        io_WR,
  output        io_RD,
  output [3:0]  io_ADDRESS,
  output [31:0] io_WDATA,
  input  [31:0] io_RDATA,
  input         io_RX_READY,
  input         io_RX_RDDATAVALID
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
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r_len; // @[transmitter.scala 35:26]
  reg [3:0] r_address; // @[transmitter.scala 36:26]
  reg [31:0] r_wdata; // @[transmitter.scala 37:26]
  reg  r_wr; // @[transmitter.scala 38:26]
  reg  r_rd; // @[transmitter.scala 39:26]
  reg  r_rd_done; // @[transmitter.scala 40:26]
  reg [2:0] r_transaction_cnt; // @[transmitter.scala 43:34]
  reg [1:0] state; // @[transmitter.scala 62:22]
  wire  _T_2 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  w_rd = _T_2 & io_TOP_RD; // @[Conditional.scala 40:58]
  wire  _T_3 = w_rd | r_rd_done; // @[transmitter.scala 69:28]
  wire  _T_5 = r_transaction_cnt == 3'h0; // @[transmitter.scala 73:37]
  wire [2:0] _T_7 = r_transaction_cnt + 3'h1; // @[transmitter.scala 79:54]
  wire  _T_11 = io_TOP_LENGTH > 4'h1; // @[transmitter.scala 92:33]
  wire  read_status = _T_2 & _T_3; // @[Conditional.scala 40:58]
  wire  _GEN_26 = _T_5 ? 1'h0 : io_RX_READY; // @[transmitter.scala 98:45]
  wire  _T_21 = r_rd_done & io_RX_RDDATAVALID; // @[transmitter.scala 117:38]
  wire [31:0] _GEN_27 = _T_21 ? io_RDATA : 32'h0; // @[transmitter.scala 117:69]
  wire  _GEN_28 = _T_21 ? 1'h0 : _GEN_26; // @[transmitter.scala 117:69]
  wire  _GEN_37 = read_status & _GEN_28; // @[transmitter.scala 97:42]
  wire [31:0] _GEN_38 = read_status ? _GEN_27 : 32'h0; // @[transmitter.scala 97:42]
  wire  _GEN_47 = io_TOP_WR ? 1'h0 : _GEN_37; // @[transmitter.scala 72:31]
  wire [31:0] _GEN_48 = io_TOP_WR ? 32'h0 : _GEN_38; // @[transmitter.scala 72:31]
  wire  _T_25 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_27 = r_len > 4'h1; // @[transmitter.scala 136:23]
  wire [3:0] _T_29 = r_address + 4'h1; // @[transmitter.scala 137:39]
  wire [3:0] _T_31 = r_len - 4'h1; // @[transmitter.scala 140:35]
  wire  _GEN_54 = _T_27 & r_wr; // @[transmitter.scala 136:29]
  wire  _GEN_55 = _T_27 & r_rd; // @[transmitter.scala 136:29]
  wire [31:0] _GEN_59 = io_RX_READY ? io_RDATA : 32'h0; // @[transmitter.scala 134:35]
  wire [31:0] _GEN_67 = _T_25 ? _GEN_59 : 32'h0; // @[Conditional.scala 39:67]
  wire  _GEN_81 = _T_2 & _GEN_47; // @[Conditional.scala 40:58]
  assign io_TOP_RDATA = _T_2 ? _GEN_48 : _GEN_67; // @[transmitter.scala 46:16 transmitter.scala 118:28 transmitter.scala 121:28 transmitter.scala 139:26 transmitter.scala 144:26]
  assign io_WR = r_wr; // @[transmitter.scala 47:16 transmitter.scala 162:14]
  assign io_RD = r_rd; // @[transmitter.scala 48:16 transmitter.scala 163:14]
  assign io_ADDRESS = r_address; // @[transmitter.scala 49:16 transmitter.scala 164:14]
  assign io_WDATA = r_wdata; // @[transmitter.scala 50:16 transmitter.scala 165:14]
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
  r_len = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  r_address = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  r_wdata = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  r_wr = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  r_rd = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  r_rd_done = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  r_transaction_cnt = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  state = _RAND_7[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      r_len <= 4'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_5) begin
          r_len <= io_TOP_LENGTH;
        end
      end else if (read_status) begin
        if (_T_5) begin
          r_len <= io_TOP_LENGTH;
        end
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        if (_T_27) begin
          r_len <= _T_31;
        end else begin
          r_len <= 4'h0;
        end
      end
    end
    if (reset) begin
      r_address <= 4'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_5) begin
          r_address <= io_TOP_ADDRESS;
        end
      end else if (read_status) begin
        if (_T_5) begin
          r_address <= io_TOP_ADDRESS;
        end
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        if (_T_27) begin
          r_address <= _T_29;
        end else begin
          r_address <= 4'h0;
        end
      end
    end
    if (reset) begin
      r_wdata <= 32'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_5) begin
          r_wdata <= io_TOP_WDATA;
        end
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        if (_T_27) begin
          r_wdata <= io_TOP_WDATA;
        end else begin
          r_wdata <= 32'h0;
        end
      end
    end
    if (reset) begin
      r_wr <= 1'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_11) begin
          r_wr <= io_TOP_WR;
        end else if (_T_5) begin
          r_wr <= io_TOP_WR;
        end
      end else if (read_status) begin
        if (_T_11) begin
          r_wr <= io_TOP_WR;
        end else if (_T_5) begin
          r_wr <= io_TOP_WR;
        end
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        r_wr <= _GEN_54;
      end
    end
    if (reset) begin
      r_rd <= 1'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_11) begin
          r_rd <= io_TOP_RD;
        end else if (_T_5) begin
          r_rd <= io_TOP_RD;
        end
      end else if (read_status) begin
        if (_T_11) begin
          r_rd <= io_TOP_RD;
        end else if (_T_5) begin
          r_rd <= io_TOP_RD;
        end
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        r_rd <= _GEN_55;
      end
    end
    if (reset) begin
      r_rd_done <= 1'h0;
    end else begin
      r_rd_done <= _GEN_81;
    end
    if (reset) begin
      r_transaction_cnt <= 3'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_5) begin
          r_transaction_cnt <= _T_7;
        end else if (io_RX_READY) begin
          r_transaction_cnt <= 3'h0;
        end else begin
          r_transaction_cnt <= _T_7;
        end
      end else if (read_status) begin
        if (_T_5) begin
          r_transaction_cnt <= _T_7;
        end else if (io_RX_READY) begin
          r_transaction_cnt <= 3'h0;
        end else begin
          r_transaction_cnt <= _T_7;
        end
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        r_transaction_cnt <= 3'h0;
      end else begin
        r_transaction_cnt <= _T_7;
      end
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_2) begin
      if (io_TOP_WR) begin
        if (_T_11) begin
          state <= 2'h1;
        end
      end else if (read_status) begin
        if (_T_11) begin
          state <= 2'h1;
        end
      end else begin
        state <= 2'h0;
      end
    end else if (_T_25) begin
      if (io_RX_READY) begin
        state <= {{1'd0}, _T_27};
      end
    end
  end
endmodule
module Receiver(
  input         clock,
  input         io_WR,
  input         io_RD,
  input  [3:0]  io_ADD,
  input  [31:0] io_WDATA,
  output [31:0] io_RDATA,
  input         io_TOP_READY,
  input         io_TOP_RDDATAVALID,
  output        io_READY,
  output        io_RDDATAVALID
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [31:0] rf [0:9]; // @[receiver.scala 39:15]
  wire [31:0] rf__T_8_data; // @[receiver.scala 39:15]
  wire [3:0] rf__T_8_addr; // @[receiver.scala 39:15]
  wire [31:0] rf__T_data; // @[receiver.scala 39:15]
  wire [3:0] rf__T_addr; // @[receiver.scala 39:15]
  wire  rf__T_mask; // @[receiver.scala 39:15]
  wire  rf__T_en; // @[receiver.scala 39:15]
  wire [31:0] rf__T_6_data; // @[receiver.scala 39:15]
  wire [3:0] rf__T_6_addr; // @[receiver.scala 39:15]
  wire  rf__T_6_mask; // @[receiver.scala 39:15]
  wire  rf__T_6_en; // @[receiver.scala 39:15]
  wire  r_wr = io_READY & io_WR; // @[receiver.scala 53:31]
  wire [31:0] _GEN_3 = io_RD ? rf__T_8_data : 32'h0; // @[receiver.scala 62:40]
  wire  _GEN_12 = r_wr ? 1'h0 : io_RD; // @[receiver.scala 60:32]
  wire [31:0] _GEN_13 = r_wr ? 32'h0 : _GEN_3; // @[receiver.scala 60:32]
  assign rf__T_8_addr = io_READY ? io_ADD : 4'h0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign rf__T_8_data = rf[rf__T_8_addr]; // @[receiver.scala 39:15]
  `else
  assign rf__T_8_data = rf__T_8_addr >= 4'ha ? _RAND_1[31:0] : rf[rf__T_8_addr]; // @[receiver.scala 39:15]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign rf__T_data = 32'h2;
  assign rf__T_addr = 4'h1;
  assign rf__T_mask = 1'h1;
  assign rf__T_en = 1'h1;
  assign rf__T_6_data = io_READY ? io_WDATA : 32'h0;
  assign rf__T_6_addr = io_READY ? io_ADD : 4'h0;
  assign rf__T_6_mask = 1'h1;
  assign rf__T_6_en = io_READY & r_wr;
  assign io_RDATA = io_READY ? _GEN_13 : 32'h0; // @[receiver.scala 43:12 receiver.scala 64:24 receiver.scala 66:24]
  assign io_READY = io_TOP_READY; // @[receiver.scala 35:18]
  assign io_RDDATAVALID = io_TOP_RDDATAVALID; // @[receiver.scala 36:18]
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
    rf[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(rf__T_en & rf__T_mask) begin
      rf[rf__T_addr] <= rf__T_data; // @[receiver.scala 39:15]
    end
    if(rf__T_6_en & rf__T_6_mask) begin
      rf[rf__T_6_addr] <= rf__T_6_data; // @[receiver.scala 39:15]
    end
  end
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_top_wr,
  input         io_top_rd,
  input  [3:0]  io_top_address,
  input  [31:0] io_top_wdata,
  output [31:0] io_top_rdata,
  input  [3:0]  io_top_length,
  input         io_top_ready,
  input         io_top_rddatavalid
);
  wire  Tx_clock; // @[Main.scala 25:18]
  wire  Tx_reset; // @[Main.scala 25:18]
  wire  Tx_io_TOP_WR; // @[Main.scala 25:18]
  wire  Tx_io_TOP_RD; // @[Main.scala 25:18]
  wire [3:0] Tx_io_TOP_ADDRESS; // @[Main.scala 25:18]
  wire [31:0] Tx_io_TOP_WDATA; // @[Main.scala 25:18]
  wire [31:0] Tx_io_TOP_RDATA; // @[Main.scala 25:18]
  wire [3:0] Tx_io_TOP_LENGTH; // @[Main.scala 25:18]
  wire  Tx_io_WR; // @[Main.scala 25:18]
  wire  Tx_io_RD; // @[Main.scala 25:18]
  wire [3:0] Tx_io_ADDRESS; // @[Main.scala 25:18]
  wire [31:0] Tx_io_WDATA; // @[Main.scala 25:18]
  wire [31:0] Tx_io_RDATA; // @[Main.scala 25:18]
  wire  Tx_io_RX_READY; // @[Main.scala 25:18]
  wire  Tx_io_RX_RDDATAVALID; // @[Main.scala 25:18]
  wire  Rx_clock; // @[Main.scala 26:18]
  wire  Rx_io_WR; // @[Main.scala 26:18]
  wire  Rx_io_RD; // @[Main.scala 26:18]
  wire [3:0] Rx_io_ADD; // @[Main.scala 26:18]
  wire [31:0] Rx_io_WDATA; // @[Main.scala 26:18]
  wire [31:0] Rx_io_RDATA; // @[Main.scala 26:18]
  wire  Rx_io_TOP_READY; // @[Main.scala 26:18]
  wire  Rx_io_TOP_RDDATAVALID; // @[Main.scala 26:18]
  wire  Rx_io_READY; // @[Main.scala 26:18]
  wire  Rx_io_RDDATAVALID; // @[Main.scala 26:18]
  Transmitter Tx ( // @[Main.scala 25:18]
    .clock(Tx_clock),
    .reset(Tx_reset),
    .io_TOP_WR(Tx_io_TOP_WR),
    .io_TOP_RD(Tx_io_TOP_RD),
    .io_TOP_ADDRESS(Tx_io_TOP_ADDRESS),
    .io_TOP_WDATA(Tx_io_TOP_WDATA),
    .io_TOP_RDATA(Tx_io_TOP_RDATA),
    .io_TOP_LENGTH(Tx_io_TOP_LENGTH),
    .io_WR(Tx_io_WR),
    .io_RD(Tx_io_RD),
    .io_ADDRESS(Tx_io_ADDRESS),
    .io_WDATA(Tx_io_WDATA),
    .io_RDATA(Tx_io_RDATA),
    .io_RX_READY(Tx_io_RX_READY),
    .io_RX_RDDATAVALID(Tx_io_RX_RDDATAVALID)
  );
  Receiver Rx ( // @[Main.scala 26:18]
    .clock(Rx_clock),
    .io_WR(Rx_io_WR),
    .io_RD(Rx_io_RD),
    .io_ADD(Rx_io_ADD),
    .io_WDATA(Rx_io_WDATA),
    .io_RDATA(Rx_io_RDATA),
    .io_TOP_READY(Rx_io_TOP_READY),
    .io_TOP_RDDATAVALID(Rx_io_TOP_RDDATAVALID),
    .io_READY(Rx_io_READY),
    .io_RDDATAVALID(Rx_io_RDDATAVALID)
  );
  assign io_top_rdata = Tx_io_TOP_RDATA; // @[Main.scala 34:21]
  assign Tx_clock = clock;
  assign Tx_reset = reset;
  assign Tx_io_TOP_WR = io_top_wr; // @[Main.scala 30:21]
  assign Tx_io_TOP_RD = io_top_rd; // @[Main.scala 31:21]
  assign Tx_io_TOP_ADDRESS = io_top_address; // @[Main.scala 32:21]
  assign Tx_io_TOP_WDATA = io_top_wdata; // @[Main.scala 33:21]
  assign Tx_io_TOP_LENGTH = io_top_length; // @[Main.scala 35:21]
  assign Tx_io_RDATA = Rx_io_RDATA; // @[Main.scala 46:15]
  assign Tx_io_RX_READY = Rx_io_READY; // @[Main.scala 47:19]
  assign Tx_io_RX_RDDATAVALID = Rx_io_RDDATAVALID; // @[Main.scala 48:24]
  assign Rx_clock = clock;
  assign Rx_io_WR = Tx_io_WR; // @[Main.scala 42:15]
  assign Rx_io_RD = Tx_io_RD; // @[Main.scala 43:15]
  assign Rx_io_ADD = Tx_io_ADDRESS; // @[Main.scala 44:15]
  assign Rx_io_WDATA = Tx_io_WDATA; // @[Main.scala 45:15]
  assign Rx_io_TOP_READY = io_top_ready; // @[Main.scala 38:25]
  assign Rx_io_TOP_RDDATAVALID = io_top_rddatavalid; // @[Main.scala 39:25]
endmodule
