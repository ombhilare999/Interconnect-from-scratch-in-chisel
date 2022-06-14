;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit Top : 
  module Transmitter : 
    input clock : Clock
    input reset : Reset
    output io : {flip START : UInt<1>, flip TOP_WR : UInt<1>, flip TOP_RD : UInt<1>, flip TOP_ADDRESS : UInt<4>, flip TOP_WDATA : UInt<32>, TOP_RDATA : UInt<32>, WR : UInt<1>, RD : UInt<1>, ADDRESS : UInt<4>, WDATA : UInt<32>, flip RDATA : UInt<32>}
    
    io.TOP_RDATA <= UInt<1>("h00") @[transmitter.scala 47:16]
    io.WR <= UInt<1>("h00") @[transmitter.scala 48:16]
    io.RD <= UInt<1>("h00") @[transmitter.scala 49:16]
    io.ADDRESS <= UInt<1>("h00") @[transmitter.scala 50:16]
    io.WDATA <= UInt<1>("h00") @[transmitter.scala 51:16]
    reg state : UInt<2>, clock with : (reset => (reset, UInt<1>("h00"))) @[transmitter.scala 58:22]
    node _T = asUInt(UInt<1>("h00")) @[Conditional.scala 37:23]
    node _T_1 = asUInt(state) @[Conditional.scala 37:39]
    node _T_2 = eq(_T, _T_1) @[Conditional.scala 37:30]
    when _T_2 : @[Conditional.scala 40:58]
      node _T_3 = eq(io.START, UInt<1>("h01")) @[transmitter.scala 63:21]
      when _T_3 : @[transmitter.scala 63:30]
        node _T_4 = eq(io.TOP_WR, UInt<1>("h01")) @[transmitter.scala 64:25]
        when _T_4 : @[transmitter.scala 64:33]
          io.WR <= io.TOP_WR @[transmitter.scala 66:22]
          io.RD <= io.TOP_RD @[transmitter.scala 67:22]
          io.ADDRESS <= io.TOP_ADDRESS @[transmitter.scala 68:22]
          io.WDATA <= io.TOP_WDATA @[transmitter.scala 69:22]
          skip @[transmitter.scala 64:33]
        else : @[transmitter.scala 70:40]
          node _T_5 = eq(io.TOP_RD, UInt<1>("h01")) @[transmitter.scala 70:31]
          when _T_5 : @[transmitter.scala 70:40]
            io.WR <= io.TOP_WR @[transmitter.scala 72:24]
            io.RD <= io.TOP_RD @[transmitter.scala 73:24]
            io.ADDRESS <= io.TOP_ADDRESS @[transmitter.scala 74:24]
            io.TOP_RDATA <= io.RDATA @[transmitter.scala 75:24]
            skip @[transmitter.scala 70:40]
          else : @[transmitter.scala 76:22]
            state <= UInt<1>("h00") @[transmitter.scala 77:17]
            skip @[transmitter.scala 76:22]
        skip @[transmitter.scala 63:30]
      skip @[Conditional.scala 40:58]
    
  module Receiver : 
    input clock : Clock
    input reset : Reset
    output io : {flip WR : UInt<1>, flip RD : UInt<1>, flip ADD : UInt<4>, flip WDATA : UInt<32>, RDATA : UInt<32>}
    
    io.RDATA <= UInt<1>("h00") @[receiver.scala 36:16]
    smem mem : UInt<32>[10], undefined @[receiver.scala 39:24]
    reg state : UInt<2>, clock with : (reset => (reset, UInt<1>("h00"))) @[receiver.scala 46:22]
    node _T = asUInt(UInt<1>("h00")) @[Conditional.scala 37:23]
    node _T_1 = asUInt(state) @[Conditional.scala 37:39]
    node _T_2 = eq(_T, _T_1) @[Conditional.scala 37:30]
    when _T_2 : @[Conditional.scala 40:58]
      node _T_3 = eq(io.WR, UInt<1>("h01")) @[receiver.scala 50:21]
      when _T_3 : @[receiver.scala 50:29]
        write mport _T_4 = mem[io.ADD], clock
        _T_4 <= io.WDATA
        skip @[receiver.scala 50:29]
      else : @[receiver.scala 54:36]
        node _T_5 = eq(io.RD, UInt<1>("h01")) @[receiver.scala 54:27]
        when _T_5 : @[receiver.scala 54:36]
          wire _T_6 : UInt @[receiver.scala 56:31]
          _T_6 is invalid @[receiver.scala 56:31]
          when UInt<1>("h01") : @[receiver.scala 56:31]
            _T_6 <= io.ADD @[receiver.scala 56:31]
            node _T_7 = or(_T_6, UInt<4>("h00")) @[receiver.scala 56:31]
            node _T_8 = bits(_T_7, 3, 0) @[receiver.scala 56:31]
            read mport _T_9 = mem[_T_8], clock @[receiver.scala 56:31]
            skip @[receiver.scala 56:31]
          io.RDATA <= _T_9 @[receiver.scala 56:20]
          skip @[receiver.scala 54:36]
        else : @[receiver.scala 59:22]
          state <= UInt<1>("h00") @[receiver.scala 61:17]
          skip @[receiver.scala 59:22]
      skip @[Conditional.scala 40:58]
    
  module Top : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip start : UInt<1>, flip top_wr : UInt<1>, flip top_rd : UInt<1>, flip top_address : UInt<4>, flip top_wdata : UInt<32>, top_rdata : UInt<32>}
    
    inst Tx of Transmitter @[Main.scala 23:18]
    Tx.clock <= clock
    Tx.reset <= reset
    inst Rx of Receiver @[Main.scala 24:18]
    Rx.clock <= clock
    Rx.reset <= reset
    Tx.io.TOP_WR <= io.top_wr @[Main.scala 28:21]
    Tx.io.TOP_RD <= io.top_rd @[Main.scala 29:21]
    Tx.io.TOP_ADDRESS <= io.top_address @[Main.scala 30:21]
    Tx.io.TOP_WDATA <= io.top_wdata @[Main.scala 31:21]
    io.top_rdata <= Tx.io.TOP_RDATA @[Main.scala 32:21]
    Rx.io.WR <= Tx.io.WR @[Main.scala 35:12]
    Rx.io.RD <= Tx.io.RD @[Main.scala 36:12]
    Rx.io.ADD <= Tx.io.ADDRESS @[Main.scala 37:13]
    Rx.io.WDATA <= Tx.io.WDATA @[Main.scala 38:15]
    Tx.io.RDATA <= Rx.io.RDATA @[Main.scala 39:15]
    Tx.io.START <= io.start @[Main.scala 40:15]
    
