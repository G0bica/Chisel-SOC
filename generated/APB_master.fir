FIRRTL version 1.2.0
circuit APB_master :
  module APB_master :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip i_cmd : UInt<65>, flip i_valid : UInt<1>, o_resp : UInt<33>, o_ready : UInt<1>, pADDR : UInt<32>, pSELx : UInt<1>, pENABLE : UInt<1>, pWRITE : UInt<1>, pWDATA : UInt<32>, flip pRDATA : UInt<32>, flip pREADY : UInt<1>, flip pSLVERR : UInt<1>} @[\\src\\main\\scala\\APB_master.scala 16:14]

    reg stateReg : UInt<2>, clock with :
      reset => (reset, UInt<1>("h0")) @[\\src\\main\\scala\\APB_master.scala 41:26]
    node _T = asUInt(UInt<1>("h0")) @[\\src\\main\\scala\\APB_master.scala 43:21]
    node _T_1 = asUInt(stateReg) @[\\src\\main\\scala\\APB_master.scala 43:21]
    node _T_2 = eq(_T, _T_1) @[\\src\\main\\scala\\APB_master.scala 43:21]
    when _T_2 : @[\\src\\main\\scala\\APB_master.scala 43:21]
      when io.i_valid : @[\\src\\main\\scala\\APB_master.scala 46:24]
        stateReg <= UInt<1>("h1") @[\\src\\main\\scala\\APB_master.scala 47:18]
    else :
      node _T_3 = asUInt(UInt<1>("h1")) @[\\src\\main\\scala\\APB_master.scala 43:21]
      node _T_4 = asUInt(stateReg) @[\\src\\main\\scala\\APB_master.scala 43:21]
      node _T_5 = eq(_T_3, _T_4) @[\\src\\main\\scala\\APB_master.scala 43:21]
      when _T_5 : @[\\src\\main\\scala\\APB_master.scala 43:21]
        stateReg <= UInt<2>("h2") @[\\src\\main\\scala\\APB_master.scala 53:16]
      else :
        node _T_6 = asUInt(UInt<2>("h2")) @[\\src\\main\\scala\\APB_master.scala 43:21]
        node _T_7 = asUInt(stateReg) @[\\src\\main\\scala\\APB_master.scala 43:21]
        node _T_8 = eq(_T_6, _T_7) @[\\src\\main\\scala\\APB_master.scala 43:21]
        when _T_8 : @[\\src\\main\\scala\\APB_master.scala 43:21]
          node _T_9 = and(io.pREADY, io.i_valid) @[\\src\\main\\scala\\APB_master.scala 59:22]
          when _T_9 : @[\\src\\main\\scala\\APB_master.scala 59:36]
            stateReg <= UInt<1>("h1") @[\\src\\main\\scala\\APB_master.scala 60:18]
          else :
            node _T_10 = eq(io.i_valid, UInt<1>("h0")) @[\\src\\main\\scala\\APB_master.scala 63:30]
            node _T_11 = and(io.pREADY, _T_10) @[\\src\\main\\scala\\APB_master.scala 63:27]
            when _T_11 : @[\\src\\main\\scala\\APB_master.scala 63:42]
              stateReg <= UInt<1>("h0") @[\\src\\main\\scala\\APB_master.scala 64:18]
    node _io_pADDR_T = bits(io.i_cmd, 31, 0) @[\\src\\main\\scala\\APB_master.scala 79:23]
    io.pADDR <= _io_pADDR_T @[\\src\\main\\scala\\APB_master.scala 79:12]
    node _io_pWDATA_T = bits(io.i_cmd, 63, 32) @[\\src\\main\\scala\\APB_master.scala 80:24]
    io.pWDATA <= _io_pWDATA_T @[\\src\\main\\scala\\APB_master.scala 80:13]
    node _io_pWRITE_T = bits(io.i_cmd, 64, 64) @[\\src\\main\\scala\\APB_master.scala 81:24]
    io.pWRITE <= _io_pWRITE_T @[\\src\\main\\scala\\APB_master.scala 81:13]
    node _io_pENABLE_T = eq(stateReg, UInt<2>("h2")) @[\\src\\main\\scala\\APB_master.scala 83:26]
    io.pENABLE <= _io_pENABLE_T @[\\src\\main\\scala\\APB_master.scala 83:14]
    node _io_pSELx_T = eq(stateReg, UInt<1>("h1")) @[\\src\\main\\scala\\APB_master.scala 84:24]
    node _io_pSELx_T_1 = eq(stateReg, UInt<2>("h2")) @[\\src\\main\\scala\\APB_master.scala 84:47]
    node _io_pSELx_T_2 = or(_io_pSELx_T, _io_pSELx_T_1) @[\\src\\main\\scala\\APB_master.scala 84:35]
    io.pSELx <= _io_pSELx_T_2 @[\\src\\main\\scala\\APB_master.scala 84:12]
    node _io_o_ready_T = and(io.pENABLE, io.pREADY) @[\\src\\main\\scala\\APB_master.scala 85:28]
    io.o_ready <= _io_o_ready_T @[\\src\\main\\scala\\APB_master.scala 85:14]
    node _io_o_resp_T = cat(io.pSLVERR, io.pRDATA) @[\\src\\main\\scala\\APB_master.scala 86:19]
    io.o_resp <= _io_o_resp_T @[\\src\\main\\scala\\APB_master.scala 86:13]

