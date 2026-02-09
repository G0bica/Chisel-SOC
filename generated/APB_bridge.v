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
module APB_bridge(
  input         clock,
  input         reset,
  input  [31:0] io_io_address, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input         io_io_addr_strobe, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input  [31:0] io_io_write_data, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input         io_io_write_strobe, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input         io_io_read_strobe, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output [31:0] io_io_read_data, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output        io_io_ready, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output [31:0] io_pADDR, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output        io_pSELx, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output        io_pENABLE, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output        io_pWRITE, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  output [31:0] io_pWDATA, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input  [31:0] io_pRDATA, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input         io_pREADY, // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
  input         io_pSLVERR // @[\\src\\main\\scala\\APB_bridge.scala 13:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  master_apb_clock; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_reset; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire [64:0] master_apb_io_i_cmd; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_i_valid; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire [32:0] master_apb_io_o_resp; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_o_ready; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire [31:0] master_apb_io_pADDR; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_pSELx; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_pENABLE; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_pWRITE; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire [31:0] master_apb_io_pWDATA; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire [31:0] master_apb_io_pRDATA; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_pREADY; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  wire  master_apb_io_pSLVERR; // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
  reg  delayWrite; // @[\\src\\main\\scala\\APB_bridge.scala 43:27]
  wire  bridgeEnable = io_io_address[31:24] == 8'hc0; // @[\\src\\main\\scala\\APB_bridge.scala 49:44]
  wire  valid = io_io_addr_strobe & bridgeEnable; // @[\\src\\main\\scala\\APB_bridge.scala 51:30]
  wire  write = io_io_write_strobe & ~io_io_read_strobe; // @[\\src\\main\\scala\\APB_bridge.scala 54:31]
  wire  _GEN_0 = valid ? write : delayWrite; // @[\\src\\main\\scala\\APB_bridge.scala 56:15 57:16 43:27]
  wire [32:0] cmd_hi = {_GEN_0,io_io_write_data}; // @[\\src\\main\\scala\\APB_bridge.scala 62:13]
  wire [32:0] resp = master_apb_io_o_resp; // @[\\src\\main\\scala\\APB_bridge.scala 40:19 70:9]
  wire  ready = master_apb_io_o_ready; // @[\\src\\main\\scala\\APB_bridge.scala 41:19 71:9]
  APB_master master_apb ( // @[\\src\\main\\scala\\APB_bridge.scala 65:26]
    .clock(master_apb_clock),
    .reset(master_apb_reset),
    .io_i_cmd(master_apb_io_i_cmd),
    .io_i_valid(master_apb_io_i_valid),
    .io_o_resp(master_apb_io_o_resp),
    .io_o_ready(master_apb_io_o_ready),
    .io_pADDR(master_apb_io_pADDR),
    .io_pSELx(master_apb_io_pSELx),
    .io_pENABLE(master_apb_io_pENABLE),
    .io_pWRITE(master_apb_io_pWRITE),
    .io_pWDATA(master_apb_io_pWDATA),
    .io_pRDATA(master_apb_io_pRDATA),
    .io_pREADY(master_apb_io_pREADY),
    .io_pSLVERR(master_apb_io_pSLVERR)
  );
  assign io_io_read_data = resp[32] ? 32'hdeadfa17 : resp[31:0]; // @[\\src\\main\\scala\\APB_bridge.scala 74:25]
  assign io_io_ready = ready & bridgeEnable; // @[\\src\\main\\scala\\APB_bridge.scala 80:24]
  assign io_pADDR = master_apb_io_pADDR; // @[\\src\\main\\scala\\APB_bridge.scala 82:14]
  assign io_pSELx = master_apb_io_pSELx; // @[\\src\\main\\scala\\APB_bridge.scala 83:14]
  assign io_pENABLE = master_apb_io_pENABLE; // @[\\src\\main\\scala\\APB_bridge.scala 84:14]
  assign io_pWRITE = master_apb_io_pWRITE; // @[\\src\\main\\scala\\APB_bridge.scala 85:14]
  assign io_pWDATA = master_apb_io_pWDATA; // @[\\src\\main\\scala\\APB_bridge.scala 86:14]
  assign master_apb_clock = clock;
  assign master_apb_reset = reset;
  assign master_apb_io_i_cmd = {cmd_hi,io_io_address}; // @[\\src\\main\\scala\\APB_bridge.scala 62:13]
  assign master_apb_io_i_valid = io_io_addr_strobe & bridgeEnable; // @[\\src\\main\\scala\\APB_bridge.scala 51:30]
  assign master_apb_io_pRDATA = io_pRDATA; // @[\\src\\main\\scala\\APB_bridge.scala 88:25]
  assign master_apb_io_pREADY = io_pREADY; // @[\\src\\main\\scala\\APB_bridge.scala 89:25]
  assign master_apb_io_pSLVERR = io_pSLVERR; // @[\\src\\main\\scala\\APB_bridge.scala 90:25]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\APB_bridge.scala 43:27]
      delayWrite <= 1'h0; // @[\\src\\main\\scala\\APB_bridge.scala 43:27]
    end else if (valid) begin // @[\\src\\main\\scala\\APB_bridge.scala 56:15]
      delayWrite <= write; // @[\\src\\main\\scala\\APB_bridge.scala 57:16]
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
  delayWrite = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
