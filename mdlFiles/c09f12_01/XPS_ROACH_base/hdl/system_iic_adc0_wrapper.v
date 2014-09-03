//-----------------------------------------------------------------------------
// system_iic_adc0_wrapper.v
//-----------------------------------------------------------------------------

module system_iic_adc0_wrapper
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
    sda_i,
    sda_o,
    sda_t,
    scl_i,
    scl_o,
    scl_t,
    gain_load,
    gain_value,
    app_clk
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
  input sda_i;
  output sda_o;
  output sda_t;
  input scl_i;
  output scl_o;
  output scl_t;
  input gain_load;
  input [13:0] gain_value;
  input app_clk;

  kat_adc_iic_controller
    #(
      .C_BASEADDR ( 32'h00040000 ),
      .C_HIGHADDR ( 32'h000407ff ),
      .C_OPB_AWIDTH ( 32 ),
      .C_OPB_DWIDTH ( 32 ),
      .EN_GAIN ( 1 ),
      .CORE_FREQ ( 83333 ),
      .IIC_FREQ ( 100 )
    )
    iic_adc0 (
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
      .sda_i ( sda_i ),
      .sda_o ( sda_o ),
      .sda_t ( sda_t ),
      .scl_i ( scl_i ),
      .scl_o ( scl_o ),
      .scl_t ( scl_t ),
      .gain_load ( gain_load ),
      .gain_value ( gain_value ),
      .app_clk ( app_clk )
    );

endmodule

