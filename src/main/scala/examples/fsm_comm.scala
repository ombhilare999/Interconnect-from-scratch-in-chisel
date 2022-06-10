package examples

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

/*
Transmitter  <------->   Receiver
    FSM                    FSM
 */

 //object Main extends App(){

    class Transmitter extends Module() {
        val io = IO(
            new Bundle {
            val START = Input(UInt(1.W)) // Triggers the communication
            val WR = Output(UInt(1.W))
            val RD = Output(UInt(1.W))
            val ADD = Output(UInt(32.W))
            val WDATA = Output(UInt(32.W))
            val RDATA = Input(UInt(32.W))
            }
        )

        val r_start = RegInit(0.U(1.W))  
        val r_wr    = RegInit(0.U(1.W))
        val r_rd    = RegInit(0.U(1.W))
        val r_add   = RegInit(0.U(32.W))
        val r_wdata = RegInit(0.U(32.W))
        val r_rdata = RegInit(0.U(32.W))

        object State extends ChiselEnum {
            val sNone, sOne, sTwo, sThree = Value
        }

        val state = RegInit(State.sNone)

        switch(state) {
            is(State.sNone) {
                when(r_start === 1.U) {
                    state := State.sOne
                }
            }
            is(State.sOne) {    // Write Operation First Cycle
                r_wr := 1.U        // Sending Write as 1
                r_rd := 0.U        // Keeping Read signal de-asserted
                r_add := 10.U      // Lower Bit is 10
                r_wdata := 20.U    // Data to be write at location 10 is 20
                state := State.sTwo
            }
            is(State.sThree) {      // Deasserting Everything
                r_wr := 0.U
                r_rd := 0.U
                r_add := 0.U
                r_wdata := 0.U
                state := State.sNone
            }
        }
        
        r_start := io.START 
        io.WR := r_wr
        io.RD := r_rd
        io.ADD := r_add
        io.WDATA := r_wdata
        r_rdata := io.RDATA  
    }

    class Receiver extends Module() {
        val io = IO(
            new Bundle {
            val WR = Input(UInt(1.W))
            val RD = Input(UInt(1.W))
            val ADD = Input(UInt(32.W))
            val WDATA = Input(UInt(32.W))
            val RDATA = Output(UInt(32.W))
            val CDATA = Output(UInt(32.W))
            }
        )

        
        val r_wr    = RegInit(0.U(1.W))
        val r_rd    = RegInit(0.U(1.W))
        val r_add   = RegInit(0.U(32.W))
        val r_wdata = RegInit(0.U(32.W))
        val r_rdata = RegInit(0.U(32.W))
        val r_cdata = RegInit(0.U(32.W))  


        object State extends ChiselEnum {
            val sNone, sOne, sTwo, sThree = Value
        }

        val state = RegInit(State.sNone)

        switch(state) {
            is(State.sNone) {
                when(r_wr === 1.U) { // Right now Supporting Write Operation Only
                    state := State.sOne
                    r_rdata := 0.U
                }
            }
            is(State.sOne) { // Write Operation First Cycle
                when(r_wr === 1.U) {
                    when(r_add === 10.U) {
                    r_cdata := r_wdata // Storing the write data into current data
                    state := State.sTwo
                    }
                }
            }
            is(State.sTwo) {
                when(r_wr === 1.U) {
                    when(r_add === 11.U) {
                    r_cdata := r_wdata // Storing the write data into current data
                    state := State.sThree
                    }
                }
            }
            is(State.sThree) { // Deasserting Everything
                r_cdata := 0.U
            }
        }

        r_wr := io.WR
        r_rd := io.RD
        r_add := io.ADD
        r_wdata := io.WDATA
        io.RDATA := r_rdata
        io.CDATA := r_cdata
    }

    class Top() extends Module {

        val io = IO(
            new Bundle {
            val start = Input(UInt(0.W)) // Triggers the communication
            val cdata_check = Output(UInt(32.W))
            }
        )

        val Tx = Module(new Transmitter)
        val Rx = Module(new Receiver)
        val cdata_check = UInt(32.W)

        //Connecting both the modules
        Rx.io.WR := Tx.io.WR
        Rx.io.RD := Tx.io.RD
        Rx.io.ADD := Tx.io.ADD
        Rx.io.WDATA := Tx.io.WDATA
        Tx.io.RDATA := Rx.io.RDATA
        Tx.io.START := io.start
    
        //To check the modules
        io.cdata_check := Rx.io.CDATA
    }

    object TopDriver extends App {
        (new chisel3.stage.ChiselStage).emitVerilog(new Top, args)
    }

//}