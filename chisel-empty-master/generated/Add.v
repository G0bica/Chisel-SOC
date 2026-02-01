module Add(
  input   clock,
  input   reset,
  output  io_led, // @[\\src\\main\\scala\\empty\\Add.scala 14:14]
  input   io_sw // @[\\src\\main\\scala\\empty\\Add.scala 14:14]
);
  assign io_led = io_sw; // @[\\src\\main\\scala\\empty\\Add.scala 19:10]
endmodule
