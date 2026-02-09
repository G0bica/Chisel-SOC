error id: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala:Bool.
file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:

offset: 1094
uri: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala
text:
```scala
import chisel3._
import chisel3.util._

class APBBridge() extends Module {

  
  val DW = 32
  val AW = 32
  val CW = 1 + DW + AW
  val RW = 1 + DW

  val brgBase = "hC0000000".U(32.W)



  val io = IO(new Bundle {

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


  val cmd = UInt(CW-1.W)
  val valid = Bool() 
  val resp = Uint(RW-1.W)
  val ready = Bool()

  val bridgeEnable = (io.addr(31, 24) === brgBase(31, 24) )
  val validRequest = io.addrStrobe && bridgeEnable

  val writeRequest = Bool()
  val write = @@Bool()
  val delayWrite()

  write := io.writeStrobe & !io.readStrobe

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


  val master_apebe = Module(new APB_master())

  master_apebe.io.i_cmd := cmd
  master_apebe.io.i_valid := 
  master_apebe.io.o_resp := 
  master_apebe.io.o_ready
  master_apebe.io.pADDR
  master_apebe.io.pSELx
  master_apebe.io.pENABLE
  master_apebe.io.pWRITE
  master_apebe.io.pWDATA
  master_apebe.io.pRDATA
  master_apebe.io.pREADY
  master_epebe.io.pSLVERR

  


}
```


#### Short summary: 

empty definition using pc, found symbol in pc: 