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

  val r_wr = RegInit(0.U(1.W))
  val r_rd = RegInit(0.U(1.W))
  val r_add = RegInit(0.U(4.W))
  val r_wdata = RegInit(0.U(32.W))
  val r_rdata = RegInit(0.U(32.W))

  // Connecting signals from Top to register:
  r_wr := io.WR
  r_rd := io.RD
  r_add := io.ADD
  r_wdata := io.WDATA
  io.RDATA := r_rdata

  //Memory Related Signals:
  val mem = SyncReadMem(10, UInt(32.W))
  
  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  switch(state) {
    is(State.sIdle) {
        when (r_wr === 1.U){        //Go To State one for write
          state := State.sOne
        } .elsewhen(r_rd === 1.U) { //Go To state two for read
          state := State.sTwo
        } .otherwise {
          state := State.sIdle          //Otherwise stay in IDLE state
        }
    }
    is(State.sOne) { // Write Operation First Cycle
      mem.write(r_add, r_wdata)
      state := State.sIdle
    }
    is(State.sTwo) {
      r_rdata := mem.read(r_add, true.B)  
      state := State.sIdle
    }
  }
}
