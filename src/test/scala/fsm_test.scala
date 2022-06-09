package fsm_test

import chisel3._
import chisel3.tester._
import chisel3.tester.RawTester.test

object Main extends App () { 

    test(new fsm_comm.Top(start = 1.U)) { c =>
        step(3)
    }

}