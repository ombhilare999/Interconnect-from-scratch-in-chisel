package examples

import chisel3.iotesters.{PeekPokeTester, Driver, ChiselFlatSpec}

object Main extends App() {

    class fsm_test(c: Top) extends PeekPokeTester(c) {
        poke(c.io.start, 1)
        step(3)
        expect(c.cdata_check, 40)
    }

    
}