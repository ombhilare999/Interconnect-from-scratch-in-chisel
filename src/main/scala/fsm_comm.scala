package fsm_comm

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

/*
Transmitter  <------->   Receiver
    FSM                    FSM
1) Generating Clock Signal
2) Write Signal from the transmitter
3) 
*/


    
    class Transmitter extends Module () {
        val io = IO (
            new Bundle {
                val START = Input(UInt(0.W)) //Triggers the communication
                val WR = Output(UInt(0.W))
                val RD = Output(UInt(0.W))
                val ADD = Output(UInt(32.W))
                val WDATA = Output(UInt(32.W))
                val RDATA = Input(UInt(32.W))
            }
        )

        object State extends ChiselEnum {
            val sNone, sOne, sTwo, sThree = Value
        }

        val state = RegInit(State.sNone)

        switch(state) {
            is(State.sNone) {
                when(io.START === 1.U) {
                    state := State.sOne
                }
            }
            is(State.sOne) {   //Write Operation First Cycle
                io.WR := 1.U     //Sending Write as 1 
                io.RD := 0.U     //Keeping Read signal de-asserted
                io.ADD := 10.U   //Lower Bit is 10
                io.WDATA := 20.U //Data to be write at location 10 is 20
                state := State.sTwo
            }
            is(State.sTwo) {
                io.ADD := 11.U   //Address Changes to 11
                io.WDATA := 40.U //Data changes to 40
                state := State.sThree
            }
            is(State.sThree) { //Deasserting Everything
                io.WR := 0.U
                io.RD := 0.U
                io.ADD := 0.U
                io.WDATA := 0.U 
                state := State.sNone
            }
        }
    }

    class Receiver extends Module () {
        val io = IO (
            new Bundle {
                val WR = Input(UInt(0.W))
                val RD = Input(UInt(0.W))
                val ADD = Input(UInt(32.W))
                val WDATA = Input(UInt(32.W))
                val RDATA = Output(UInt(32.W))
                val CDATA = Output(UInt(32.W))
            }
        )        

        object State extends ChiselEnum {
            val sNone, sOne, sTwo, sThree = Value
        }

        val state = RegInit(State.sNone)

        switch(state) {
            is(State.sNone) {
                when(io.WR  === 1.U) {   //Right now Supporting Write Operation Only
                    state := State.sOne
                }
            }
            is(State.sOne) {   //Write Operation First Cycle
                when(io.WR === 1.U) {
                    when(io.ADD === 10.U) {
                        io.CDATA := io.WDATA //Storing the write data into current data
                        state := State.sTwo
                    }
                }
            }
            is(State.sTwo) {
                when(io.WR === 1.U) {
                    when(io.ADD === 11.U) {
                        io.CDATA := io.WDATA //Storing the write data into current data
                        state := State.sThree
                    }
                }
            }
            is(State.sThree) { //Deasserting Everything
                io.CDATA := 0.U
            }
        }
    }
