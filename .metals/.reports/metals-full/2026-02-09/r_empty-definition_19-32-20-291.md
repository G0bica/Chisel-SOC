error id: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala:master_apb.
file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/master_apb.
	 -chisel3/util/master_apb.
	 -master_apb.
	 -scala/Predef.master_apb.
offset: 1621
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

  // CPu singnalš  
  val io_address      = Input(UInt(32.W))
  val io_addr_strobe  = Input(Bool())
  val io_write_data   = Input(UInt(32.W))
  val io_write_strobe = Input(Bool())

  val io_read_data    = Output(UInt(32.W))
  val io_read_strobe  = Input(Bool())
  val io_ready        = Output(Bool())

  // APB signals
  val pADDR   = Output(UInt(AW.W))
  val pSELx   = Output(Bool())
  val pENABLE = Output(Bool())
  val pWRITE  = Output(Bool())
  val pWDATA  = Output(UInt(DW.W))

  val pRDATA  = Input(UInt(DW.W))
  val pREADY  = Input(Bool())
  val pSLVERR = Input(Bool())
  })


  val cmd = UInt(CW-1.W)
  val valid = Bool() 
  val resp = Uint(RW-1.W)
  val ready = Bool()

  val bridgeEnable = (io.io_addr(31, 24) === brgBase(31, 24) )
  val valid = io.io_addr_strobe && bridgeEnable

  val writeRequest = Bool()
  val write = Bool()
  val delayWrite = regInit(0.B())

  write := io.writeStrobe & !io.readStrobe

  when(valid) {
    delayWrite := write
    
  }

  writeRequest := Mux(valid, wirte, delayWrite)


  cmd := Cat(write_req, io.write_data, io.addr)
  //cmd := (write_req << 63) | (io.write_data << 31) |  io.addr

  io.read_data := Mux(reps(DW), "hDEADFA17", resp(DW-1, 0))

  io.ready := ready & mcs_bridge_enable






  


  val master_apebe = Module(new APB_master())

master_apb.io.i_cmd   := cmd
maste@@r_apb.io.i_valid := valid

resp  := master_apb.io.o_resp
ready := master_apb.io.o_ready

// APB signals
pADDR   := master_apb.io.pADDR
pSELx   := master_apb.io.pSELx
pENABLE := master_apb.io.pENABLE
pWRITE  := master_apb.io.pWRITE
pWDATA  := master_apb.io.pWDATA

master_apb.io.pRDATA  := pRDATA
master_apb.io.pREADY  := pREADY
master_apb.io.pSLVERR := pSLVERR
  


}
```


#### Short summary: 

empty definition using pc, found symbol in pc: 