import chisel3._
import chisel3.util._

class APB_GPIO(val addrWidth: Int, val dataWidth: Int) extends Module {
  val io = IO(new Bundle {

    val paddr   = Input(UInt(addrWidth.W))
    val psel    = Input(Bool())
    val penable = Input(Bool())
    val pwrite  = Input(Bool())
    val pwdata  = Input(UInt(dataWidth.W))
    val prdata  = Output(UInt(dataWidth.W))
    val pready  = Output(Bool())
    val pslverr = Output(Bool())

    val switch  = Input(UInt(16.W))
    val led     = Output(UInt(16.W))
  })

  val LED_OFF = "h04".U(7.W)
  val SW_OFF  = "h00".U(7.W)

  val ledReg = RegInit(0.U(16.W))

  val isSetup  = io.psel && !io.penable
  val isAccess = io.psel && io.penable
  val addrLow  = io.paddr(6, 0)

  val writeValid = isAccess && io.pwrite && (addrLow === LED_OFF)
  when(writeValid) {
    ledReg := io.pwdata(15, 0)
  }

  io.prdata := Mux(isAccess && !io.pwrite && (addrLow === SW_OFF), 
                   Cat(0.U(16.W), io.switch), 
                   0.U)

  val invalidAddr = (addrLow =/= LED_OFF) && (addrLow =/= SW_OFF)
  val errorReg    = RegNext(isAccess && invalidAddr, false.B)

  io.led     := ledReg
  io.pready  := true.B
  io.pslverr := errorReg
}