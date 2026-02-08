
import chisel3._
import chisel3.util._


class APB_timer extends Module{

  val DW = 32
  val AW = 32
  val CW = 1 + DW + AW
  val RW = 1 + DW



  val io = IO(new Bundle {
    
    val pResetn = Input(UInt(8.W))

    val i_cmd   = Input(UInt(CW.W))
    val i_valid = Input(Bool())
    val o_resp  = Output(UInt(RW.W))
    val o_ready = Output(Bool())

    val pADDR   = Output(UInt(AW.W))
    val pSELx   = Output(Bool())
    val pENABLE = Output(Bool())
    val pWRITE  = Output(Bool())
    val pWDATA  = Output(UInt(DW.W))
    val pRDATA  = Input(UInt(DW.W))
    val pREADY  = Input(Bool())
    val pSLVERR = Input(Bool())
  })





}