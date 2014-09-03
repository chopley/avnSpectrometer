-------------------------------------------------------------------------------
-- system_c09f12_01_xsg_core_config_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_c09f12_01_xsg_core_config_wrapper is
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
end system_c09f12_01_xsg_core_config_wrapper;

architecture STRUCTURE of system_c09f12_01_xsg_core_config_wrapper is

  component c09f12_01 is
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

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of c09f12_01 : component is "user_black_box";

begin

  c09f12_01_XSG_core_config : c09f12_01
    port map (
      clk => clk,
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
      c09f12_01_leds_roach_gpioa0_gateway => c09f12_01_leds_roach_gpioa0_gateway,
      c09f12_01_leds_roach_gpioa1_gateway => c09f12_01_leds_roach_gpioa1_gateway,
      c09f12_01_leds_roach_gpioa2_gateway => c09f12_01_leds_roach_gpioa2_gateway,
      c09f12_01_leds_roach_gpioa3_gateway => c09f12_01_leds_roach_gpioa3_gateway,
      c09f12_01_leds_roach_gpioa4_gateway => c09f12_01_leds_roach_gpioa4_gateway,
      c09f12_01_leds_roach_gpioa5_gateway => c09f12_01_leds_roach_gpioa5_gateway,
      c09f12_01_leds_roach_gpioa6_gateway => c09f12_01_leds_roach_gpioa6_gateway,
      c09f12_01_leds_roach_gpioa7_gateway => c09f12_01_leds_roach_gpioa7_gateway,
      c09f12_01_leds_roach_gpioa_oe_gateway => c09f12_01_leds_roach_gpioa_oe_gateway,
      c09f12_01_leds_roach_led0_gateway => c09f12_01_leds_roach_led0_gateway,
      c09f12_01_leds_roach_led1_gateway => c09f12_01_leds_roach_led1_gateway,
      c09f12_01_leds_roach_led2_gateway => c09f12_01_leds_roach_led2_gateway,
      c09f12_01_leds_roach_led3_gateway => c09f12_01_leds_roach_led3_gateway,
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

end architecture STRUCTURE;

