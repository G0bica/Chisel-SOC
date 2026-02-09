module APB_master(
  input         clock,
  input         reset,
  input  [64:0] io_i_cmd, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  input         io_i_valid, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output [32:0] io_o_resp, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output        io_o_ready, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output [31:0] io_pADDR, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output        io_pSELx, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output        io_pENABLE, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output        io_pWRITE, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  output [31:0] io_pWDATA, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  input  [31:0] io_pRDATA, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  input         io_pREADY, // @[\\src\\main\\scala\\APB_master.scala 16:14]
  input         io_pSLVERR // @[\\src\\main\\scala\\APB_master.scala 16:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] stateReg; // @[\\src\\main\\scala\\APB_master.scala 41:26]
  wire [1:0] _GEN_1 = io_pREADY & ~io_i_valid ? 2'h0 : stateReg; // @[\\src\\main\\scala\\APB_master.scala 63:42 64:18 41:26]
  wire [1:0] _GEN_2 = io_pREADY & io_i_valid ? 2'h1 : _GEN_1; // @[\\src\\main\\scala\\APB_master.scala 59:36 60:18]
  wire  _io_pENABLE_T = stateReg == 2'h2; // @[\\src\\main\\scala\\APB_master.scala 83:26]
  assign io_o_resp = {io_pSLVERR,io_pRDATA}; // @[\\src\\main\\scala\\APB_master.scala 86:19]
  assign io_o_ready = io_pENABLE & io_pREADY; // @[\\src\\main\\scala\\APB_master.scala 85:28]
  assign io_pADDR = io_i_cmd[31:0]; // @[\\src\\main\\scala\\APB_master.scala 79:23]
  assign io_pSELx = stateReg == 2'h1 | _io_pENABLE_T; // @[\\src\\main\\scala\\APB_master.scala 84:35]
  assign io_pENABLE = stateReg == 2'h2; // @[\\src\\main\\scala\\APB_master.scala 83:26]
  assign io_pWRITE = io_i_cmd[64]; // @[\\src\\main\\scala\\APB_master.scala 81:24]
  assign io_pWDATA = io_i_cmd[63:32]; // @[\\src\\main\\scala\\APB_master.scala 80:24]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\APB_master.scala 41:26]
      stateReg <= 2'h0; // @[\\src\\main\\scala\\APB_master.scala 41:26]
    end else if (2'h0 == stateReg) begin // @[\\src\\main\\scala\\APB_master.scala 43:21]
      if (io_i_valid) begin // @[\\src\\main\\scala\\APB_master.scala 46:24]
        stateReg <= 2'h1; // @[\\src\\main\\scala\\APB_master.scala 47:18]
      end
    end else if (2'h1 == stateReg) begin // @[\\src\\main\\scala\\APB_master.scala 43:21]
      stateReg <= 2'h2; // @[\\src\\main\\scala\\APB_master.scala 53:16]
    end else if (2'h2 == stateReg) begin // @[\\src\\main\\scala\\APB_master.scala 43:21]
      stateReg <= _GEN_2;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
