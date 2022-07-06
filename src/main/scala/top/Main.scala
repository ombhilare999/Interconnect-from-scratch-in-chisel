package top

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

class Top extends Module() {
    
    val io = IO(
        new Bundle {
            // Signals from Top:
            val TOP_WR      = Input(UInt(1.W))    // Write Enable Signal
            val TOP_RD      = Input(UInt(1.W))    // Read Enable Signal
            val TOP_ADDRESS = Input(UInt(6.W))    // Address Bus
            val TOP_WDATA   = Input(UInt(32.W))   // Write Data Bus
            val TOP_LENGTH  = Input(UInt(8.W))    // Length Input
            val TOP_BURST   = Input(UInt(2.W))    // Burst Type
            val TOP_SIZE    = Input(UInt(3.W))    // Number of bytes in one burst

            // Signals from Top for Rx:
            val TOP_RDATA     = Output(UInt(32.W))  // Read Data Bus
            val TOP_R_ADDRESS = Input(UInt(6.W))    // Address Bus 
            val TOP_R_LENGTH  = Input(UInt(8.W))    // Length Input
            val TOP_R_BURST   = Input(UInt(2.W))    // Burst Type
            val TOP_R_SIZE    = Input(UInt(3.W))    // Number of bytes in one burst

            //AXI Write Address Channel
            val AW_BURST = Output(UInt(2.W))   //Burst Type:  2 Bit Burst Bus
            val AW_ADDR  = Output(UInt(6.W))   //Address Bus: 6 Bit Address Bus 
            val AW_LEN   = Output(UInt(8.W))   //Burst Lenght:8 Bit Length Bus 
            val AW_SIZE  = Output(UInt(3.W))   //Burst Size:  3 Bit Size Bus 
            val AW_ID    = Output(UInt(1.W))   //Write Address ID
            val AW_READY = Input(UInt(1.W))    //Write Address Ready
            val AW_VALID = Output(UInt(1.W))   //Write Address Valid
            val AW_PROT  = Output(UInt(3.W))   //Protection Type

            //AXI Write Data Channel
            val W_DATA  = Output(UInt(32.W))   //Write Data
            val W_LAST  = Output(UInt(1.W))    //Write Last.
            val W_STRB  = Output(UInt(4.W))    //Write Strobes.
            val W_READY = Input(UInt(1.W))     //Write Data Ready
            val W_VALID = Output(UInt(1.W))    //Write Data Valid            
            
            //AXI Write Response Channel
            val B_ID    = Input(UInt(1.W))     //Response ID Tag
            val B_RESP  = Input(UInt(2.W))     //Write Response
            val B_READY = Output(UInt(1.W))    //Response Ready
            val B_VALID = Input(UInt(1.W))     //Write Response Valid
            
            //AXI Read Address Channel
            val AR_BURST = Output(UInt(2.W))   //Burst Type:  2 Bit Burst Bus
            val AR_ADDR  = Output(UInt(6.W))   //Address Bus: 6 Bit Address Bus 
            val AR_LEN   = Output(UInt(8.W))   //Burst Lenght:8 Bit Length Bus 
            val AR_SIZE  = Output(UInt(3.W))   //Burst Size:  3 Bit Size Bus 
            val AR_ID    = Output(UInt(1.W))   //Read Address ID
            val AR_READY = Input(UInt(1.W))    //Read Address Ready
            val AR_VALID = Output(UInt(1.W))   //Read Address Valid
            val AR_PROT  = Output(UInt(3.W))   //Protection Type
            
            //AXI Read Data/Response Channel
            val R_DATA  = Input(UInt(32.W))   //Read Data
            val R_LAST  = Input(UInt(1.W))    //Read Last.
            val R_ID    = Input(UInt(1.W))    //Read Data ID
            val R_RESP  = Input(UInt(2.W))    //Read Response
            val R_READY = Output(UInt(1.W))   //Read Data Ready
            val R_VALID = Input(UInt(1.W))    //Read Data Valid                 
        }
    )
        // Registered Signals
        
        //Write Address Signals:
        val r_AW_BURST = RegInit(0.U(2.W))
        val r_AW_ADDR  = RegInit(0.U(6.W))
        val r_AW_LEN   = RegInit(0.U(8.W))
        val r_AW_SIZE  = RegInit(0.U(3.W))
        val r_AW_ID    = RegInit(0.U(1.W))
        val r_AW_VALID = RegInit(0.U(1.W))
        val r_AW_PROT  = RegInit(0.U(3.W))

        //Write Data Signals:
        val r_W_DATA   = RegInit(0.U(32.W))
        val r_W_LAST   = RegInit(0.U(1.W))
        val r_W_STRB   = RegInit(0.U(4.W))
        val r_W_VALID  = RegInit(0.U(1.W))

        //Write Response:
        val r_B_READY  = RegInit(0.U(1.W))

        //Read Address signals:
        val r_AR_BURST = RegInit(0.U(2.W))
        val r_AR_ADDR  = RegInit(0.U(6.W))
        val r_AR_LEN   = RegInit(0.U(8.W))
        val r_AR_SIZE  = RegInit(0.U(3.W))
        val r_AR_ID    = RegInit(0.U(1.W))
        val r_AR_READY = RegInit(0.U(1.W))
        val r_AR_VALID = RegInit(0.U(1.W))
        val r_AR_PROT  = RegInit(0.U(3.W))
        
        //Read Data/Response Channel
        val r_R_RDATA   = RegInit(0.U(32.W))
        val r_R_READY  = RegInit(0.U(1.W))

        //Extra Variables write:
        val r_transaction_cnt     = RegInit(0.U(3.W))
        val r_len                 = RegInit(0.U(8.W))
        val write_response_ready  = Wire(UInt(1.W))
        
        //Extra Variables read:
        val rx_transaction_cnt    = RegInit(0.U(3.W))
        val rx_len                = RegInit(0.U(8.W))
        val read_response_ready  = Wire(UInt(1.W))

        //Initializing Variables:
        write_response_ready := 0.U  
        write_response_ready := io.B_VALID & ~io.B_RESP

        read_response_ready  := 0.U
        read_response_ready  := io.R_VALID & ~io.R_RESP & io.R_LAST

        // Object for Write State Machine 
        object State extends ChiselEnum {
            val sIdle, sOne, sTwo, sThree = Value
        }

        val state = RegInit(State.sIdle)
        
        //Write State Machine
        switch(state) {   
            is(State.sIdle) {
                when(io.TOP_WR === 1.U) {               //IF write is asserted by the top module
                    when (r_transaction_cnt === 0.U){   //Means the first step of transaction
                        //First Transaction:
                        r_B_READY := 0.U                //Last Transaction reamining task
                        r_AW_BURST := io.TOP_BURST
                        r_AW_ADDR  := io.TOP_ADDRESS
                        r_AW_LEN   := io.TOP_LENGTH
                        r_AW_SIZE  := io.TOP_SIZE
                        r_len      := ( io.TOP_LENGTH << io.TOP_SIZE ) + 1.U
                        r_W_DATA   := io.TOP_WDATA
                        r_AW_VALID := 1.U
                        r_W_VALID  := 1.U
                        r_AW_ID    := 0.U
                        r_AW_PROT  := 0.U
                        when (io.AW_READY === 1.U){ //Valid and Ready high at the same time
                            r_transaction_cnt := 0.U
                            state := State.sOne
                            r_AW_VALID := 0.U
                        } .otherwise {
                            r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
                        }
                    } .otherwise {
                        when (io.AW_READY === 1.U){ //Valid and Ready high at the same time
                            r_transaction_cnt := 0.U
                            r_AW_VALID := 0.U
                            state := State.sOne
                        } .otherwise {
                            // Hold the Values
                            r_AW_BURST := r_AW_BURST
                            r_AW_ADDR  := r_AW_ADDR
                            r_AW_LEN   := r_AW_LEN
                            r_AW_SIZE  := r_AW_SIZE
                            r_W_DATA   := r_W_DATA
                            r_AW_VALID := 1.U
                            r_AW_ID    := 0.U
                            r_AW_PROT  := 0.U                           
                            r_transaction_cnt := r_transaction_cnt + 1.U  //Increment on each transaction 
                        }
                    } 
                } .otherwise {
                    state := State.sIdle
                }
            } 
            is(State.sOne){
                when(io.W_READY === 1.U) {  
                    when (r_len >= 1.U) { 
                        r_len      := r_len - 1.U
                        r_W_STRB   := "hf".asUInt(4.W)
                        r_W_DATA   := io.TOP_WDATA
                        state      := State.sOne        
                        when (r_len === 1.U){
                            r_W_LAST   := 1.U      
                        }
                    } .otherwise {
                        state := State.sTwo      //Go to next state 
                        r_W_LAST  := 0.U
                        r_W_DATA   := 0.U    
                        r_W_STRB   := 0.U
                        r_W_VALID  := 0.U
                    }
                } .otherwise {
                    r_W_DATA   := r_W_DATA
                    r_W_LAST   := r_W_LAST               
                    r_W_STRB   := r_W_STRB
                    r_W_VALID  := r_W_VALID
                    state := State.sOne
                }
            }
            is(State.sTwo){
                r_B_READY := 1.U        //Stating master is ready to accept the write response
                when (write_response_ready === 1.U) {
                    state     := State.sIdle
                }
            }
        }
    

        // Object for Write State Machine 
        object Rx_State extends ChiselEnum {
            val sIdle, sOne, sTwo, sThree = Value
        }

        val rx_state = RegInit(Rx_State.sIdle)
        
        //Write State Machine
        switch(rx_state) {   
            is(Rx_State.sIdle){
                when(io.TOP_RD === 1.U) {               //IF write is asserted by the top module
                    when(rx_transaction_cnt === 0.U) {
                        //First Transaction:
                        r_AR_ADDR  := io.TOP_R_ADDRESS
                        r_AR_BURST := io.TOP_R_BURST
                        r_AR_LEN   := io.TOP_R_LENGTH
                        r_AR_SIZE  := io.TOP_R_SIZE
                        rx_len     := (io.TOP_R_LENGTH << io.TOP_R_SIZE) + 1.U 
                        r_AR_VALID := 1.U
                        r_R_READY  := 1.U
                        r_AR_ID    := 0.U
                        r_AR_PROT  := 0.U
                        when(io.AR_READY === 1.U) {     //Valid and Ready High at
                            rx_transaction_cnt := 0.U 
                            rx_state := Rx_State.sOne
                            r_AR_VALID := 0.U
                        } .otherwise {
                            rx_transaction_cnt := rx_transaction_cnt + 1.U
                        }
                    } .otherwise {
                        when(io.AR_READY === 1.U){
                            rx_transaction_cnt := 0.U
                            r_AR_VALID         := 0.U
                            rx_state := Rx_State.sOne
                        } .otherwise {
                            //Hold the values
                            r_AR_ADDR  := io.TOP_R_ADDRESS
                            r_AR_BURST := io.TOP_R_BURST
                            r_AR_LEN   := io.TOP_R_LENGTH
                            r_AR_SIZE  := io.TOP_R_SIZE 
                            r_AR_VALID := 1.U
                            r_R_READY  := 1.U
                            r_AR_ID    := 0.U
                            r_AR_PROT  := 0.U                           
                            rx_transaction_cnt := rx_transaction_cnt + 1.U
                        }
                    }
                } .otherwise {
                    rx_state := Rx_State.sIdle
                }
            }
            is(Rx_State.sOne){
                when(io.R_VALID === 1.U){
                    when (rx_len >= 1.U){
                        rx_len    := rx_len - 1.U 
                        r_R_RDATA := io.R_DATA
                        rx_state  := Rx_State.sOne
                        when (read_response_ready === 1.U){
                            r_R_READY := 0.U
                            rx_state := Rx_State.sIdle
                        }
                    }
                } .otherwise {
                    r_R_RDATA := 0.U
                    rx_state  := Rx_State.sOne
                }
            }
        }

        //Updating AXI Signals:

        //Write Address Signals:
        io.AW_BURST := r_AW_BURST 
        io.AW_ADDR  := r_AW_ADDR  
        io.AW_LEN   := r_AW_LEN  
        io.AW_SIZE  := r_AW_SIZE 
        io.AW_ID    := r_AW_ID    
        io.AW_VALID := r_AW_VALID
        io.AW_PROT  := r_AW_PROT  

        //Write Data Signals:
        io.W_DATA   := r_W_DATA
        io.W_LAST   := r_W_LAST
        io.W_STRB   := r_W_STRB
        io.W_VALID  := r_W_VALID

        //Write Response Channel:
        io.B_READY  := r_B_READY

        //Read Address Channel:
        io.AR_BURST := r_AR_BURST
        io.AR_ADDR  := r_AR_ADDR
        io.AR_LEN   := r_AR_LEN
        io.AR_SIZE  := r_AR_SIZE
        io.AR_ID    := r_AR_ID
        io.AR_VALID := r_AR_VALID
        io.AR_PROT  := r_AR_PROT
        
        //Read Data/Response Channel:
        io.R_READY   := r_R_READY

        //Signals to Top Module:
        io.TOP_RDATA := r_R_RDATA
}

object TopDriver extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new Top, args)
}
