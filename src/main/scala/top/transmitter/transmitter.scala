package top.transmitter

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

/*
Transmitter  <------->   Receiver
    FSM                    FSM
 */

class Transmitter extends Module() {
  val io = IO(
    new Bundle {
      // Signals from Top:
      val START       = Input(UInt(1.W))    // Triggers the communication
      val TOP_WR      = Input(UInt(1.W))    // Write Enable Signal
      val TOP_RD      = Input(UInt(1.W))    // Read Enable Signal
      val TOP_ADDRESS = Input(UInt(4.W))    // Address Bus
      val TOP_WDATA   = Input(UInt(32.W))   // Write Data Bus
      val TOP_RDATA   = Output(UInt(32.W))  // Read Data Bus

      //Receiver Side Signals:
      val WR        = Output(UInt(1.W))     // Write Enable Signal for receiver
      val RD        = Output(UInt(1.W))     // Read Enable Signal for receiver
      val ADDRESS   = Output(UInt(4.W))     // Address Bus for receiver
      val WDATA     = Output(UInt(32.W))    // Write data bus for receiver
      val RDATA     = Input(UInt(32.W))     // Read data bus for receiver
    }
  )
  
  //Initializing the Output Variables
  io.TOP_RDATA := 0.U
  io.WR        := 0.U
  io.RD        := 0.U 
  io.ADDRESS   := 0.U
  io.WDATA     := 0.U

  // Object for state 
  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  //Transmitter FSM
  switch(state) {
    is(State.sIdle) {
      when(io.START === 1.U) {
        when (io.TOP_WR === 1.U){        
          io.WR      := io.TOP_WR       // Asserting write enable
          io.RD      := io.TOP_RD       // De-Asserting Read Enable 
          io.ADDRESS := io.TOP_ADDRESS  // Sending the address received from Top
          io.WDATA   := io.TOP_WDATA    // Sending the data received from Top
        } .elsewhen(io.TOP_RD === 1.U) { 
          //state := State.sTwo
          io.WR        := io.TOP_WR       // De-Asserting write enable
          io.RD        := io.TOP_RD       // Asserting Read Enable 
          io.ADDRESS   := io.TOP_ADDRESS  // Sending the address received from Top
          io.TOP_RDATA := io.RDATA          
        } .otherwise {
          state := State.sIdle            //Otherwise stay in IDLE state
        }
      }
    }
    //is(State.sOne) { 
    //}
    //is(State.sTwo) {
    //}
  }
}
