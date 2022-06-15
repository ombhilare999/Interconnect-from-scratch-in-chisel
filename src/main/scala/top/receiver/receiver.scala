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
  
  //Initializing the Output Variables
  io.RDATA     := 0.U

  //Memory Related Signals:
  val mem = SyncReadMem(10, UInt(32.W))

  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  switch(state) {
    is(State.sIdle) {
        when (io.WR === 1.U){        
          mem.write(io.ADD, io.WDATA)
        } .elsewhen(io.RD === 1.U) { 
          io.RDATA := mem.read(io.ADD, true.B) 
        } .otherwise {
          state := State.sIdle          //Otherwise stay in IDLE state
        }
    }
  }
}
