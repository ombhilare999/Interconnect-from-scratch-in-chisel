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
      val TOP_WR      = Input(UInt(1.W))   // Write Enable Signal
      val TOP_RD      = Input(UInt(1.W))   // Read Enable Signal
      val TOP_ADDRESS = Input(UInt(4.W))  // Address Bus
      val TOP_WDATA   = Input(UInt(32.W))  // Write Data Bus
      val TOP_RDATA   = Output(UInt(32.W))  // Read Data Bus

      //Receiver Side Signals:
      val WR        = Output(UInt(1.W))   // Write Enable Signal for receiver
      val RD        = Output(UInt(1.W))   // Read Enable Signal for receiver
      val ADDRESS   = Output(UInt(4.W))  // Address Bus for receiver
      val WDATA     = Output(UInt(32.W))  // Write data bus for receiver
      val RDATA     = Input(UInt(32.W))   // Read data bus for receiver
    }
  )
  
  //Initializing the signals Signals from Top:
  val r_start       = RegInit(0.U(1.W))   // Start signal to trigger the communication
  val r_top_wr      = RegInit(0.U(1.W))   // Write Enable Signal
  val r_top_rd      = RegInit(0.U(1.W))   // Read Enable Signal
  val r_top_address = RegInit(0.U(4.W))  // Address Bus
  val r_top_wdata   = RegInit(0.U(32.W))  // Write Data Bus
  val r_top_rdata   = RegInit(0.U(32.W))  // Read Data Bus

  // Connecting the IO signals from the TOP to reg buffers
  r_start       := io.START
  r_top_wr      := io.TOP_WR
  r_top_rd      := io.TOP_RD
  io.TOP_RDATA  := 0.U

  // Object for state 
  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)

  //Transmitter FSM
  switch(state) {
    is(State.sIdle) {
      when(r_start === 1.U) {
        when (r_top_wr === 1.U){        //Go To State one for write
          state := State.sOne
        } .elsewhen(r_top_rd === 1.U) { //Go To state two for read
          state := State.sTwo
        } .otherwise {
          state := State.sIdle          //Otherwise stay in IDLE state
        }
      }
    }
    is(State.sOne) { 
      r_top_wr      := io.TOP_WR       // Asserting write enable
      r_top_rd      := io.TOP_RD       // De-Asserting Read Enable 
      r_top_address := io.TOP_ADDRESS  // Sending the address received from Top
      r_top_wdata   := io.TOP_WDATA    // Sending the data received from Top
      state         := State.sIdle
    }
    is(State.sTwo) {
      r_top_wr      := io.TOP_WR       // Asserting write enable
      r_top_rd      := io.TOP_RD       // De-Asserting Read Enable 
      r_top_address := io.TOP_ADDRESS  // Sending the address received from Top
      io.TOP_RDATA  := r_top_rdata 
      state         := State.sIdle
    }
  }

  //Updating the signals which will go towards the receiver
  io.WR       := r_top_wr
  io.RD       := r_top_rd
  io.ADDRESS  := r_top_address
  io.WDATA    := r_top_wdata
  r_top_rdata := io.RDATA 
  
}
