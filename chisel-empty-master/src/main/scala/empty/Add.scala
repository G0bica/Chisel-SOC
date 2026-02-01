/*
 * Dummy file to start a Chisel project.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 * 
 */

package empty

import chisel3._
// import chisel3.util._

class Add extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(1.W))
    val sw = Input(UInt(1.W))
  })
 
  io.led := io.sw
}

object AddMain extends App {
  println("Generating the adder hardware")
  emitVerilog(new Add(), Array("--target-dir", "generated"))
}