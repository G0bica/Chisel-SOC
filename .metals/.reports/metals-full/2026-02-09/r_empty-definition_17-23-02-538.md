error id: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/APB_master.scala:chisel3.
file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/APB_master.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/chisel3.
	 -chisel3/util/chisel3.
	 -chisel3.
	 -scala/Predef.chisel3.
offset: 34
uri: file:///C:/Users/Matic/Documents/šola/fri/dn/Chisel-SOC/src/main/scala/APB_master.scala
text:
```scala


import chisel3._
import chise@@l3.util._
import chisel3.experimental.ChiselEnum

class APB_master extends Module {

  val DW = 32
  val AW = 32
  val CW = 1 + DW + AW
  val RW = 1 + DW



  val io = IO(new Bundle {
    
    

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

  object State extends ChiselEnum{
    val IDLE, SETUP, ACCESS = Value
  }

  import State._

  val stateReg = RegInit (IDLE)

  switch (stateReg) {

    is (IDLE){
      when(io.i_valid) {
        stateReg := SETUP
      }
    }

    is (SETUP){

      stateReg := ACCESS

    }

    is (ACCESS){

      when(io.pREADY && io.i_valid){
        stateReg := SETUP
      }

      .elsewhen(io.pREADY && !io.i_valid){
        stateReg := IDLE
      }


    }





  }

  // output signals


  io.pADDR := io.i_cmd(AW-1,0)
  io.pWDATA := io.i_cmd(CW-2,AW)
  io.pWRITE := io.i_cmd(CW-1)

  io.pENABLE := stateReg === ACCESS
  io.pSELx := stateReg === SETUP  || stateReg === ACCESS
  io.o_ready := io.pENABLE && io.pREADY 
  io.o_resp := Cat(io.pSLVERR, io.pRDATA) 






  

}

object APBMasterGenerator extends App {
  println("Generating the hardware")
  emitVerilog(new APBInterconnect(), Array("--target-dir", "generated"))
  
}
```


#### Short summary: 

empty definition using pc, found symbol in pc: 