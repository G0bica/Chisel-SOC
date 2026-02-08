

package empty

import chisel3._
// import chisel3.util._

class Topmodule extends Module {
    
  // =============================
  // Parameters (localparam)
  // =============================

  val AW = 32
  val DW = 32
  val NUM_PERIPHERALS = 64
  val NUM_REG_PERIPHERAL = 32

  val CW = 1 + DW + AW
  val RW = 1 + DW

  // =============================
  // IO
  // =============================

  val io = IO(new Bundle {
    val resetn   = Input(Bool())
    val leds     = Output(UInt(16.W))
    val switches = Input(UInt(16.W))
  })

  
  val reset = !io.resetn

  // =============================
  // IO Bus Signals
  // =============================

  val io_address      = Wire(UInt(32.W))
  val io_addr_strobe  = Wire(Bool())
  val io_write_data   = Wire(UInt(32.W))
  val io_write_strobe = Wire(Bool())
  val io_byte_enable  = Wire(UInt(4.W))
  val io_read_data    = Wire(UInt(32.W))
  val io_read_strobe  = Wire(Bool())
  val io_ready        = Wire(Bool())

  // =============================
  // Microblaze (BlackBox assumed)
  // =============================

  val microblaze = Module(new MicroblazeBlackBox)

  microblaze.io.Clk            := clock
  microblaze.io.Reset          := reset
  microblaze.io.IO_addr_strobe := io_addr_strobe
  microblaze.io.IO_address     := io_address
  microblaze.io.IO_byte_enable := io_byte_enable
  microblaze.io.IO_read_data   := io_read_data
  microblaze.io.IO_read_strobe := io_read_strobe
  microblaze.io.IO_ready       := io_ready
  microblaze.io.IO_write_data  := io_write_data
  microblaze.io.IO_write_strobe:= io_write_strobe

  // =============================
  // APB Master Signals
  // =============================

  val MpADDR   = Wire(UInt(AW.W))
  val MpWDATA  = Wire(UInt(DW.W))
  val MpSELx   = Wire(Bool())
  val MpWRITE  = Wire(Bool())
  val MpREADY  = Wire(Bool())
  val MpENABLE = Wire(Bool())
  val MpSLVERR = Wire(Bool())
  val MpRDATA  = Wire(UInt(DW.W))

  // =============================
  // APB Bridge
  // =============================

  val apbBridge = Module(new APB_Bridge(DW, AW, "hC0000000".U))

  apbBridge.io.CLK    := clock
  apbBridge.io.RESETn := io.resetn

  apbBridge.io.io_address      := io_address
  apbBridge.io.io_addr_strobe  := io_addr_strobe
  apbBridge.io.io_write_data   := io_write_data
  apbBridge.io.io_write_strobe := io_write_strobe
  apbBridge.io.io_byte_enable  := io_byte_enable
  apbBridge.io.io_read_data    := io_read_data
  apbBridge.io.io_read_strobe  := io_read_strobe
  apbBridge.io.io_ready        := io_ready

  apbBridge.io.pADDR   := MpADDR
  apbBridge.io.pSELx   := MpSELx
  apbBridge.io.pENABLE := MpENABLE
  apbBridge.io.pWRITE  := MpWRITE
  apbBridge.io.pWDATA  := MpWDATA
  apbBridge.io.pRDATA  := MpRDATA
  apbBridge.io.pREADY  := MpREADY
  apbBridge.io.pSLVERR := MpSLVERR

  // =============================
  // Interconnect Arrays (Vec)
  // =============================

  val SpADDR   = Wire(Vec(NUM_PERIPHERALS, UInt(AW.W)))
  val SpSEL    = Wire(Vec(NUM_PERIPHERALS, Bool()))
  val SpENABLE = Wire(Vec(NUM_PERIPHERALS, Bool()))
  val SpWRITE  = Wire(Vec(NUM_PERIPHERALS, Bool()))
  val SpWDATA  = Wire(Vec(NUM_PERIPHERALS, UInt(DW.W)))
  val SpRDATA  = Wire(Vec(NUM_PERIPHERALS, UInt(DW.W)))
  val SpREADY  = Wire(Vec(NUM_PERIPHERALS, Bool()))
  val SpSLVERR = Wire(Vec(NUM_PERIPHERALS, Bool()))

  // =============================
  // Interconnect
  // =============================

  val interconnect = Module(
    new APB_Interconnect(DW, AW, NUM_PERIPHERALS, NUM_REG_PERIPHERAL)
  )

  interconnect.io.MpADDR   := MpADDR
  interconnect.io.MpSELx   := MpSELx
  interconnect.io.MpENABLE := MpENABLE
  interconnect.io.MpWRITE  := MpWRITE
  interconnect.io.MpWDATA  := MpWDATA
  interconnect.io.MpRDATA  := MpRDATA
  interconnect.io.MpREADY  := MpREADY
  interconnect.io.MpSLVERR := MpSLVERR

  interconnect.io.SpADDR   := SpADDR
  interconnect.io.SpSEL    := SpSEL
  interconnect.io.SpENABLE := SpENABLE
  interconnect.io.SpWRITE  := SpWRITE
  interconnect.io.SpWDATA  := SpWDATA
  interconnect.io.SpRDATA  := SpRDATA
  interconnect.io.SpREADY  := SpREADY
  interconnect.io.SpSLVERR := SpSLVERR

  // =============================
  // GPIO Peripheral (index 0)
  // =============================

  val gpio = Module(new APB_GPIO(DW, AW))

  gpio.io.pCLK    := clock
  gpio.io.pRESETn := io.resetn
  gpio.io.pADDR   := SpADDR(0)
  gpio.io.pSEL    := SpSEL(0)
  gpio.io.pENABLE := SpENABLE(0)
  gpio.io.pWRITE  := SpWRITE(0)
  gpio.io.pWDATA  := SpWDATA(0)
  gpio.io.pRDATA  := SpRDATA(0)
  gpio.io.pREADY  := SpREADY(0)
  gpio.io.pSLVERR := SpSLVERR(0)
  gpio.io.switch  := io.switches
  io.leds         := gpio.io.led

  // =============================
  // Timer Peripheral (index 1)
  // =============================

  val timer = Module(new APB_Timer(DW, AW))

  timer.io.pCLK    := clock
  timer.io.pRESETn := io.resetn
  timer.io.pADDR   := SpADDR(1)
  timer.io.pSEL    := SpSEL(1)
  timer.io.pENABLE := SpENABLE(1)
  timer.io.pWRITE  := SpWRITE(1)
  timer.io.pWDATA  := SpWDATA(1)
  timer.io.pRDATA  := SpRDATA(1)
  timer.io.pREADY  := SpREADY(1)
  timer.io.pSLVERR := SpSLVERR(1)

  // =============================
  // Remaining peripherals (like genvar loop)
  // =============================

  for (i <- 2 until NUM_PERIPHERALS) {
    SpSLVERR(i) := true.B
    SpREADY(i)  := false.B
    SpRDATA(i)  := "hFFFFFFFF".U
  }


}

object TopmoduleMain extends App {
  println("Generating the  hardware")
  emitVerilog(new APB_master, Array("--target-dir", "generated"))
  emitVerilog(new APB_timer, Array("--target-dir", "generated"))
  emitVerilog(new ApbBridge, Array("--target-dir", "generated"))
  emitVerilog(new APBGPIO, Array("--target-dir", "generated"))
  emitVerilog(new APBInterconnect, Array("--target-dir", "generated"))
  emitVerilog(new APBInterconnect, Array("--target-dir", "generated"))
}