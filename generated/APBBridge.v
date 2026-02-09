module APBBridge(
  input         clock,
  input         reset,
  input         io_addrStrobe, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  input  [31:0] io_addr, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  input         io_writeStrobe, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  input  [31:0] io_wdata, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output [31:0] io_rdata, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output        io_ready, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output [31:0] io_paddr, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output        io_psel, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output        io_penable, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output        io_pwrite, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  output [31:0] io_pwdata, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  input  [31:0] io_prdata, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  input         io_pready, // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
  input         io_pslverr // @[\\src\\main\\scala\\ApbBridge.scala 11:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  bridgeEnable = io_addr[31:24] == 8'h30; // @[\\src\\main\\scala\\ApbBridge.scala 30:39]
  wire  validRequest = io_addrStrobe & bridgeEnable; // @[\\src\\main\\scala\\ApbBridge.scala 31:36]
  reg [1:0] state; // @[\\src\\main\\scala\\ApbBridge.scala 34:22]
  wire [1:0] _GEN_1 = io_pready ? 2'h0 : state; // @[\\src\\main\\scala\\ApbBridge.scala 34:22 44:{23,31}]
  wire  _io_psel_T_1 = state == 2'h2; // @[\\src\\main\\scala\\ApbBridge.scala 51:46]
  assign io_rdata = io_pslverr ? 32'hdeadfa17 : io_prdata; // @[\\src\\main\\scala\\ApbBridge.scala 55:20]
  assign io_ready = _io_psel_T_1 & io_pready & bridgeEnable; // @[\\src\\main\\scala\\ApbBridge.scala 58:48]
  assign io_paddr = io_addr; // @[\\src\\main\\scala\\ApbBridge.scala 48:14]
  assign io_psel = state == 2'h1 | state == 2'h2; // @[\\src\\main\\scala\\ApbBridge.scala 51:36]
  assign io_penable = state == 2'h2; // @[\\src\\main\\scala\\ApbBridge.scala 52:24]
  assign io_pwrite = io_writeStrobe; // @[\\src\\main\\scala\\ApbBridge.scala 49:14]
  assign io_pwdata = io_wdata; // @[\\src\\main\\scala\\ApbBridge.scala 50:14]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\ApbBridge.scala 34:22]
      state <= 2'h0; // @[\\src\\main\\scala\\ApbBridge.scala 34:22]
    end else if (2'h0 == state) begin // @[\\src\\main\\scala\\ApbBridge.scala 36:17]
      if (validRequest) begin // @[\\src\\main\\scala\\ApbBridge.scala 38:26]
        state <= 2'h1; // @[\\src\\main\\scala\\ApbBridge.scala 38:34]
      end
    end else if (2'h1 == state) begin // @[\\src\\main\\scala\\ApbBridge.scala 36:17]
      state <= 2'h2; // @[\\src\\main\\scala\\ApbBridge.scala 41:13]
    end else if (2'h2 == state) begin // @[\\src\\main\\scala\\ApbBridge.scala 36:17]
      state <= _GEN_1;
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
  state = _RAND_0[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
