import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class APBMasterTester extends AnyFlatSpec with ChiselScalatestTester {

  "APB_master" should "complete one transfer" in {
    test(new APB_master) { dut =>

      // Default values
      dut.io.pREADY.poke(false.B)
      dut.io.pSLVERR.poke(false.B)
      dut.io.pRDATA.poke(0.U)

      dut.io.i_valid.poke(false.B)
      dut.io.i_cmd.poke(0.U)

      dut.clock.step(1)

      // Send command
      val addr  = 0x10
      val data  = 0xABCD
      val write = 1

      val cmd = (write << 63) | (data << 32) | addr

      dut.io.i_cmd.poke(cmd.U)
      dut.io.i_valid.poke(true.B)

      dut.clock.step(1) // IDLE -> SETUP
      dut.clock.step(1) // SETUP -> ACCESS

      // Slave ready
      dut.io.pREADY.poke(true.B)

      dut.clock.step(1)

      dut.io.o_ready.expect(true.B)
    }
  }
}
