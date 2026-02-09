import chisel3._
import chisel3.util._

class APB_bridge extends Module {

  val DW = 32
  val AW = 32
  val CW = 1 + DW + AW
  val RW = 1 + DW

  val brgBase = "hC0000000".U(32.W)

  val io = IO(new Bundle {

    // CPU signals
    val io_address      = Input(UInt(32.W))
    val io_addr_strobe  = Input(Bool())
    val io_write_data   = Input(UInt(32.W))
    val io_write_strobe = Input(Bool())
    val io_read_strobe  = Input(Bool())

    val io_read_data    = Output(UInt(32.W))
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


  val cmd   = Wire(UInt(CW.W))
  val valid = Wire(Bool())
  val resp  = Wire(UInt(RW.W))
  val ready = Wire(Bool())

  val delayWrite = RegInit(false.B)
  val write      = Wire(Bool())
  val writeReq   = Wire(Bool())



  val bridgeEnable = io.io_address(31, 24) === brgBase(31, 24)

  valid := io.io_addr_strobe && bridgeEnable


  write := io.io_write_strobe && !io.io_read_strobe

  when(valid) {
    delayWrite := write
  }

  writeReq := Mux(valid, write, delayWrite)

  cmd := Cat(writeReq, io.io_write_data, io.io_address)


  val master_apb = Module(new APB_master)

  master_apb.io.i_cmd   := cmd
  master_apb.io.i_valid := valid

  resp  := master_apb.io.o_resp
  ready := master_apb.io.o_ready


  io.io_read_data := Mux(
    resp(DW),                 
    "hDEADFA17".U(32.W),         
    resp(DW-1, 0)                
  )

  io.io_ready := ready && bridgeEnable

  io.pADDR   := master_apb.io.pADDR
  io.pSELx   := master_apb.io.pSELx
  io.pENABLE := master_apb.io.pENABLE
  io.pWRITE  := master_apb.io.pWRITE
  io.pWDATA  := master_apb.io.pWDATA

  master_apb.io.pRDATA  := io.pRDATA
  master_apb.io.pREADY  := io.pREADY
  master_apb.io.pSLVERR := io.pSLVERR
}
