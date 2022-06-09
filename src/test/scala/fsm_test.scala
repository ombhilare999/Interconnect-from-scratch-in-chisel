package fsm_test

import chisel3._
import chiseltest._
import chiseltest.ChiselScalatestTester
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class fsm_test extends AnyFlatSpec with ChiselScalatestTester {
    test(new fsm_comm.Transmitter) { c =>

    }

    test(new fsm_comm.Receiver ) { d =>

    }

    println("Hello World")
}