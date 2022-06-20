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
      val TOP_LENGTH  = Input(UInt(4.W))    // Length Input

      //Receiver Side Signals:
      val WR        = Output(UInt(1.W))     // Write Enable Signal for receiver
      val RD        = Output(UInt(1.W))     // Read Enable Signal for receiver
      val ADDRESS   = Output(UInt(4.W))     // Address Bus for receiver
      val WDATA     = Output(UInt(32.W))    // Write data bus for receiver
      val RDATA     = Input(UInt(32.W))     // Read data bus for receiver
      val LENGTH    = Output(UInt(4.W))
    }
  )
  
  
  val r_len     = RegInit(0.U(4.W))
  val r_address = RegInit(0.U(4.W))
  val r_wdata   = RegInit(0.U(32.W))
  val r_wr      = RegInit(0.U(1.W))
  val r_rd      = RegInit(0.U(1.W))

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
            io.TOP_RDATA := io.RDATA  
            r_wdata      := io.TOP_WDATA    // Sending the data received from Top
            r_address    := io.TOP_ADDRESS  // Sending the address received from Top  
            r_wr        := io.TOP_WR       // Asserting write enable
            r_rd        := io.TOP_RD       // De-Asserting Read Enable        
            r_len        := io.TOP_LENGTH 
            when (io.TOP_LENGTH > 1.U) {
                state := State.sOne
                r_wr        := io.TOP_WR       // Asserting write enable
                r_rd        := io.TOP_RD       // De-Asserting Read Enable 
            } 
      } .otherwise {
          state := State.sIdle            //Otherwise go to IDLE state
      }
    }
    is(State.sOne) {
        when (r_len > 1.U){ 
          r_address    := r_address + 1.U
          r_wdata      := io.TOP_WDATA
          io.TOP_RDATA := io.RDATA
          r_len        := r_len - 1.U
          state        := State.sOne          //Remain in state two
        } .otherwise {
          state := State.sIdle            //Otherwise go to IDLE state
          io.TOP_RDATA := io.RDATA
          r_len        := 0.U
          r_wr         := 0.U       
          r_rd         := 0.U
          r_address    := 0.U
          r_wdata      := 0.U  
        }
    }
  }

  io.WR      := r_wr
  io.RD      := r_rd
  io.ADDRESS := r_address
  io.LENGTH  := r_len
  io.WDATA   := r_wdata
  
}
