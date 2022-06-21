package top.receiver

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


class Receiver extends Module() {
  val io = IO(
    new Bundle {
      val WR        = Input(UInt(1.W))
      val RD        = Input(UInt(1.W))
      val ADD       = Input(UInt(4.W))
      val WDATA     = Input(UInt(32.W))
      val RDATA     = Output(UInt(32.W))
      val TOP_READY = Input(UInt(1.W)) 
      val READY     = Output(UInt(1.W))
    }
  )
  
  //Registered Input:
  val r_address = Wire(UInt(4.W)) //RegInit(0.U(4.W))
  val r_wdata   = Wire(UInt(32.W)) //RegInit(0.U(32.W))
  val r_wr      = Wire(UInt(1.W)) //RegInit(0.U(1.W))
  val r_rd      = Wire(UInt(1.W)) //RegInit(0.U(1.W))

  r_wr       :=  0.U
  r_rd       :=  0.U
  r_address  :=  0.U
  r_wdata    :=  0.U

  //Updating Ready from Top
  io.READY := io.TOP_READY
  
  //Memory Related Signals
  val rf = Mem(10, UInt(32.W))

  //Initializing the output signals
  io.RDATA := 0.U
  
  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  switch(state) {
    is(State.sIdle) {
        when(io.READY === 1.U){
            //Updating registers based on Input
            r_wr       :=  io.WR
            r_rd       :=  io.RD
            r_address  :=  io.ADD
            r_wdata    :=  io.WDATA

            when (r_wr === 1.U){        
              rf(r_address) := r_wdata
            } .elsewhen(io.RD === 1.U) { 
              //r_rdata := mem.read(io.ADD, io.RD.asBool())
              io.RDATA := rf(r_address)
            } .otherwise {
              io.RDATA := 0.U
              state := State.sIdle          //Otherwise stay in IDLE state
            }
        } .otherwise {
            r_wr       :=  0.U
            r_rd       :=  0.U
            r_address  :=  0.U
            r_wdata    :=  0.U
        }
    }
  }
}
