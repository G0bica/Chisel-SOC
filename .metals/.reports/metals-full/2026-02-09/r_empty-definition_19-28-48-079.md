error id: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala:pSLVERR.
file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/ApbBridge.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/master_epebe/io/pSLVERR.
	 -chisel3/master_epebe/io/pSLVERR#
	 -chisel3/master_epebe/io/pSLVERR().
	 -chisel3/util/master_epebe/io/pSLVERR.
	 -chisel3/util/master_epebe/io/pSLVERR#
	 -chisel3/util/master_epebe/io/pSLVERR().
	 -master_epebe/io/pSLVERR.
	 -master_epebe/io/pSLVERR#
	 -master_epebe/io/pSLVERR().
	 -scala/Predef.master_epebe.io.pSLVERR.
	 -scala/Predef.master_epebe.io.pSLVERR#
	 -scala/Predef.master_epebe.io.pSLVERR().
offset: 1935
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

  master_apebe.io.i_cmd := cmd
  master_apebe.io.i_valid := valid
  master_apebe.io.o_resp := resp
  master_apebe.io.o_ready := 
  master_apebe.io.pADDR := 
  master_apebe.io.pSELx := 
  master_apebe.io.pENABLE :=
  master_apebe.io.pWRITE
  master_apebe.io.pWDATA
  master_apebe.io.pRDATA
  master_apebe.io.pREADY
  master_epebe.io.pSLVER@@R

  


}
```


#### Short summary: 

empty definition using pc, found symbol in pc: 