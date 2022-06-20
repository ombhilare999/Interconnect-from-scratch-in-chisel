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
      val LENGTH    = Input(UInt(4.W))
    }
  )
  
  //Initializing the Output Variables
  //val r_rdata   = RegInit(0.U(32.W))
  //val r_rd  = RegNext(io.RD)
  //val w_mem_rdy = Wire(UInt(1.W))
  //w_mem_rdy := io.RD | r_rd

  //Memory Related Signals:
  //val mem = SyncReadMem(10, UInt(32.W))
  //val rf = Mem(10, UInt(32.W))
  val memReg = Reg(Vec(10 , UInt(32.W)))
  memReg(0x06.U) := 0x0A.U
  memReg(0x07.U) := 0x0B.U
  memReg(0x08.U) := 0x0C.U
  memReg(0x09.U) := 0x0D.U
  io.RDATA := 0.U

  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  switch(state) {
    is(State.sIdle) {
        
        when (io.WR === 1.U){        
          //mem.write(io.ADD, io.WDATA)
          //rf(io.ADD) := io.WDATA
          memReg(io.ADD) := io.WDATA
        } .elsewhen(io.RD === 1.U) { 
          //r_rdata := mem.read(io.ADD, io.RD.asBool())
          //io.RDATA := rf(io.ADD)
          io.RDATA := memReg(io.ADD)     
        } .otherwise {
          //r_rdata := 0.U
          //io.RDATA := 0.U
          state := State.sIdle          //Otherwise stay in IDLE state
        }
    }
  }

  //io.RDATA := r_rdata
}
