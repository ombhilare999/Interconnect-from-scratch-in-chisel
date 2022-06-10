package examples

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
            val START = Input(UInt(1.W)) // Triggers the communication
            val WR = Output(UInt(1.W))
            val RD = Output(UInt(1.W))
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
            is(State.sOne) { // Write Operation First Cycle
                io.WR := 0.U
                io.RD := 0x0.U(1.W) // Keeping Read signal de-asserted
                io.ADD := 0x10.U(32.W) // Lower Bit is 10
                io.WDATA := 0x20.U(32.W) // Data to be write at location 10 is 20
                state := State.sTwo
            }
            is(State.sTwo) {
                io.ADD := 0x11.U(32.W)       // Address Changes to 11
                io.WDATA := 0x40.U(32.W)     // Data changes to 40
                state := State.sThree
            }
            is(State.sThree) { // Deasserting Everything
                io.WR := 0x0.U(1.W)
                io.RD := 0x0.U(1.W)
                io.ADD := 0x0.U(32.W)
                io.WDATA := 0x0.U(32.W)
                state := State.sNone
            }
        }
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

        object State extends ChiselEnum {
            val sNone, sOne, sTwo, sThree = Value
        }

        val state = RegInit(State.sNone)

        switch(state) {
            is(State.sNone) {
            when(io.WR === 1.U) { // Right now Supporting Write Operation Only
                state := State.sOne
                io.RDATA := 0.U
            }
            }
            is(State.sOne) { // Write Operation First Cycle
                when(io.ADD === 10.U) {
                io.CDATA := io.WDATA // Storing the write data into current data
                state := State.sTwo
                }
            }
            is(State.sTwo) {
            when(io.WR === 1.U) {
                when(io.ADD === 11.U) {
                io.CDATA := io.WDATA // Storing the write data into current data
                state := State.sThree
                }
            }
            }
            is(State.sThree) { // Deasserting Everything
            io.CDATA := 0.U
            }
        }
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

