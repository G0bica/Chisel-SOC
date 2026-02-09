error id: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/APB_master_tb.scala:AnyFlatSpec#
file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/APB_master_tb.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/AnyFlatSpec#
	 -chisel3/util/AnyFlatSpec#
	 -chiseltest/AnyFlatSpec#
	 -org/scalatest/flatspec/AnyFlatSpec#
	 -AnyFlatSpec#
	 -scala/Predef.AnyFlatSpec#
offset: 159
uri: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/APB_master_tb.scala
text:
```scala
import chisel3._
import chisel3.util._



import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class AddTester extends AnyF@@latSpec with ChiselScalatestTester {

  "Add" should "work" in {
    test(new Add) { dut =>
      for (a <- 0 to 2) {
        for (b <- 0 to 3) {
          val result = a + b
          dut.io.a.poke(a.U)
          dut.io.b.poke(b.U)
          dut.clock.step(1)
          dut.io.c.expect(result.U)
        }
      }
    }
  }
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 