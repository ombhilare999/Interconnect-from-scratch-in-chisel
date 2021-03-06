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
      val RX_READY       = Input(UInt(1.W))
      val RX_RDDATAVALID = Input(UInt(1.W))
    }
  )
  
  
  val r_len     = RegInit(0.U(4.W))
  val r_address = RegInit(0.U(4.W))
  val r_wdata   = RegInit(0.U(32.W))
  val r_wr      = RegInit(0.U(1.W))
  val r_rd      = RegInit(0.U(1.W))
  val r_transaction_cnt = RegInit(0.U(3.W))
  val read_wait  = RegInit(0.U(1.W))
  val read_write = Wire(UInt(1.W))

  //val w_rd_done = Wire(UInt(1.W))
  //val read_status = Wire(UInt(1.W))   
  //val read_store_status = Wire(UInt(1.W))

  //Initializing the Output Variables
  io.TOP_RDATA := 0.U
  io.WR        := 0.U
  io.RD        := 0.U 
  io.ADDRESS   := 0.U
  io.WDATA     := 0.U
  read_write   := 0.U
  read_write   := read_wait & io.RX_RDDATAVALID
  // Read Status Related signals
  //read_status  := 0.U
  //w_rd_done    := 0.U

  //read_store_status := 0.U
  //read_status  := io.TOP_RD | w_rd_done
  //read_store_status := w_rd_done & io.RX_RDDATAVALID
  

  
  // Object for state 
  object State extends ChiselEnum {
    val sIdle, sOne, sTwo = Value
  }

  val state = RegInit(State.sIdle)
  
  //Transmitter FSM 
  switch(state) {
    is(State.sIdle) {    
      when(io.TOP_WR === 1.U) {                 
            when (r_transaction_cnt === 0.U){   //Means the first step of transaction
              r_wdata      := io.TOP_WDATA    // Sending the data received from Top
              r_address    := io.TOP_ADDRESS  // Sending the address received from Top  
              r_wr         := io.TOP_WR       // Asserting write enable
              r_rd         := io.TOP_RD       // De-Asserting Read Enable        
              r_len        := io.TOP_LENGTH 
              when (io.RX_READY === 1.U){
                  r_transaction_cnt := 0.U
              } .otherwise {
                r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
              }
            } .otherwise {
                when (io.RX_READY === 1.U){
                    r_transaction_cnt := 0.U
                } .otherwise {
                    r_wdata      := r_wdata
                    r_address    := r_address
                    r_wr         := r_wr
                    r_rd         := r_rd
                    r_len        := r_len
                    r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
                }
            }
            when (io.TOP_LENGTH > 1.U) {
                state := State.sOne
                r_wr        := io.TOP_WR       // Asserting write enable
                r_rd        := io.TOP_RD       // De-Asserting Read Enable 
            } 
      } .elsewhen((io.TOP_RD === 1.U)) {      
            when (r_transaction_cnt === 0.U){   //Means the first step of transaction
              r_address    := io.TOP_ADDRESS  // Sending the address received from Top  
              r_wr         := io.TOP_WR       // Asserting write enable
              r_rd         := io.TOP_RD       // De-Asserting Read Enable        
              r_len        := io.TOP_LENGTH
              when (io.RX_READY === 1.U){
                  r_transaction_cnt := 0.U
                  read_wait  := 1.U
              } .otherwise {
                r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
              }
            } .otherwise {
                when (io.RX_READY === 1.U){
                    r_transaction_cnt := 0.U
                    read_wait  := 1.U
                } .otherwise {
                    r_address    := r_address
                    r_wr         := r_wr
                    r_rd         := r_rd
                    r_len        := r_len
                    r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
                }
            }
            when (io.TOP_LENGTH > 1.U) {
                state := State.sOne
                r_wr        := io.TOP_WR       // Asserting write enable
                r_rd        := io.TOP_RD       // De-Asserting Read Enable 
            } 
      } .otherwise {
          state := State.sIdle            //Otherwise go to IDLE state
      }

      when (read_write === 1.U){
          io.TOP_RDATA := io.RDATA
          when (io.TOP_LENGTH > 1.U) {
            read_wait    := 1.U
          }  .otherwise {
            read_wait    := 0.U
          }
        }
    }
    is(State.sOne) {
        when(( (io.RX_READY & (!io.RD)) | io.RX_RDDATAVALID) === 1.U){
          r_transaction_cnt := 0.U
          when (r_len > 1.U){ 
            r_address    := r_address + 1.U
            r_wdata      := io.TOP_WDATA
            read_wait  := 1.U
            r_len        := r_len - 1.U
            state        := State.sOne          //Remain in state two
          } .otherwise {
            state := State.sIdle            //Otherwise go to IDLE state
            read_wait  := 0.U
            r_len        := 0.U
            r_wr         := 0.U       
            r_rd         := 0.U
            r_address    := 0.U
            r_wdata      := 0.U  
        }
        } .otherwise {
          r_wdata      := r_wdata
          r_address    := r_address
          r_wr         := r_wr
          r_rd         := r_rd
          r_len        := r_len
          r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
        }

      when (read_write === 1.U){
          io.TOP_RDATA := io.RDATA
      }
    }
  }

  io.WR      := r_wr
  io.RD      := r_rd
  io.ADDRESS := r_address
  io.WDATA   := r_wdata
  
}
