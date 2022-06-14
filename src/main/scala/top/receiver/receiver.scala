package top.receiver

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


class Receiver extends Module() {
  val io = IO(
    new Bundle {
      val WR = Input(UInt(1.W))
      val RD = Input(UInt(1.W))
      val ADD = Input(UInt(4.W))
      val WDATA = Input(UInt(32.W))
      val RDATA = Output(UInt(32.W))
    }
  )
  
  //val ready = RegInit(0.U(1.W))
  //val r_wr = RegInit(0.U(1.W))
  //val r_rd = RegNext(io.RD)
  //val r_add = RegInit(0.U(4.W))
  //val r_wdata = RegInit(0.U(32.W))
  //val r_rdata = RegInit(0.U(32.W))
  //val r_tempdata = RegInit(0.U(32.W))

  // Connecting signals from Top to register:
  //r_wr := io.WR
  
  //r_add := io.ADD
  //r_wdata := io.WDATA
  //io.TEMPDATA := r_tempdata
  //io.RDATA := r_rdata

  //Initializing the Output Variables
  io.RDATA     := 0.U

  //Memory Related Signals:
  val mem = SyncReadMem(10, UInt(32.W))
  //val rf = Mem(10, UInt(32.W))

  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  switch(state) {
    is(State.sIdle) {
        when (io.WR === 1.U){        //Go To State one for write
          //state := State.sOne
          mem.write(io.ADD, io.WDATA)
          //rf(io.ADD) := io.WDATA
        } .elsewhen(io.RD === 1.U) { //Go To state two for read
          //state := State.sTwo
          io.RDATA := mem.read(io.ADD, true.B) 
          //ready := 1.U
          //io.RDATA := rf(io.ADD)
        } .otherwise {
          //ready := 0.U
          state := State.sIdle          //Otherwise stay in IDLE state
        }
    }
    //is(State.sOne) { // Write Operation First Cycle
    //}
    //is(State.sTwo) {
    //}
  }
}
