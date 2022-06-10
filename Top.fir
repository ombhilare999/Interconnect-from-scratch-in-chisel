;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit Top : 
  module Transmitter : 
    input clock : Clock
    input reset : Reset
    output io : {flip START : UInt<1>, WR : UInt<1>, RD : UInt<1>, ADD : UInt<32>, WDATA : UInt<32>, flip RDATA : UInt<32>}
    
    reg state : UInt<2>, clock with : (reset => (reset, UInt<1>("h00"))) @[fsm_comm.scala 28:28]
    node _T = asUInt(UInt<1>("h00")) @[Conditional.scala 37:23]
    node _T_1 = asUInt(state) @[Conditional.scala 37:39]
    node _T_2 = eq(_T, _T_1) @[Conditional.scala 37:30]
    when _T_2 : @[Conditional.scala 40:58]
      node _T_3 = eq(io.START, UInt<1>("h01")) @[fsm_comm.scala 32:27]
      when _T_3 : @[fsm_comm.scala 32:36]
        state <= UInt<1>("h01") @[fsm_comm.scala 33:23]
        skip @[fsm_comm.scala 32:36]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_4 = asUInt(UInt<1>("h01")) @[Conditional.scala 37:23]
      node _T_5 = asUInt(state) @[Conditional.scala 37:39]
      node _T_6 = eq(_T_4, _T_5) @[Conditional.scala 37:30]
      when _T_6 : @[Conditional.scala 39:67]
        io.WR <= UInt<1>("h01") @[fsm_comm.scala 37:23]
        io.RD <= UInt<1>("h00") @[fsm_comm.scala 38:23]
        io.ADD <= UInt<32>("h0a") @[fsm_comm.scala 39:24]
        io.WDATA <= UInt<32>("h014") @[fsm_comm.scala 40:26]
        state <= UInt<2>("h02") @[fsm_comm.scala 41:23]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_7 = asUInt(UInt<2>("h02")) @[Conditional.scala 37:23]
        node _T_8 = asUInt(state) @[Conditional.scala 37:39]
        node _T_9 = eq(_T_7, _T_8) @[Conditional.scala 37:30]
        when _T_9 : @[Conditional.scala 39:67]
          io.ADD <= UInt<32>("h0b") @[fsm_comm.scala 44:24]
          io.WDATA <= UInt<32>("h028") @[fsm_comm.scala 45:26]
          state <= UInt<2>("h03") @[fsm_comm.scala 46:23]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_10 = asUInt(UInt<2>("h03")) @[Conditional.scala 37:23]
          node _T_11 = asUInt(state) @[Conditional.scala 37:39]
          node _T_12 = eq(_T_10, _T_11) @[Conditional.scala 37:30]
          when _T_12 : @[Conditional.scala 39:67]
            io.WR <= UInt<1>("h00") @[fsm_comm.scala 49:23]
            io.RD <= UInt<1>("h00") @[fsm_comm.scala 50:23]
            io.ADD <= UInt<32>("h00") @[fsm_comm.scala 51:24]
            io.WDATA <= UInt<32>("h00") @[fsm_comm.scala 52:26]
            state <= UInt<1>("h00") @[fsm_comm.scala 53:23]
            skip @[Conditional.scala 39:67]
    
  module Receiver : 
    input clock : Clock
    input reset : Reset
    output io : {flip WR : UInt<1>, flip RD : UInt<1>, flip ADD : UInt<32>, flip WDATA : UInt<32>, RDATA : UInt<32>, CDATA : UInt<32>}
    
    reg state : UInt<2>, clock with : (reset => (reset, UInt<1>("h00"))) @[fsm_comm.scala 74:28]
    node _T = asUInt(UInt<1>("h00")) @[Conditional.scala 37:23]
    node _T_1 = asUInt(state) @[Conditional.scala 37:39]
    node _T_2 = eq(_T, _T_1) @[Conditional.scala 37:30]
    when _T_2 : @[Conditional.scala 40:58]
      node _T_3 = eq(io.WR, UInt<1>("h01")) @[fsm_comm.scala 78:24]
      when _T_3 : @[fsm_comm.scala 78:33]
        state <= UInt<1>("h01") @[fsm_comm.scala 79:23]
        io.RDATA <= UInt<1>("h00") @[fsm_comm.scala 80:26]
        skip @[fsm_comm.scala 78:33]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_4 = asUInt(UInt<1>("h01")) @[Conditional.scala 37:23]
      node _T_5 = asUInt(state) @[Conditional.scala 37:39]
      node _T_6 = eq(_T_4, _T_5) @[Conditional.scala 37:30]
      when _T_6 : @[Conditional.scala 39:67]
        node _T_7 = eq(io.ADD, UInt<4>("h0a")) @[fsm_comm.scala 84:29]
        when _T_7 : @[fsm_comm.scala 84:39]
          io.CDATA <= io.WDATA @[fsm_comm.scala 85:26]
          state <= UInt<2>("h02") @[fsm_comm.scala 86:23]
          skip @[fsm_comm.scala 84:39]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_8 = asUInt(UInt<2>("h02")) @[Conditional.scala 37:23]
        node _T_9 = asUInt(state) @[Conditional.scala 37:39]
        node _T_10 = eq(_T_8, _T_9) @[Conditional.scala 37:30]
        when _T_10 : @[Conditional.scala 39:67]
          node _T_11 = eq(io.WR, UInt<1>("h01")) @[fsm_comm.scala 90:24]
          when _T_11 : @[fsm_comm.scala 90:33]
            node _T_12 = eq(io.ADD, UInt<4>("h0b")) @[fsm_comm.scala 91:29]
            when _T_12 : @[fsm_comm.scala 91:39]
              io.CDATA <= io.WDATA @[fsm_comm.scala 92:26]
              state <= UInt<2>("h03") @[fsm_comm.scala 93:23]
              skip @[fsm_comm.scala 91:39]
            skip @[fsm_comm.scala 90:33]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_13 = asUInt(UInt<2>("h03")) @[Conditional.scala 37:23]
          node _T_14 = asUInt(state) @[Conditional.scala 37:39]
          node _T_15 = eq(_T_13, _T_14) @[Conditional.scala 37:30]
          when _T_15 : @[Conditional.scala 39:67]
            io.CDATA <= UInt<1>("h00") @[fsm_comm.scala 98:22]
            skip @[Conditional.scala 39:67]
    
  module Top : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip start : UInt<0>, cdata_check : UInt<32>}
    
    inst Tx of Transmitter @[fsm_comm.scala 112:24]
    Tx.clock <= clock
    Tx.reset <= reset
    inst Rx of Receiver @[fsm_comm.scala 113:24]
    Rx.clock <= clock
    Rx.reset <= reset
    Rx.io.WR <= Tx.io.WR @[fsm_comm.scala 117:18]
    Rx.io.RD <= Tx.io.RD @[fsm_comm.scala 118:18]
    Rx.io.ADD <= Tx.io.ADD @[fsm_comm.scala 119:19]
    Rx.io.WDATA <= Tx.io.WDATA @[fsm_comm.scala 120:21]
    Tx.io.RDATA <= Rx.io.RDATA @[fsm_comm.scala 121:21]
    Tx.io.START <= io.start @[fsm_comm.scala 122:21]
    io.cdata_check <= Rx.io.CDATA @[fsm_comm.scala 125:24]
    
