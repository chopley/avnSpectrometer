-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
  port (
    sys_clk_n : in std_logic;
    sys_clk_p : in std_logic;
    dly_clk_n : in std_logic;
    dly_clk_p : in std_logic;
    aux0_clk_n : in std_logic;
    aux0_clk_p : in std_logic;
    aux1_clk_n : in std_logic;
    aux1_clk_p : in std_logic;
    epb_clk_in : in std_logic;
    epb_data : inout std_logic_vector(15 downto 0);
    epb_addr : in std_logic_vector(22 downto 0);
    epb_addr_gp : in std_logic_vector(5 downto 0);
    epb_cs_n : in std_logic;
    epb_be_n : in std_logic_vector(1 downto 0);
    epb_r_w_n : in std_logic;
    epb_oe_n : in std_logic;
    epb_rdy : out std_logic;
    ppc_irq_n : out std_logic;
    mgt_ref_clk_top_n : in std_logic;
    mgt_ref_clk_top_p : in std_logic;
    mgt_ref_clk_bottom_n : in std_logic;
    mgt_ref_clk_bottom_p : in std_logic;
    mgt_rx_top_1_n : in std_logic_vector(3 downto 0);
    mgt_rx_top_1_p : in std_logic_vector(3 downto 0);
    mgt_tx_top_1_n : out std_logic_vector(3 downto 0);
    mgt_tx_top_1_p : out std_logic_vector(3 downto 0);
    mgt_rx_top_0_n : in std_logic_vector(3 downto 0);
    mgt_rx_top_0_p : in std_logic_vector(3 downto 0);
    mgt_tx_top_0_n : out std_logic_vector(3 downto 0);
    mgt_tx_top_0_p : out std_logic_vector(3 downto 0);
    mgt_rx_bottom_1_n : in std_logic_vector(3 downto 0);
    mgt_rx_bottom_1_p : in std_logic_vector(3 downto 0);
    mgt_tx_bottom_1_n : out std_logic_vector(3 downto 0);
    mgt_tx_bottom_1_p : out std_logic_vector(3 downto 0);
    mgt_rx_bottom_0_n : in std_logic_vector(3 downto 0);
    mgt_rx_bottom_0_p : in std_logic_vector(3 downto 0);
    mgt_tx_bottom_0_n : out std_logic_vector(3 downto 0);
    mgt_tx_bottom_0_p : out std_logic_vector(3 downto 0);
    adc0_ser_clk : out std_logic;
    adc0_ser_dat : out std_logic;
    adc0_ser_cs : out std_logic;
    adc0clk_p : in std_logic;
    adc0clk_n : in std_logic;
    adc0sync_p : in std_logic;
    adc0sync_n : in std_logic;
    adc0overrange_p : in std_logic;
    adc0overrange_n : in std_logic;
    adc0di_d_p : in std_logic_vector(7 downto 0);
    adc0di_d_n : in std_logic_vector(7 downto 0);
    adc0di_p : in std_logic_vector(7 downto 0);
    adc0di_n : in std_logic_vector(7 downto 0);
    adc0dq_d_p : in std_logic_vector(7 downto 0);
    adc0dq_d_n : in std_logic_vector(7 downto 0);
    adc0dq_p : in std_logic_vector(7 downto 0);
    adc0dq_n : in std_logic_vector(7 downto 0);
    adc0rst : out std_logic;
    adc0powerdown : out std_logic;
    adc0_iic_sda : inout std_logic;
    adc0_iic_scl : inout std_logic;
    c09f12_01_leds_roach_gpioa0_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa1_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa2_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa3_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa4_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa5_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa6_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa7_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_gpioa_oe_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_led0_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_led1_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_led2_ext : out std_logic_vector(0 to 0);
    c09f12_01_leds_roach_led3_ext : out std_logic_vector(0 to 0);
    qdr0_k_n : out std_logic;
    qdr0_k : out std_logic;
    qdr0_d : out std_logic_vector(17 downto 0);
    qdr0_bw_n : out std_logic_vector(1 downto 0);
    qdr0_sa : out std_logic_vector(21 downto 0);
    qdr0_w_n : out std_logic;
    qdr0_r_n : out std_logic;
    qdr0_q : in std_logic_vector(17 downto 0);
    qdr0_cq_n : in std_logic;
    qdr0_cq : in std_logic;
    qdr0_qvld : in std_logic;
    qdr0_dll_off_n : out std_logic
  );
end system;

architecture STRUCTURE of system is

  component system_opb_katadccontroller_0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      adc0_adc3wire_clk : out std_logic;
      adc0_adc3wire_data : out std_logic;
      adc0_adc3wire_strobe : out std_logic;
      adc0_adc_reset : out std_logic;
      adc0_dcm_reset : out std_logic;
      adc0_psclk : out std_logic;
      adc0_psen : out std_logic;
      adc0_psincdec : out std_logic;
      adc0_psdone : in std_logic;
      adc0_clk : in std_logic;
      adc1_adc3wire_clk : out std_logic;
      adc1_adc3wire_data : out std_logic;
      adc1_adc3wire_strobe : out std_logic;
      adc1_adc_reset : out std_logic;
      adc1_dcm_reset : out std_logic;
      adc1_psclk : out std_logic;
      adc1_psen : out std_logic;
      adc1_psincdec : out std_logic;
      adc1_psdone : in std_logic;
      adc1_clk : in std_logic
    );
  end component;

  component system_infrastructure_inst_wrapper is
    port (
      sys_clk_n : in std_logic;
      sys_clk_p : in std_logic;
      dly_clk_n : in std_logic;
      dly_clk_p : in std_logic;
      aux0_clk_n : in std_logic;
      aux0_clk_p : in std_logic;
      aux1_clk_n : in std_logic;
      aux1_clk_p : in std_logic;
      epb_clk_in : in std_logic;
      sys_clk : out std_logic;
      sys_clk90 : out std_logic;
      sys_clk180 : out std_logic;
      sys_clk270 : out std_logic;
      sys_clk_lock : out std_logic;
      sys_clk2x : out std_logic;
      sys_clk2x90 : out std_logic;
      sys_clk2x180 : out std_logic;
      sys_clk2x270 : out std_logic;
      dly_clk : out std_logic;
      aux0_clk : out std_logic;
      aux0_clk90 : out std_logic;
      aux0_clk180 : out std_logic;
      aux0_clk270 : out std_logic;
      aux1_clk : out std_logic;
      aux1_clk90 : out std_logic;
      aux1_clk180 : out std_logic;
      aux1_clk270 : out std_logic;
      aux0_clk2x : out std_logic;
      aux0_clk2x90 : out std_logic;
      aux0_clk2x180 : out std_logic;
      aux0_clk2x270 : out std_logic;
      epb_clk : out std_logic;
      idelay_rst : in std_logic;
      idelay_rdy : out std_logic;
      op_power_on_rst : out std_logic
    );
  end component;

  component system_reset_block_inst_wrapper is
    port (
      clk : in std_logic;
      ip_async_reset_i : in std_logic;
      ip_reset_i : in std_logic;
      op_reset_o : out std_logic
    );
  end component;

  component system_opb0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : out std_logic;
      SYS_Rst : in std_logic;
      Debug_SYS_Rst : in std_logic;
      WDT_Rst : in std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      M_beXfer : in std_logic_vector(0 to 0);
      M_busLock : in std_logic_vector(0 to 0);
      M_DBus : in std_logic_vector(0 to 31);
      M_DBusEn : in std_logic_vector(0 to 0);
      M_DBusEn32_63 : in std_logic_vector(0 to 0);
      M_dwXfer : in std_logic_vector(0 to 0);
      M_fwXfer : in std_logic_vector(0 to 0);
      M_hwXfer : in std_logic_vector(0 to 0);
      M_request : in std_logic_vector(0 to 0);
      M_RNW : in std_logic_vector(0 to 0);
      M_select : in std_logic_vector(0 to 0);
      M_seqAddr : in std_logic_vector(0 to 0);
      Sl_beAck : in std_logic_vector(0 to 30);
      Sl_DBus : in std_logic_vector(0 to 991);
      Sl_DBusEn : in std_logic_vector(0 to 30);
      Sl_DBusEn32_63 : in std_logic_vector(0 to 30);
      Sl_errAck : in std_logic_vector(0 to 30);
      Sl_dwAck : in std_logic_vector(0 to 30);
      Sl_fwAck : in std_logic_vector(0 to 30);
      Sl_hwAck : in std_logic_vector(0 to 30);
      Sl_retry : in std_logic_vector(0 to 30);
      Sl_toutSup : in std_logic_vector(0 to 30);
      Sl_xferAck : in std_logic_vector(0 to 30);
      OPB_MRequest : out std_logic_vector(0 to 0);
      OPB_ABus : out std_logic_vector(0 to 31);
      OPB_BE : out std_logic_vector(0 to 3);
      OPB_beXfer : out std_logic;
      OPB_beAck : out std_logic;
      OPB_busLock : out std_logic;
      OPB_rdDBus : out std_logic_vector(0 to 31);
      OPB_wrDBus : out std_logic_vector(0 to 31);
      OPB_DBus : out std_logic_vector(0 to 31);
      OPB_errAck : out std_logic;
      OPB_dwAck : out std_logic;
      OPB_dwXfer : out std_logic;
      OPB_fwAck : out std_logic;
      OPB_fwXfer : out std_logic;
      OPB_hwAck : out std_logic;
      OPB_hwXfer : out std_logic;
      OPB_MGrant : out std_logic_vector(0 to 0);
      OPB_pendReq : out std_logic_vector(0 to 0);
      OPB_retry : out std_logic;
      OPB_RNW : out std_logic;
      OPB_select : out std_logic;
      OPB_seqAddr : out std_logic;
      OPB_timeout : out std_logic;
      OPB_toutSup : out std_logic;
      OPB_xferAck : out std_logic
    );
  end component;

  component system_epb_opb_bridge_inst_wrapper is
    port (
      epb_data_oe_n : out std_logic;
      epb_cs_n : in std_logic;
      epb_oe_n : in std_logic;
      epb_r_w_n : in std_logic;
      epb_be_n : in std_logic_vector(1 downto 0);
      epb_addr : in std_logic_vector(22 downto 0);
      epb_addr_gp : in std_logic_vector(5 downto 0);
      epb_data_i : in std_logic_vector(15 downto 0);
      epb_data_o : out std_logic_vector(15 downto 0);
      epb_rdy : out std_logic;
      epb_rdy_oe : out std_logic;
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      M_request : out std_logic;
      M_busLock : out std_logic;
      M_select : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 3);
      M_seqAddr : out std_logic;
      M_DBus : out std_logic_vector(0 to 31);
      M_ABus : out std_logic_vector(0 to 31);
      OPB_MGrant : in std_logic;
      OPB_xferAck : in std_logic;
      OPB_errAck : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31)
    );
  end component;

  component system_epb_infrastructure_inst_wrapper is
    port (
      epb_data_buf : inout std_logic_vector(15 downto 0);
      epb_data_oe_n_i : in std_logic;
      epb_data_out_i : in std_logic_vector(15 downto 0);
      epb_data_in_o : out std_logic_vector(15 downto 0);
      epb_oe_n_buf : in std_logic;
      epb_oe_n : out std_logic;
      epb_cs_n_buf : in std_logic;
      epb_cs_n : out std_logic;
      epb_r_w_n_buf : in std_logic;
      epb_r_w_n : out std_logic;
      epb_be_n_buf : in std_logic_vector(1 downto 0);
      epb_be_n : out std_logic_vector(1 downto 0);
      epb_addr_buf : in std_logic_vector(22 downto 0);
      epb_addr : out std_logic_vector(22 downto 0);
      epb_addr_gp_buf : in std_logic_vector(5 downto 0);
      epb_addr_gp : out std_logic_vector(5 downto 0);
      epb_rdy_buf : out std_logic;
      epb_rdy : in std_logic;
      epb_rdy_oe : in std_logic
    );
  end component;

  component system_sys_block_inst_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      soft_reset : out std_logic;
      irq_n : out std_logic;
      app_irq : in std_logic_vector(15 downto 0);
      fab_clk : in std_logic
    );
  end component;

  component system_xaui_infrastructure_inst_wrapper is
    port (
      mgt_refclk_t_n : in std_logic;
      mgt_refclk_t_p : in std_logic;
      mgt_refclk_b_n : in std_logic;
      mgt_refclk_b_p : in std_logic;
      mgt_rx_t1_n : in std_logic_vector(3 downto 0);
      mgt_rx_t1_p : in std_logic_vector(3 downto 0);
      mgt_tx_t1_n : out std_logic_vector(3 downto 0);
      mgt_tx_t1_p : out std_logic_vector(3 downto 0);
      mgt_rx_t0_n : in std_logic_vector(3 downto 0);
      mgt_rx_t0_p : in std_logic_vector(3 downto 0);
      mgt_tx_t0_n : out std_logic_vector(3 downto 0);
      mgt_tx_t0_p : out std_logic_vector(3 downto 0);
      mgt_rx_b1_n : in std_logic_vector(3 downto 0);
      mgt_rx_b1_p : in std_logic_vector(3 downto 0);
      mgt_tx_b1_n : out std_logic_vector(3 downto 0);
      mgt_tx_b1_p : out std_logic_vector(3 downto 0);
      mgt_rx_b0_n : in std_logic_vector(3 downto 0);
      mgt_rx_b0_p : in std_logic_vector(3 downto 0);
      mgt_tx_b0_n : out std_logic_vector(3 downto 0);
      mgt_tx_b0_p : out std_logic_vector(3 downto 0);
      reset : in std_logic;
      mgt_clk_1 : out std_logic;
      mgt_clk_0 : out std_logic;
      mgt_tx_reset_3 : in std_logic_vector(3 downto 0);
      mgt_rx_reset_3 : in std_logic_vector(3 downto 0);
      mgt_rxdata_3 : out std_logic_vector(63 downto 0);
      mgt_rxcharisk_3 : out std_logic_vector(7 downto 0);
      mgt_txdata_3 : in std_logic_vector(63 downto 0);
      mgt_txcharisk_3 : in std_logic_vector(7 downto 0);
      mgt_code_comma_3 : out std_logic_vector(7 downto 0);
      mgt_enchansync_3 : in std_logic;
      mgt_enable_align_3 : in std_logic_vector(3 downto 0);
      mgt_loopback_3 : in std_logic;
      mgt_powerdown_3 : in std_logic;
      mgt_rxlock_3 : out std_logic_vector(3 downto 0);
      mgt_syncok_3 : out std_logic_vector(3 downto 0);
      mgt_codevalid_3 : out std_logic_vector(7 downto 0);
      mgt_rxbufferr_3 : out std_logic_vector(3 downto 0);
      mgt_rxeqmix_3 : in std_logic_vector(1 downto 0);
      mgt_rxeqpole_3 : in std_logic_vector(3 downto 0);
      mgt_txpreemphasis_3 : in std_logic_vector(2 downto 0);
      mgt_txdiffctrl_3 : in std_logic_vector(2 downto 0);
      mgt_tx_reset_2 : in std_logic_vector(3 downto 0);
      mgt_rx_reset_2 : in std_logic_vector(3 downto 0);
      mgt_rxdata_2 : out std_logic_vector(63 downto 0);
      mgt_rxcharisk_2 : out std_logic_vector(7 downto 0);
      mgt_txdata_2 : in std_logic_vector(63 downto 0);
      mgt_txcharisk_2 : in std_logic_vector(7 downto 0);
      mgt_code_comma_2 : out std_logic_vector(7 downto 0);
      mgt_enchansync_2 : in std_logic;
      mgt_enable_align_2 : in std_logic_vector(3 downto 0);
      mgt_loopback_2 : in std_logic;
      mgt_powerdown_2 : in std_logic;
      mgt_rxlock_2 : out std_logic_vector(3 downto 0);
      mgt_syncok_2 : out std_logic_vector(3 downto 0);
      mgt_codevalid_2 : out std_logic_vector(7 downto 0);
      mgt_rxbufferr_2 : out std_logic_vector(3 downto 0);
      mgt_rxeqmix_2 : in std_logic_vector(1 downto 0);
      mgt_rxeqpole_2 : in std_logic_vector(3 downto 0);
      mgt_txpreemphasis_2 : in std_logic_vector(2 downto 0);
      mgt_txdiffctrl_2 : in std_logic_vector(2 downto 0);
      mgt_tx_reset_1 : in std_logic_vector(3 downto 0);
      mgt_rx_reset_1 : in std_logic_vector(3 downto 0);
      mgt_rxdata_1 : out std_logic_vector(63 downto 0);
      mgt_rxcharisk_1 : out std_logic_vector(7 downto 0);
      mgt_txdata_1 : in std_logic_vector(63 downto 0);
      mgt_txcharisk_1 : in std_logic_vector(7 downto 0);
      mgt_code_comma_1 : out std_logic_vector(7 downto 0);
      mgt_enchansync_1 : in std_logic;
      mgt_enable_align_1 : in std_logic_vector(3 downto 0);
      mgt_loopback_1 : in std_logic;
      mgt_powerdown_1 : in std_logic;
      mgt_rxlock_1 : out std_logic_vector(3 downto 0);
      mgt_syncok_1 : out std_logic_vector(3 downto 0);
      mgt_codevalid_1 : out std_logic_vector(7 downto 0);
      mgt_rxbufferr_1 : out std_logic_vector(3 downto 0);
      mgt_rxeqmix_1 : in std_logic_vector(1 downto 0);
      mgt_rxeqpole_1 : in std_logic_vector(3 downto 0);
      mgt_txpreemphasis_1 : in std_logic_vector(2 downto 0);
      mgt_txdiffctrl_1 : in std_logic_vector(2 downto 0);
      mgt_tx_reset_0 : in std_logic_vector(3 downto 0);
      mgt_rx_reset_0 : in std_logic_vector(3 downto 0);
      mgt_rxdata_0 : out std_logic_vector(63 downto 0);
      mgt_rxcharisk_0 : out std_logic_vector(7 downto 0);
      mgt_txdata_0 : in std_logic_vector(63 downto 0);
      mgt_txcharisk_0 : in std_logic_vector(7 downto 0);
      mgt_code_comma_0 : out std_logic_vector(7 downto 0);
      mgt_enchansync_0 : in std_logic;
      mgt_enable_align_0 : in std_logic_vector(3 downto 0);
      mgt_loopback_0 : in std_logic;
      mgt_powerdown_0 : in std_logic;
      mgt_rxlock_0 : out std_logic_vector(3 downto 0);
      mgt_syncok_0 : out std_logic_vector(3 downto 0);
      mgt_codevalid_0 : out std_logic_vector(7 downto 0);
      mgt_rxbufferr_0 : out std_logic_vector(3 downto 0);
      mgt_rxeqmix_0 : in std_logic_vector(1 downto 0);
      mgt_rxeqpole_0 : in std_logic_vector(3 downto 0);
      mgt_txpreemphasis_0 : in std_logic_vector(2 downto 0);
      mgt_txdiffctrl_0 : in std_logic_vector(2 downto 0)
    );
  end component;

  component system_c09f12_01_xsg_core_config_wrapper is
    port (
      clk : in std_logic;
      c09f12_01_a0_fd0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_a0_fd1_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_a1_fd0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_a1_fd1_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_ctrl0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_ctrl1_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_bram_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_bram_addr : out std_logic_vector(9 downto 0);
      c09f12_01_adc_snap0_bram_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_bram_we : out std_logic;
      c09f12_01_adc_snap0_ctrl_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_status_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_tr_en_cnt_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_trig_offset_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap0_val_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_bram_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_bram_addr : out std_logic_vector(9 downto 0);
      c09f12_01_adc_snap1_bram_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_bram_we : out std_logic;
      c09f12_01_adc_snap1_ctrl_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_status_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_tr_en_cnt_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_trig_offset_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_adc_snap1_val_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_sum_sq0_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_adc_sum_sq1_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_board_id_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_clk_frequency_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_coarse_ctrl_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_coarse_delay0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_coarse_delay1_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_control_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_delay_tr_status0_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_delay_tr_status1_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_eq0_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_eq0_addr : out std_logic_vector(11 downto 0);
      c09f12_01_eq0_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_eq0_we : out std_logic;
      c09f12_01_eq1_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_eq1_addr : out std_logic_vector(11 downto 0);
      c09f12_01_eq1_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_eq1_we : out std_logic;
      c09f12_01_fine_ctrl_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_fstatus0_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_fstatus1_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_gbe0_led_rx : in std_logic;
      c09f12_01_gbe0_led_tx : in std_logic;
      c09f12_01_gbe0_led_up : in std_logic;
      c09f12_01_gbe0_rx_bad_frame : in std_logic;
      c09f12_01_gbe0_rx_data : in std_logic_vector(63 downto 0);
      c09f12_01_gbe0_rx_end_of_frame : in std_logic;
      c09f12_01_gbe0_rx_overrun : in std_logic;
      c09f12_01_gbe0_rx_source_ip : in std_logic_vector(31 downto 0);
      c09f12_01_gbe0_rx_source_port : in std_logic_vector(15 downto 0);
      c09f12_01_gbe0_rx_valid : in std_logic;
      c09f12_01_gbe0_tx_afull : in std_logic;
      c09f12_01_gbe0_tx_overflow : in std_logic;
      c09f12_01_gbe0_rst : out std_logic;
      c09f12_01_gbe0_rx_ack : out std_logic;
      c09f12_01_gbe0_rx_overrun_ack : out std_logic;
      c09f12_01_gbe0_tx_data : out std_logic_vector(63 downto 0);
      c09f12_01_gbe0_tx_dest_ip : out std_logic_vector(31 downto 0);
      c09f12_01_gbe0_tx_dest_port : out std_logic_vector(15 downto 0);
      c09f12_01_gbe0_tx_end_of_frame : out std_logic;
      c09f12_01_gbe0_tx_valid : out std_logic;
      c09f12_01_gbe_ip0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_gbe_port_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_gbe_tx_cnt0_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_gbe_tx_err_cnt0_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_katadc0_user_data_valid : in std_logic;
      c09f12_01_katadc0_user_datai0 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_datai1 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_datai2 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_datai3 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_dataq0 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_dataq1 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_dataq2 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_dataq3 : in std_logic_vector(7 downto 0);
      c09f12_01_katadc0_user_outofrange0 : in std_logic;
      c09f12_01_katadc0_user_outofrange1 : in std_logic;
      c09f12_01_katadc0_user_sync0 : in std_logic;
      c09f12_01_katadc0_user_sync1 : in std_logic;
      c09f12_01_katadc0_user_sync2 : in std_logic;
      c09f12_01_katadc0_user_sync3 : in std_logic;
      c09f12_01_katadc0_gain_load : out std_logic;
      c09f12_01_katadc0_gain_value : out std_logic_vector(13 downto 0);
      c09f12_01_ld_time_lsw0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_ld_time_lsw1_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_ld_time_msw0_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_ld_time_msw1_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_leds_roach_gpioa0_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa1_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa2_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa3_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa4_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa5_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa6_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa7_gateway : out std_logic;
      c09f12_01_leds_roach_gpioa_oe_gateway : out std_logic;
      c09f12_01_leds_roach_led0_gateway : out std_logic;
      c09f12_01_leds_roach_led1_gateway : out std_logic;
      c09f12_01_leds_roach_led2_gateway : out std_logic;
      c09f12_01_leds_roach_led3_gateway : out std_logic;
      c09f12_01_mcount_lsw_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_mcount_msw_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_pps_count_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_qdr_ct_qdr_ack : in std_logic;
      c09f12_01_qdr_ct_qdr_cal_fail : in std_logic;
      c09f12_01_qdr_ct_qdr_data_out : in std_logic_vector(35 downto 0);
      c09f12_01_qdr_ct_qdr_phy_ready : in std_logic;
      c09f12_01_qdr_ct_qdr_address : out std_logic_vector(31 downto 0);
      c09f12_01_qdr_ct_qdr_be : out std_logic_vector(3 downto 0);
      c09f12_01_qdr_ct_qdr_data_in : out std_logic_vector(35 downto 0);
      c09f12_01_qdr_ct_qdr_rd_en : out std_logic;
      c09f12_01_qdr_ct_qdr_wr_en : out std_logic;
      c09f12_01_rcs_app_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_rcs_lib_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_rcs_user_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_snap_debug_addr_user_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_snap_debug_bram_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_snap_debug_bram_addr : out std_logic_vector(10 downto 0);
      c09f12_01_snap_debug_bram_data_in : out std_logic_vector(31 downto 0);
      c09f12_01_snap_debug_bram_we : out std_logic;
      c09f12_01_snap_debug_ctrl_user_data_out : in std_logic_vector(31 downto 0);
      c09f12_01_trig_level_user_data_out : in std_logic_vector(31 downto 0)
    );
  end component;

  component system_c09f12_01_a0_fd0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_a0_fd1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_a1_fd0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_a1_fd1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_ctrl0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_ctrl1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap0_bram_ramblk_wrapper is
    port (
      clk : in std_logic;
      bram_en_a : in std_logic;
      bram_we : in std_logic;
      bram_addr : in std_logic_vector(9 downto 0);
      bram_rd_data : out std_logic_vector(31 downto 0);
      bram_wr_data : in std_logic_vector(31 downto 0);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_adc_snap0_bram_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_adc_snap0_ctrl_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap0_status_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap0_tr_en_cnt_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap0_trig_offset_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap0_val_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap1_bram_ramblk_wrapper is
    port (
      clk : in std_logic;
      bram_en_a : in std_logic;
      bram_we : in std_logic;
      bram_addr : in std_logic_vector(9 downto 0);
      bram_rd_data : out std_logic_vector(31 downto 0);
      bram_wr_data : in std_logic_vector(31 downto 0);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_adc_snap1_bram_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_adc_snap1_ctrl_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap1_status_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap1_tr_en_cnt_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap1_trig_offset_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_snap1_val_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_sum_sq0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_adc_sum_sq1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_board_id_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_clk_frequency_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_coarse_ctrl_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_coarse_delay0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_coarse_delay1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_control_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_delay_tr_status0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_delay_tr_status1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_eq0_ramblk_wrapper is
    port (
      clk : in std_logic;
      bram_en_a : in std_logic;
      bram_we : in std_logic;
      bram_addr : in std_logic_vector(11 downto 0);
      bram_rd_data : out std_logic_vector(31 downto 0);
      bram_wr_data : in std_logic_vector(31 downto 0);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_eq0_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_eq1_ramblk_wrapper is
    port (
      clk : in std_logic;
      bram_en_a : in std_logic;
      bram_we : in std_logic;
      bram_addr : in std_logic_vector(11 downto 0);
      bram_rd_data : out std_logic_vector(31 downto 0);
      bram_wr_data : in std_logic_vector(31 downto 0);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_eq1_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_fine_ctrl_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_fstatus0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_fstatus1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_gbe0_wrapper is
    port (
      clk : in std_logic;
      rst : in std_logic;
      tx_valid : in std_logic;
      tx_afull : out std_logic;
      tx_overflow : out std_logic;
      tx_end_of_frame : in std_logic;
      tx_data : in std_logic_vector(63 downto 0);
      tx_dest_ip : in std_logic_vector(31 downto 0);
      tx_dest_port : in std_logic_vector(15 downto 0);
      rx_valid : out std_logic;
      rx_end_of_frame : out std_logic;
      rx_data : out std_logic_vector(63 downto 0);
      rx_source_ip : out std_logic_vector(31 downto 0);
      rx_source_port : out std_logic_vector(15 downto 0);
      rx_bad_frame : out std_logic;
      rx_overrun : out std_logic;
      rx_overrun_ack : in std_logic;
      rx_ack : in std_logic;
      led_up : out std_logic;
      led_rx : out std_logic;
      led_tx : out std_logic;
      xaui_clk : in std_logic;
      xgmii_txd : out std_logic_vector(63 downto 0);
      xgmii_txc : out std_logic_vector(7 downto 0);
      xgmii_rxd : in std_logic_vector(63 downto 0);
      xgmii_rxc : in std_logic_vector(7 downto 0);
      xaui_reset : in std_logic;
      xaui_status : in std_logic_vector(7 downto 0);
      mgt_rxeqmix : out std_logic_vector(1 downto 0);
      mgt_rxeqpole : out std_logic_vector(3 downto 0);
      mgt_txpreemphasis : out std_logic_vector(2 downto 0);
      mgt_txdiffctrl : out std_logic_vector(2 downto 0);
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic
    );
  end component;

  component system_xaui_phy_0_wrapper is
    port (
      reset : in std_logic;
      mgt_clk : in std_logic;
      mgt_txdata : out std_logic_vector(63 downto 0);
      mgt_txcharisk : out std_logic_vector(7 downto 0);
      mgt_rxdata : in std_logic_vector(63 downto 0);
      mgt_rxcharisk : in std_logic_vector(7 downto 0);
      mgt_enable_align : out std_logic_vector(3 downto 0);
      mgt_code_valid : in std_logic_vector(7 downto 0);
      mgt_code_comma : in std_logic_vector(7 downto 0);
      mgt_rxlock : in std_logic_vector(3 downto 0);
      mgt_rxbufferr : in std_logic_vector(3 downto 0);
      mgt_loopback : out std_logic;
      mgt_syncok : in std_logic_vector(3 downto 0);
      mgt_en_chan_sync : out std_logic;
      mgt_powerdown : out std_logic;
      mgt_rx_reset : out std_logic_vector(3 downto 0);
      mgt_tx_reset : out std_logic_vector(3 downto 0);
      xgmii_txd : in std_logic_vector(63 downto 0);
      xgmii_txc : in std_logic_vector(7 downto 0);
      xgmii_rxd : out std_logic_vector(63 downto 0);
      xgmii_rxc : out std_logic_vector(7 downto 0);
      xaui_reset : in std_logic;
      xaui_status : out std_logic_vector(7 downto 0)
    );
  end component;

  component system_c09f12_01_gbe_ip0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_gbe_port_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_gbe_tx_cnt0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_gbe_tx_err_cnt0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_katadc0_wrapper is
    port (
      adc_clk_p : in std_logic;
      adc_clk_n : in std_logic;
      adc_sync_p : in std_logic;
      adc_sync_n : in std_logic;
      adc_overrange_p : in std_logic;
      adc_overrange_n : in std_logic;
      adc_di_d_p : in std_logic_vector(7 downto 0);
      adc_di_d_n : in std_logic_vector(7 downto 0);
      adc_di_p : in std_logic_vector(7 downto 0);
      adc_di_n : in std_logic_vector(7 downto 0);
      adc_dq_d_p : in std_logic_vector(7 downto 0);
      adc_dq_d_n : in std_logic_vector(7 downto 0);
      adc_dq_p : in std_logic_vector(7 downto 0);
      adc_dq_n : in std_logic_vector(7 downto 0);
      adc_rst : out std_logic;
      adc_powerdown : out std_logic;
      user_datai0 : out std_logic_vector(7 downto 0);
      user_datai1 : out std_logic_vector(7 downto 0);
      user_datai2 : out std_logic_vector(7 downto 0);
      user_datai3 : out std_logic_vector(7 downto 0);
      user_dataq0 : out std_logic_vector(7 downto 0);
      user_dataq1 : out std_logic_vector(7 downto 0);
      user_dataq2 : out std_logic_vector(7 downto 0);
      user_dataq3 : out std_logic_vector(7 downto 0);
      user_outofrange0 : out std_logic;
      user_outofrange1 : out std_logic;
      user_sync0 : out std_logic;
      user_sync1 : out std_logic;
      user_sync2 : out std_logic;
      user_sync3 : out std_logic;
      user_data_valid : out std_logic;
      dcm_reset : in std_logic;
      ctrl_reset : in std_logic;
      ctrl_clk_in : in std_logic;
      ctrl_clk_out : out std_logic;
      ctrl_clk90_out : out std_logic;
      ctrl_clk180_out : out std_logic;
      ctrl_clk270_out : out std_logic;
      ctrl_dcm_locked : out std_logic;
      dcm_psclk : in std_logic;
      dcm_psen : in std_logic;
      dcm_psincdec : in std_logic;
      dcm_psdone : out std_logic
    );
  end component;

  component system_iic_adc0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      sda_i : in std_logic;
      sda_o : out std_logic;
      sda_t : out std_logic;
      scl_i : in std_logic;
      scl_o : out std_logic;
      scl_t : out std_logic;
      gain_load : in std_logic;
      gain_value : in std_logic_vector(13 downto 0);
      app_clk : in std_logic
    );
  end component;

  component system_iic_infrastructure_adc0_wrapper is
    port (
      Sda_I : out std_logic;
      Sda_O : in std_logic;
      Sda_T : in std_logic;
      Scl_I : out std_logic;
      Scl_O : in std_logic;
      Scl_T : in std_logic;
      Sda : inout std_logic;
      Scl : inout std_logic
    );
  end component;

  component system_c09f12_01_ld_time_lsw0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_ld_time_lsw1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_ld_time_msw0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_ld_time_msw1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa0_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa1_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa2_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa3_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa4_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa5_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa6_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa7_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_gpioa_oe_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_led0_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_led1_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_led2_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_leds_roach_led3_wrapper is
    port (
      gateway : in std_logic_vector(0 to 0);
      io_pad : out std_logic_vector(0 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

  component system_c09f12_01_mcount_lsw_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_mcount_msw_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_pps_count_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_qdr0_controller_wrapper is
    port (
      clk0 : in std_logic;
      clk180 : in std_logic;
      clk270 : in std_logic;
      div_clk : in std_logic;
      reset : in std_logic;
      idelay_rdy : in std_logic;
      qdr_k_n : out std_logic;
      qdr_k : out std_logic;
      qdr_d : out std_logic_vector(17 downto 0);
      qdr_bw_n : out std_logic_vector(1 downto 0);
      qdr_sa : out std_logic_vector(21 downto 0);
      qdr_w_n : out std_logic;
      qdr_r_n : out std_logic;
      qdr_q : in std_logic_vector(17 downto 0);
      qdr_cq_n : in std_logic;
      qdr_cq : in std_logic;
      qdr_qvld : in std_logic;
      qdr_dll_off_n : out std_logic;
      phy_rdy : out std_logic;
      cal_fail : out std_logic;
      usr_addr : in std_logic_vector(21 downto 0);
      usr_wr_strb : in std_logic;
      usr_wr_data : in std_logic_vector(35 downto 0);
      usr_wr_be : in std_logic_vector(3 downto 0);
      usr_rd_strb : in std_logic;
      usr_rd_data : out std_logic_vector(35 downto 0);
      usr_rd_dvld : out std_logic
    );
  end component;

  component system_qdr0_sniffer_wrapper is
    port (
      OPB_Clk_config : in std_logic;
      OPB_Rst_config : in std_logic;
      Sl_DBus_config : out std_logic_vector(0 to 31);
      Sl_errAck_config : out std_logic;
      Sl_retry_config : out std_logic;
      Sl_toutSup_config : out std_logic;
      Sl_xferAck_config : out std_logic;
      OPB_ABus_config : in std_logic_vector(0 to 31);
      OPB_BE_config : in std_logic_vector(0 to 3);
      OPB_DBus_config : in std_logic_vector(0 to 31);
      OPB_RNW_config : in std_logic;
      OPB_select_config : in std_logic;
      OPB_seqAddr_config : in std_logic;
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      qdr_clk : in std_logic;
      master_addr : out std_logic_vector(21 downto 0);
      master_wr_strb : out std_logic;
      master_wr_data : out std_logic_vector(35 downto 0);
      master_wr_be : out std_logic_vector(3 downto 0);
      master_rd_strb : out std_logic;
      master_rd_data : in std_logic_vector(35 downto 0);
      master_rd_dvld : in std_logic;
      slave_addr : in std_logic_vector(31 downto 0);
      slave_wr_strb : in std_logic;
      slave_wr_data : in std_logic_vector(35 downto 0);
      slave_wr_be : in std_logic_vector(3 downto 0);
      slave_rd_strb : in std_logic;
      slave_rd_data : out std_logic_vector(35 downto 0);
      slave_rd_dvld : out std_logic;
      slave_ack : out std_logic;
      phy_rdy : in std_logic;
      cal_fail : in std_logic;
      qdr_reset : out std_logic
    );
  end component;

  component system_c09f12_01_rcs_app_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_rcs_lib_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_rcs_user_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_snap_debug_addr_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_in : in std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_snap_debug_bram_ramblk_wrapper is
    port (
      clk : in std_logic;
      bram_en_a : in std_logic;
      bram_we : in std_logic;
      bram_addr : in std_logic_vector(10 downto 0);
      bram_rd_data : out std_logic_vector(31 downto 0);
      bram_wr_data : in std_logic_vector(31 downto 0);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_snap_debug_bram_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component system_c09f12_01_snap_debug_ctrl_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_c09f12_01_trig_level_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      user_data_out : out std_logic_vector(31 downto 0);
      user_clk : in std_logic
    );
  end component;

  component system_opb1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : out std_logic;
      SYS_Rst : in std_logic;
      Debug_SYS_Rst : in std_logic;
      WDT_Rst : in std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      M_beXfer : in std_logic_vector(0 to 0);
      M_busLock : in std_logic_vector(0 to 0);
      M_DBus : in std_logic_vector(0 to 31);
      M_DBusEn : in std_logic_vector(0 to 0);
      M_DBusEn32_63 : in std_logic_vector(0 to 0);
      M_dwXfer : in std_logic_vector(0 to 0);
      M_fwXfer : in std_logic_vector(0 to 0);
      M_hwXfer : in std_logic_vector(0 to 0);
      M_request : in std_logic_vector(0 to 0);
      M_RNW : in std_logic_vector(0 to 0);
      M_select : in std_logic_vector(0 to 0);
      M_seqAddr : in std_logic_vector(0 to 0);
      Sl_beAck : in std_logic_vector(0 to 26);
      Sl_DBus : in std_logic_vector(0 to 863);
      Sl_DBusEn : in std_logic_vector(0 to 26);
      Sl_DBusEn32_63 : in std_logic_vector(0 to 26);
      Sl_errAck : in std_logic_vector(0 to 26);
      Sl_dwAck : in std_logic_vector(0 to 26);
      Sl_fwAck : in std_logic_vector(0 to 26);
      Sl_hwAck : in std_logic_vector(0 to 26);
      Sl_retry : in std_logic_vector(0 to 26);
      Sl_toutSup : in std_logic_vector(0 to 26);
      Sl_xferAck : in std_logic_vector(0 to 26);
      OPB_MRequest : out std_logic_vector(0 to 0);
      OPB_ABus : out std_logic_vector(0 to 31);
      OPB_BE : out std_logic_vector(0 to 3);
      OPB_beXfer : out std_logic;
      OPB_beAck : out std_logic;
      OPB_busLock : out std_logic;
      OPB_rdDBus : out std_logic_vector(0 to 31);
      OPB_wrDBus : out std_logic_vector(0 to 31);
      OPB_DBus : out std_logic_vector(0 to 31);
      OPB_errAck : out std_logic;
      OPB_dwAck : out std_logic;
      OPB_dwXfer : out std_logic;
      OPB_fwAck : out std_logic;
      OPB_fwXfer : out std_logic;
      OPB_hwAck : out std_logic;
      OPB_hwXfer : out std_logic;
      OPB_MGrant : out std_logic_vector(0 to 0);
      OPB_pendReq : out std_logic_vector(0 to 0);
      OPB_retry : out std_logic;
      OPB_RNW : out std_logic;
      OPB_select : out std_logic;
      OPB_seqAddr : out std_logic;
      OPB_timeout : out std_logic;
      OPB_toutSup : out std_logic;
      OPB_xferAck : out std_logic
    );
  end component;

  component system_opb2opb_bridge_opb1_wrapper is
    port (
      MOPB_Clk : in std_logic;
      SOPB_Clk : in std_logic;
      MOPB_Rst : in std_logic;
      SOPB_Rst : in std_logic;
      SOPB_ABus : in std_logic_vector(0 to 31);
      SOPB_BE : in std_logic_vector(0 to 3);
      SOPB_DBus : in std_logic_vector(0 to 31);
      SOPB_RNW : in std_logic;
      SOPB_select : in std_logic;
      SOPB_seqAddr : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      M_ABus : out std_logic_vector(0 to 31);
      M_BE : out std_logic_vector(0 to 3);
      M_busLock : out std_logic;
      M_DBus : out std_logic_vector(0 to 31);
      M_request : out std_logic;
      M_RNW : out std_logic;
      M_select : out std_logic;
      M_seqAddr : out std_logic;
      MOPB_DBus : in std_logic_vector(0 to 31);
      MOPB_errAck : in std_logic;
      MOPB_MGrant : in std_logic;
      MOPB_retry : in std_logic;
      MOPB_timeout : in std_logic;
      MOPB_xferAck : in std_logic
    );
  end component;

  -- Internal signals

  signal adc0_adc3wire_clk : std_logic;
  signal adc0_adc3wire_data : std_logic;
  signal adc0_adc3wire_strobe : std_logic;
  signal adc0_adc_reset : std_logic;
  signal adc0_clk : std_logic;
  signal adc0_clk90 : std_logic;
  signal adc0_clk180 : std_logic;
  signal adc0_clk270 : std_logic;
  signal adc0_dcm_reset : std_logic;
  signal adc0_psclk : std_logic;
  signal adc0_psdone : std_logic;
  signal adc0_psen : std_logic;
  signal adc0_psincdec : std_logic;
  signal c09f12_01_a0_fd0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_a0_fd1_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_a1_fd0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_a1_fd1_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_ctrl0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_ctrl1_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_bram_addr : std_logic_vector(9 downto 0);
  signal c09f12_01_adc_snap0_bram_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_bram_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Addr : std_logic_vector(0 to 31);
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Clk : std_logic;
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Din : std_logic_vector(0 to 31);
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Dout : std_logic_vector(0 to 31);
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_EN : std_logic;
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Rst : std_logic;
  signal c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_WEN : std_logic_vector(0 to 3);
  signal c09f12_01_adc_snap0_bram_we : std_logic;
  signal c09f12_01_adc_snap0_ctrl_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_status_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_tr_en_cnt_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_trig_offset_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_val_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_bram_addr : std_logic_vector(9 downto 0);
  signal c09f12_01_adc_snap1_bram_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_bram_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Addr : std_logic_vector(0 to 31);
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Clk : std_logic;
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Din : std_logic_vector(0 to 31);
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Dout : std_logic_vector(0 to 31);
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_EN : std_logic;
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Rst : std_logic;
  signal c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_WEN : std_logic_vector(0 to 3);
  signal c09f12_01_adc_snap1_bram_we : std_logic;
  signal c09f12_01_adc_snap1_ctrl_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_status_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_tr_en_cnt_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_trig_offset_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_val_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_sum_sq0_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_adc_sum_sq1_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_board_id_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_clk_frequency_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_coarse_ctrl_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_coarse_delay0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_coarse_delay1_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_control_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_delay_tr_status0_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_delay_tr_status1_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_eq0_addr : std_logic_vector(11 downto 0);
  signal c09f12_01_eq0_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_eq0_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_eq0_ramblk_portb_BRAM_Addr : std_logic_vector(0 to 31);
  signal c09f12_01_eq0_ramblk_portb_BRAM_Clk : std_logic;
  signal c09f12_01_eq0_ramblk_portb_BRAM_Din : std_logic_vector(0 to 31);
  signal c09f12_01_eq0_ramblk_portb_BRAM_Dout : std_logic_vector(0 to 31);
  signal c09f12_01_eq0_ramblk_portb_BRAM_EN : std_logic;
  signal c09f12_01_eq0_ramblk_portb_BRAM_Rst : std_logic;
  signal c09f12_01_eq0_ramblk_portb_BRAM_WEN : std_logic_vector(0 to 3);
  signal c09f12_01_eq0_we : std_logic;
  signal c09f12_01_eq1_addr : std_logic_vector(11 downto 0);
  signal c09f12_01_eq1_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_eq1_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_eq1_ramblk_portb_BRAM_Addr : std_logic_vector(0 to 31);
  signal c09f12_01_eq1_ramblk_portb_BRAM_Clk : std_logic;
  signal c09f12_01_eq1_ramblk_portb_BRAM_Din : std_logic_vector(0 to 31);
  signal c09f12_01_eq1_ramblk_portb_BRAM_Dout : std_logic_vector(0 to 31);
  signal c09f12_01_eq1_ramblk_portb_BRAM_EN : std_logic;
  signal c09f12_01_eq1_ramblk_portb_BRAM_Rst : std_logic;
  signal c09f12_01_eq1_ramblk_portb_BRAM_WEN : std_logic_vector(0 to 3);
  signal c09f12_01_eq1_we : std_logic;
  signal c09f12_01_fine_ctrl_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_fstatus0_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_fstatus1_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_gbe0_led_rx : std_logic;
  signal c09f12_01_gbe0_led_tx : std_logic;
  signal c09f12_01_gbe0_led_up : std_logic;
  signal c09f12_01_gbe0_rst : std_logic;
  signal c09f12_01_gbe0_rx_ack : std_logic;
  signal c09f12_01_gbe0_rx_bad_frame : std_logic;
  signal c09f12_01_gbe0_rx_data : std_logic_vector(63 downto 0);
  signal c09f12_01_gbe0_rx_end_of_frame : std_logic;
  signal c09f12_01_gbe0_rx_overrun : std_logic;
  signal c09f12_01_gbe0_rx_overrun_ack : std_logic;
  signal c09f12_01_gbe0_rx_source_ip : std_logic_vector(31 downto 0);
  signal c09f12_01_gbe0_rx_source_port : std_logic_vector(15 downto 0);
  signal c09f12_01_gbe0_rx_valid : std_logic;
  signal c09f12_01_gbe0_tx_afull : std_logic;
  signal c09f12_01_gbe0_tx_data : std_logic_vector(63 downto 0);
  signal c09f12_01_gbe0_tx_dest_ip : std_logic_vector(31 downto 0);
  signal c09f12_01_gbe0_tx_dest_port : std_logic_vector(15 downto 0);
  signal c09f12_01_gbe0_tx_end_of_frame : std_logic;
  signal c09f12_01_gbe0_tx_overflow : std_logic;
  signal c09f12_01_gbe0_tx_valid : std_logic;
  signal c09f12_01_gbe_ip0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_gbe_port_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_gbe_tx_cnt0_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_gbe_tx_err_cnt0_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_katadc0_gain_load : std_logic;
  signal c09f12_01_katadc0_gain_value : std_logic_vector(13 downto 0);
  signal c09f12_01_katadc0_user_data_valid : std_logic;
  signal c09f12_01_katadc0_user_datai0 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_datai1 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_datai2 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_datai3 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq0 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq1 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq2 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq3 : std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_outofrange0 : std_logic;
  signal c09f12_01_katadc0_user_outofrange1 : std_logic;
  signal c09f12_01_katadc0_user_sync0 : std_logic;
  signal c09f12_01_katadc0_user_sync1 : std_logic;
  signal c09f12_01_katadc0_user_sync2 : std_logic;
  signal c09f12_01_katadc0_user_sync3 : std_logic;
  signal c09f12_01_ld_time_lsw0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_ld_time_lsw1_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_ld_time_msw0_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_ld_time_msw1_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_leds_roach_gpioa0_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa1_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa2_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa3_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa4_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa5_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa6_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa7_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_gpioa_oe_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_led0_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_led1_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_led2_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_leds_roach_led3_gateway : std_logic_vector(0 to 0);
  signal c09f12_01_mcount_lsw_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_mcount_msw_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_pps_count_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_qdr_ct_qdr_ack : std_logic;
  signal c09f12_01_qdr_ct_qdr_address : std_logic_vector(31 downto 0);
  signal c09f12_01_qdr_ct_qdr_be : std_logic_vector(3 downto 0);
  signal c09f12_01_qdr_ct_qdr_cal_fail : std_logic;
  signal c09f12_01_qdr_ct_qdr_data_in : std_logic_vector(35 downto 0);
  signal c09f12_01_qdr_ct_qdr_data_out : std_logic_vector(35 downto 0);
  signal c09f12_01_qdr_ct_qdr_phy_ready : std_logic;
  signal c09f12_01_qdr_ct_qdr_qdr_addr : std_logic_vector(21 downto 0);
  signal c09f12_01_qdr_ct_qdr_qdr_rd_data : std_logic_vector(35 downto 0);
  signal c09f12_01_qdr_ct_qdr_qdr_rd_dvld : std_logic;
  signal c09f12_01_qdr_ct_qdr_qdr_rd_strb : std_logic;
  signal c09f12_01_qdr_ct_qdr_qdr_wr_be : std_logic_vector(3 downto 0);
  signal c09f12_01_qdr_ct_qdr_qdr_wr_data : std_logic_vector(35 downto 0);
  signal c09f12_01_qdr_ct_qdr_qdr_wr_strb : std_logic;
  signal c09f12_01_qdr_ct_qdr_rd_en : std_logic;
  signal c09f12_01_qdr_ct_qdr_reset : std_logic;
  signal c09f12_01_qdr_ct_qdr_wr_en : std_logic;
  signal c09f12_01_rcs_app_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_rcs_lib_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_rcs_user_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_addr_user_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_bram_addr : std_logic_vector(10 downto 0);
  signal c09f12_01_snap_debug_bram_data_in : std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_bram_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Addr : std_logic_vector(0 to 31);
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Clk : std_logic;
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Din : std_logic_vector(0 to 31);
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Dout : std_logic_vector(0 to 31);
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_EN : std_logic;
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Rst : std_logic;
  signal c09f12_01_snap_debug_bram_ramblk_portb_BRAM_WEN : std_logic_vector(0 to 3);
  signal c09f12_01_snap_debug_bram_we : std_logic;
  signal c09f12_01_snap_debug_ctrl_user_data_out : std_logic_vector(31 downto 0);
  signal c09f12_01_trig_level_user_data_out : std_logic_vector(31 downto 0);
  signal dly_clk : std_logic;
  signal epb_addr_gp_int : std_logic_vector(5 downto 0);
  signal epb_addr_int : std_logic_vector(22 downto 0);
  signal epb_be_n_int : std_logic_vector(1 downto 0);
  signal epb_clk : std_logic;
  signal epb_cs_n_int : std_logic;
  signal epb_data_i : std_logic_vector(15 downto 0);
  signal epb_data_o : std_logic_vector(15 downto 0);
  signal epb_data_oe_n : std_logic;
  signal epb_oe_n_int : std_logic;
  signal epb_r_w_n_int : std_logic;
  signal epb_rdy_buf : std_logic;
  signal epb_rdy_oe : std_logic;
  signal idelay_rdy : std_logic;
  signal iic_adc0_scl_i : std_logic;
  signal iic_adc0_scl_o : std_logic;
  signal iic_adc0_scl_t : std_logic;
  signal iic_adc0_sda_i : std_logic;
  signal iic_adc0_sda_o : std_logic;
  signal iic_adc0_sda_t : std_logic;
  signal mgt_clk_0 : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(1 downto 0);
  signal net_gnd3 : std_logic_vector(2 downto 0);
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal net_gnd8 : std_logic_vector(7 downto 0);
  signal net_gnd27 : std_logic_vector(0 to 26);
  signal net_gnd31 : std_logic_vector(0 to 30);
  signal net_gnd64 : std_logic_vector(63 downto 0);
  signal net_vcc1 : std_logic_vector(0 to 0);
  signal net_vcc27 : std_logic_vector(0 to 26);
  signal net_vcc31 : std_logic_vector(0 to 30);
  signal opb0_M_ABus : std_logic_vector(0 to 31);
  signal opb0_M_BE : std_logic_vector(0 to 3);
  signal opb0_M_DBus : std_logic_vector(0 to 31);
  signal opb0_M_RNW : std_logic_vector(0 to 0);
  signal opb0_M_busLock : std_logic_vector(0 to 0);
  signal opb0_M_request : std_logic_vector(0 to 0);
  signal opb0_M_select : std_logic_vector(0 to 0);
  signal opb0_M_seqAddr : std_logic_vector(0 to 0);
  signal opb0_OPB_ABus : std_logic_vector(0 to 31);
  signal opb0_OPB_BE : std_logic_vector(0 to 3);
  signal opb0_OPB_DBus : std_logic_vector(0 to 31);
  signal opb0_OPB_MGrant : std_logic_vector(0 to 0);
  signal opb0_OPB_RNW : std_logic;
  signal opb0_OPB_Rst : std_logic;
  signal opb0_OPB_errAck : std_logic;
  signal opb0_OPB_retry : std_logic;
  signal opb0_OPB_select : std_logic;
  signal opb0_OPB_seqAddr : std_logic;
  signal opb0_OPB_timeout : std_logic;
  signal opb0_OPB_xferAck : std_logic;
  signal opb0_Sl_DBus : std_logic_vector(0 to 991);
  signal opb0_Sl_errAck : std_logic_vector(0 to 30);
  signal opb0_Sl_retry : std_logic_vector(0 to 30);
  signal opb0_Sl_toutSup : std_logic_vector(0 to 30);
  signal opb0_Sl_xferAck : std_logic_vector(0 to 30);
  signal opb1_M_ABus : std_logic_vector(0 to 31);
  signal opb1_M_BE : std_logic_vector(0 to 3);
  signal opb1_M_DBus : std_logic_vector(0 to 31);
  signal opb1_M_RNW : std_logic_vector(0 to 0);
  signal opb1_M_busLock : std_logic_vector(0 to 0);
  signal opb1_M_request : std_logic_vector(0 to 0);
  signal opb1_M_select : std_logic_vector(0 to 0);
  signal opb1_M_seqAddr : std_logic_vector(0 to 0);
  signal opb1_OPB_ABus : std_logic_vector(0 to 31);
  signal opb1_OPB_BE : std_logic_vector(0 to 3);
  signal opb1_OPB_DBus : std_logic_vector(0 to 31);
  signal opb1_OPB_MGrant : std_logic_vector(0 to 0);
  signal opb1_OPB_RNW : std_logic;
  signal opb1_OPB_Rst : std_logic;
  signal opb1_OPB_errAck : std_logic;
  signal opb1_OPB_retry : std_logic;
  signal opb1_OPB_select : std_logic;
  signal opb1_OPB_seqAddr : std_logic;
  signal opb1_OPB_timeout : std_logic;
  signal opb1_OPB_xferAck : std_logic;
  signal opb1_Sl_DBus : std_logic_vector(0 to 863);
  signal opb1_Sl_errAck : std_logic_vector(0 to 26);
  signal opb1_Sl_retry : std_logic_vector(0 to 26);
  signal opb1_Sl_toutSup : std_logic_vector(0 to 26);
  signal opb1_Sl_xferAck : std_logic_vector(0 to 26);
  signal pgassign1 : std_logic_vector(15 downto 0);
  signal power_on_rst : std_logic;
  signal sys_reset : std_logic;
  signal xaui0_mgt_rx_n : std_logic_vector(3 downto 0);
  signal xaui0_mgt_rx_p : std_logic_vector(3 downto 0);
  signal xaui0_mgt_tx_n : std_logic_vector(3 downto 0);
  signal xaui0_mgt_tx_p : std_logic_vector(3 downto 0);
  signal xaui0_ref_clk_n : std_logic;
  signal xaui0_ref_clk_p : std_logic;
  signal xaui1_mgt_rx_n : std_logic_vector(3 downto 0);
  signal xaui1_mgt_rx_p : std_logic_vector(3 downto 0);
  signal xaui1_mgt_tx_n : std_logic_vector(3 downto 0);
  signal xaui1_mgt_tx_p : std_logic_vector(3 downto 0);
  signal xaui2_mgt_rx_n : std_logic_vector(3 downto 0);
  signal xaui2_mgt_rx_p : std_logic_vector(3 downto 0);
  signal xaui2_mgt_tx_n : std_logic_vector(3 downto 0);
  signal xaui2_mgt_tx_p : std_logic_vector(3 downto 0);
  signal xaui2_ref_clk_n : std_logic;
  signal xaui2_ref_clk_p : std_logic;
  signal xaui3_mgt_rx_n : std_logic_vector(3 downto 0);
  signal xaui3_mgt_rx_p : std_logic_vector(3 downto 0);
  signal xaui3_mgt_tx_n : std_logic_vector(3 downto 0);
  signal xaui3_mgt_tx_p : std_logic_vector(3 downto 0);
  signal xaui_conf0_mgt_rxeqmix : std_logic_vector(1 downto 0);
  signal xaui_conf0_mgt_rxeqpole : std_logic_vector(3 downto 0);
  signal xaui_conf0_mgt_txdiffctrl : std_logic_vector(2 downto 0);
  signal xaui_conf0_mgt_txpreemphasis : std_logic_vector(2 downto 0);
  signal xaui_sys0_mgt_code_comma : std_logic_vector(7 downto 0);
  signal xaui_sys0_mgt_code_valid : std_logic_vector(7 downto 0);
  signal xaui_sys0_mgt_en_chan_sync : std_logic;
  signal xaui_sys0_mgt_enable_align : std_logic_vector(3 downto 0);
  signal xaui_sys0_mgt_loopback : std_logic;
  signal xaui_sys0_mgt_powerdown : std_logic;
  signal xaui_sys0_mgt_rx_charisk : std_logic_vector(7 downto 0);
  signal xaui_sys0_mgt_rx_data : std_logic_vector(63 downto 0);
  signal xaui_sys0_mgt_rx_reset : std_logic_vector(3 downto 0);
  signal xaui_sys0_mgt_rxbufferr : std_logic_vector(3 downto 0);
  signal xaui_sys0_mgt_rxlock : std_logic_vector(3 downto 0);
  signal xaui_sys0_mgt_syncok : std_logic_vector(3 downto 0);
  signal xaui_sys0_mgt_tx_charisk : std_logic_vector(7 downto 0);
  signal xaui_sys0_mgt_tx_data : std_logic_vector(63 downto 0);
  signal xaui_sys0_mgt_tx_reset : std_logic_vector(3 downto 0);
  signal xgmii0_xaui_status : std_logic_vector(7 downto 0);
  signal xgmii0_xgmii_rxc : std_logic_vector(7 downto 0);
  signal xgmii0_xgmii_rxd : std_logic_vector(63 downto 0);
  signal xgmii0_xgmii_txc : std_logic_vector(7 downto 0);
  signal xgmii0_xgmii_txd : std_logic_vector(63 downto 0);

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system_opb_katadccontroller_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_infrastructure_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_reset_block_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_opb0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_epb_opb_bridge_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_epb_infrastructure_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_sys_block_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_xaui_infrastructure_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_xsg_core_config_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_a0_fd0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_a0_fd1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_a1_fd0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_a1_fd1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_ctrl0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_ctrl1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_bram_ramblk_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_bram_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_ctrl_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_status_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_tr_en_cnt_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_trig_offset_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap0_val_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_bram_ramblk_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_bram_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_ctrl_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_status_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_tr_en_cnt_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_trig_offset_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_snap1_val_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_sum_sq0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_adc_sum_sq1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_board_id_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_clk_frequency_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_coarse_ctrl_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_coarse_delay0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_coarse_delay1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_control_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_delay_tr_status0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_delay_tr_status1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_eq0_ramblk_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_eq0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_eq1_ramblk_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_eq1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_fine_ctrl_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_fstatus0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_fstatus1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_gbe0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_xaui_phy_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_gbe_ip0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_gbe_port_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_gbe_tx_cnt0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_gbe_tx_err_cnt0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_katadc0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_iic_adc0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_iic_infrastructure_adc0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_ld_time_lsw0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_ld_time_lsw1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_ld_time_msw0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_ld_time_msw1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa2_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa3_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa4_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa5_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa6_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa7_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_gpioa_oe_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_led0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_led1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_led2_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_leds_roach_led3_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_mcount_lsw_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_mcount_msw_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_pps_count_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_qdr0_controller_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_qdr0_sniffer_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_rcs_app_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_rcs_lib_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_rcs_user_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_snap_debug_addr_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_snap_debug_bram_ramblk_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_snap_debug_bram_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_snap_debug_ctrl_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_c09f12_01_trig_level_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_opb1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_opb2opb_bridge_opb1_wrapper : component is "user_black_box";

begin

  -- Internal assignments

  xaui2_ref_clk_n <= mgt_ref_clk_top_n;
  xaui2_ref_clk_p <= mgt_ref_clk_top_p;
  xaui0_ref_clk_n <= mgt_ref_clk_bottom_n;
  xaui0_ref_clk_p <= mgt_ref_clk_bottom_p;
  xaui3_mgt_rx_n <= mgt_rx_top_1_n;
  xaui3_mgt_rx_p <= mgt_rx_top_1_p;
  mgt_tx_top_1_n <= xaui3_mgt_tx_n;
  mgt_tx_top_1_p <= xaui3_mgt_tx_p;
  xaui2_mgt_rx_n <= mgt_rx_top_0_n;
  xaui2_mgt_rx_p <= mgt_rx_top_0_p;
  mgt_tx_top_0_n <= xaui2_mgt_tx_n;
  mgt_tx_top_0_p <= xaui2_mgt_tx_p;
  xaui1_mgt_rx_n <= mgt_rx_bottom_1_n;
  xaui1_mgt_rx_p <= mgt_rx_bottom_1_p;
  mgt_tx_bottom_1_n <= xaui1_mgt_tx_n;
  mgt_tx_bottom_1_p <= xaui1_mgt_tx_p;
  xaui0_mgt_rx_n <= mgt_rx_bottom_0_n;
  xaui0_mgt_rx_p <= mgt_rx_bottom_0_p;
  mgt_tx_bottom_0_n <= xaui0_mgt_tx_n;
  mgt_tx_bottom_0_p <= xaui0_mgt_tx_p;
  adc0_ser_clk <= adc0_adc3wire_clk;
  adc0_ser_dat <= adc0_adc3wire_data;
  adc0_ser_cs <= adc0_adc3wire_strobe;
  pgassign1(15 downto 0) <= X"0000";
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd2(1 downto 0) <= B"00";
  net_gnd27(0 to 26) <= B"000000000000000000000000000";
  net_gnd3(2 downto 0) <= B"000";
  net_gnd31(0 to 30) <= B"0000000000000000000000000000000";
  net_gnd4(3 downto 0) <= B"0000";
  net_gnd64(63 downto 0) <= B"0000000000000000000000000000000000000000000000000000000000000000";
  net_gnd8(7 downto 0) <= B"00000000";
  net_vcc1(0 to 0) <= B"1";
  net_vcc27(0 to 26) <= B"111111111111111111111111111";
  net_vcc31(0 to 30) <= B"1111111111111111111111111111111";

  opb_katadccontroller_0 : system_opb_katadccontroller_0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(0 to 31),
      Sl_errAck => opb0_Sl_errAck(0),
      Sl_retry => opb0_Sl_retry(0),
      Sl_toutSup => opb0_Sl_toutSup(0),
      Sl_xferAck => opb0_Sl_xferAck(0),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      adc0_adc3wire_clk => adc0_adc3wire_clk,
      adc0_adc3wire_data => adc0_adc3wire_data,
      adc0_adc3wire_strobe => adc0_adc3wire_strobe,
      adc0_adc_reset => adc0_adc_reset,
      adc0_dcm_reset => adc0_dcm_reset,
      adc0_psclk => adc0_psclk,
      adc0_psen => adc0_psen,
      adc0_psincdec => adc0_psincdec,
      adc0_psdone => adc0_psdone,
      adc0_clk => adc0_clk,
      adc1_adc3wire_clk => open,
      adc1_adc3wire_data => open,
      adc1_adc3wire_strobe => open,
      adc1_adc_reset => open,
      adc1_dcm_reset => open,
      adc1_psclk => open,
      adc1_psen => open,
      adc1_psincdec => open,
      adc1_psdone => net_gnd0,
      adc1_clk => net_gnd0
    );

  infrastructure_inst : system_infrastructure_inst_wrapper
    port map (
      sys_clk_n => sys_clk_n,
      sys_clk_p => sys_clk_p,
      dly_clk_n => dly_clk_n,
      dly_clk_p => dly_clk_p,
      aux0_clk_n => aux0_clk_n,
      aux0_clk_p => aux0_clk_p,
      aux1_clk_n => aux1_clk_n,
      aux1_clk_p => aux1_clk_p,
      epb_clk_in => epb_clk_in,
      sys_clk => open,
      sys_clk90 => open,
      sys_clk180 => open,
      sys_clk270 => open,
      sys_clk_lock => open,
      sys_clk2x => open,
      sys_clk2x90 => open,
      sys_clk2x180 => open,
      sys_clk2x270 => open,
      dly_clk => dly_clk,
      aux0_clk => open,
      aux0_clk90 => open,
      aux0_clk180 => open,
      aux0_clk270 => open,
      aux1_clk => open,
      aux1_clk90 => open,
      aux1_clk180 => open,
      aux1_clk270 => open,
      aux0_clk2x => open,
      aux0_clk2x90 => open,
      aux0_clk2x180 => open,
      aux0_clk2x270 => open,
      epb_clk => epb_clk,
      idelay_rst => power_on_rst,
      idelay_rdy => idelay_rdy,
      op_power_on_rst => power_on_rst
    );

  reset_block_inst : system_reset_block_inst_wrapper
    port map (
      clk => epb_clk,
      ip_async_reset_i => power_on_rst,
      ip_reset_i => power_on_rst,
      op_reset_o => sys_reset
    );

  opb0 : system_opb0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      SYS_Rst => power_on_rst,
      Debug_SYS_Rst => net_gnd0,
      WDT_Rst => net_gnd0,
      M_ABus => opb0_M_ABus,
      M_BE => opb0_M_BE,
      M_beXfer => net_gnd1(0 to 0),
      M_busLock => opb0_M_busLock(0 to 0),
      M_DBus => opb0_M_DBus,
      M_DBusEn => net_gnd1(0 to 0),
      M_DBusEn32_63 => net_vcc1(0 to 0),
      M_dwXfer => net_gnd1(0 to 0),
      M_fwXfer => net_gnd1(0 to 0),
      M_hwXfer => net_gnd1(0 to 0),
      M_request => opb0_M_request(0 to 0),
      M_RNW => opb0_M_RNW(0 to 0),
      M_select => opb0_M_select(0 to 0),
      M_seqAddr => opb0_M_seqAddr(0 to 0),
      Sl_beAck => net_gnd31,
      Sl_DBus => opb0_Sl_DBus,
      Sl_DBusEn => net_vcc31,
      Sl_DBusEn32_63 => net_vcc31,
      Sl_errAck => opb0_Sl_errAck,
      Sl_dwAck => net_gnd31,
      Sl_fwAck => net_gnd31,
      Sl_hwAck => net_gnd31,
      Sl_retry => opb0_Sl_retry,
      Sl_toutSup => opb0_Sl_toutSup,
      Sl_xferAck => opb0_Sl_xferAck,
      OPB_MRequest => open,
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_beXfer => open,
      OPB_beAck => open,
      OPB_busLock => open,
      OPB_rdDBus => open,
      OPB_wrDBus => open,
      OPB_DBus => opb0_OPB_DBus,
      OPB_errAck => opb0_OPB_errAck,
      OPB_dwAck => open,
      OPB_dwXfer => open,
      OPB_fwAck => open,
      OPB_fwXfer => open,
      OPB_hwAck => open,
      OPB_hwXfer => open,
      OPB_MGrant => opb0_OPB_MGrant(0 to 0),
      OPB_pendReq => open,
      OPB_retry => opb0_OPB_retry,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      OPB_timeout => opb0_OPB_timeout,
      OPB_toutSup => open,
      OPB_xferAck => opb0_OPB_xferAck
    );

  epb_opb_bridge_inst : system_epb_opb_bridge_inst_wrapper
    port map (
      epb_data_oe_n => epb_data_oe_n,
      epb_cs_n => epb_cs_n_int,
      epb_oe_n => epb_oe_n_int,
      epb_r_w_n => epb_r_w_n_int,
      epb_be_n => epb_be_n_int,
      epb_addr => epb_addr_int,
      epb_addr_gp => epb_addr_gp_int,
      epb_data_i => epb_data_i,
      epb_data_o => epb_data_o,
      epb_rdy => epb_rdy_buf,
      epb_rdy_oe => epb_rdy_oe,
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      M_request => opb0_M_request(0),
      M_busLock => opb0_M_busLock(0),
      M_select => opb0_M_select(0),
      M_RNW => opb0_M_RNW(0),
      M_BE => opb0_M_BE,
      M_seqAddr => opb0_M_seqAddr(0),
      M_DBus => opb0_M_DBus,
      M_ABus => opb0_M_ABus,
      OPB_MGrant => opb0_OPB_MGrant(0),
      OPB_xferAck => opb0_OPB_xferAck,
      OPB_errAck => opb0_OPB_errAck,
      OPB_retry => opb0_OPB_retry,
      OPB_timeout => opb0_OPB_timeout,
      OPB_DBus => opb0_OPB_DBus
    );

  epb_infrastructure_inst : system_epb_infrastructure_inst_wrapper
    port map (
      epb_data_buf => epb_data,
      epb_data_oe_n_i => epb_data_oe_n,
      epb_data_out_i => epb_data_o,
      epb_data_in_o => epb_data_i,
      epb_oe_n_buf => epb_oe_n,
      epb_oe_n => epb_oe_n_int,
      epb_cs_n_buf => epb_cs_n,
      epb_cs_n => epb_cs_n_int,
      epb_r_w_n_buf => epb_r_w_n,
      epb_r_w_n => epb_r_w_n_int,
      epb_be_n_buf => epb_be_n,
      epb_be_n => epb_be_n_int,
      epb_addr_buf => epb_addr,
      epb_addr => epb_addr_int,
      epb_addr_gp_buf => epb_addr_gp,
      epb_addr_gp => epb_addr_gp_int,
      epb_rdy_buf => epb_rdy,
      epb_rdy => epb_rdy_buf,
      epb_rdy_oe => epb_rdy_oe
    );

  sys_block_inst : system_sys_block_inst_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(32 to 63),
      Sl_errAck => opb0_Sl_errAck(1),
      Sl_retry => opb0_Sl_retry(1),
      Sl_toutSup => opb0_Sl_toutSup(1),
      Sl_xferAck => opb0_Sl_xferAck(1),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      soft_reset => open,
      irq_n => ppc_irq_n,
      app_irq => pgassign1,
      fab_clk => adc0_clk
    );

  xaui_infrastructure_inst : system_xaui_infrastructure_inst_wrapper
    port map (
      mgt_refclk_t_n => xaui2_ref_clk_n,
      mgt_refclk_t_p => xaui2_ref_clk_p,
      mgt_refclk_b_n => xaui0_ref_clk_n,
      mgt_refclk_b_p => xaui0_ref_clk_p,
      mgt_rx_t1_n => xaui3_mgt_rx_n,
      mgt_rx_t1_p => xaui3_mgt_rx_p,
      mgt_tx_t1_n => xaui3_mgt_tx_n,
      mgt_tx_t1_p => xaui3_mgt_tx_p,
      mgt_rx_t0_n => xaui2_mgt_rx_n,
      mgt_rx_t0_p => xaui2_mgt_rx_p,
      mgt_tx_t0_n => xaui2_mgt_tx_n,
      mgt_tx_t0_p => xaui2_mgt_tx_p,
      mgt_rx_b1_n => xaui1_mgt_rx_n,
      mgt_rx_b1_p => xaui1_mgt_rx_p,
      mgt_tx_b1_n => xaui1_mgt_tx_n,
      mgt_tx_b1_p => xaui1_mgt_tx_p,
      mgt_rx_b0_n => xaui0_mgt_rx_n,
      mgt_rx_b0_p => xaui0_mgt_rx_p,
      mgt_tx_b0_n => xaui0_mgt_tx_n,
      mgt_tx_b0_p => xaui0_mgt_tx_p,
      reset => sys_reset,
      mgt_clk_1 => open,
      mgt_clk_0 => mgt_clk_0,
      mgt_tx_reset_3 => net_gnd4,
      mgt_rx_reset_3 => net_gnd4,
      mgt_rxdata_3 => open,
      mgt_rxcharisk_3 => open,
      mgt_txdata_3 => net_gnd64,
      mgt_txcharisk_3 => net_gnd8,
      mgt_code_comma_3 => open,
      mgt_enchansync_3 => net_gnd0,
      mgt_enable_align_3 => net_gnd4,
      mgt_loopback_3 => net_gnd0,
      mgt_powerdown_3 => net_gnd0,
      mgt_rxlock_3 => open,
      mgt_syncok_3 => open,
      mgt_codevalid_3 => open,
      mgt_rxbufferr_3 => open,
      mgt_rxeqmix_3 => net_gnd2,
      mgt_rxeqpole_3 => net_gnd4,
      mgt_txpreemphasis_3 => net_gnd3,
      mgt_txdiffctrl_3 => net_gnd3,
      mgt_tx_reset_2 => net_gnd4,
      mgt_rx_reset_2 => net_gnd4,
      mgt_rxdata_2 => open,
      mgt_rxcharisk_2 => open,
      mgt_txdata_2 => net_gnd64,
      mgt_txcharisk_2 => net_gnd8,
      mgt_code_comma_2 => open,
      mgt_enchansync_2 => net_gnd0,
      mgt_enable_align_2 => net_gnd4,
      mgt_loopback_2 => net_gnd0,
      mgt_powerdown_2 => net_gnd0,
      mgt_rxlock_2 => open,
      mgt_syncok_2 => open,
      mgt_codevalid_2 => open,
      mgt_rxbufferr_2 => open,
      mgt_rxeqmix_2 => net_gnd2,
      mgt_rxeqpole_2 => net_gnd4,
      mgt_txpreemphasis_2 => net_gnd3,
      mgt_txdiffctrl_2 => net_gnd3,
      mgt_tx_reset_1 => net_gnd4,
      mgt_rx_reset_1 => net_gnd4,
      mgt_rxdata_1 => open,
      mgt_rxcharisk_1 => open,
      mgt_txdata_1 => net_gnd64,
      mgt_txcharisk_1 => net_gnd8,
      mgt_code_comma_1 => open,
      mgt_enchansync_1 => net_gnd0,
      mgt_enable_align_1 => net_gnd4,
      mgt_loopback_1 => net_gnd0,
      mgt_powerdown_1 => net_gnd0,
      mgt_rxlock_1 => open,
      mgt_syncok_1 => open,
      mgt_codevalid_1 => open,
      mgt_rxbufferr_1 => open,
      mgt_rxeqmix_1 => net_gnd2,
      mgt_rxeqpole_1 => net_gnd4,
      mgt_txpreemphasis_1 => net_gnd3,
      mgt_txdiffctrl_1 => net_gnd3,
      mgt_tx_reset_0 => xaui_sys0_mgt_tx_reset,
      mgt_rx_reset_0 => xaui_sys0_mgt_rx_reset,
      mgt_rxdata_0 => xaui_sys0_mgt_rx_data,
      mgt_rxcharisk_0 => xaui_sys0_mgt_rx_charisk,
      mgt_txdata_0 => xaui_sys0_mgt_tx_data,
      mgt_txcharisk_0 => xaui_sys0_mgt_tx_charisk,
      mgt_code_comma_0 => xaui_sys0_mgt_code_comma,
      mgt_enchansync_0 => xaui_sys0_mgt_en_chan_sync,
      mgt_enable_align_0 => xaui_sys0_mgt_enable_align,
      mgt_loopback_0 => xaui_sys0_mgt_loopback,
      mgt_powerdown_0 => xaui_sys0_mgt_powerdown,
      mgt_rxlock_0 => xaui_sys0_mgt_rxlock,
      mgt_syncok_0 => xaui_sys0_mgt_syncok,
      mgt_codevalid_0 => xaui_sys0_mgt_code_valid,
      mgt_rxbufferr_0 => xaui_sys0_mgt_rxbufferr,
      mgt_rxeqmix_0 => xaui_conf0_mgt_rxeqmix,
      mgt_rxeqpole_0 => xaui_conf0_mgt_rxeqpole,
      mgt_txpreemphasis_0 => xaui_conf0_mgt_txpreemphasis,
      mgt_txdiffctrl_0 => xaui_conf0_mgt_txdiffctrl
    );

  c09f12_01_XSG_core_config : system_c09f12_01_xsg_core_config_wrapper
    port map (
      clk => adc0_clk,
      c09f12_01_a0_fd0_user_data_out => c09f12_01_a0_fd0_user_data_out,
      c09f12_01_a0_fd1_user_data_out => c09f12_01_a0_fd1_user_data_out,
      c09f12_01_a1_fd0_user_data_out => c09f12_01_a1_fd0_user_data_out,
      c09f12_01_a1_fd1_user_data_out => c09f12_01_a1_fd1_user_data_out,
      c09f12_01_adc_ctrl0_user_data_out => c09f12_01_adc_ctrl0_user_data_out,
      c09f12_01_adc_ctrl1_user_data_out => c09f12_01_adc_ctrl1_user_data_out,
      c09f12_01_adc_snap0_bram_data_out => c09f12_01_adc_snap0_bram_data_out,
      c09f12_01_adc_snap0_bram_addr => c09f12_01_adc_snap0_bram_addr,
      c09f12_01_adc_snap0_bram_data_in => c09f12_01_adc_snap0_bram_data_in,
      c09f12_01_adc_snap0_bram_we => c09f12_01_adc_snap0_bram_we,
      c09f12_01_adc_snap0_ctrl_user_data_out => c09f12_01_adc_snap0_ctrl_user_data_out,
      c09f12_01_adc_snap0_status_user_data_in => c09f12_01_adc_snap0_status_user_data_in,
      c09f12_01_adc_snap0_tr_en_cnt_user_data_in => c09f12_01_adc_snap0_tr_en_cnt_user_data_in,
      c09f12_01_adc_snap0_trig_offset_user_data_out => c09f12_01_adc_snap0_trig_offset_user_data_out,
      c09f12_01_adc_snap0_val_user_data_in => c09f12_01_adc_snap0_val_user_data_in,
      c09f12_01_adc_snap1_bram_data_out => c09f12_01_adc_snap1_bram_data_out,
      c09f12_01_adc_snap1_bram_addr => c09f12_01_adc_snap1_bram_addr,
      c09f12_01_adc_snap1_bram_data_in => c09f12_01_adc_snap1_bram_data_in,
      c09f12_01_adc_snap1_bram_we => c09f12_01_adc_snap1_bram_we,
      c09f12_01_adc_snap1_ctrl_user_data_out => c09f12_01_adc_snap1_ctrl_user_data_out,
      c09f12_01_adc_snap1_status_user_data_in => c09f12_01_adc_snap1_status_user_data_in,
      c09f12_01_adc_snap1_tr_en_cnt_user_data_in => c09f12_01_adc_snap1_tr_en_cnt_user_data_in,
      c09f12_01_adc_snap1_trig_offset_user_data_out => c09f12_01_adc_snap1_trig_offset_user_data_out,
      c09f12_01_adc_snap1_val_user_data_in => c09f12_01_adc_snap1_val_user_data_in,
      c09f12_01_adc_sum_sq0_user_data_in => c09f12_01_adc_sum_sq0_user_data_in,
      c09f12_01_adc_sum_sq1_user_data_in => c09f12_01_adc_sum_sq1_user_data_in,
      c09f12_01_board_id_user_data_out => c09f12_01_board_id_user_data_out,
      c09f12_01_clk_frequency_user_data_in => c09f12_01_clk_frequency_user_data_in,
      c09f12_01_coarse_ctrl_user_data_out => c09f12_01_coarse_ctrl_user_data_out,
      c09f12_01_coarse_delay0_user_data_out => c09f12_01_coarse_delay0_user_data_out,
      c09f12_01_coarse_delay1_user_data_out => c09f12_01_coarse_delay1_user_data_out,
      c09f12_01_control_user_data_out => c09f12_01_control_user_data_out,
      c09f12_01_delay_tr_status0_user_data_in => c09f12_01_delay_tr_status0_user_data_in,
      c09f12_01_delay_tr_status1_user_data_in => c09f12_01_delay_tr_status1_user_data_in,
      c09f12_01_eq0_data_out => c09f12_01_eq0_data_out,
      c09f12_01_eq0_addr => c09f12_01_eq0_addr,
      c09f12_01_eq0_data_in => c09f12_01_eq0_data_in,
      c09f12_01_eq0_we => c09f12_01_eq0_we,
      c09f12_01_eq1_data_out => c09f12_01_eq1_data_out,
      c09f12_01_eq1_addr => c09f12_01_eq1_addr,
      c09f12_01_eq1_data_in => c09f12_01_eq1_data_in,
      c09f12_01_eq1_we => c09f12_01_eq1_we,
      c09f12_01_fine_ctrl_user_data_out => c09f12_01_fine_ctrl_user_data_out,
      c09f12_01_fstatus0_user_data_in => c09f12_01_fstatus0_user_data_in,
      c09f12_01_fstatus1_user_data_in => c09f12_01_fstatus1_user_data_in,
      c09f12_01_gbe0_led_rx => c09f12_01_gbe0_led_rx,
      c09f12_01_gbe0_led_tx => c09f12_01_gbe0_led_tx,
      c09f12_01_gbe0_led_up => c09f12_01_gbe0_led_up,
      c09f12_01_gbe0_rx_bad_frame => c09f12_01_gbe0_rx_bad_frame,
      c09f12_01_gbe0_rx_data => c09f12_01_gbe0_rx_data,
      c09f12_01_gbe0_rx_end_of_frame => c09f12_01_gbe0_rx_end_of_frame,
      c09f12_01_gbe0_rx_overrun => c09f12_01_gbe0_rx_overrun,
      c09f12_01_gbe0_rx_source_ip => c09f12_01_gbe0_rx_source_ip,
      c09f12_01_gbe0_rx_source_port => c09f12_01_gbe0_rx_source_port,
      c09f12_01_gbe0_rx_valid => c09f12_01_gbe0_rx_valid,
      c09f12_01_gbe0_tx_afull => c09f12_01_gbe0_tx_afull,
      c09f12_01_gbe0_tx_overflow => c09f12_01_gbe0_tx_overflow,
      c09f12_01_gbe0_rst => c09f12_01_gbe0_rst,
      c09f12_01_gbe0_rx_ack => c09f12_01_gbe0_rx_ack,
      c09f12_01_gbe0_rx_overrun_ack => c09f12_01_gbe0_rx_overrun_ack,
      c09f12_01_gbe0_tx_data => c09f12_01_gbe0_tx_data,
      c09f12_01_gbe0_tx_dest_ip => c09f12_01_gbe0_tx_dest_ip,
      c09f12_01_gbe0_tx_dest_port => c09f12_01_gbe0_tx_dest_port,
      c09f12_01_gbe0_tx_end_of_frame => c09f12_01_gbe0_tx_end_of_frame,
      c09f12_01_gbe0_tx_valid => c09f12_01_gbe0_tx_valid,
      c09f12_01_gbe_ip0_user_data_out => c09f12_01_gbe_ip0_user_data_out,
      c09f12_01_gbe_port_user_data_out => c09f12_01_gbe_port_user_data_out,
      c09f12_01_gbe_tx_cnt0_user_data_in => c09f12_01_gbe_tx_cnt0_user_data_in,
      c09f12_01_gbe_tx_err_cnt0_user_data_in => c09f12_01_gbe_tx_err_cnt0_user_data_in,
      c09f12_01_katadc0_user_data_valid => c09f12_01_katadc0_user_data_valid,
      c09f12_01_katadc0_user_datai0 => c09f12_01_katadc0_user_datai0,
      c09f12_01_katadc0_user_datai1 => c09f12_01_katadc0_user_datai1,
      c09f12_01_katadc0_user_datai2 => c09f12_01_katadc0_user_datai2,
      c09f12_01_katadc0_user_datai3 => c09f12_01_katadc0_user_datai3,
      c09f12_01_katadc0_user_dataq0 => c09f12_01_katadc0_user_dataq0,
      c09f12_01_katadc0_user_dataq1 => c09f12_01_katadc0_user_dataq1,
      c09f12_01_katadc0_user_dataq2 => c09f12_01_katadc0_user_dataq2,
      c09f12_01_katadc0_user_dataq3 => c09f12_01_katadc0_user_dataq3,
      c09f12_01_katadc0_user_outofrange0 => c09f12_01_katadc0_user_outofrange0,
      c09f12_01_katadc0_user_outofrange1 => c09f12_01_katadc0_user_outofrange1,
      c09f12_01_katadc0_user_sync0 => c09f12_01_katadc0_user_sync0,
      c09f12_01_katadc0_user_sync1 => c09f12_01_katadc0_user_sync1,
      c09f12_01_katadc0_user_sync2 => c09f12_01_katadc0_user_sync2,
      c09f12_01_katadc0_user_sync3 => c09f12_01_katadc0_user_sync3,
      c09f12_01_katadc0_gain_load => c09f12_01_katadc0_gain_load,
      c09f12_01_katadc0_gain_value => c09f12_01_katadc0_gain_value,
      c09f12_01_ld_time_lsw0_user_data_out => c09f12_01_ld_time_lsw0_user_data_out,
      c09f12_01_ld_time_lsw1_user_data_out => c09f12_01_ld_time_lsw1_user_data_out,
      c09f12_01_ld_time_msw0_user_data_out => c09f12_01_ld_time_msw0_user_data_out,
      c09f12_01_ld_time_msw1_user_data_out => c09f12_01_ld_time_msw1_user_data_out,
      c09f12_01_leds_roach_gpioa0_gateway => c09f12_01_leds_roach_gpioa0_gateway(0),
      c09f12_01_leds_roach_gpioa1_gateway => c09f12_01_leds_roach_gpioa1_gateway(0),
      c09f12_01_leds_roach_gpioa2_gateway => c09f12_01_leds_roach_gpioa2_gateway(0),
      c09f12_01_leds_roach_gpioa3_gateway => c09f12_01_leds_roach_gpioa3_gateway(0),
      c09f12_01_leds_roach_gpioa4_gateway => c09f12_01_leds_roach_gpioa4_gateway(0),
      c09f12_01_leds_roach_gpioa5_gateway => c09f12_01_leds_roach_gpioa5_gateway(0),
      c09f12_01_leds_roach_gpioa6_gateway => c09f12_01_leds_roach_gpioa6_gateway(0),
      c09f12_01_leds_roach_gpioa7_gateway => c09f12_01_leds_roach_gpioa7_gateway(0),
      c09f12_01_leds_roach_gpioa_oe_gateway => c09f12_01_leds_roach_gpioa_oe_gateway(0),
      c09f12_01_leds_roach_led0_gateway => c09f12_01_leds_roach_led0_gateway(0),
      c09f12_01_leds_roach_led1_gateway => c09f12_01_leds_roach_led1_gateway(0),
      c09f12_01_leds_roach_led2_gateway => c09f12_01_leds_roach_led2_gateway(0),
      c09f12_01_leds_roach_led3_gateway => c09f12_01_leds_roach_led3_gateway(0),
      c09f12_01_mcount_lsw_user_data_in => c09f12_01_mcount_lsw_user_data_in,
      c09f12_01_mcount_msw_user_data_in => c09f12_01_mcount_msw_user_data_in,
      c09f12_01_pps_count_user_data_in => c09f12_01_pps_count_user_data_in,
      c09f12_01_qdr_ct_qdr_ack => c09f12_01_qdr_ct_qdr_ack,
      c09f12_01_qdr_ct_qdr_cal_fail => c09f12_01_qdr_ct_qdr_cal_fail,
      c09f12_01_qdr_ct_qdr_data_out => c09f12_01_qdr_ct_qdr_data_out,
      c09f12_01_qdr_ct_qdr_phy_ready => c09f12_01_qdr_ct_qdr_phy_ready,
      c09f12_01_qdr_ct_qdr_address => c09f12_01_qdr_ct_qdr_address,
      c09f12_01_qdr_ct_qdr_be => c09f12_01_qdr_ct_qdr_be,
      c09f12_01_qdr_ct_qdr_data_in => c09f12_01_qdr_ct_qdr_data_in,
      c09f12_01_qdr_ct_qdr_rd_en => c09f12_01_qdr_ct_qdr_rd_en,
      c09f12_01_qdr_ct_qdr_wr_en => c09f12_01_qdr_ct_qdr_wr_en,
      c09f12_01_rcs_app_user_data_in => c09f12_01_rcs_app_user_data_in,
      c09f12_01_rcs_lib_user_data_in => c09f12_01_rcs_lib_user_data_in,
      c09f12_01_rcs_user_user_data_in => c09f12_01_rcs_user_user_data_in,
      c09f12_01_snap_debug_addr_user_data_in => c09f12_01_snap_debug_addr_user_data_in,
      c09f12_01_snap_debug_bram_data_out => c09f12_01_snap_debug_bram_data_out,
      c09f12_01_snap_debug_bram_addr => c09f12_01_snap_debug_bram_addr,
      c09f12_01_snap_debug_bram_data_in => c09f12_01_snap_debug_bram_data_in,
      c09f12_01_snap_debug_bram_we => c09f12_01_snap_debug_bram_we,
      c09f12_01_snap_debug_ctrl_user_data_out => c09f12_01_snap_debug_ctrl_user_data_out,
      c09f12_01_trig_level_user_data_out => c09f12_01_trig_level_user_data_out
    );

  c09f12_01_a0_fd0 : system_c09f12_01_a0_fd0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(64 to 95),
      Sl_errAck => opb0_Sl_errAck(2),
      Sl_retry => opb0_Sl_retry(2),
      Sl_toutSup => opb0_Sl_toutSup(2),
      Sl_xferAck => opb0_Sl_xferAck(2),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_a0_fd0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_a0_fd1 : system_c09f12_01_a0_fd1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(96 to 127),
      Sl_errAck => opb0_Sl_errAck(3),
      Sl_retry => opb0_Sl_retry(3),
      Sl_toutSup => opb0_Sl_toutSup(3),
      Sl_xferAck => opb0_Sl_xferAck(3),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_a0_fd1_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_a1_fd0 : system_c09f12_01_a1_fd0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(128 to 159),
      Sl_errAck => opb0_Sl_errAck(4),
      Sl_retry => opb0_Sl_retry(4),
      Sl_toutSup => opb0_Sl_toutSup(4),
      Sl_xferAck => opb0_Sl_xferAck(4),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_a1_fd0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_a1_fd1 : system_c09f12_01_a1_fd1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(160 to 191),
      Sl_errAck => opb0_Sl_errAck(5),
      Sl_retry => opb0_Sl_retry(5),
      Sl_toutSup => opb0_Sl_toutSup(5),
      Sl_xferAck => opb0_Sl_xferAck(5),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_a1_fd1_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_ctrl0 : system_c09f12_01_adc_ctrl0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(192 to 223),
      Sl_errAck => opb0_Sl_errAck(6),
      Sl_retry => opb0_Sl_retry(6),
      Sl_toutSup => opb0_Sl_toutSup(6),
      Sl_xferAck => opb0_Sl_xferAck(6),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_adc_ctrl0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_ctrl1 : system_c09f12_01_adc_ctrl1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(224 to 255),
      Sl_errAck => opb0_Sl_errAck(7),
      Sl_retry => opb0_Sl_retry(7),
      Sl_toutSup => opb0_Sl_toutSup(7),
      Sl_xferAck => opb0_Sl_xferAck(7),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_adc_ctrl1_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap0_bram_ramblk : system_c09f12_01_adc_snap0_bram_ramblk_wrapper
    port map (
      clk => adc0_clk,
      bram_en_a => net_gnd0,
      bram_we => c09f12_01_adc_snap0_bram_we,
      bram_addr => c09f12_01_adc_snap0_bram_addr,
      bram_rd_data => c09f12_01_adc_snap0_bram_data_out,
      bram_wr_data => c09f12_01_adc_snap0_bram_data_in,
      BRAM_Rst_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Rst,
      BRAM_Clk_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Clk,
      BRAM_EN_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_EN,
      BRAM_WEN_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_WEN,
      BRAM_Addr_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Addr,
      BRAM_Din_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Din,
      BRAM_Dout_B => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Dout
    );

  c09f12_01_adc_snap0_bram : system_c09f12_01_adc_snap0_bram_wrapper
    port map (
      opb_clk => epb_clk,
      opb_rst => opb0_OPB_Rst,
      opb_abus => opb0_OPB_ABus,
      opb_dbus => opb0_OPB_DBus,
      sln_dbus => opb0_Sl_DBus(256 to 287),
      opb_select => opb0_OPB_select,
      opb_rnw => opb0_OPB_RNW,
      opb_seqaddr => opb0_OPB_seqAddr,
      opb_be => opb0_OPB_BE,
      sln_xferack => opb0_Sl_xferAck(8),
      sln_errack => opb0_Sl_errAck(8),
      sln_toutsup => opb0_Sl_toutSup(8),
      sln_retry => opb0_Sl_retry(8),
      bram_rst => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Rst,
      bram_clk => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Clk,
      bram_en => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_EN,
      bram_wen => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_WEN,
      bram_addr => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Addr,
      bram_din => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Din,
      bram_dout => c09f12_01_adc_snap0_bram_ramblk_portb_BRAM_Dout
    );

  c09f12_01_adc_snap0_ctrl : system_c09f12_01_adc_snap0_ctrl_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(288 to 319),
      Sl_errAck => opb0_Sl_errAck(9),
      Sl_retry => opb0_Sl_retry(9),
      Sl_toutSup => opb0_Sl_toutSup(9),
      Sl_xferAck => opb0_Sl_xferAck(9),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_adc_snap0_ctrl_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap0_status : system_c09f12_01_adc_snap0_status_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(320 to 351),
      Sl_errAck => opb0_Sl_errAck(10),
      Sl_retry => opb0_Sl_retry(10),
      Sl_toutSup => opb0_Sl_toutSup(10),
      Sl_xferAck => opb0_Sl_xferAck(10),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_snap0_status_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap0_tr_en_cnt : system_c09f12_01_adc_snap0_tr_en_cnt_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(352 to 383),
      Sl_errAck => opb0_Sl_errAck(11),
      Sl_retry => opb0_Sl_retry(11),
      Sl_toutSup => opb0_Sl_toutSup(11),
      Sl_xferAck => opb0_Sl_xferAck(11),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_snap0_tr_en_cnt_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap0_trig_offset : system_c09f12_01_adc_snap0_trig_offset_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(384 to 415),
      Sl_errAck => opb0_Sl_errAck(12),
      Sl_retry => opb0_Sl_retry(12),
      Sl_toutSup => opb0_Sl_toutSup(12),
      Sl_xferAck => opb0_Sl_xferAck(12),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_adc_snap0_trig_offset_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap0_val : system_c09f12_01_adc_snap0_val_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(416 to 447),
      Sl_errAck => opb0_Sl_errAck(13),
      Sl_retry => opb0_Sl_retry(13),
      Sl_toutSup => opb0_Sl_toutSup(13),
      Sl_xferAck => opb0_Sl_xferAck(13),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_snap0_val_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap1_bram_ramblk : system_c09f12_01_adc_snap1_bram_ramblk_wrapper
    port map (
      clk => adc0_clk,
      bram_en_a => net_gnd0,
      bram_we => c09f12_01_adc_snap1_bram_we,
      bram_addr => c09f12_01_adc_snap1_bram_addr,
      bram_rd_data => c09f12_01_adc_snap1_bram_data_out,
      bram_wr_data => c09f12_01_adc_snap1_bram_data_in,
      BRAM_Rst_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Rst,
      BRAM_Clk_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Clk,
      BRAM_EN_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_EN,
      BRAM_WEN_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_WEN,
      BRAM_Addr_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Addr,
      BRAM_Din_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Din,
      BRAM_Dout_B => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Dout
    );

  c09f12_01_adc_snap1_bram : system_c09f12_01_adc_snap1_bram_wrapper
    port map (
      opb_clk => epb_clk,
      opb_rst => opb0_OPB_Rst,
      opb_abus => opb0_OPB_ABus,
      opb_dbus => opb0_OPB_DBus,
      sln_dbus => opb0_Sl_DBus(448 to 479),
      opb_select => opb0_OPB_select,
      opb_rnw => opb0_OPB_RNW,
      opb_seqaddr => opb0_OPB_seqAddr,
      opb_be => opb0_OPB_BE,
      sln_xferack => opb0_Sl_xferAck(14),
      sln_errack => opb0_Sl_errAck(14),
      sln_toutsup => opb0_Sl_toutSup(14),
      sln_retry => opb0_Sl_retry(14),
      bram_rst => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Rst,
      bram_clk => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Clk,
      bram_en => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_EN,
      bram_wen => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_WEN,
      bram_addr => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Addr,
      bram_din => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Din,
      bram_dout => c09f12_01_adc_snap1_bram_ramblk_portb_BRAM_Dout
    );

  c09f12_01_adc_snap1_ctrl : system_c09f12_01_adc_snap1_ctrl_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(480 to 511),
      Sl_errAck => opb0_Sl_errAck(15),
      Sl_retry => opb0_Sl_retry(15),
      Sl_toutSup => opb0_Sl_toutSup(15),
      Sl_xferAck => opb0_Sl_xferAck(15),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_adc_snap1_ctrl_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap1_status : system_c09f12_01_adc_snap1_status_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(512 to 543),
      Sl_errAck => opb0_Sl_errAck(16),
      Sl_retry => opb0_Sl_retry(16),
      Sl_toutSup => opb0_Sl_toutSup(16),
      Sl_xferAck => opb0_Sl_xferAck(16),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_snap1_status_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap1_tr_en_cnt : system_c09f12_01_adc_snap1_tr_en_cnt_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(544 to 575),
      Sl_errAck => opb0_Sl_errAck(17),
      Sl_retry => opb0_Sl_retry(17),
      Sl_toutSup => opb0_Sl_toutSup(17),
      Sl_xferAck => opb0_Sl_xferAck(17),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_snap1_tr_en_cnt_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap1_trig_offset : system_c09f12_01_adc_snap1_trig_offset_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(576 to 607),
      Sl_errAck => opb0_Sl_errAck(18),
      Sl_retry => opb0_Sl_retry(18),
      Sl_toutSup => opb0_Sl_toutSup(18),
      Sl_xferAck => opb0_Sl_xferAck(18),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_adc_snap1_trig_offset_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_adc_snap1_val : system_c09f12_01_adc_snap1_val_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(608 to 639),
      Sl_errAck => opb0_Sl_errAck(19),
      Sl_retry => opb0_Sl_retry(19),
      Sl_toutSup => opb0_Sl_toutSup(19),
      Sl_xferAck => opb0_Sl_xferAck(19),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_snap1_val_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_sum_sq0 : system_c09f12_01_adc_sum_sq0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(640 to 671),
      Sl_errAck => opb0_Sl_errAck(20),
      Sl_retry => opb0_Sl_retry(20),
      Sl_toutSup => opb0_Sl_toutSup(20),
      Sl_xferAck => opb0_Sl_xferAck(20),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_sum_sq0_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_adc_sum_sq1 : system_c09f12_01_adc_sum_sq1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(672 to 703),
      Sl_errAck => opb0_Sl_errAck(21),
      Sl_retry => opb0_Sl_retry(21),
      Sl_toutSup => opb0_Sl_toutSup(21),
      Sl_xferAck => opb0_Sl_xferAck(21),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_adc_sum_sq1_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_board_id : system_c09f12_01_board_id_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(704 to 735),
      Sl_errAck => opb0_Sl_errAck(22),
      Sl_retry => opb0_Sl_retry(22),
      Sl_toutSup => opb0_Sl_toutSup(22),
      Sl_xferAck => opb0_Sl_xferAck(22),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_board_id_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_clk_frequency : system_c09f12_01_clk_frequency_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(736 to 767),
      Sl_errAck => opb0_Sl_errAck(23),
      Sl_retry => opb0_Sl_retry(23),
      Sl_toutSup => opb0_Sl_toutSup(23),
      Sl_xferAck => opb0_Sl_xferAck(23),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_in => c09f12_01_clk_frequency_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_coarse_ctrl : system_c09f12_01_coarse_ctrl_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(768 to 799),
      Sl_errAck => opb0_Sl_errAck(24),
      Sl_retry => opb0_Sl_retry(24),
      Sl_toutSup => opb0_Sl_toutSup(24),
      Sl_xferAck => opb0_Sl_xferAck(24),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_coarse_ctrl_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_coarse_delay0 : system_c09f12_01_coarse_delay0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(800 to 831),
      Sl_errAck => opb0_Sl_errAck(25),
      Sl_retry => opb0_Sl_retry(25),
      Sl_toutSup => opb0_Sl_toutSup(25),
      Sl_xferAck => opb0_Sl_xferAck(25),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_coarse_delay0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_coarse_delay1 : system_c09f12_01_coarse_delay1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(832 to 863),
      Sl_errAck => opb0_Sl_errAck(26),
      Sl_retry => opb0_Sl_retry(26),
      Sl_toutSup => opb0_Sl_toutSup(26),
      Sl_xferAck => opb0_Sl_xferAck(26),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      user_data_out => c09f12_01_coarse_delay1_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_control : system_c09f12_01_control_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(0 to 31),
      Sl_errAck => opb1_Sl_errAck(0),
      Sl_retry => opb1_Sl_retry(0),
      Sl_toutSup => opb1_Sl_toutSup(0),
      Sl_xferAck => opb1_Sl_xferAck(0),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_control_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_delay_tr_status0 : system_c09f12_01_delay_tr_status0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(32 to 63),
      Sl_errAck => opb1_Sl_errAck(1),
      Sl_retry => opb1_Sl_retry(1),
      Sl_toutSup => opb1_Sl_toutSup(1),
      Sl_xferAck => opb1_Sl_xferAck(1),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_delay_tr_status0_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_delay_tr_status1 : system_c09f12_01_delay_tr_status1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(64 to 95),
      Sl_errAck => opb1_Sl_errAck(2),
      Sl_retry => opb1_Sl_retry(2),
      Sl_toutSup => opb1_Sl_toutSup(2),
      Sl_xferAck => opb1_Sl_xferAck(2),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_delay_tr_status1_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_eq0_ramblk : system_c09f12_01_eq0_ramblk_wrapper
    port map (
      clk => adc0_clk,
      bram_en_a => net_gnd0,
      bram_we => c09f12_01_eq0_we,
      bram_addr => c09f12_01_eq0_addr,
      bram_rd_data => c09f12_01_eq0_data_out,
      bram_wr_data => c09f12_01_eq0_data_in,
      BRAM_Rst_B => c09f12_01_eq0_ramblk_portb_BRAM_Rst,
      BRAM_Clk_B => c09f12_01_eq0_ramblk_portb_BRAM_Clk,
      BRAM_EN_B => c09f12_01_eq0_ramblk_portb_BRAM_EN,
      BRAM_WEN_B => c09f12_01_eq0_ramblk_portb_BRAM_WEN,
      BRAM_Addr_B => c09f12_01_eq0_ramblk_portb_BRAM_Addr,
      BRAM_Din_B => c09f12_01_eq0_ramblk_portb_BRAM_Din,
      BRAM_Dout_B => c09f12_01_eq0_ramblk_portb_BRAM_Dout
    );

  c09f12_01_eq0 : system_c09f12_01_eq0_wrapper
    port map (
      opb_clk => epb_clk,
      opb_rst => opb1_OPB_Rst,
      opb_abus => opb1_OPB_ABus,
      opb_dbus => opb1_OPB_DBus,
      sln_dbus => opb1_Sl_DBus(96 to 127),
      opb_select => opb1_OPB_select,
      opb_rnw => opb1_OPB_RNW,
      opb_seqaddr => opb1_OPB_seqAddr,
      opb_be => opb1_OPB_BE,
      sln_xferack => opb1_Sl_xferAck(3),
      sln_errack => opb1_Sl_errAck(3),
      sln_toutsup => opb1_Sl_toutSup(3),
      sln_retry => opb1_Sl_retry(3),
      bram_rst => c09f12_01_eq0_ramblk_portb_BRAM_Rst,
      bram_clk => c09f12_01_eq0_ramblk_portb_BRAM_Clk,
      bram_en => c09f12_01_eq0_ramblk_portb_BRAM_EN,
      bram_wen => c09f12_01_eq0_ramblk_portb_BRAM_WEN,
      bram_addr => c09f12_01_eq0_ramblk_portb_BRAM_Addr,
      bram_din => c09f12_01_eq0_ramblk_portb_BRAM_Din,
      bram_dout => c09f12_01_eq0_ramblk_portb_BRAM_Dout
    );

  c09f12_01_eq1_ramblk : system_c09f12_01_eq1_ramblk_wrapper
    port map (
      clk => adc0_clk,
      bram_en_a => net_gnd0,
      bram_we => c09f12_01_eq1_we,
      bram_addr => c09f12_01_eq1_addr,
      bram_rd_data => c09f12_01_eq1_data_out,
      bram_wr_data => c09f12_01_eq1_data_in,
      BRAM_Rst_B => c09f12_01_eq1_ramblk_portb_BRAM_Rst,
      BRAM_Clk_B => c09f12_01_eq1_ramblk_portb_BRAM_Clk,
      BRAM_EN_B => c09f12_01_eq1_ramblk_portb_BRAM_EN,
      BRAM_WEN_B => c09f12_01_eq1_ramblk_portb_BRAM_WEN,
      BRAM_Addr_B => c09f12_01_eq1_ramblk_portb_BRAM_Addr,
      BRAM_Din_B => c09f12_01_eq1_ramblk_portb_BRAM_Din,
      BRAM_Dout_B => c09f12_01_eq1_ramblk_portb_BRAM_Dout
    );

  c09f12_01_eq1 : system_c09f12_01_eq1_wrapper
    port map (
      opb_clk => epb_clk,
      opb_rst => opb1_OPB_Rst,
      opb_abus => opb1_OPB_ABus,
      opb_dbus => opb1_OPB_DBus,
      sln_dbus => opb1_Sl_DBus(128 to 159),
      opb_select => opb1_OPB_select,
      opb_rnw => opb1_OPB_RNW,
      opb_seqaddr => opb1_OPB_seqAddr,
      opb_be => opb1_OPB_BE,
      sln_xferack => opb1_Sl_xferAck(4),
      sln_errack => opb1_Sl_errAck(4),
      sln_toutsup => opb1_Sl_toutSup(4),
      sln_retry => opb1_Sl_retry(4),
      bram_rst => c09f12_01_eq1_ramblk_portb_BRAM_Rst,
      bram_clk => c09f12_01_eq1_ramblk_portb_BRAM_Clk,
      bram_en => c09f12_01_eq1_ramblk_portb_BRAM_EN,
      bram_wen => c09f12_01_eq1_ramblk_portb_BRAM_WEN,
      bram_addr => c09f12_01_eq1_ramblk_portb_BRAM_Addr,
      bram_din => c09f12_01_eq1_ramblk_portb_BRAM_Din,
      bram_dout => c09f12_01_eq1_ramblk_portb_BRAM_Dout
    );

  c09f12_01_fine_ctrl : system_c09f12_01_fine_ctrl_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(160 to 191),
      Sl_errAck => opb1_Sl_errAck(5),
      Sl_retry => opb1_Sl_retry(5),
      Sl_toutSup => opb1_Sl_toutSup(5),
      Sl_xferAck => opb1_Sl_xferAck(5),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_fine_ctrl_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_fstatus0 : system_c09f12_01_fstatus0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(192 to 223),
      Sl_errAck => opb1_Sl_errAck(6),
      Sl_retry => opb1_Sl_retry(6),
      Sl_toutSup => opb1_Sl_toutSup(6),
      Sl_xferAck => opb1_Sl_xferAck(6),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_fstatus0_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_fstatus1 : system_c09f12_01_fstatus1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(224 to 255),
      Sl_errAck => opb1_Sl_errAck(7),
      Sl_retry => opb1_Sl_retry(7),
      Sl_toutSup => opb1_Sl_toutSup(7),
      Sl_xferAck => opb1_Sl_xferAck(7),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_fstatus1_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_gbe0 : system_c09f12_01_gbe0_wrapper
    port map (
      clk => adc0_clk,
      rst => c09f12_01_gbe0_rst,
      tx_valid => c09f12_01_gbe0_tx_valid,
      tx_afull => c09f12_01_gbe0_tx_afull,
      tx_overflow => c09f12_01_gbe0_tx_overflow,
      tx_end_of_frame => c09f12_01_gbe0_tx_end_of_frame,
      tx_data => c09f12_01_gbe0_tx_data,
      tx_dest_ip => c09f12_01_gbe0_tx_dest_ip,
      tx_dest_port => c09f12_01_gbe0_tx_dest_port,
      rx_valid => c09f12_01_gbe0_rx_valid,
      rx_end_of_frame => c09f12_01_gbe0_rx_end_of_frame,
      rx_data => c09f12_01_gbe0_rx_data,
      rx_source_ip => c09f12_01_gbe0_rx_source_ip,
      rx_source_port => c09f12_01_gbe0_rx_source_port,
      rx_bad_frame => c09f12_01_gbe0_rx_bad_frame,
      rx_overrun => c09f12_01_gbe0_rx_overrun,
      rx_overrun_ack => c09f12_01_gbe0_rx_overrun_ack,
      rx_ack => c09f12_01_gbe0_rx_ack,
      led_up => c09f12_01_gbe0_led_up,
      led_rx => c09f12_01_gbe0_led_rx,
      led_tx => c09f12_01_gbe0_led_tx,
      xaui_clk => mgt_clk_0,
      xgmii_txd => xgmii0_xgmii_txd,
      xgmii_txc => xgmii0_xgmii_txc,
      xgmii_rxd => xgmii0_xgmii_rxd,
      xgmii_rxc => xgmii0_xgmii_rxc,
      xaui_reset => net_gnd0,
      xaui_status => xgmii0_xaui_status,
      mgt_rxeqmix => xaui_conf0_mgt_rxeqmix,
      mgt_rxeqpole => xaui_conf0_mgt_rxeqpole,
      mgt_txpreemphasis => xaui_conf0_mgt_txpreemphasis,
      mgt_txdiffctrl => xaui_conf0_mgt_txdiffctrl,
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(256 to 287),
      Sl_errAck => opb1_Sl_errAck(8),
      Sl_retry => opb1_Sl_retry(8),
      Sl_toutSup => opb1_Sl_toutSup(8),
      Sl_xferAck => opb1_Sl_xferAck(8),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr
    );

  xaui_phy_0 : system_xaui_phy_0_wrapper
    port map (
      reset => sys_reset,
      mgt_clk => mgt_clk_0,
      mgt_txdata => xaui_sys0_mgt_tx_data,
      mgt_txcharisk => xaui_sys0_mgt_tx_charisk,
      mgt_rxdata => xaui_sys0_mgt_rx_data,
      mgt_rxcharisk => xaui_sys0_mgt_rx_charisk,
      mgt_enable_align => xaui_sys0_mgt_enable_align,
      mgt_code_valid => xaui_sys0_mgt_code_valid,
      mgt_code_comma => xaui_sys0_mgt_code_comma,
      mgt_rxlock => xaui_sys0_mgt_rxlock,
      mgt_rxbufferr => xaui_sys0_mgt_rxbufferr,
      mgt_loopback => xaui_sys0_mgt_loopback,
      mgt_syncok => xaui_sys0_mgt_syncok,
      mgt_en_chan_sync => xaui_sys0_mgt_en_chan_sync,
      mgt_powerdown => xaui_sys0_mgt_powerdown,
      mgt_rx_reset => xaui_sys0_mgt_rx_reset,
      mgt_tx_reset => xaui_sys0_mgt_tx_reset,
      xgmii_txd => xgmii0_xgmii_txd,
      xgmii_txc => xgmii0_xgmii_txc,
      xgmii_rxd => xgmii0_xgmii_rxd,
      xgmii_rxc => xgmii0_xgmii_rxc,
      xaui_reset => net_gnd0,
      xaui_status => xgmii0_xaui_status
    );

  c09f12_01_gbe_ip0 : system_c09f12_01_gbe_ip0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(288 to 319),
      Sl_errAck => opb1_Sl_errAck(9),
      Sl_retry => opb1_Sl_retry(9),
      Sl_toutSup => opb1_Sl_toutSup(9),
      Sl_xferAck => opb1_Sl_xferAck(9),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_gbe_ip0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_gbe_port : system_c09f12_01_gbe_port_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(320 to 351),
      Sl_errAck => opb1_Sl_errAck(10),
      Sl_retry => opb1_Sl_retry(10),
      Sl_toutSup => opb1_Sl_toutSup(10),
      Sl_xferAck => opb1_Sl_xferAck(10),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_gbe_port_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_gbe_tx_cnt0 : system_c09f12_01_gbe_tx_cnt0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(352 to 383),
      Sl_errAck => opb1_Sl_errAck(11),
      Sl_retry => opb1_Sl_retry(11),
      Sl_toutSup => opb1_Sl_toutSup(11),
      Sl_xferAck => opb1_Sl_xferAck(11),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_gbe_tx_cnt0_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_gbe_tx_err_cnt0 : system_c09f12_01_gbe_tx_err_cnt0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(384 to 415),
      Sl_errAck => opb1_Sl_errAck(12),
      Sl_retry => opb1_Sl_retry(12),
      Sl_toutSup => opb1_Sl_toutSup(12),
      Sl_xferAck => opb1_Sl_xferAck(12),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_gbe_tx_err_cnt0_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_katadc0 : system_c09f12_01_katadc0_wrapper
    port map (
      adc_clk_p => adc0clk_p,
      adc_clk_n => adc0clk_n,
      adc_sync_p => adc0sync_p,
      adc_sync_n => adc0sync_n,
      adc_overrange_p => adc0overrange_p,
      adc_overrange_n => adc0overrange_n,
      adc_di_d_p => adc0di_d_p,
      adc_di_d_n => adc0di_d_n,
      adc_di_p => adc0di_p,
      adc_di_n => adc0di_n,
      adc_dq_d_p => adc0dq_d_p,
      adc_dq_d_n => adc0dq_d_n,
      adc_dq_p => adc0dq_p,
      adc_dq_n => adc0dq_n,
      adc_rst => adc0rst,
      adc_powerdown => adc0powerdown,
      user_datai0 => c09f12_01_katadc0_user_datai0,
      user_datai1 => c09f12_01_katadc0_user_datai1,
      user_datai2 => c09f12_01_katadc0_user_datai2,
      user_datai3 => c09f12_01_katadc0_user_datai3,
      user_dataq0 => c09f12_01_katadc0_user_dataq0,
      user_dataq1 => c09f12_01_katadc0_user_dataq1,
      user_dataq2 => c09f12_01_katadc0_user_dataq2,
      user_dataq3 => c09f12_01_katadc0_user_dataq3,
      user_outofrange0 => c09f12_01_katadc0_user_outofrange0,
      user_outofrange1 => c09f12_01_katadc0_user_outofrange1,
      user_sync0 => c09f12_01_katadc0_user_sync0,
      user_sync1 => c09f12_01_katadc0_user_sync1,
      user_sync2 => c09f12_01_katadc0_user_sync2,
      user_sync3 => c09f12_01_katadc0_user_sync3,
      user_data_valid => c09f12_01_katadc0_user_data_valid,
      dcm_reset => adc0_dcm_reset,
      ctrl_reset => adc0_adc_reset,
      ctrl_clk_in => adc0_clk,
      ctrl_clk_out => adc0_clk,
      ctrl_clk90_out => adc0_clk90,
      ctrl_clk180_out => adc0_clk180,
      ctrl_clk270_out => adc0_clk270,
      ctrl_dcm_locked => open,
      dcm_psclk => adc0_psclk,
      dcm_psen => adc0_psen,
      dcm_psincdec => adc0_psincdec,
      dcm_psdone => adc0_psdone
    );

  iic_adc0 : system_iic_adc0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(864 to 895),
      Sl_errAck => opb0_Sl_errAck(27),
      Sl_retry => opb0_Sl_retry(27),
      Sl_toutSup => opb0_Sl_toutSup(27),
      Sl_xferAck => opb0_Sl_xferAck(27),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      sda_i => iic_adc0_sda_i,
      sda_o => iic_adc0_sda_o,
      sda_t => iic_adc0_sda_t,
      scl_i => iic_adc0_scl_i,
      scl_o => iic_adc0_scl_o,
      scl_t => iic_adc0_scl_t,
      gain_load => c09f12_01_katadc0_gain_load,
      gain_value => c09f12_01_katadc0_gain_value,
      app_clk => adc0_clk
    );

  iic_infrastructure_adc0 : system_iic_infrastructure_adc0_wrapper
    port map (
      Sda_I => iic_adc0_sda_i,
      Sda_O => iic_adc0_sda_o,
      Sda_T => iic_adc0_sda_t,
      Scl_I => iic_adc0_scl_i,
      Scl_O => iic_adc0_scl_o,
      Scl_T => iic_adc0_scl_t,
      Sda => adc0_iic_sda,
      Scl => adc0_iic_scl
    );

  c09f12_01_ld_time_lsw0 : system_c09f12_01_ld_time_lsw0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(416 to 447),
      Sl_errAck => opb1_Sl_errAck(13),
      Sl_retry => opb1_Sl_retry(13),
      Sl_toutSup => opb1_Sl_toutSup(13),
      Sl_xferAck => opb1_Sl_xferAck(13),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_ld_time_lsw0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_ld_time_lsw1 : system_c09f12_01_ld_time_lsw1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(448 to 479),
      Sl_errAck => opb1_Sl_errAck(14),
      Sl_retry => opb1_Sl_retry(14),
      Sl_toutSup => opb1_Sl_toutSup(14),
      Sl_xferAck => opb1_Sl_xferAck(14),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_ld_time_lsw1_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_ld_time_msw0 : system_c09f12_01_ld_time_msw0_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(480 to 511),
      Sl_errAck => opb1_Sl_errAck(15),
      Sl_retry => opb1_Sl_retry(15),
      Sl_toutSup => opb1_Sl_toutSup(15),
      Sl_xferAck => opb1_Sl_xferAck(15),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_ld_time_msw0_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_ld_time_msw1 : system_c09f12_01_ld_time_msw1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(512 to 543),
      Sl_errAck => opb1_Sl_errAck(16),
      Sl_retry => opb1_Sl_retry(16),
      Sl_toutSup => opb1_Sl_toutSup(16),
      Sl_xferAck => opb1_Sl_xferAck(16),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_ld_time_msw1_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_leds_roach_gpioa0 : system_c09f12_01_leds_roach_gpioa0_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa0_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa0_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa1 : system_c09f12_01_leds_roach_gpioa1_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa1_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa1_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa2 : system_c09f12_01_leds_roach_gpioa2_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa2_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa2_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa3 : system_c09f12_01_leds_roach_gpioa3_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa3_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa3_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa4 : system_c09f12_01_leds_roach_gpioa4_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa4_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa4_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa5 : system_c09f12_01_leds_roach_gpioa5_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa5_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa5_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa6 : system_c09f12_01_leds_roach_gpioa6_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa6_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa6_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa7 : system_c09f12_01_leds_roach_gpioa7_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa7_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa7_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_gpioa_oe : system_c09f12_01_leds_roach_gpioa_oe_wrapper
    port map (
      gateway => c09f12_01_leds_roach_gpioa_oe_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_gpioa_oe_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_led0 : system_c09f12_01_leds_roach_led0_wrapper
    port map (
      gateway => c09f12_01_leds_roach_led0_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_led0_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_led1 : system_c09f12_01_leds_roach_led1_wrapper
    port map (
      gateway => c09f12_01_leds_roach_led1_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_led1_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_led2 : system_c09f12_01_leds_roach_led2_wrapper
    port map (
      gateway => c09f12_01_leds_roach_led2_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_led2_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_leds_roach_led3 : system_c09f12_01_leds_roach_led3_wrapper
    port map (
      gateway => c09f12_01_leds_roach_led3_gateway(0 to 0),
      io_pad => c09f12_01_leds_roach_led3_ext(0 to 0),
      clk => adc0_clk,
      clk90 => adc0_clk90
    );

  c09f12_01_mcount_lsw : system_c09f12_01_mcount_lsw_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(544 to 575),
      Sl_errAck => opb1_Sl_errAck(17),
      Sl_retry => opb1_Sl_retry(17),
      Sl_toutSup => opb1_Sl_toutSup(17),
      Sl_xferAck => opb1_Sl_xferAck(17),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_mcount_lsw_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_mcount_msw : system_c09f12_01_mcount_msw_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(576 to 607),
      Sl_errAck => opb1_Sl_errAck(18),
      Sl_retry => opb1_Sl_retry(18),
      Sl_toutSup => opb1_Sl_toutSup(18),
      Sl_xferAck => opb1_Sl_xferAck(18),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_mcount_msw_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_pps_count : system_c09f12_01_pps_count_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(608 to 639),
      Sl_errAck => opb1_Sl_errAck(19),
      Sl_retry => opb1_Sl_retry(19),
      Sl_toutSup => opb1_Sl_toutSup(19),
      Sl_xferAck => opb1_Sl_xferAck(19),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_pps_count_user_data_in,
      user_clk => adc0_clk
    );

  qdr0_controller : system_qdr0_controller_wrapper
    port map (
      clk0 => adc0_clk,
      clk180 => adc0_clk180,
      clk270 => adc0_clk270,
      div_clk => dly_clk,
      reset => c09f12_01_qdr_ct_qdr_reset,
      idelay_rdy => idelay_rdy,
      qdr_k_n => qdr0_k_n,
      qdr_k => qdr0_k,
      qdr_d => qdr0_d,
      qdr_bw_n => qdr0_bw_n,
      qdr_sa => qdr0_sa,
      qdr_w_n => qdr0_w_n,
      qdr_r_n => qdr0_r_n,
      qdr_q => qdr0_q,
      qdr_cq_n => qdr0_cq_n,
      qdr_cq => qdr0_cq,
      qdr_qvld => qdr0_qvld,
      qdr_dll_off_n => qdr0_dll_off_n,
      phy_rdy => c09f12_01_qdr_ct_qdr_phy_ready,
      cal_fail => c09f12_01_qdr_ct_qdr_cal_fail,
      usr_addr => c09f12_01_qdr_ct_qdr_qdr_addr,
      usr_wr_strb => c09f12_01_qdr_ct_qdr_qdr_wr_strb,
      usr_wr_data => c09f12_01_qdr_ct_qdr_qdr_wr_data,
      usr_wr_be => c09f12_01_qdr_ct_qdr_qdr_wr_be,
      usr_rd_strb => c09f12_01_qdr_ct_qdr_qdr_rd_strb,
      usr_rd_data => c09f12_01_qdr_ct_qdr_qdr_rd_data,
      usr_rd_dvld => c09f12_01_qdr_ct_qdr_qdr_rd_dvld
    );

  qdr0_sniffer : system_qdr0_sniffer_wrapper
    port map (
      OPB_Clk_config => epb_clk,
      OPB_Rst_config => opb0_OPB_Rst,
      Sl_DBus_config => opb0_Sl_DBus(928 to 959),
      Sl_errAck_config => opb0_Sl_errAck(29),
      Sl_retry_config => opb0_Sl_retry(29),
      Sl_toutSup_config => opb0_Sl_toutSup(29),
      Sl_xferAck_config => opb0_Sl_xferAck(29),
      OPB_ABus_config => opb0_OPB_ABus,
      OPB_BE_config => opb0_OPB_BE,
      OPB_DBus_config => opb0_OPB_DBus,
      OPB_RNW_config => opb0_OPB_RNW,
      OPB_select_config => opb0_OPB_select,
      OPB_seqAddr_config => opb0_OPB_seqAddr,
      OPB_Clk => epb_clk,
      OPB_Rst => opb0_OPB_Rst,
      Sl_DBus => opb0_Sl_DBus(896 to 927),
      Sl_errAck => opb0_Sl_errAck(28),
      Sl_retry => opb0_Sl_retry(28),
      Sl_toutSup => opb0_Sl_toutSup(28),
      Sl_xferAck => opb0_Sl_xferAck(28),
      OPB_ABus => opb0_OPB_ABus,
      OPB_BE => opb0_OPB_BE,
      OPB_DBus => opb0_OPB_DBus,
      OPB_RNW => opb0_OPB_RNW,
      OPB_select => opb0_OPB_select,
      OPB_seqAddr => opb0_OPB_seqAddr,
      qdr_clk => adc0_clk,
      master_addr => c09f12_01_qdr_ct_qdr_qdr_addr,
      master_wr_strb => c09f12_01_qdr_ct_qdr_qdr_wr_strb,
      master_wr_data => c09f12_01_qdr_ct_qdr_qdr_wr_data,
      master_wr_be => c09f12_01_qdr_ct_qdr_qdr_wr_be,
      master_rd_strb => c09f12_01_qdr_ct_qdr_qdr_rd_strb,
      master_rd_data => c09f12_01_qdr_ct_qdr_qdr_rd_data,
      master_rd_dvld => c09f12_01_qdr_ct_qdr_qdr_rd_dvld,
      slave_addr => c09f12_01_qdr_ct_qdr_address,
      slave_wr_strb => c09f12_01_qdr_ct_qdr_wr_en,
      slave_wr_data => c09f12_01_qdr_ct_qdr_data_in,
      slave_wr_be => c09f12_01_qdr_ct_qdr_be,
      slave_rd_strb => c09f12_01_qdr_ct_qdr_rd_en,
      slave_rd_data => c09f12_01_qdr_ct_qdr_data_out,
      slave_rd_dvld => open,
      slave_ack => c09f12_01_qdr_ct_qdr_ack,
      phy_rdy => c09f12_01_qdr_ct_qdr_phy_ready,
      cal_fail => c09f12_01_qdr_ct_qdr_cal_fail,
      qdr_reset => c09f12_01_qdr_ct_qdr_reset
    );

  c09f12_01_rcs_app : system_c09f12_01_rcs_app_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(640 to 671),
      Sl_errAck => opb1_Sl_errAck(20),
      Sl_retry => opb1_Sl_retry(20),
      Sl_toutSup => opb1_Sl_toutSup(20),
      Sl_xferAck => opb1_Sl_xferAck(20),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_rcs_app_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_rcs_lib : system_c09f12_01_rcs_lib_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(672 to 703),
      Sl_errAck => opb1_Sl_errAck(21),
      Sl_retry => opb1_Sl_retry(21),
      Sl_toutSup => opb1_Sl_toutSup(21),
      Sl_xferAck => opb1_Sl_xferAck(21),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_rcs_lib_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_rcs_user : system_c09f12_01_rcs_user_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(704 to 735),
      Sl_errAck => opb1_Sl_errAck(22),
      Sl_retry => opb1_Sl_retry(22),
      Sl_toutSup => opb1_Sl_toutSup(22),
      Sl_xferAck => opb1_Sl_xferAck(22),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_rcs_user_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_snap_debug_addr : system_c09f12_01_snap_debug_addr_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(736 to 767),
      Sl_errAck => opb1_Sl_errAck(23),
      Sl_retry => opb1_Sl_retry(23),
      Sl_toutSup => opb1_Sl_toutSup(23),
      Sl_xferAck => opb1_Sl_xferAck(23),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_in => c09f12_01_snap_debug_addr_user_data_in,
      user_clk => adc0_clk
    );

  c09f12_01_snap_debug_bram_ramblk : system_c09f12_01_snap_debug_bram_ramblk_wrapper
    port map (
      clk => adc0_clk,
      bram_en_a => net_gnd0,
      bram_we => c09f12_01_snap_debug_bram_we,
      bram_addr => c09f12_01_snap_debug_bram_addr,
      bram_rd_data => c09f12_01_snap_debug_bram_data_out,
      bram_wr_data => c09f12_01_snap_debug_bram_data_in,
      BRAM_Rst_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Rst,
      BRAM_Clk_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Clk,
      BRAM_EN_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_EN,
      BRAM_WEN_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_WEN,
      BRAM_Addr_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Addr,
      BRAM_Din_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Din,
      BRAM_Dout_B => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Dout
    );

  c09f12_01_snap_debug_bram : system_c09f12_01_snap_debug_bram_wrapper
    port map (
      opb_clk => epb_clk,
      opb_rst => opb1_OPB_Rst,
      opb_abus => opb1_OPB_ABus,
      opb_dbus => opb1_OPB_DBus,
      sln_dbus => opb1_Sl_DBus(768 to 799),
      opb_select => opb1_OPB_select,
      opb_rnw => opb1_OPB_RNW,
      opb_seqaddr => opb1_OPB_seqAddr,
      opb_be => opb1_OPB_BE,
      sln_xferack => opb1_Sl_xferAck(24),
      sln_errack => opb1_Sl_errAck(24),
      sln_toutsup => opb1_Sl_toutSup(24),
      sln_retry => opb1_Sl_retry(24),
      bram_rst => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Rst,
      bram_clk => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Clk,
      bram_en => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_EN,
      bram_wen => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_WEN,
      bram_addr => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Addr,
      bram_din => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Din,
      bram_dout => c09f12_01_snap_debug_bram_ramblk_portb_BRAM_Dout
    );

  c09f12_01_snap_debug_ctrl : system_c09f12_01_snap_debug_ctrl_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(800 to 831),
      Sl_errAck => opb1_Sl_errAck(25),
      Sl_retry => opb1_Sl_retry(25),
      Sl_toutSup => opb1_Sl_toutSup(25),
      Sl_xferAck => opb1_Sl_xferAck(25),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_snap_debug_ctrl_user_data_out,
      user_clk => adc0_clk
    );

  c09f12_01_trig_level : system_c09f12_01_trig_level_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      Sl_DBus => opb1_Sl_DBus(832 to 863),
      Sl_errAck => opb1_Sl_errAck(26),
      Sl_retry => opb1_Sl_retry(26),
      Sl_toutSup => opb1_Sl_toutSup(26),
      Sl_xferAck => opb1_Sl_xferAck(26),
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_DBus => opb1_OPB_DBus,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      user_data_out => c09f12_01_trig_level_user_data_out,
      user_clk => adc0_clk
    );

  opb1 : system_opb1_wrapper
    port map (
      OPB_Clk => epb_clk,
      OPB_Rst => opb1_OPB_Rst,
      SYS_Rst => sys_reset,
      Debug_SYS_Rst => net_gnd0,
      WDT_Rst => net_gnd0,
      M_ABus => opb1_M_ABus,
      M_BE => opb1_M_BE,
      M_beXfer => net_gnd1(0 to 0),
      M_busLock => opb1_M_busLock(0 to 0),
      M_DBus => opb1_M_DBus,
      M_DBusEn => net_gnd1(0 to 0),
      M_DBusEn32_63 => net_vcc1(0 to 0),
      M_dwXfer => net_gnd1(0 to 0),
      M_fwXfer => net_gnd1(0 to 0),
      M_hwXfer => net_gnd1(0 to 0),
      M_request => opb1_M_request(0 to 0),
      M_RNW => opb1_M_RNW(0 to 0),
      M_select => opb1_M_select(0 to 0),
      M_seqAddr => opb1_M_seqAddr(0 to 0),
      Sl_beAck => net_gnd27,
      Sl_DBus => opb1_Sl_DBus,
      Sl_DBusEn => net_vcc27,
      Sl_DBusEn32_63 => net_vcc27,
      Sl_errAck => opb1_Sl_errAck,
      Sl_dwAck => net_gnd27,
      Sl_fwAck => net_gnd27,
      Sl_hwAck => net_gnd27,
      Sl_retry => opb1_Sl_retry,
      Sl_toutSup => opb1_Sl_toutSup,
      Sl_xferAck => opb1_Sl_xferAck,
      OPB_MRequest => open,
      OPB_ABus => opb1_OPB_ABus,
      OPB_BE => opb1_OPB_BE,
      OPB_beXfer => open,
      OPB_beAck => open,
      OPB_busLock => open,
      OPB_rdDBus => open,
      OPB_wrDBus => open,
      OPB_DBus => opb1_OPB_DBus,
      OPB_errAck => opb1_OPB_errAck,
      OPB_dwAck => open,
      OPB_dwXfer => open,
      OPB_fwAck => open,
      OPB_fwXfer => open,
      OPB_hwAck => open,
      OPB_hwXfer => open,
      OPB_MGrant => opb1_OPB_MGrant(0 to 0),
      OPB_pendReq => open,
      OPB_retry => opb1_OPB_retry,
      OPB_RNW => opb1_OPB_RNW,
      OPB_select => opb1_OPB_select,
      OPB_seqAddr => opb1_OPB_seqAddr,
      OPB_timeout => opb1_OPB_timeout,
      OPB_toutSup => open,
      OPB_xferAck => opb1_OPB_xferAck
    );

  opb2opb_bridge_opb1 : system_opb2opb_bridge_opb1_wrapper
    port map (
      MOPB_Clk => epb_clk,
      SOPB_Clk => epb_clk,
      MOPB_Rst => opb1_OPB_Rst,
      SOPB_Rst => opb0_OPB_Rst,
      SOPB_ABus => opb0_OPB_ABus,
      SOPB_BE => opb0_OPB_BE,
      SOPB_DBus => opb0_OPB_DBus,
      SOPB_RNW => opb0_OPB_RNW,
      SOPB_select => opb0_OPB_select,
      SOPB_seqAddr => opb0_OPB_seqAddr,
      Sl_DBus => opb0_Sl_DBus(960 to 991),
      Sl_errAck => opb0_Sl_errAck(30),
      Sl_retry => opb0_Sl_retry(30),
      Sl_toutSup => opb0_Sl_toutSup(30),
      Sl_xferAck => opb0_Sl_xferAck(30),
      M_ABus => opb1_M_ABus,
      M_BE => opb1_M_BE,
      M_busLock => opb1_M_busLock(0),
      M_DBus => opb1_M_DBus,
      M_request => opb1_M_request(0),
      M_RNW => opb1_M_RNW(0),
      M_select => opb1_M_select(0),
      M_seqAddr => opb1_M_seqAddr(0),
      MOPB_DBus => opb1_OPB_DBus,
      MOPB_errAck => opb1_OPB_errAck,
      MOPB_MGrant => opb1_OPB_MGrant(0),
      MOPB_retry => opb1_OPB_retry,
      MOPB_timeout => opb1_OPB_timeout,
      MOPB_xferAck => opb1_OPB_xferAck
    );

end architecture STRUCTURE;

