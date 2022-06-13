package top.receiver

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


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

  val r_wr = RegInit(0.U(1.W))
  val r_rd = RegInit(0.U(1.W))
  val r_add = RegInit(0.U(32.W))
  val r_wdata = RegInit(0.U(32.W))
  val r_rdata = RegInit(0.U(32.W))
  val r_cdata = RegInit(0.U(32.W))

  object State extends ChiselEnum {
    val sNone, sOne, sTwo = Value
  }

  val state = RegInit(State.sNone)

  switch(state) {
    is(State.sNone) {
      when(r_wr === 1.U) { // Right now Supporting Write Operation Only
        when(r_add === 30.U) {
          r_cdata := r_wdata // Storing the write data into current data
          state := State.sOne
        }
      }
    }
    is(State.sOne) { // Write Operation First Cycle
      when(r_wr === 1.U) {
        when(r_add === 31.U) {
          r_cdata := r_wdata // Storing the write data into current data
          state := State.sTwo
        }
      }
    }
    is(State.sTwo) {
      r_cdata := 0.U
      // state := State.sNone
    }
  }

  r_wr := io.WR
  r_rd := io.RD
  r_add := io.ADD
  r_wdata := io.WDATA
  io.RDATA := r_rdata
  io.CDATA := r_cdata
}
