package top

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import top.transmitter._
import top.receiver._


class Top() extends Module {

  val io = IO(
    new Bundle {
      val top_wr      = Input(UInt(1.W))    //Input(UInt(1.W))    // Write Enable Signal
      val top_rd      = Input(UInt(1.W))    //Input(UInt(1.W))    // Read Enable Signal
      val top_address = Input(UInt(4.W))    // Address Bus
      val top_wdata   = Input(UInt(32.W))   // Write Data Bus
      val top_rdata   = Output(UInt(32.W))  // Read Data Bus
      val top_length  = Input(UInt(4.W))    // Length Input
      val top_ready   = Input(UInt(1.W))     // Receiver Ready Input
      val top_rddatavalid = Input(UInt(1.W)) // Receiver Data Valid Input
    }
  )

  val Tx = Module(new Transmitter)
  val Rx = Module(new Receiver)
  val top_rdata   = 0.U(32.W)
  
  //Connecting Signal from Top to Transmitter:
  Tx.io.TOP_WR      := io.top_wr   
  Tx.io.TOP_RD      := io.top_rd
  Tx.io.TOP_ADDRESS := io.top_address
  Tx.io.TOP_WDATA   := io.top_wdata
  io.top_rdata      := Tx.io.TOP_RDATA
  Tx.io.TOP_LENGTH  := io.top_length

  //Connecting Singal from Top to Receiver
  Rx.io.TOP_READY       := io.top_ready
  Rx.io.TOP_RDDATAVALID := io.top_rddatavalid

  // Connecting both the modules
  Rx.io.WR    := Tx.io.WR
  Rx.io.RD    := Tx.io.RD
  Rx.io.ADD   := Tx.io.ADDRESS
  Rx.io.WDATA := Tx.io.WDATA
  Tx.io.RDATA := Rx.io.RDATA
  Tx.io.RX_READY  := Rx.io.READY
  Tx.io.RX_RDDATAVALID := Rx.io.RDDATAVALID
}


object TopDriver extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new Top, args)
}
