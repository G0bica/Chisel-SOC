import chisel3._
import chisel3.util._

class APBInterconnect(
  val addrWidth: Int = 32, 
  val dataWidth: Int = 32, 
  val numPeripherals: Int = 64, 
  val numRegPerPeripheral: Int = 32
) extends Module {
  
  val io = IO(new Bundle {
    // Master Interface
    val in = new Bundle {
      val paddr   = Input(UInt(addrWidth.W))
      val psel    = Input(Bool())
      val penable = Input(Bool())
      val pwrite  = Input(Bool())
      val pwdata  = Input(UInt(dataWidth.W))
      val prdata  = Output(UInt(dataWidth.W))
      val pready  = Output(Bool())
      val pslverr = Output(Bool())
    }

    // Slave Interfaces (Vector of Peripherals)
    val slaves = Vec(numPeripherals, new Bundle {
      val psel    = Output(Bool())
      val paddr   = Output(UInt(addrWidth.W))
      val penable = Output(Bool())
      val pwrite  = Output(Bool())
      val pwdata  = Output(UInt(dataWidth.W))
      val prdata  = Input(UInt(dataWidth.W))
      val pready  = Input(Bool())
      val pslverr = Input(Bool())
    })
  })

  // --- Addressing Logic ---
  // Equivalent to $clog2 in SystemVerilog
  val offsetBits = log2Ceil(numRegPerPeripheral) + 2 
  val selectorBits = log2Ceil(numPeripherals)
  
  // Extract the index of the peripheral from the address
  // index = paddr[selectorBits + offsetBits - 1 : offsetBits]
  val peripheralIndex = io.in.paddr(selectorBits + offsetBits - 1, offsetBits)

  // --- Forwarding Logic ---
  // Using a loop to broadcast master signals to all slaves (except PSEL)
  for (i <- 0 until numPeripherals) {
    io.slaves(i).paddr   := io.in.paddr
    io.slaves(i).penable := io.in.penable
    io.slaves(i).pwrite  := io.in.pwrite
    io.slaves(i).pwdata  := io.in.pwdata
    
    // Decoder: Only the indexed slave gets PSEL high
    io.slaves(i).psel := io.in.psel && (peripheralIndex === i.U)
  }

  // --- Response MUX ---
  // Using the index to select which slave drives the Master inputs
  io.in.pready  := io.slaves(peripheralIndex).pready
  io.in.pslverr := io.slaves(peripheralIndex).pslverr
  
  // RDATA logic: Only drive data if it's a read transaction
  io.in.prdata := 0.U
  when(!io.in.pwrite && io.in.psel) {
    io.in.prdata := io.slaves(peripheralIndex).prdata
  }
}