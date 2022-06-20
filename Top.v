module Transmitter(
  input         clock,
  input         reset,
  input         io_START,
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
  input  [31:0] io_RDATA
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r_len; // @[transmitter.scala 35:26]
  reg [3:0] r_address; // @[transmitter.scala 36:26]
  reg [31:0] r_wdata; // @[transmitter.scala 37:26]
  reg  r_wr; // @[transmitter.scala 38:26]
  reg  r_rd; // @[transmitter.scala 39:26]
  reg [1:0] state; // @[transmitter.scala 54:22]
  wire  _T_2 = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_4 = io_TOP_LENGTH > 4'h1; // @[transmitter.scala 66:31]
  wire [31:0] _GEN_3 = io_START ? io_RDATA : 32'h0; // @[transmitter.scala 59:30]
  wire  _T_7 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_8 = r_len > 4'h1; // @[transmitter.scala 76:21]
  wire [3:0] _T_10 = r_address + 4'h1; // @[transmitter.scala 77:37]
  wire [3:0] _T_12 = r_len - 4'h1; // @[transmitter.scala 80:33]
  wire [31:0] _GEN_12 = _T_8 ? io_RDATA : 32'h0; // @[transmitter.scala 76:27]
  wire  _GEN_15 = _T_8 & r_wr; // @[transmitter.scala 76:27]
  wire  _GEN_16 = _T_8 & r_rd; // @[transmitter.scala 76:27]
  wire [31:0] _GEN_19 = _T_7 ? _GEN_12 : 32'h0; // @[Conditional.scala 39:67]
  assign io_TOP_RDATA = _T_2 ? _GEN_3 : _GEN_19; // @[transmitter.scala 42:16 transmitter.scala 60:24 transmitter.scala 79:24]
  assign io_WR = r_wr; // @[transmitter.scala 43:16 transmitter.scala 93:14]
  assign io_RD = r_rd; // @[transmitter.scala 44:16 transmitter.scala 94:14]
  assign io_ADDRESS = r_address; // @[transmitter.scala 45:16 transmitter.scala 95:14]
  assign io_WDATA = r_wdata; // @[transmitter.scala 46:16 transmitter.scala 97:14]
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
  state = _RAND_5[1:0];
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
      if (io_START) begin
        r_len <= io_TOP_LENGTH;
      end
    end else if (_T_7) begin
      if (_T_8) begin
        r_len <= _T_12;
      end else begin
        r_len <= 4'h0;
      end
    end
    if (reset) begin
      r_address <= 4'h0;
    end else if (_T_2) begin
      if (io_START) begin
        r_address <= io_TOP_ADDRESS;
      end
    end else if (_T_7) begin
      if (_T_8) begin
        r_address <= _T_10;
      end else begin
        r_address <= 4'h0;
      end
    end
    if (reset) begin
      r_wdata <= 32'h0;
    end else if (_T_2) begin
      if (io_START) begin
        r_wdata <= io_TOP_WDATA;
      end
    end else if (_T_7) begin
      if (_T_8) begin
        r_wdata <= io_TOP_WDATA;
      end else begin
        r_wdata <= 32'h0;
      end
    end
    if (reset) begin
      r_wr <= 1'h0;
    end else if (_T_2) begin
      if (io_START) begin
        r_wr <= io_TOP_WR;
      end
    end else if (_T_7) begin
      r_wr <= _GEN_15;
    end
    if (reset) begin
      r_rd <= 1'h0;
    end else if (_T_2) begin
      if (io_START) begin
        r_rd <= io_TOP_RD;
      end
    end else if (_T_7) begin
      r_rd <= _GEN_16;
    end
    if (reset) begin
      state <= 2'h0;
    end else if (_T_2) begin
      if (io_START) begin
        if (_T_4) begin
          state <= 2'h1;
        end
      end else begin
        state <= 2'h0;
      end
    end else if (_T_7) begin
      state <= {{1'd0}, _T_8};
    end
  end
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
`endif // RANDOMIZE_REG_INIT
  reg [31:0] rf [0:9]; // @[receiver.scala 28:15]
  wire [31:0] rf__T_7_data; // @[receiver.scala 28:15]
  wire [3:0] rf__T_7_addr; // @[receiver.scala 28:15]
  wire [31:0] rf__T_5_data; // @[receiver.scala 28:15]
  wire [3:0] rf__T_5_addr; // @[receiver.scala 28:15]
  wire  rf__T_5_mask; // @[receiver.scala 28:15]
  wire  rf__T_5_en; // @[receiver.scala 28:15]
  reg  r_rd; // @[receiver.scala 22:22]
  wire  w_mem_rdy = io_RD | r_rd; // @[receiver.scala 24:22]
  wire [31:0] _GEN_3 = w_mem_rdy ? rf__T_7_data : 32'h0; // @[receiver.scala 43:40]
  assign rf__T_7_addr = io_ADD;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign rf__T_7_data = rf[rf__T_7_addr]; // @[receiver.scala 28:15]
  `else
  assign rf__T_7_data = rf__T_7_addr >= 4'ha ? _RAND_1[31:0] : rf[rf__T_7_addr]; // @[receiver.scala 28:15]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign rf__T_5_data = io_WDATA;
  assign rf__T_5_addr = io_ADD;
  assign rf__T_5_mask = 1'h1;
  assign rf__T_5_en = io_WR;
  assign io_RDATA = io_WR ? 32'h0 : _GEN_3; // @[receiver.scala 29:12 receiver.scala 45:20 receiver.scala 48:20]
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
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  r_rd = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(rf__T_5_en & rf__T_5_mask) begin
      rf[rf__T_5_addr] <= rf__T_5_data; // @[receiver.scala 28:15]
    end
    r_rd <= io_RD;
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
  output [31:0] io_top_rdata,
  input  [3:0]  io_top_length
);
  wire  Tx_clock; // @[Main.scala 24:18]
  wire  Tx_reset; // @[Main.scala 24:18]
  wire  Tx_io_START; // @[Main.scala 24:18]
  wire  Tx_io_TOP_WR; // @[Main.scala 24:18]
  wire  Tx_io_TOP_RD; // @[Main.scala 24:18]
  wire [3:0] Tx_io_TOP_ADDRESS; // @[Main.scala 24:18]
  wire [31:0] Tx_io_TOP_WDATA; // @[Main.scala 24:18]
  wire [31:0] Tx_io_TOP_RDATA; // @[Main.scala 24:18]
  wire [3:0] Tx_io_TOP_LENGTH; // @[Main.scala 24:18]
  wire  Tx_io_WR; // @[Main.scala 24:18]
  wire  Tx_io_RD; // @[Main.scala 24:18]
  wire [3:0] Tx_io_ADDRESS; // @[Main.scala 24:18]
  wire [31:0] Tx_io_WDATA; // @[Main.scala 24:18]
  wire [31:0] Tx_io_RDATA; // @[Main.scala 24:18]
  wire  Rx_clock; // @[Main.scala 25:18]
  wire  Rx_io_WR; // @[Main.scala 25:18]
  wire  Rx_io_RD; // @[Main.scala 25:18]
  wire [3:0] Rx_io_ADD; // @[Main.scala 25:18]
  wire [31:0] Rx_io_WDATA; // @[Main.scala 25:18]
  wire [31:0] Rx_io_RDATA; // @[Main.scala 25:18]
  Transmitter Tx ( // @[Main.scala 24:18]
    .clock(Tx_clock),
    .reset(Tx_reset),
    .io_START(Tx_io_START),
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
    .io_RDATA(Tx_io_RDATA)
  );
  Receiver Rx ( // @[Main.scala 25:18]
    .clock(Rx_clock),
    .io_WR(Rx_io_WR),
    .io_RD(Rx_io_RD),
    .io_ADD(Rx_io_ADD),
    .io_WDATA(Rx_io_WDATA),
    .io_RDATA(Rx_io_RDATA)
  );
  assign io_top_rdata = Tx_io_TOP_RDATA; // @[Main.scala 33:21]
  assign Tx_clock = clock;
  assign Tx_reset = reset;
  assign Tx_io_START = io_start; // @[Main.scala 42:15]
  assign Tx_io_TOP_WR = io_top_wr; // @[Main.scala 29:21]
  assign Tx_io_TOP_RD = io_top_rd; // @[Main.scala 30:21]
  assign Tx_io_TOP_ADDRESS = io_top_address; // @[Main.scala 31:21]
  assign Tx_io_TOP_WDATA = io_top_wdata; // @[Main.scala 32:21]
  assign Tx_io_TOP_LENGTH = io_top_length; // @[Main.scala 34:21]
  assign Tx_io_RDATA = Rx_io_RDATA; // @[Main.scala 41:15]
  assign Rx_clock = clock;
  assign Rx_io_WR = Tx_io_WR; // @[Main.scala 37:12]
  assign Rx_io_RD = Tx_io_RD; // @[Main.scala 38:12]
  assign Rx_io_ADD = Tx_io_ADDRESS; // @[Main.scala 39:13]
  assign Rx_io_WDATA = Tx_io_WDATA; // @[Main.scala 40:15]
endmodule
