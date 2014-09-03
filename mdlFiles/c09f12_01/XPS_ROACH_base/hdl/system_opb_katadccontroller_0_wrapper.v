//-----------------------------------------------------------------------------
// system_opb_katadccontroller_0_wrapper.v
//-----------------------------------------------------------------------------

module system_opb_katadccontroller_0_wrapper
  (
    OPB_Clk,
    OPB_Rst,
    Sl_DBus,
    Sl_errAck,
    Sl_retry,
    Sl_toutSup,
    Sl_xferAck,
    OPB_ABus,
    OPB_BE,
    OPB_DBus,
    OPB_RNW,
    OPB_select,
    OPB_seqAddr,
    adc0_adc3wire_clk,
    adc0_adc3wire_data,
    adc0_adc3wire_strobe,
    adc0_adc_reset,
    adc0_dcm_reset,
    adc0_psclk,
    adc0_psen,
    adc0_psincdec,
    adc0_psdone,
    adc0_clk,
    adc1_adc3wire_clk,
    adc1_adc3wire_data,
    adc1_adc3wire_strobe,
    adc1_adc_reset,
    adc1_dcm_reset,
    adc1_psclk,
    adc1_psen,
    adc1_psincdec,
    adc1_psdone,
    adc1_clk
  );
  input OPB_Clk;
  input OPB_Rst;
  output [0:31] Sl_DBus;
  output Sl_errAck;
  output Sl_retry;
  output Sl_toutSup;
  output Sl_xferAck;
  input [0:31] OPB_ABus;
  input [0:3] OPB_BE;
  input [0:31] OPB_DBus;
  input OPB_RNW;
  input OPB_select;
  input OPB_seqAddr;
  output adc0_adc3wire_clk;
  output adc0_adc3wire_data;
  output adc0_adc3wire_strobe;
  output adc0_adc_reset;
  output adc0_dcm_reset;
  output adc0_psclk;
  output adc0_psen;
  output adc0_psincdec;
  input adc0_psdone;
  input adc0_clk;
  output adc1_adc3wire_clk;
  output adc1_adc3wire_data;
  output adc1_adc3wire_strobe;
  output adc1_adc_reset;
  output adc1_dcm_reset;
  output adc1_psclk;
  output adc1_psen;
  output adc1_psincdec;
  input adc1_psdone;
  input adc1_clk;

  opb_katadccontroller
    #(
      .C_BASEADDR ( 32'h00020000 ),
      .C_HIGHADDR ( 32'h0002ffff ),
      .C_OPB_AWIDTH ( 32 ),
      .C_OPB_DWIDTH ( 32 ),
      .C_FAMILY ( "virtex5" ),
      .INTERLEAVED_0 ( 0 ),
      .INTERLEAVED_1 ( 0 ),
      .AUTOCONFIG_0 ( 1 ),
      .AUTOCONFIG_1 ( 1 )
    )
    opb_katadccontroller_0 (
      .OPB_Clk ( OPB_Clk ),
      .OPB_Rst ( OPB_Rst ),
      .Sl_DBus ( Sl_DBus ),
      .Sl_errAck ( Sl_errAck ),
      .Sl_retry ( Sl_retry ),
      .Sl_toutSup ( Sl_toutSup ),
      .Sl_xferAck ( Sl_xferAck ),
      .OPB_ABus ( OPB_ABus ),
      .OPB_BE ( OPB_BE ),
      .OPB_DBus ( OPB_DBus ),
      .OPB_RNW ( OPB_RNW ),
      .OPB_select ( OPB_select ),
      .OPB_seqAddr ( OPB_seqAddr ),
      .adc0_adc3wire_clk ( adc0_adc3wire_clk ),
      .adc0_adc3wire_data ( adc0_adc3wire_data ),
      .adc0_adc3wire_strobe ( adc0_adc3wire_strobe ),
      .adc0_adc_reset ( adc0_adc_reset ),
      .adc0_dcm_reset ( adc0_dcm_reset ),
      .adc0_psclk ( adc0_psclk ),
      .adc0_psen ( adc0_psen ),
      .adc0_psincdec ( adc0_psincdec ),
      .adc0_psdone ( adc0_psdone ),
      .adc0_clk ( adc0_clk ),
      .adc1_adc3wire_clk ( adc1_adc3wire_clk ),
      .adc1_adc3wire_data ( adc1_adc3wire_data ),
      .adc1_adc3wire_strobe ( adc1_adc3wire_strobe ),
      .adc1_adc_reset ( adc1_adc_reset ),
      .adc1_dcm_reset ( adc1_dcm_reset ),
      .adc1_psclk ( adc1_psclk ),
      .adc1_psen ( adc1_psen ),
      .adc1_psincdec ( adc1_psincdec ),
      .adc1_psdone ( adc1_psdone ),
      .adc1_clk ( adc1_clk )
    );

endmodule

