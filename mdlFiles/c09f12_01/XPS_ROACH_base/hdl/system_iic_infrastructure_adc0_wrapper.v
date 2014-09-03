//-----------------------------------------------------------------------------
// system_iic_infrastructure_adc0_wrapper.v
//-----------------------------------------------------------------------------

module system_iic_infrastructure_adc0_wrapper
  (
    Sda_I,
    Sda_O,
    Sda_T,
    Scl_I,
    Scl_O,
    Scl_T,
    Sda,
    Scl
  );
  output Sda_I;
  input Sda_O;
  input Sda_T;
  output Scl_I;
  input Scl_O;
  input Scl_T;
  inout Sda;
  inout Scl;

  iic_infrastructure
    iic_infrastructure_adc0 (
      .Sda_I ( Sda_I ),
      .Sda_O ( Sda_O ),
      .Sda_T ( Sda_T ),
      .Scl_I ( Scl_I ),
      .Scl_O ( Scl_O ),
      .Scl_T ( Scl_T ),
      .Sda ( Sda ),
      .Scl ( Scl )
    );

endmodule

