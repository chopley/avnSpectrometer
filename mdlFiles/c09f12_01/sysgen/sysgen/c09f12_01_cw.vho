
-------------------------------------------------------------------
-- System Generator version 14.6 VHDL source file.
--
-- Copyright(C) 2013 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2013 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component c09f12_01_cw  port (
    c09f12_01_a0_fd0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_a0_fd1_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_a1_fd0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_a1_fd1_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_ctrl0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_ctrl1_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap0_bram_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap0_ctrl_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap0_trig_offset_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_bram_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_ctrl_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_trig_offset_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_board_id_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_coarse_ctrl_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_coarse_delay0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_coarse_delay1_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_control_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_eq0_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_eq1_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_fine_ctrl_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_gbe0_led_rx: in std_logic; 
    c09f12_01_gbe0_led_tx: in std_logic; 
    c09f12_01_gbe0_led_up: in std_logic; 
    c09f12_01_gbe0_rx_bad_frame: in std_logic; 
    c09f12_01_gbe0_rx_data: in std_logic_vector(63 downto 0); 
    c09f12_01_gbe0_rx_end_of_frame: in std_logic; 
    c09f12_01_gbe0_rx_overrun: in std_logic; 
    c09f12_01_gbe0_rx_source_ip: in std_logic_vector(31 downto 0); 
    c09f12_01_gbe0_rx_source_port: in std_logic_vector(15 downto 0); 
    c09f12_01_gbe0_rx_valid: in std_logic; 
    c09f12_01_gbe0_tx_afull: in std_logic; 
    c09f12_01_gbe0_tx_overflow: in std_logic; 
    c09f12_01_gbe_ip0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_gbe_port_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_katadc0_user_data_valid: in std_logic; 
    c09f12_01_katadc0_user_datai0: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_datai1: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_datai2: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_datai3: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_dataq0: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_dataq1: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_dataq2: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_dataq3: in std_logic_vector(7 downto 0); 
    c09f12_01_katadc0_user_outofrange0: in std_logic; 
    c09f12_01_katadc0_user_outofrange1: in std_logic; 
    c09f12_01_katadc0_user_sync0: in std_logic; 
    c09f12_01_katadc0_user_sync1: in std_logic; 
    c09f12_01_katadc0_user_sync2: in std_logic; 
    c09f12_01_katadc0_user_sync3: in std_logic; 
    c09f12_01_ld_time_lsw0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_ld_time_lsw1_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_ld_time_msw0_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_ld_time_msw1_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_qdr_ct_qdr_ack: in std_logic; 
    c09f12_01_qdr_ct_qdr_cal_fail: in std_logic; 
    c09f12_01_qdr_ct_qdr_data_out: in std_logic_vector(35 downto 0); 
    c09f12_01_qdr_ct_qdr_phy_ready: in std_logic; 
    c09f12_01_snap_debug_bram_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_snap_debug_ctrl_user_data_out: in std_logic_vector(31 downto 0); 
    c09f12_01_trig_level_user_data_out: in std_logic_vector(31 downto 0); 
    ce: in std_logic := '1'; 
    clk: in std_logic; -- clock period = 5.0 ns (200.0 Mhz)
    c09f12_01_adc_snap0_bram_addr: out std_logic_vector(9 downto 0); 
    c09f12_01_adc_snap0_bram_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap0_bram_we: out std_logic; 
    c09f12_01_adc_snap0_status_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap0_tr_en_cnt_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap0_val_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_bram_addr: out std_logic_vector(9 downto 0); 
    c09f12_01_adc_snap1_bram_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_bram_we: out std_logic; 
    c09f12_01_adc_snap1_status_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_tr_en_cnt_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_snap1_val_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_sum_sq0_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_adc_sum_sq1_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_clk_frequency_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_delay_tr_status0_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_delay_tr_status1_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_eq0_addr: out std_logic_vector(11 downto 0); 
    c09f12_01_eq0_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_eq0_we: out std_logic; 
    c09f12_01_eq1_addr: out std_logic_vector(11 downto 0); 
    c09f12_01_eq1_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_eq1_we: out std_logic; 
    c09f12_01_fstatus0_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_fstatus1_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_gbe0_rst: out std_logic; 
    c09f12_01_gbe0_rx_ack: out std_logic; 
    c09f12_01_gbe0_rx_overrun_ack: out std_logic; 
    c09f12_01_gbe0_tx_data: out std_logic_vector(63 downto 0); 
    c09f12_01_gbe0_tx_dest_ip: out std_logic_vector(31 downto 0); 
    c09f12_01_gbe0_tx_dest_port: out std_logic_vector(15 downto 0); 
    c09f12_01_gbe0_tx_end_of_frame: out std_logic; 
    c09f12_01_gbe0_tx_valid: out std_logic; 
    c09f12_01_gbe_tx_cnt0_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_gbe_tx_err_cnt0_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_katadc0_gain_load: out std_logic; 
    c09f12_01_katadc0_gain_value: out std_logic_vector(13 downto 0); 
    c09f12_01_leds_roach_gpioa0_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa1_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa2_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa3_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa4_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa5_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa6_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa7_gateway: out std_logic; 
    c09f12_01_leds_roach_gpioa_oe_gateway: out std_logic; 
    c09f12_01_leds_roach_led0_gateway: out std_logic; 
    c09f12_01_leds_roach_led1_gateway: out std_logic; 
    c09f12_01_leds_roach_led2_gateway: out std_logic; 
    c09f12_01_leds_roach_led3_gateway: out std_logic; 
    c09f12_01_mcount_lsw_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_mcount_msw_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_pps_count_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_qdr_ct_qdr_address: out std_logic_vector(31 downto 0); 
    c09f12_01_qdr_ct_qdr_be: out std_logic_vector(3 downto 0); 
    c09f12_01_qdr_ct_qdr_data_in: out std_logic_vector(35 downto 0); 
    c09f12_01_qdr_ct_qdr_rd_en: out std_logic; 
    c09f12_01_qdr_ct_qdr_wr_en: out std_logic; 
    c09f12_01_rcs_app_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_rcs_lib_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_rcs_user_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_snap_debug_addr_user_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_snap_debug_bram_addr: out std_logic_vector(10 downto 0); 
    c09f12_01_snap_debug_bram_data_in: out std_logic_vector(31 downto 0); 
    c09f12_01_snap_debug_bram_we: out std_logic; 
    gateway_out: out std_logic; 
    gateway_out1: out std_logic_vector(25 downto 0); 
    gateway_out1_x0: out std_logic_vector(25 downto 0); 
    gateway_out1_x1: out std_logic_vector(25 downto 0); 
    gateway_out1_x2: out std_logic_vector(25 downto 0); 
    gateway_out1_x3: out std_logic_vector(25 downto 0); 
    gateway_out1_x4: out std_logic_vector(25 downto 0); 
    gateway_out1_x5: out std_logic_vector(25 downto 0); 
    gateway_out1_x6: out std_logic_vector(25 downto 0); 
    gateway_out2: out std_logic; 
    gateway_out2_x0: out std_logic; 
    gateway_out2_x1: out std_logic; 
    gateway_out2_x2: out std_logic; 
    gateway_out2_x3: out std_logic; 
    gateway_out2_x4: out std_logic; 
    gateway_out2_x5: out std_logic; 
    gateway_out2_x6: out std_logic; 
    gateway_out_x0: out std_logic; 
    gateway_out_x1: out std_logic; 
    gateway_out_x2: out std_logic; 
    gateway_out_x3: out std_logic; 
    gateway_out_x4: out std_logic; 
    gateway_out_x5: out std_logic; 
    gateway_out_x6: out std_logic; 
    gateway_t1: out std_logic_vector(7 downto 0); 
    gateway_t1_x0: out std_logic_vector(7 downto 0); 
    gateway_t1_x1: out std_logic_vector(7 downto 0); 
    gateway_t1_x2: out std_logic_vector(7 downto 0); 
    gateway_t1_x3: out std_logic_vector(7 downto 0); 
    gateway_t1_x4: out std_logic_vector(7 downto 0); 
    gateway_t1_x5: out std_logic_vector(7 downto 0); 
    gateway_t1_x6: out std_logic_vector(7 downto 0); 
    gateway_t2: out std_logic; 
    gateway_t2_x0: out std_logic; 
    gateway_t2_x1: out std_logic; 
    gateway_t2_x2: out std_logic; 
    gateway_t2_x3: out std_logic; 
    gateway_t2_x4: out std_logic; 
    gateway_t2_x5: out std_logic; 
    gateway_t2_x6: out std_logic; 
    gateway_t3: out std_logic_vector(8 downto 0); 
    gateway_t3_x0: out std_logic_vector(8 downto 0); 
    gateway_t3_x1: out std_logic_vector(8 downto 0); 
    gateway_t3_x2: out std_logic_vector(8 downto 0); 
    gateway_t3_x3: out std_logic_vector(8 downto 0); 
    gateway_t3_x4: out std_logic_vector(8 downto 0); 
    gateway_t3_x5: out std_logic_vector(8 downto 0); 
    gateway_t3_x6: out std_logic_vector(8 downto 0)
  );
end component;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body.  Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : c09f12_01_cw
  port map (
    c09f12_01_a0_fd0_user_data_out => c09f12_01_a0_fd0_user_data_out,
    c09f12_01_a0_fd1_user_data_out => c09f12_01_a0_fd1_user_data_out,
    c09f12_01_a1_fd0_user_data_out => c09f12_01_a1_fd0_user_data_out,
    c09f12_01_a1_fd1_user_data_out => c09f12_01_a1_fd1_user_data_out,
    c09f12_01_adc_ctrl0_user_data_out => c09f12_01_adc_ctrl0_user_data_out,
    c09f12_01_adc_ctrl1_user_data_out => c09f12_01_adc_ctrl1_user_data_out,
    c09f12_01_adc_snap0_bram_data_out => c09f12_01_adc_snap0_bram_data_out,
    c09f12_01_adc_snap0_ctrl_user_data_out => c09f12_01_adc_snap0_ctrl_user_data_out,
    c09f12_01_adc_snap0_trig_offset_user_data_out => c09f12_01_adc_snap0_trig_offset_user_data_out,
    c09f12_01_adc_snap1_bram_data_out => c09f12_01_adc_snap1_bram_data_out,
    c09f12_01_adc_snap1_ctrl_user_data_out => c09f12_01_adc_snap1_ctrl_user_data_out,
    c09f12_01_adc_snap1_trig_offset_user_data_out => c09f12_01_adc_snap1_trig_offset_user_data_out,
    c09f12_01_board_id_user_data_out => c09f12_01_board_id_user_data_out,
    c09f12_01_coarse_ctrl_user_data_out => c09f12_01_coarse_ctrl_user_data_out,
    c09f12_01_coarse_delay0_user_data_out => c09f12_01_coarse_delay0_user_data_out,
    c09f12_01_coarse_delay1_user_data_out => c09f12_01_coarse_delay1_user_data_out,
    c09f12_01_control_user_data_out => c09f12_01_control_user_data_out,
    c09f12_01_eq0_data_out => c09f12_01_eq0_data_out,
    c09f12_01_eq1_data_out => c09f12_01_eq1_data_out,
    c09f12_01_fine_ctrl_user_data_out => c09f12_01_fine_ctrl_user_data_out,
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
    c09f12_01_gbe_ip0_user_data_out => c09f12_01_gbe_ip0_user_data_out,
    c09f12_01_gbe_port_user_data_out => c09f12_01_gbe_port_user_data_out,
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
    c09f12_01_ld_time_lsw0_user_data_out => c09f12_01_ld_time_lsw0_user_data_out,
    c09f12_01_ld_time_lsw1_user_data_out => c09f12_01_ld_time_lsw1_user_data_out,
    c09f12_01_ld_time_msw0_user_data_out => c09f12_01_ld_time_msw0_user_data_out,
    c09f12_01_ld_time_msw1_user_data_out => c09f12_01_ld_time_msw1_user_data_out,
    c09f12_01_qdr_ct_qdr_ack => c09f12_01_qdr_ct_qdr_ack,
    c09f12_01_qdr_ct_qdr_cal_fail => c09f12_01_qdr_ct_qdr_cal_fail,
    c09f12_01_qdr_ct_qdr_data_out => c09f12_01_qdr_ct_qdr_data_out,
    c09f12_01_qdr_ct_qdr_phy_ready => c09f12_01_qdr_ct_qdr_phy_ready,
    c09f12_01_snap_debug_bram_data_out => c09f12_01_snap_debug_bram_data_out,
    c09f12_01_snap_debug_ctrl_user_data_out => c09f12_01_snap_debug_ctrl_user_data_out,
    c09f12_01_trig_level_user_data_out => c09f12_01_trig_level_user_data_out,
    ce => ce,
    clk => clk,
    c09f12_01_adc_snap0_bram_addr => c09f12_01_adc_snap0_bram_addr,
    c09f12_01_adc_snap0_bram_data_in => c09f12_01_adc_snap0_bram_data_in,
    c09f12_01_adc_snap0_bram_we => c09f12_01_adc_snap0_bram_we,
    c09f12_01_adc_snap0_status_user_data_in => c09f12_01_adc_snap0_status_user_data_in,
    c09f12_01_adc_snap0_tr_en_cnt_user_data_in => c09f12_01_adc_snap0_tr_en_cnt_user_data_in,
    c09f12_01_adc_snap0_val_user_data_in => c09f12_01_adc_snap0_val_user_data_in,
    c09f12_01_adc_snap1_bram_addr => c09f12_01_adc_snap1_bram_addr,
    c09f12_01_adc_snap1_bram_data_in => c09f12_01_adc_snap1_bram_data_in,
    c09f12_01_adc_snap1_bram_we => c09f12_01_adc_snap1_bram_we,
    c09f12_01_adc_snap1_status_user_data_in => c09f12_01_adc_snap1_status_user_data_in,
    c09f12_01_adc_snap1_tr_en_cnt_user_data_in => c09f12_01_adc_snap1_tr_en_cnt_user_data_in,
    c09f12_01_adc_snap1_val_user_data_in => c09f12_01_adc_snap1_val_user_data_in,
    c09f12_01_adc_sum_sq0_user_data_in => c09f12_01_adc_sum_sq0_user_data_in,
    c09f12_01_adc_sum_sq1_user_data_in => c09f12_01_adc_sum_sq1_user_data_in,
    c09f12_01_clk_frequency_user_data_in => c09f12_01_clk_frequency_user_data_in,
    c09f12_01_delay_tr_status0_user_data_in => c09f12_01_delay_tr_status0_user_data_in,
    c09f12_01_delay_tr_status1_user_data_in => c09f12_01_delay_tr_status1_user_data_in,
    c09f12_01_eq0_addr => c09f12_01_eq0_addr,
    c09f12_01_eq0_data_in => c09f12_01_eq0_data_in,
    c09f12_01_eq0_we => c09f12_01_eq0_we,
    c09f12_01_eq1_addr => c09f12_01_eq1_addr,
    c09f12_01_eq1_data_in => c09f12_01_eq1_data_in,
    c09f12_01_eq1_we => c09f12_01_eq1_we,
    c09f12_01_fstatus0_user_data_in => c09f12_01_fstatus0_user_data_in,
    c09f12_01_fstatus1_user_data_in => c09f12_01_fstatus1_user_data_in,
    c09f12_01_gbe0_rst => c09f12_01_gbe0_rst,
    c09f12_01_gbe0_rx_ack => c09f12_01_gbe0_rx_ack,
    c09f12_01_gbe0_rx_overrun_ack => c09f12_01_gbe0_rx_overrun_ack,
    c09f12_01_gbe0_tx_data => c09f12_01_gbe0_tx_data,
    c09f12_01_gbe0_tx_dest_ip => c09f12_01_gbe0_tx_dest_ip,
    c09f12_01_gbe0_tx_dest_port => c09f12_01_gbe0_tx_dest_port,
    c09f12_01_gbe0_tx_end_of_frame => c09f12_01_gbe0_tx_end_of_frame,
    c09f12_01_gbe0_tx_valid => c09f12_01_gbe0_tx_valid,
    c09f12_01_gbe_tx_cnt0_user_data_in => c09f12_01_gbe_tx_cnt0_user_data_in,
    c09f12_01_gbe_tx_err_cnt0_user_data_in => c09f12_01_gbe_tx_err_cnt0_user_data_in,
    c09f12_01_katadc0_gain_load => c09f12_01_katadc0_gain_load,
    c09f12_01_katadc0_gain_value => c09f12_01_katadc0_gain_value,
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
    c09f12_01_qdr_ct_qdr_address => c09f12_01_qdr_ct_qdr_address,
    c09f12_01_qdr_ct_qdr_be => c09f12_01_qdr_ct_qdr_be,
    c09f12_01_qdr_ct_qdr_data_in => c09f12_01_qdr_ct_qdr_data_in,
    c09f12_01_qdr_ct_qdr_rd_en => c09f12_01_qdr_ct_qdr_rd_en,
    c09f12_01_qdr_ct_qdr_wr_en => c09f12_01_qdr_ct_qdr_wr_en,
    c09f12_01_rcs_app_user_data_in => c09f12_01_rcs_app_user_data_in,
    c09f12_01_rcs_lib_user_data_in => c09f12_01_rcs_lib_user_data_in,
    c09f12_01_rcs_user_user_data_in => c09f12_01_rcs_user_user_data_in,
    c09f12_01_snap_debug_addr_user_data_in => c09f12_01_snap_debug_addr_user_data_in,
    c09f12_01_snap_debug_bram_addr => c09f12_01_snap_debug_bram_addr,
    c09f12_01_snap_debug_bram_data_in => c09f12_01_snap_debug_bram_data_in,
    c09f12_01_snap_debug_bram_we => c09f12_01_snap_debug_bram_we,
    gateway_out => gateway_out,
    gateway_out1 => gateway_out1,
    gateway_out1_x0 => gateway_out1_x0,
    gateway_out1_x1 => gateway_out1_x1,
    gateway_out1_x2 => gateway_out1_x2,
    gateway_out1_x3 => gateway_out1_x3,
    gateway_out1_x4 => gateway_out1_x4,
    gateway_out1_x5 => gateway_out1_x5,
    gateway_out1_x6 => gateway_out1_x6,
    gateway_out2 => gateway_out2,
    gateway_out2_x0 => gateway_out2_x0,
    gateway_out2_x1 => gateway_out2_x1,
    gateway_out2_x2 => gateway_out2_x2,
    gateway_out2_x3 => gateway_out2_x3,
    gateway_out2_x4 => gateway_out2_x4,
    gateway_out2_x5 => gateway_out2_x5,
    gateway_out2_x6 => gateway_out2_x6,
    gateway_out_x0 => gateway_out_x0,
    gateway_out_x1 => gateway_out_x1,
    gateway_out_x2 => gateway_out_x2,
    gateway_out_x3 => gateway_out_x3,
    gateway_out_x4 => gateway_out_x4,
    gateway_out_x5 => gateway_out_x5,
    gateway_out_x6 => gateway_out_x6,
    gateway_t1 => gateway_t1,
    gateway_t1_x0 => gateway_t1_x0,
    gateway_t1_x1 => gateway_t1_x1,
    gateway_t1_x2 => gateway_t1_x2,
    gateway_t1_x3 => gateway_t1_x3,
    gateway_t1_x4 => gateway_t1_x4,
    gateway_t1_x5 => gateway_t1_x5,
    gateway_t1_x6 => gateway_t1_x6,
    gateway_t2 => gateway_t2,
    gateway_t2_x0 => gateway_t2_x0,
    gateway_t2_x1 => gateway_t2_x1,
    gateway_t2_x2 => gateway_t2_x2,
    gateway_t2_x3 => gateway_t2_x3,
    gateway_t2_x4 => gateway_t2_x4,
    gateway_t2_x5 => gateway_t2_x5,
    gateway_t2_x6 => gateway_t2_x6,
    gateway_t3 => gateway_t3,
    gateway_t3_x0 => gateway_t3_x0,
    gateway_t3_x1 => gateway_t3_x1,
    gateway_t3_x2 => gateway_t3_x2,
    gateway_t3_x3 => gateway_t3_x3,
    gateway_t3_x4 => gateway_t3_x4,
    gateway_t3_x5 => gateway_t3_x5,
    gateway_t3_x6 => gateway_t3_x6);
-- INST_TAG_END ------ End INSTANTIATION Template ------------
