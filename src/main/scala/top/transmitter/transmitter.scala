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
      val START = Input(UInt(1.W)) // Triggers the communication
      val WR = Output(UInt(1.W))
      val RD = Output(UInt(1.W))
      val ADD = Output(UInt(32.W))
      val WDATA = Output(UInt(32.W))
      val RDATA = Input(UInt(32.W))
    }
  )

  val r_start = RegInit(0.U(1.W))
  val r_wr = RegInit(0.U(1.W))
  val r_rd = RegInit(0.U(1.W))
  val r_add = RegInit(0.U(32.W))
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
    is(State.sOne) { // Write Operation First Cycle
      r_wr := 1.U // Sending Write as 1
      r_rd := 0.U // Keeping Read signal de-asserted
      r_add := 30.U // Lower bit is stored at 30 Address
      r_wdata := 20.U // Data stored at address is 20
      state := State.sTwo
    }
    is(State.sTwo) {
      r_add := 31.U // Lower bit is stored at 31 Address
      r_wdata := 22.U // Data stored at address is 22
      state := State.sThree
    }
    is(State.sThree) { // Deasserting Everything
      r_wr := 0.U
      r_rd := 0.U
      r_add := 0.U
      r_wdata := 0.U
      // state := State.sNone
    }
  }

  r_start := io.START
  io.WR := r_wr
  io.RD := r_rd
  io.ADD := r_add
  io.WDATA := r_wdata
  r_rdata := io.RDATA
}
