import chisel3._



class Led extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(1.W))
    val sw = Input(UInt(1.W))
  })
 
  io.led := sw
}

