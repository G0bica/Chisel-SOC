error id: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala:scala/Predef.`???`().
file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/Bundle#
	 -chisel3/util/Bundle#
	 -Bundle#
	 -scala/Predef.Bundle#
offset: 171
uri: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala
text:
```scala
import chisel3._
import chisel3.util._

class APBBridge() extends Module {

  
  val addrWidth = 32
  val dataWidth =  32
  val brgBase = 

  val io = IO(new Bun@@dle {

    val addrStrobe  = Input(Bool())
    val addr        = Input(UInt(addrWidth.W))
    val writeStrobe = Input(Bool())
    val wdata       = Input(UInt(dataWidth.W))
    val rdata       = Output(UInt(dataWidth.W))
    val ready       = Output(Bool())

    val paddr       = Output(UInt(addrWidth.W))
    val psel        = Output(Bool())
    val penable     = Output(Bool())
    val pwrite      = Output(Bool())
    val pwdata      = Output(UInt(dataWidth.W))
    val prdata      = Input(UInt(dataWidth.W))
    val pready      = Input(Bool())
    val pslverr     = Input(Bool())
  })

  val bridgeEnable = (io.addr(31, 24) === (brgBase.U >> 24))
  val validRequest = io.addrStrobe && bridgeEnable

  val sIdle :: sSetup :: sAccess :: Nil = Enum(3)
  val state = RegInit(sIdle)

  switch(state) {
    is(sIdle) {
      when(validRequest) { state := sSetup }
    }
    is(sSetup) {
      state := sAccess
    }
    is(sAccess) {
      when(io.pready) { state := sIdle }
    }
  }

  io.paddr   := io.addr
  io.pwrite  := io.writeStrobe
  io.pwdata  := io.wdata
  io.psel    := (state === sSetup) || (state === sAccess)
  io.penable := (state === sAccess)


  val dataOut = Mux(io.pslverr, "hDEADFA17".U(32.W), io.prdata)
  
  io.rdata := dataOut
  io.ready := (state === sAccess) && io.pready && bridgeEnable
}
```


#### Short summary: 

empty definition using pc, found symbol in pc: 