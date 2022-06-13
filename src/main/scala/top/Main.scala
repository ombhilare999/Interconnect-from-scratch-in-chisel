package top

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import top.transmitter._
import top.receiver._


class Top() extends Module {

  val io = IO(
    new Bundle {
      val start = Input(UInt(1.W)) // Triggers the communication
      val cdata_check = Output(UInt(32.W))
    }
  )

  val Tx = Module(new Transmitter)
  val Rx = Module(new Receiver)
  val cdata_check = UInt(32.W)

  // Connecting both the modules
  Rx.io.WR := Tx.io.WR
  Rx.io.RD := Tx.io.RD
  Rx.io.ADD := Tx.io.ADD
  Rx.io.WDATA := Tx.io.WDATA
  Tx.io.RDATA := Rx.io.RDATA
  Tx.io.START := io.start

  // To check the modules
  io.cdata_check := Rx.io.CDATA
}

object TopDriver extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new Top, args)
}
