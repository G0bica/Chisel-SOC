FIRRTL version 1.2.0
circuit APBBridge :
  module APBBridge :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip addrStrobe : UInt<1>, flip addr : UInt<32>, flip writeStrobe : UInt<1>, flip wdata : UInt<32>, rdata : UInt<32>, ready : UInt<1>, paddr : UInt<32>, psel : UInt<1>, penable : UInt<1>, pwrite : UInt<1>, pwdata : UInt<32>, flip prdata : UInt<32>, flip pready : UInt<1>, flip pslverr : UInt<1>} @[\\src\\main\\scala\\ApbBridge.scala 11:14]

    node _bridgeEnable_T = bits(io.addr, 31, 24) @[\\src\\main\\scala\\ApbBridge.scala 30:30]
    node bridgeEnable = eq(_bridgeEnable_T, UInt<8>("h30")) @[\\src\\main\\scala\\ApbBridge.scala 30:39]
    node validRequest = and(io.addrStrobe, bridgeEnable) @[\\src\\main\\scala\\ApbBridge.scala 31:36]
    reg state : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[\\src\\main\\scala\\ApbBridge.scala 34:22]
    node _T = eq(UInt<2>("h0"), state) @[\\src\\main\\scala\\ApbBridge.scala 36:17]
    when _T : @[\\src\\main\\scala\\ApbBridge.scala 36:17]
      when validRequest : @[\\src\\main\\scala\\ApbBridge.scala 38:26]
        state <= UInt<2>("h1") @[\\src\\main\\scala\\ApbBridge.scala 38:34]
    else :
      node _T_1 = eq(UInt<2>("h1"), state) @[\\src\\main\\scala\\ApbBridge.scala 36:17]
      when _T_1 : @[\\src\\main\\scala\\ApbBridge.scala 36:17]
        state <= UInt<2>("h2") @[\\src\\main\\scala\\ApbBridge.scala 41:13]
      else :
        node _T_2 = eq(UInt<2>("h2"), state) @[\\src\\main\\scala\\ApbBridge.scala 36:17]
        when _T_2 : @[\\src\\main\\scala\\ApbBridge.scala 36:17]
          when io.pready : @[\\src\\main\\scala\\ApbBridge.scala 44:23]
            state <= UInt<2>("h0") @[\\src\\main\\scala\\ApbBridge.scala 44:31]
    io.paddr <= io.addr @[\\src\\main\\scala\\ApbBridge.scala 48:14]
    io.pwrite <= io.writeStrobe @[\\src\\main\\scala\\ApbBridge.scala 49:14]
    io.pwdata <= io.wdata @[\\src\\main\\scala\\ApbBridge.scala 50:14]
    node _io_psel_T = eq(state, UInt<2>("h1")) @[\\src\\main\\scala\\ApbBridge.scala 51:24]
    node _io_psel_T_1 = eq(state, UInt<2>("h2")) @[\\src\\main\\scala\\ApbBridge.scala 51:46]
    node _io_psel_T_2 = or(_io_psel_T, _io_psel_T_1) @[\\src\\main\\scala\\ApbBridge.scala 51:36]
    io.psel <= _io_psel_T_2 @[\\src\\main\\scala\\ApbBridge.scala 51:14]
    node _io_penable_T = eq(state, UInt<2>("h2")) @[\\src\\main\\scala\\ApbBridge.scala 52:24]
    io.penable <= _io_penable_T @[\\src\\main\\scala\\ApbBridge.scala 52:14]
    node dataOut = mux(io.pslverr, UInt<32>("hdeadfa17"), io.prdata) @[\\src\\main\\scala\\ApbBridge.scala 55:20]
    io.rdata <= dataOut @[\\src\\main\\scala\\ApbBridge.scala 57:12]
    node _io_ready_T = eq(state, UInt<2>("h2")) @[\\src\\main\\scala\\ApbBridge.scala 58:22]
    node _io_ready_T_1 = and(_io_ready_T, io.pready) @[\\src\\main\\scala\\ApbBridge.scala 58:35]
    node _io_ready_T_2 = and(_io_ready_T_1, bridgeEnable) @[\\src\\main\\scala\\ApbBridge.scala 58:48]
    io.ready <= _io_ready_T_2 @[\\src\\main\\scala\\ApbBridge.scala 58:12]

