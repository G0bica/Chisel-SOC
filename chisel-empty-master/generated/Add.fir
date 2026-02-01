FIRRTL version 1.2.0
circuit Add :
  module Add :
    input clock : Clock
    input reset : UInt<1>
    output io : { led : UInt<1>, flip sw : UInt<1>} @[\\src\\main\\scala\\empty\\Add.scala 14:14]

    io.led <= io.sw @[\\src\\main\\scala\\empty\\Add.scala 19:10]

