import chisel3._
import chisel3.util._

class uart(val baudRate: Int, val clockFreq: Int) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(Bool())
    val txd = Output(Bool())
    val en = Input(Bool())
    val tx_data = Input(UInt(8.W))
    val tx_valid = Input(Bool())
    val tx_ready = Output(Bool())
    val rx_data = Output(UInt(8.W))
    val rx_valid = Output(Bool())
  })

  val BIT_CNT_MAX = (clockFreq / baudRate).U
  val HALF_BIT_CNT = (clockFreq / (baudRate * 2)).U

  val tx_state = RegInit(0.U(2.W)) 
  val tx_counter = RegInit(0.U(32.W))
  val tx_bitIdx = RegInit(0.U(3.W))
  val tx_buffer = Reg(UInt(8.W))

  io.txd := true.B
  io.tx_ready := (tx_state === 0.U)

  when(tx_state === 0.U) {
    when(io.tx_valid) {
      tx_buffer := io.tx_data
      tx_state := 1.U
      tx_counter := 0.U
    }
  } .otherwise {
    tx_counter := tx_counter + 1.U
    when(tx_counter === BIT_CNT_MAX - 1.U) {
      tx_counter := 0.U
      when(tx_state === 1.U) { 
        tx_state := 2.U
        tx_bitIdx := 0.U
      } .elsewhen(tx_state === 2.U) { 
        tx_bitIdx := tx_bitIdx + 1.U
        when(tx_bitIdx === 7.U) { tx_state := 3.U }
      } .otherwise { 
        tx_state := 0.U
      }
    }
  }

  when(tx_state === 1.U) { io.txd := false.B }
  .elsewhen(tx_state === 2.U) { io.txd := tx_buffer(tx_bitIdx) }
  .otherwise { io.txd := true.B }

  val rx_state = RegInit(0.U(2.W))
  val rx_counter = RegInit(0.U(32.W))
  val rx_bitIdx = RegInit(0.U(3.W))
  val rx_reg = Reg(UInt(8.W))
  val rx_validReg = RegInit(false.B)

  io.rx_data := rx_reg
  io.rx_valid := rx_validReg
  rx_validReg := false.B

  when(rx_state === 0.U) {
    when(!io.rxd) { 
      when(rx_counter === HALF_BIT_CNT) {
        rx_state := 1.U
        rx_counter := 0.U
        rx_bitIdx := 0.U
      } .otherwise { rx_counter := rx_counter + 1.U }
    } .otherwise { rx_counter := 0.U }
  } .otherwise {
    rx_counter := rx_counter + 1.U
    when(rx_counter === BIT_CNT_MAX - 1.U) {
      rx_counter := 0.U
      when(rx_state === 1.U) {
        rx_reg := Cat(io.rxd, rx_reg(7, 1))
        rx_bitIdx := rx_bitIdx + 1.U
        when(rx_bitIdx === 7.U) { rx_state := 2.U }
      } .otherwise {
        rx_validReg := true.B
        rx_state := 0.U
      }
    }
  }
}

class APBBundle(val addrWidth: Int, val dataWidth: Int) extends Bundle {
  val paddr   = Input(UInt(addrWidth.W))
  val psel    = Input(Bool())
  val penable = Input(Bool())
  val pwrite  = Input(Bool())
  val pwdata  = Input(UInt(dataWidth.W))
  val prdata  = Output(UInt(dataWidth.W))
  val pready  = Output(Bool())
  val pslverr = Output(Bool())
}

class ApbUartWrapper(val baudRate: Int, val clockFreq: Int) extends Module {
  val io = IO(new Bundle {
    val apb = new APBBundle(12, 32)
    val rxd = Input(Bool())
    val txd = Output(Bool())
  })

  val uartCore = Module(new uart(baudRate, clockFreq))
  
  uartCore.io.rxd := io.rxd
  io.txd := uartCore.io.txd
  uartCore.io.en := true.B

  val setupPhase = io.apb.psel && !io.apb.penable
  
  io.apb.pready  := true.B
  io.apb.pslverr := false.B
  io.apb.prdata  := 0.U

  val rxBuf = RegInit(0.U(8.W))
  val rxValid = RegInit(false.B)

  when(uartCore.io.rx_valid) {
    rxBuf := uartCore.io.rx_data
    rxValid := true.B
  }

  when(io.apb.psel && !io.apb.pwrite) {
    switch(io.apb.paddr) {
      is(0.U) { 
        io.apb.prdata := rxBuf 
        when(io.apb.penable) {
          rxValid := false.B 
        } 
      }
      is(4.U) { 
        io.apb.prdata := Cat(0.U(30.W), rxValid, uartCore.io.tx_ready) 
      }
    }
  }

  uartCore.io.tx_data  := io.apb.pwdata(7, 0)
  uartCore.io.tx_valid := false.B

  when(setupPhase && io.apb.pwrite) {
    when(io.apb.paddr === 0.U) {
      uartCore.io.tx_valid := true.B
    }
  }
}