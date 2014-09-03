
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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;
-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on
entity xlclockdriver is
  generic (
    period: integer := 2;
    log_2_period: integer := 0;
    pipeline_regs: integer := 5;
    use_bufg: integer := 0
  );
  port (
    sysclk: in std_logic;
    sysclr: in std_logic;
    sysce: in std_logic;
    clk: out std_logic;
    clr: out std_logic;
    ce: out std_logic;
    ce_logic: out std_logic
  );
end xlclockdriver;
architecture behavior of xlclockdriver is
  component bufg
    port (
      i: in std_logic;
      o: out std_logic
    );
  end component;
  component synth_reg_w_init
    generic (
      width: integer;
      init_index: integer;
      init_value: bit_vector;
      latency: integer
    );
    port (
      i: in std_logic_vector(width - 1 downto 0);
      ce: in std_logic;
      clr: in std_logic;
      clk: in std_logic;
      o: out std_logic_vector(width - 1 downto 0)
    );
  end component;
  function size_of_uint(inp: integer; power_of_2: boolean)
    return integer
  is
    constant inp_vec: std_logic_vector(31 downto 0) :=
      integer_to_std_logic_vector(inp,32, xlUnsigned);
    variable result: integer;
  begin
    result := 32;
    for i in 0 to 31 loop
      if inp_vec(i) = '1' then
        result := i;
      end if;
    end loop;
    if power_of_2 then
      return result;
    else
      return result+1;
    end if;
  end;
  function is_power_of_2(inp: std_logic_vector)
    return boolean
  is
    constant width: integer := inp'length;
    variable vec: std_logic_vector(width - 1 downto 0);
    variable single_bit_set: boolean;
    variable more_than_one_bit_set: boolean;
    variable result: boolean;
  begin
    vec := inp;
    single_bit_set := false;
    more_than_one_bit_set := false;
    -- synopsys translate_off
    if (is_XorU(vec)) then
      return false;
    end if;
     -- synopsys translate_on
    if width > 0 then
      for i in 0 to width - 1 loop
        if vec(i) = '1' then
          if single_bit_set then
            more_than_one_bit_set := true;
          end if;
          single_bit_set := true;
        end if;
      end loop;
    end if;
    if (single_bit_set and not(more_than_one_bit_set)) then
      result := true;
    else
      result := false;
    end if;
    return result;
  end;
  function ce_reg_init_val(index, period : integer)
    return integer
  is
     variable result: integer;
   begin
      result := 0;
      if ((index mod period) = 0) then
          result := 1;
      end if;
      return result;
  end;
  function remaining_pipe_regs(num_pipeline_regs, period : integer)
    return integer
  is
     variable factor, result: integer;
  begin
      factor := (num_pipeline_regs / period);
      result := num_pipeline_regs - (period * factor) + 1;
      return result;
  end;

  function sg_min(L, R: INTEGER) return INTEGER is
  begin
      if L < R then
            return L;
      else
            return R;
      end if;
  end;
  constant max_pipeline_regs : integer := 8;
  constant pipe_regs : integer := 5;
  constant num_pipeline_regs : integer := sg_min(pipeline_regs, max_pipeline_regs);
  constant rem_pipeline_regs : integer := remaining_pipe_regs(num_pipeline_regs,period);
  constant period_floor: integer := max(2, period);
  constant power_of_2_counter: boolean :=
    is_power_of_2(integer_to_std_logic_vector(period_floor,32, xlUnsigned));
  constant cnt_width: integer :=
    size_of_uint(period_floor, power_of_2_counter);
  constant clk_for_ce_pulse_minus1: std_logic_vector(cnt_width - 1 downto 0) :=
    integer_to_std_logic_vector((period_floor - 2),cnt_width, xlUnsigned);
  constant clk_for_ce_pulse_minus2: std_logic_vector(cnt_width - 1 downto 0) :=
    integer_to_std_logic_vector(max(0,period - 3),cnt_width, xlUnsigned);
  constant clk_for_ce_pulse_minus_regs: std_logic_vector(cnt_width - 1 downto 0) :=
    integer_to_std_logic_vector(max(0,period - rem_pipeline_regs),cnt_width, xlUnsigned);
  signal clk_num: unsigned(cnt_width - 1 downto 0) := (others => '0');
  signal ce_vec : std_logic_vector(num_pipeline_regs downto 0);
  attribute MAX_FANOUT : string;
  attribute MAX_FANOUT of ce_vec:signal is "REDUCE";
  signal ce_vec_logic : std_logic_vector(num_pipeline_regs downto 0);
  attribute MAX_FANOUT of ce_vec_logic:signal is "REDUCE";
  signal internal_ce: std_logic_vector(0 downto 0);
  signal internal_ce_logic: std_logic_vector(0 downto 0);
  signal cnt_clr, cnt_clr_dly: std_logic_vector (0 downto 0);
begin
  clk <= sysclk;
  clr <= sysclr;
  cntr_gen: process(sysclk)
  begin
    if sysclk'event and sysclk = '1'  then
      if (sysce = '1') then
        if ((cnt_clr_dly(0) = '1') or (sysclr = '1')) then
          clk_num <= (others => '0');
        else
          clk_num <= clk_num + 1;
        end if;
    end if;
    end if;
  end process;
  clr_gen: process(clk_num, sysclr)
  begin
    if power_of_2_counter then
      cnt_clr(0) <= sysclr;
    else
      if (unsigned_to_std_logic_vector(clk_num) = clk_for_ce_pulse_minus1
          or sysclr = '1') then
        cnt_clr(0) <= '1';
      else
        cnt_clr(0) <= '0';
      end if;
    end if;
  end process;
  clr_reg: synth_reg_w_init
    generic map (
      width => 1,
      init_index => 0,
      init_value => b"0000",
      latency => 1
    )
    port map (
      i => cnt_clr,
      ce => sysce,
      clr => sysclr,
      clk => sysclk,
      o => cnt_clr_dly
    );
  pipelined_ce : if period > 1 generate
      ce_gen: process(clk_num)
      begin
          if unsigned_to_std_logic_vector(clk_num) = clk_for_ce_pulse_minus_regs then
              ce_vec(num_pipeline_regs) <= '1';
          else
              ce_vec(num_pipeline_regs) <= '0';
          end if;
      end process;
      ce_pipeline: for index in num_pipeline_regs downto 1 generate
          ce_reg : synth_reg_w_init
              generic map (
                  width => 1,
                  init_index => ce_reg_init_val(index, period),
                  init_value => b"0000",
                  latency => 1
                  )
              port map (
                  i => ce_vec(index downto index),
                  ce => sysce,
                  clr => sysclr,
                  clk => sysclk,
                  o => ce_vec(index-1 downto index-1)
                  );
      end generate;
      internal_ce <= ce_vec(0 downto 0);
  end generate;
  pipelined_ce_logic: if period > 1 generate
      ce_gen_logic: process(clk_num)
      begin
          if unsigned_to_std_logic_vector(clk_num) = clk_for_ce_pulse_minus_regs then
              ce_vec_logic(num_pipeline_regs) <= '1';
          else
              ce_vec_logic(num_pipeline_regs) <= '0';
          end if;
      end process;
      ce_logic_pipeline: for index in num_pipeline_regs downto 1 generate
          ce_logic_reg : synth_reg_w_init
              generic map (
                  width => 1,
                  init_index => ce_reg_init_val(index, period),
                  init_value => b"0000",
                  latency => 1
                  )
              port map (
                  i => ce_vec_logic(index downto index),
                  ce => sysce,
                  clr => sysclr,
                  clk => sysclk,
                  o => ce_vec_logic(index-1 downto index-1)
                  );
      end generate;
      internal_ce_logic <= ce_vec_logic(0 downto 0);
  end generate;
  use_bufg_true: if period > 1 and use_bufg = 1 generate
    ce_bufg_inst: bufg
      port map (
        i => internal_ce(0),
        o => ce
      );
    ce_bufg_inst_logic: bufg
      port map (
        i => internal_ce_logic(0),
        o => ce_logic
      );
  end generate;
  use_bufg_false: if period > 1 and (use_bufg = 0) generate
    ce <= internal_ce(0);
    ce_logic <= internal_ce_logic(0);
  end generate;
  generate_system_clk: if period = 1 generate
    ce <= sysce;
    ce_logic <= sysce;
  end generate;
end architecture behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

entity default_clock_driver_c09f12_01 is
  port (
    sysce: in std_logic; 
    sysce_clr: in std_logic; 
    sysclk: in std_logic; 
    ce_1: out std_logic; 
    clk_1: out std_logic
  );
end default_clock_driver_c09f12_01;

architecture structural of default_clock_driver_c09f12_01 is
  attribute syn_noprune: boolean;
  attribute syn_noprune of structural : architecture is true;
  attribute optimize_primitives: boolean;
  attribute optimize_primitives of structural : architecture is false;
  attribute dont_touch: boolean;
  attribute dont_touch of structural : architecture is true;

  signal sysce_clr_x0: std_logic;
  signal sysce_x0: std_logic;
  signal sysclk_x0: std_logic;
  signal xlclockdriver_1_ce: std_logic;
  signal xlclockdriver_1_clk: std_logic;

begin
  sysce_x0 <= sysce;
  sysce_clr_x0 <= sysce_clr;
  sysclk_x0 <= sysclk;
  ce_1 <= xlclockdriver_1_ce;
  clk_1 <= xlclockdriver_1_clk;

  xlclockdriver_1: entity work.xlclockdriver
    generic map (
      log_2_period => 1,
      period => 1,
      use_bufg => 0
    )
    port map (
      sysce => sysce_x0,
      sysclk => sysclk_x0,
      sysclr => sysce_clr_x0,
      ce => xlclockdriver_1_ce,
      clk => xlclockdriver_1_clk
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

entity c09f12_01_cw is
  port (
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
end c09f12_01_cw;

architecture structural of c09f12_01_cw is
  component xlpersistentdff
    port (
      clk: in std_logic; 
      d: in std_logic; 
      q: out std_logic
    );
  end component;
  attribute syn_black_box: boolean;
  attribute syn_black_box of xlpersistentdff: component is true;
  attribute box_type: string;
  attribute box_type of xlpersistentdff: component is "black_box";
  attribute syn_noprune: boolean;
  attribute optimize_primitives: boolean;
  attribute dont_touch: boolean;
  attribute syn_noprune of xlpersistentdff: component is true;
  attribute optimize_primitives of xlpersistentdff: component is false;
  attribute dont_touch of xlpersistentdff: component is true;

  signal c09f12_01_a0_fd0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_a0_fd1_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_a1_fd0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_a1_fd1_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_ctrl0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_ctrl1_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_bram_addr_net: std_logic_vector(9 downto 0);
  signal c09f12_01_adc_snap0_bram_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_bram_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_bram_we_net: std_logic;
  signal c09f12_01_adc_snap0_ctrl_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_status_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_tr_en_cnt_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_trig_offset_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap0_val_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_bram_addr_net: std_logic_vector(9 downto 0);
  signal c09f12_01_adc_snap1_bram_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_bram_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_bram_we_net: std_logic;
  signal c09f12_01_adc_snap1_ctrl_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_status_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_tr_en_cnt_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_trig_offset_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_snap1_val_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_sum_sq0_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_adc_sum_sq1_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_board_id_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_clk_frequency_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_coarse_ctrl_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_coarse_delay0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_coarse_delay1_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_control_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_delay_tr_status0_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_delay_tr_status1_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_eq0_addr_net: std_logic_vector(11 downto 0);
  signal c09f12_01_eq0_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_eq0_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_eq0_we_net: std_logic;
  signal c09f12_01_eq1_addr_net: std_logic_vector(11 downto 0);
  signal c09f12_01_eq1_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_eq1_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_eq1_we_net: std_logic;
  signal c09f12_01_fine_ctrl_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_fstatus0_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_fstatus1_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_gbe0_led_rx_net: std_logic;
  signal c09f12_01_gbe0_led_tx_net: std_logic;
  signal c09f12_01_gbe0_led_up_net: std_logic;
  signal c09f12_01_gbe0_rst_net: std_logic;
  signal c09f12_01_gbe0_rx_ack_net: std_logic;
  signal c09f12_01_gbe0_rx_bad_frame_net: std_logic;
  signal c09f12_01_gbe0_rx_data_net: std_logic_vector(63 downto 0);
  signal c09f12_01_gbe0_rx_end_of_frame_net: std_logic;
  signal c09f12_01_gbe0_rx_overrun_ack_net: std_logic;
  signal c09f12_01_gbe0_rx_overrun_net: std_logic;
  signal c09f12_01_gbe0_rx_source_ip_net: std_logic_vector(31 downto 0);
  signal c09f12_01_gbe0_rx_source_port_net: std_logic_vector(15 downto 0);
  signal c09f12_01_gbe0_rx_valid_net: std_logic;
  signal c09f12_01_gbe0_tx_afull_net: std_logic;
  signal c09f12_01_gbe0_tx_data_net: std_logic_vector(63 downto 0);
  signal c09f12_01_gbe0_tx_dest_ip_net: std_logic_vector(31 downto 0);
  signal c09f12_01_gbe0_tx_dest_port_net: std_logic_vector(15 downto 0);
  signal c09f12_01_gbe0_tx_end_of_frame_net: std_logic;
  signal c09f12_01_gbe0_tx_overflow_net: std_logic;
  signal c09f12_01_gbe0_tx_valid_net: std_logic;
  signal c09f12_01_gbe_ip0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_gbe_port_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_gbe_tx_cnt0_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_gbe_tx_err_cnt0_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_katadc0_gain_load_net: std_logic;
  signal c09f12_01_katadc0_gain_value_net: std_logic_vector(13 downto 0);
  signal c09f12_01_katadc0_user_data_valid_net: std_logic;
  signal c09f12_01_katadc0_user_datai0_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_datai1_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_datai2_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_datai3_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq0_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq1_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq2_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_dataq3_net: std_logic_vector(7 downto 0);
  signal c09f12_01_katadc0_user_outofrange0_net: std_logic;
  signal c09f12_01_katadc0_user_outofrange1_net: std_logic;
  signal c09f12_01_katadc0_user_sync0_net: std_logic;
  signal c09f12_01_katadc0_user_sync1_net: std_logic;
  signal c09f12_01_katadc0_user_sync2_net: std_logic;
  signal c09f12_01_katadc0_user_sync3_net: std_logic;
  signal c09f12_01_ld_time_lsw0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_ld_time_lsw1_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_ld_time_msw0_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_ld_time_msw1_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_leds_roach_gpioa0_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa1_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa2_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa3_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa4_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa5_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa6_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa7_gateway_net: std_logic;
  signal c09f12_01_leds_roach_gpioa_oe_gateway_net: std_logic;
  signal c09f12_01_leds_roach_led0_gateway_net: std_logic;
  signal c09f12_01_leds_roach_led1_gateway_net: std_logic;
  signal c09f12_01_leds_roach_led2_gateway_net: std_logic;
  signal c09f12_01_leds_roach_led3_gateway_net: std_logic;
  signal c09f12_01_mcount_lsw_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_mcount_msw_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_pps_count_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_qdr_ct_qdr_ack_net: std_logic;
  signal c09f12_01_qdr_ct_qdr_address_net: std_logic_vector(31 downto 0);
  signal c09f12_01_qdr_ct_qdr_be_net: std_logic_vector(3 downto 0);
  signal c09f12_01_qdr_ct_qdr_cal_fail_net: std_logic;
  signal c09f12_01_qdr_ct_qdr_data_in_net: std_logic_vector(35 downto 0);
  signal c09f12_01_qdr_ct_qdr_data_out_net: std_logic_vector(35 downto 0);
  signal c09f12_01_qdr_ct_qdr_phy_ready_net: std_logic;
  signal c09f12_01_qdr_ct_qdr_rd_en_net: std_logic;
  signal c09f12_01_qdr_ct_qdr_wr_en_net: std_logic;
  signal c09f12_01_rcs_app_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_rcs_lib_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_rcs_user_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_addr_user_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_bram_addr_net: std_logic_vector(10 downto 0);
  signal c09f12_01_snap_debug_bram_data_in_net: std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_bram_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_snap_debug_bram_we_net: std_logic;
  signal c09f12_01_snap_debug_ctrl_user_data_out_net: std_logic_vector(31 downto 0);
  signal c09f12_01_trig_level_user_data_out_net: std_logic_vector(31 downto 0);
  signal ce_1_sg_x706: std_logic;
  attribute MAX_FANOUT: string;
  attribute MAX_FANOUT of ce_1_sg_x706: signal is "REDUCE";
  signal clkNet: std_logic;
  signal clk_1_sg_x706: std_logic;
  signal gateway_out1_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x0_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x1_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x2_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x3_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x4_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x5_net: std_logic_vector(25 downto 0);
  signal gateway_out1_x6_net: std_logic_vector(25 downto 0);
  signal gateway_out2_net: std_logic;
  signal gateway_out2_x0_net: std_logic;
  signal gateway_out2_x1_net: std_logic;
  signal gateway_out2_x2_net: std_logic;
  signal gateway_out2_x3_net: std_logic;
  signal gateway_out2_x4_net: std_logic;
  signal gateway_out2_x5_net: std_logic;
  signal gateway_out2_x6_net: std_logic;
  signal gateway_out_net: std_logic;
  signal gateway_out_x0_net: std_logic;
  signal gateway_out_x1_net: std_logic;
  signal gateway_out_x2_net: std_logic;
  signal gateway_out_x3_net: std_logic;
  signal gateway_out_x4_net: std_logic;
  signal gateway_out_x5_net: std_logic;
  signal gateway_out_x6_net: std_logic;
  signal gateway_t1_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x0_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x1_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x2_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x3_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x4_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x5_net: std_logic_vector(7 downto 0);
  signal gateway_t1_x6_net: std_logic_vector(7 downto 0);
  signal gateway_t2_net: std_logic;
  signal gateway_t2_x0_net: std_logic;
  signal gateway_t2_x1_net: std_logic;
  signal gateway_t2_x2_net: std_logic;
  signal gateway_t2_x3_net: std_logic;
  signal gateway_t2_x4_net: std_logic;
  signal gateway_t2_x5_net: std_logic;
  signal gateway_t2_x6_net: std_logic;
  signal gateway_t3_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x0_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x1_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x2_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x3_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x4_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x5_net: std_logic_vector(8 downto 0);
  signal gateway_t3_x6_net: std_logic_vector(8 downto 0);
  signal persistentdff_inst_q: std_logic;
  attribute syn_keep: boolean;
  attribute syn_keep of persistentdff_inst_q: signal is true;
  attribute keep: boolean;
  attribute keep of persistentdff_inst_q: signal is true;
  attribute preserve_signal: boolean;
  attribute preserve_signal of persistentdff_inst_q: signal is true;

begin
  c09f12_01_a0_fd0_user_data_out_net <= c09f12_01_a0_fd0_user_data_out;
  c09f12_01_a0_fd1_user_data_out_net <= c09f12_01_a0_fd1_user_data_out;
  c09f12_01_a1_fd0_user_data_out_net <= c09f12_01_a1_fd0_user_data_out;
  c09f12_01_a1_fd1_user_data_out_net <= c09f12_01_a1_fd1_user_data_out;
  c09f12_01_adc_ctrl0_user_data_out_net <= c09f12_01_adc_ctrl0_user_data_out;
  c09f12_01_adc_ctrl1_user_data_out_net <= c09f12_01_adc_ctrl1_user_data_out;
  c09f12_01_adc_snap0_bram_data_out_net <= c09f12_01_adc_snap0_bram_data_out;
  c09f12_01_adc_snap0_ctrl_user_data_out_net <= c09f12_01_adc_snap0_ctrl_user_data_out;
  c09f12_01_adc_snap0_trig_offset_user_data_out_net <= c09f12_01_adc_snap0_trig_offset_user_data_out;
  c09f12_01_adc_snap1_bram_data_out_net <= c09f12_01_adc_snap1_bram_data_out;
  c09f12_01_adc_snap1_ctrl_user_data_out_net <= c09f12_01_adc_snap1_ctrl_user_data_out;
  c09f12_01_adc_snap1_trig_offset_user_data_out_net <= c09f12_01_adc_snap1_trig_offset_user_data_out;
  c09f12_01_board_id_user_data_out_net <= c09f12_01_board_id_user_data_out;
  c09f12_01_coarse_ctrl_user_data_out_net <= c09f12_01_coarse_ctrl_user_data_out;
  c09f12_01_coarse_delay0_user_data_out_net <= c09f12_01_coarse_delay0_user_data_out;
  c09f12_01_coarse_delay1_user_data_out_net <= c09f12_01_coarse_delay1_user_data_out;
  c09f12_01_control_user_data_out_net <= c09f12_01_control_user_data_out;
  c09f12_01_eq0_data_out_net <= c09f12_01_eq0_data_out;
  c09f12_01_eq1_data_out_net <= c09f12_01_eq1_data_out;
  c09f12_01_fine_ctrl_user_data_out_net <= c09f12_01_fine_ctrl_user_data_out;
  c09f12_01_gbe0_led_rx_net <= c09f12_01_gbe0_led_rx;
  c09f12_01_gbe0_led_tx_net <= c09f12_01_gbe0_led_tx;
  c09f12_01_gbe0_led_up_net <= c09f12_01_gbe0_led_up;
  c09f12_01_gbe0_rx_bad_frame_net <= c09f12_01_gbe0_rx_bad_frame;
  c09f12_01_gbe0_rx_data_net <= c09f12_01_gbe0_rx_data;
  c09f12_01_gbe0_rx_end_of_frame_net <= c09f12_01_gbe0_rx_end_of_frame;
  c09f12_01_gbe0_rx_overrun_net <= c09f12_01_gbe0_rx_overrun;
  c09f12_01_gbe0_rx_source_ip_net <= c09f12_01_gbe0_rx_source_ip;
  c09f12_01_gbe0_rx_source_port_net <= c09f12_01_gbe0_rx_source_port;
  c09f12_01_gbe0_rx_valid_net <= c09f12_01_gbe0_rx_valid;
  c09f12_01_gbe0_tx_afull_net <= c09f12_01_gbe0_tx_afull;
  c09f12_01_gbe0_tx_overflow_net <= c09f12_01_gbe0_tx_overflow;
  c09f12_01_gbe_ip0_user_data_out_net <= c09f12_01_gbe_ip0_user_data_out;
  c09f12_01_gbe_port_user_data_out_net <= c09f12_01_gbe_port_user_data_out;
  c09f12_01_katadc0_user_data_valid_net <= c09f12_01_katadc0_user_data_valid;
  c09f12_01_katadc0_user_datai0_net <= c09f12_01_katadc0_user_datai0;
  c09f12_01_katadc0_user_datai1_net <= c09f12_01_katadc0_user_datai1;
  c09f12_01_katadc0_user_datai2_net <= c09f12_01_katadc0_user_datai2;
  c09f12_01_katadc0_user_datai3_net <= c09f12_01_katadc0_user_datai3;
  c09f12_01_katadc0_user_dataq0_net <= c09f12_01_katadc0_user_dataq0;
  c09f12_01_katadc0_user_dataq1_net <= c09f12_01_katadc0_user_dataq1;
  c09f12_01_katadc0_user_dataq2_net <= c09f12_01_katadc0_user_dataq2;
  c09f12_01_katadc0_user_dataq3_net <= c09f12_01_katadc0_user_dataq3;
  c09f12_01_katadc0_user_outofrange0_net <= c09f12_01_katadc0_user_outofrange0;
  c09f12_01_katadc0_user_outofrange1_net <= c09f12_01_katadc0_user_outofrange1;
  c09f12_01_katadc0_user_sync0_net <= c09f12_01_katadc0_user_sync0;
  c09f12_01_katadc0_user_sync1_net <= c09f12_01_katadc0_user_sync1;
  c09f12_01_katadc0_user_sync2_net <= c09f12_01_katadc0_user_sync2;
  c09f12_01_katadc0_user_sync3_net <= c09f12_01_katadc0_user_sync3;
  c09f12_01_ld_time_lsw0_user_data_out_net <= c09f12_01_ld_time_lsw0_user_data_out;
  c09f12_01_ld_time_lsw1_user_data_out_net <= c09f12_01_ld_time_lsw1_user_data_out;
  c09f12_01_ld_time_msw0_user_data_out_net <= c09f12_01_ld_time_msw0_user_data_out;
  c09f12_01_ld_time_msw1_user_data_out_net <= c09f12_01_ld_time_msw1_user_data_out;
  c09f12_01_qdr_ct_qdr_ack_net <= c09f12_01_qdr_ct_qdr_ack;
  c09f12_01_qdr_ct_qdr_cal_fail_net <= c09f12_01_qdr_ct_qdr_cal_fail;
  c09f12_01_qdr_ct_qdr_data_out_net <= c09f12_01_qdr_ct_qdr_data_out;
  c09f12_01_qdr_ct_qdr_phy_ready_net <= c09f12_01_qdr_ct_qdr_phy_ready;
  c09f12_01_snap_debug_bram_data_out_net <= c09f12_01_snap_debug_bram_data_out;
  c09f12_01_snap_debug_ctrl_user_data_out_net <= c09f12_01_snap_debug_ctrl_user_data_out;
  c09f12_01_trig_level_user_data_out_net <= c09f12_01_trig_level_user_data_out;
  clkNet <= clk;
  c09f12_01_adc_snap0_bram_addr <= c09f12_01_adc_snap0_bram_addr_net;
  c09f12_01_adc_snap0_bram_data_in <= c09f12_01_adc_snap0_bram_data_in_net;
  c09f12_01_adc_snap0_bram_we <= c09f12_01_adc_snap0_bram_we_net;
  c09f12_01_adc_snap0_status_user_data_in <= c09f12_01_adc_snap0_status_user_data_in_net;
  c09f12_01_adc_snap0_tr_en_cnt_user_data_in <= c09f12_01_adc_snap0_tr_en_cnt_user_data_in_net;
  c09f12_01_adc_snap0_val_user_data_in <= c09f12_01_adc_snap0_val_user_data_in_net;
  c09f12_01_adc_snap1_bram_addr <= c09f12_01_adc_snap1_bram_addr_net;
  c09f12_01_adc_snap1_bram_data_in <= c09f12_01_adc_snap1_bram_data_in_net;
  c09f12_01_adc_snap1_bram_we <= c09f12_01_adc_snap1_bram_we_net;
  c09f12_01_adc_snap1_status_user_data_in <= c09f12_01_adc_snap1_status_user_data_in_net;
  c09f12_01_adc_snap1_tr_en_cnt_user_data_in <= c09f12_01_adc_snap1_tr_en_cnt_user_data_in_net;
  c09f12_01_adc_snap1_val_user_data_in <= c09f12_01_adc_snap1_val_user_data_in_net;
  c09f12_01_adc_sum_sq0_user_data_in <= c09f12_01_adc_sum_sq0_user_data_in_net;
  c09f12_01_adc_sum_sq1_user_data_in <= c09f12_01_adc_sum_sq1_user_data_in_net;
  c09f12_01_clk_frequency_user_data_in <= c09f12_01_clk_frequency_user_data_in_net;
  c09f12_01_delay_tr_status0_user_data_in <= c09f12_01_delay_tr_status0_user_data_in_net;
  c09f12_01_delay_tr_status1_user_data_in <= c09f12_01_delay_tr_status1_user_data_in_net;
  c09f12_01_eq0_addr <= c09f12_01_eq0_addr_net;
  c09f12_01_eq0_data_in <= c09f12_01_eq0_data_in_net;
  c09f12_01_eq0_we <= c09f12_01_eq0_we_net;
  c09f12_01_eq1_addr <= c09f12_01_eq1_addr_net;
  c09f12_01_eq1_data_in <= c09f12_01_eq1_data_in_net;
  c09f12_01_eq1_we <= c09f12_01_eq1_we_net;
  c09f12_01_fstatus0_user_data_in <= c09f12_01_fstatus0_user_data_in_net;
  c09f12_01_fstatus1_user_data_in <= c09f12_01_fstatus1_user_data_in_net;
  c09f12_01_gbe0_rst <= c09f12_01_gbe0_rst_net;
  c09f12_01_gbe0_rx_ack <= c09f12_01_gbe0_rx_ack_net;
  c09f12_01_gbe0_rx_overrun_ack <= c09f12_01_gbe0_rx_overrun_ack_net;
  c09f12_01_gbe0_tx_data <= c09f12_01_gbe0_tx_data_net;
  c09f12_01_gbe0_tx_dest_ip <= c09f12_01_gbe0_tx_dest_ip_net;
  c09f12_01_gbe0_tx_dest_port <= c09f12_01_gbe0_tx_dest_port_net;
  c09f12_01_gbe0_tx_end_of_frame <= c09f12_01_gbe0_tx_end_of_frame_net;
  c09f12_01_gbe0_tx_valid <= c09f12_01_gbe0_tx_valid_net;
  c09f12_01_gbe_tx_cnt0_user_data_in <= c09f12_01_gbe_tx_cnt0_user_data_in_net;
  c09f12_01_gbe_tx_err_cnt0_user_data_in <= c09f12_01_gbe_tx_err_cnt0_user_data_in_net;
  c09f12_01_katadc0_gain_load <= c09f12_01_katadc0_gain_load_net;
  c09f12_01_katadc0_gain_value <= c09f12_01_katadc0_gain_value_net;
  c09f12_01_leds_roach_gpioa0_gateway <= c09f12_01_leds_roach_gpioa0_gateway_net;
  c09f12_01_leds_roach_gpioa1_gateway <= c09f12_01_leds_roach_gpioa1_gateway_net;
  c09f12_01_leds_roach_gpioa2_gateway <= c09f12_01_leds_roach_gpioa2_gateway_net;
  c09f12_01_leds_roach_gpioa3_gateway <= c09f12_01_leds_roach_gpioa3_gateway_net;
  c09f12_01_leds_roach_gpioa4_gateway <= c09f12_01_leds_roach_gpioa4_gateway_net;
  c09f12_01_leds_roach_gpioa5_gateway <= c09f12_01_leds_roach_gpioa5_gateway_net;
  c09f12_01_leds_roach_gpioa6_gateway <= c09f12_01_leds_roach_gpioa6_gateway_net;
  c09f12_01_leds_roach_gpioa7_gateway <= c09f12_01_leds_roach_gpioa7_gateway_net;
  c09f12_01_leds_roach_gpioa_oe_gateway <= c09f12_01_leds_roach_gpioa_oe_gateway_net;
  c09f12_01_leds_roach_led0_gateway <= c09f12_01_leds_roach_led0_gateway_net;
  c09f12_01_leds_roach_led1_gateway <= c09f12_01_leds_roach_led1_gateway_net;
  c09f12_01_leds_roach_led2_gateway <= c09f12_01_leds_roach_led2_gateway_net;
  c09f12_01_leds_roach_led3_gateway <= c09f12_01_leds_roach_led3_gateway_net;
  c09f12_01_mcount_lsw_user_data_in <= c09f12_01_mcount_lsw_user_data_in_net;
  c09f12_01_mcount_msw_user_data_in <= c09f12_01_mcount_msw_user_data_in_net;
  c09f12_01_pps_count_user_data_in <= c09f12_01_pps_count_user_data_in_net;
  c09f12_01_qdr_ct_qdr_address <= c09f12_01_qdr_ct_qdr_address_net;
  c09f12_01_qdr_ct_qdr_be <= c09f12_01_qdr_ct_qdr_be_net;
  c09f12_01_qdr_ct_qdr_data_in <= c09f12_01_qdr_ct_qdr_data_in_net;
  c09f12_01_qdr_ct_qdr_rd_en <= c09f12_01_qdr_ct_qdr_rd_en_net;
  c09f12_01_qdr_ct_qdr_wr_en <= c09f12_01_qdr_ct_qdr_wr_en_net;
  c09f12_01_rcs_app_user_data_in <= c09f12_01_rcs_app_user_data_in_net;
  c09f12_01_rcs_lib_user_data_in <= c09f12_01_rcs_lib_user_data_in_net;
  c09f12_01_rcs_user_user_data_in <= c09f12_01_rcs_user_user_data_in_net;
  c09f12_01_snap_debug_addr_user_data_in <= c09f12_01_snap_debug_addr_user_data_in_net;
  c09f12_01_snap_debug_bram_addr <= c09f12_01_snap_debug_bram_addr_net;
  c09f12_01_snap_debug_bram_data_in <= c09f12_01_snap_debug_bram_data_in_net;
  c09f12_01_snap_debug_bram_we <= c09f12_01_snap_debug_bram_we_net;
  gateway_out <= gateway_out_net;
  gateway_out1 <= gateway_out1_net;
  gateway_out1_x0 <= gateway_out1_x0_net;
  gateway_out1_x1 <= gateway_out1_x1_net;
  gateway_out1_x2 <= gateway_out1_x2_net;
  gateway_out1_x3 <= gateway_out1_x3_net;
  gateway_out1_x4 <= gateway_out1_x4_net;
  gateway_out1_x5 <= gateway_out1_x5_net;
  gateway_out1_x6 <= gateway_out1_x6_net;
  gateway_out2 <= gateway_out2_net;
  gateway_out2_x0 <= gateway_out2_x0_net;
  gateway_out2_x1 <= gateway_out2_x1_net;
  gateway_out2_x2 <= gateway_out2_x2_net;
  gateway_out2_x3 <= gateway_out2_x3_net;
  gateway_out2_x4 <= gateway_out2_x4_net;
  gateway_out2_x5 <= gateway_out2_x5_net;
  gateway_out2_x6 <= gateway_out2_x6_net;
  gateway_out_x0 <= gateway_out_x0_net;
  gateway_out_x1 <= gateway_out_x1_net;
  gateway_out_x2 <= gateway_out_x2_net;
  gateway_out_x3 <= gateway_out_x3_net;
  gateway_out_x4 <= gateway_out_x4_net;
  gateway_out_x5 <= gateway_out_x5_net;
  gateway_out_x6 <= gateway_out_x6_net;
  gateway_t1 <= gateway_t1_net;
  gateway_t1_x0 <= gateway_t1_x0_net;
  gateway_t1_x1 <= gateway_t1_x1_net;
  gateway_t1_x2 <= gateway_t1_x2_net;
  gateway_t1_x3 <= gateway_t1_x3_net;
  gateway_t1_x4 <= gateway_t1_x4_net;
  gateway_t1_x5 <= gateway_t1_x5_net;
  gateway_t1_x6 <= gateway_t1_x6_net;
  gateway_t2 <= gateway_t2_net;
  gateway_t2_x0 <= gateway_t2_x0_net;
  gateway_t2_x1 <= gateway_t2_x1_net;
  gateway_t2_x2 <= gateway_t2_x2_net;
  gateway_t2_x3 <= gateway_t2_x3_net;
  gateway_t2_x4 <= gateway_t2_x4_net;
  gateway_t2_x5 <= gateway_t2_x5_net;
  gateway_t2_x6 <= gateway_t2_x6_net;
  gateway_t3 <= gateway_t3_net;
  gateway_t3_x0 <= gateway_t3_x0_net;
  gateway_t3_x1 <= gateway_t3_x1_net;
  gateway_t3_x2 <= gateway_t3_x2_net;
  gateway_t3_x3 <= gateway_t3_x3_net;
  gateway_t3_x4 <= gateway_t3_x4_net;
  gateway_t3_x5 <= gateway_t3_x5_net;
  gateway_t3_x6 <= gateway_t3_x6_net;

  c09f12_01_x0: entity work.c09f12_01
    port map (
      c09f12_01_a0_fd0_user_data_out => c09f12_01_a0_fd0_user_data_out_net,
      c09f12_01_a0_fd1_user_data_out => c09f12_01_a0_fd1_user_data_out_net,
      c09f12_01_a1_fd0_user_data_out => c09f12_01_a1_fd0_user_data_out_net,
      c09f12_01_a1_fd1_user_data_out => c09f12_01_a1_fd1_user_data_out_net,
      c09f12_01_adc_ctrl0_user_data_out => c09f12_01_adc_ctrl0_user_data_out_net,
      c09f12_01_adc_ctrl1_user_data_out => c09f12_01_adc_ctrl1_user_data_out_net,
      c09f12_01_adc_snap0_bram_data_out => c09f12_01_adc_snap0_bram_data_out_net,
      c09f12_01_adc_snap0_ctrl_user_data_out => c09f12_01_adc_snap0_ctrl_user_data_out_net,
      c09f12_01_adc_snap0_trig_offset_user_data_out => c09f12_01_adc_snap0_trig_offset_user_data_out_net,
      c09f12_01_adc_snap1_bram_data_out => c09f12_01_adc_snap1_bram_data_out_net,
      c09f12_01_adc_snap1_ctrl_user_data_out => c09f12_01_adc_snap1_ctrl_user_data_out_net,
      c09f12_01_adc_snap1_trig_offset_user_data_out => c09f12_01_adc_snap1_trig_offset_user_data_out_net,
      c09f12_01_board_id_user_data_out => c09f12_01_board_id_user_data_out_net,
      c09f12_01_coarse_ctrl_user_data_out => c09f12_01_coarse_ctrl_user_data_out_net,
      c09f12_01_coarse_delay0_user_data_out => c09f12_01_coarse_delay0_user_data_out_net,
      c09f12_01_coarse_delay1_user_data_out => c09f12_01_coarse_delay1_user_data_out_net,
      c09f12_01_control_user_data_out => c09f12_01_control_user_data_out_net,
      c09f12_01_eq0_data_out => c09f12_01_eq0_data_out_net,
      c09f12_01_eq1_data_out => c09f12_01_eq1_data_out_net,
      c09f12_01_fine_ctrl_user_data_out => c09f12_01_fine_ctrl_user_data_out_net,
      c09f12_01_gbe0_led_rx => c09f12_01_gbe0_led_rx_net,
      c09f12_01_gbe0_led_tx => c09f12_01_gbe0_led_tx_net,
      c09f12_01_gbe0_led_up => c09f12_01_gbe0_led_up_net,
      c09f12_01_gbe0_rx_bad_frame => c09f12_01_gbe0_rx_bad_frame_net,
      c09f12_01_gbe0_rx_data => c09f12_01_gbe0_rx_data_net,
      c09f12_01_gbe0_rx_end_of_frame => c09f12_01_gbe0_rx_end_of_frame_net,
      c09f12_01_gbe0_rx_overrun => c09f12_01_gbe0_rx_overrun_net,
      c09f12_01_gbe0_rx_source_ip => c09f12_01_gbe0_rx_source_ip_net,
      c09f12_01_gbe0_rx_source_port => c09f12_01_gbe0_rx_source_port_net,
      c09f12_01_gbe0_rx_valid => c09f12_01_gbe0_rx_valid_net,
      c09f12_01_gbe0_tx_afull => c09f12_01_gbe0_tx_afull_net,
      c09f12_01_gbe0_tx_overflow => c09f12_01_gbe0_tx_overflow_net,
      c09f12_01_gbe_ip0_user_data_out => c09f12_01_gbe_ip0_user_data_out_net,
      c09f12_01_gbe_port_user_data_out => c09f12_01_gbe_port_user_data_out_net,
      c09f12_01_katadc0_user_data_valid => c09f12_01_katadc0_user_data_valid_net,
      c09f12_01_katadc0_user_datai0 => c09f12_01_katadc0_user_datai0_net,
      c09f12_01_katadc0_user_datai1 => c09f12_01_katadc0_user_datai1_net,
      c09f12_01_katadc0_user_datai2 => c09f12_01_katadc0_user_datai2_net,
      c09f12_01_katadc0_user_datai3 => c09f12_01_katadc0_user_datai3_net,
      c09f12_01_katadc0_user_dataq0 => c09f12_01_katadc0_user_dataq0_net,
      c09f12_01_katadc0_user_dataq1 => c09f12_01_katadc0_user_dataq1_net,
      c09f12_01_katadc0_user_dataq2 => c09f12_01_katadc0_user_dataq2_net,
      c09f12_01_katadc0_user_dataq3 => c09f12_01_katadc0_user_dataq3_net,
      c09f12_01_katadc0_user_outofrange0 => c09f12_01_katadc0_user_outofrange0_net,
      c09f12_01_katadc0_user_outofrange1 => c09f12_01_katadc0_user_outofrange1_net,
      c09f12_01_katadc0_user_sync0 => c09f12_01_katadc0_user_sync0_net,
      c09f12_01_katadc0_user_sync1 => c09f12_01_katadc0_user_sync1_net,
      c09f12_01_katadc0_user_sync2 => c09f12_01_katadc0_user_sync2_net,
      c09f12_01_katadc0_user_sync3 => c09f12_01_katadc0_user_sync3_net,
      c09f12_01_ld_time_lsw0_user_data_out => c09f12_01_ld_time_lsw0_user_data_out_net,
      c09f12_01_ld_time_lsw1_user_data_out => c09f12_01_ld_time_lsw1_user_data_out_net,
      c09f12_01_ld_time_msw0_user_data_out => c09f12_01_ld_time_msw0_user_data_out_net,
      c09f12_01_ld_time_msw1_user_data_out => c09f12_01_ld_time_msw1_user_data_out_net,
      c09f12_01_qdr_ct_qdr_ack => c09f12_01_qdr_ct_qdr_ack_net,
      c09f12_01_qdr_ct_qdr_cal_fail => c09f12_01_qdr_ct_qdr_cal_fail_net,
      c09f12_01_qdr_ct_qdr_data_out => c09f12_01_qdr_ct_qdr_data_out_net,
      c09f12_01_qdr_ct_qdr_phy_ready => c09f12_01_qdr_ct_qdr_phy_ready_net,
      c09f12_01_snap_debug_bram_data_out => c09f12_01_snap_debug_bram_data_out_net,
      c09f12_01_snap_debug_ctrl_user_data_out => c09f12_01_snap_debug_ctrl_user_data_out_net,
      c09f12_01_trig_level_user_data_out => c09f12_01_trig_level_user_data_out_net,
      ce_1 => ce_1_sg_x706,
      clk_1 => clk_1_sg_x706,
      c09f12_01_adc_snap0_bram_addr => c09f12_01_adc_snap0_bram_addr_net,
      c09f12_01_adc_snap0_bram_data_in => c09f12_01_adc_snap0_bram_data_in_net,
      c09f12_01_adc_snap0_bram_we => c09f12_01_adc_snap0_bram_we_net,
      c09f12_01_adc_snap0_status_user_data_in => c09f12_01_adc_snap0_status_user_data_in_net,
      c09f12_01_adc_snap0_tr_en_cnt_user_data_in => c09f12_01_adc_snap0_tr_en_cnt_user_data_in_net,
      c09f12_01_adc_snap0_val_user_data_in => c09f12_01_adc_snap0_val_user_data_in_net,
      c09f12_01_adc_snap1_bram_addr => c09f12_01_adc_snap1_bram_addr_net,
      c09f12_01_adc_snap1_bram_data_in => c09f12_01_adc_snap1_bram_data_in_net,
      c09f12_01_adc_snap1_bram_we => c09f12_01_adc_snap1_bram_we_net,
      c09f12_01_adc_snap1_status_user_data_in => c09f12_01_adc_snap1_status_user_data_in_net,
      c09f12_01_adc_snap1_tr_en_cnt_user_data_in => c09f12_01_adc_snap1_tr_en_cnt_user_data_in_net,
      c09f12_01_adc_snap1_val_user_data_in => c09f12_01_adc_snap1_val_user_data_in_net,
      c09f12_01_adc_sum_sq0_user_data_in => c09f12_01_adc_sum_sq0_user_data_in_net,
      c09f12_01_adc_sum_sq1_user_data_in => c09f12_01_adc_sum_sq1_user_data_in_net,
      c09f12_01_clk_frequency_user_data_in => c09f12_01_clk_frequency_user_data_in_net,
      c09f12_01_delay_tr_status0_user_data_in => c09f12_01_delay_tr_status0_user_data_in_net,
      c09f12_01_delay_tr_status1_user_data_in => c09f12_01_delay_tr_status1_user_data_in_net,
      c09f12_01_eq0_addr => c09f12_01_eq0_addr_net,
      c09f12_01_eq0_data_in => c09f12_01_eq0_data_in_net,
      c09f12_01_eq0_we => c09f12_01_eq0_we_net,
      c09f12_01_eq1_addr => c09f12_01_eq1_addr_net,
      c09f12_01_eq1_data_in => c09f12_01_eq1_data_in_net,
      c09f12_01_eq1_we => c09f12_01_eq1_we_net,
      c09f12_01_fstatus0_user_data_in => c09f12_01_fstatus0_user_data_in_net,
      c09f12_01_fstatus1_user_data_in => c09f12_01_fstatus1_user_data_in_net,
      c09f12_01_gbe0_rst => c09f12_01_gbe0_rst_net,
      c09f12_01_gbe0_rx_ack => c09f12_01_gbe0_rx_ack_net,
      c09f12_01_gbe0_rx_overrun_ack => c09f12_01_gbe0_rx_overrun_ack_net,
      c09f12_01_gbe0_tx_data => c09f12_01_gbe0_tx_data_net,
      c09f12_01_gbe0_tx_dest_ip => c09f12_01_gbe0_tx_dest_ip_net,
      c09f12_01_gbe0_tx_dest_port => c09f12_01_gbe0_tx_dest_port_net,
      c09f12_01_gbe0_tx_end_of_frame => c09f12_01_gbe0_tx_end_of_frame_net,
      c09f12_01_gbe0_tx_valid => c09f12_01_gbe0_tx_valid_net,
      c09f12_01_gbe_tx_cnt0_user_data_in => c09f12_01_gbe_tx_cnt0_user_data_in_net,
      c09f12_01_gbe_tx_err_cnt0_user_data_in => c09f12_01_gbe_tx_err_cnt0_user_data_in_net,
      c09f12_01_katadc0_gain_load => c09f12_01_katadc0_gain_load_net,
      c09f12_01_katadc0_gain_value => c09f12_01_katadc0_gain_value_net,
      c09f12_01_leds_roach_gpioa0_gateway => c09f12_01_leds_roach_gpioa0_gateway_net,
      c09f12_01_leds_roach_gpioa1_gateway => c09f12_01_leds_roach_gpioa1_gateway_net,
      c09f12_01_leds_roach_gpioa2_gateway => c09f12_01_leds_roach_gpioa2_gateway_net,
      c09f12_01_leds_roach_gpioa3_gateway => c09f12_01_leds_roach_gpioa3_gateway_net,
      c09f12_01_leds_roach_gpioa4_gateway => c09f12_01_leds_roach_gpioa4_gateway_net,
      c09f12_01_leds_roach_gpioa5_gateway => c09f12_01_leds_roach_gpioa5_gateway_net,
      c09f12_01_leds_roach_gpioa6_gateway => c09f12_01_leds_roach_gpioa6_gateway_net,
      c09f12_01_leds_roach_gpioa7_gateway => c09f12_01_leds_roach_gpioa7_gateway_net,
      c09f12_01_leds_roach_gpioa_oe_gateway => c09f12_01_leds_roach_gpioa_oe_gateway_net,
      c09f12_01_leds_roach_led0_gateway => c09f12_01_leds_roach_led0_gateway_net,
      c09f12_01_leds_roach_led1_gateway => c09f12_01_leds_roach_led1_gateway_net,
      c09f12_01_leds_roach_led2_gateway => c09f12_01_leds_roach_led2_gateway_net,
      c09f12_01_leds_roach_led3_gateway => c09f12_01_leds_roach_led3_gateway_net,
      c09f12_01_mcount_lsw_user_data_in => c09f12_01_mcount_lsw_user_data_in_net,
      c09f12_01_mcount_msw_user_data_in => c09f12_01_mcount_msw_user_data_in_net,
      c09f12_01_pps_count_user_data_in => c09f12_01_pps_count_user_data_in_net,
      c09f12_01_qdr_ct_qdr_address => c09f12_01_qdr_ct_qdr_address_net,
      c09f12_01_qdr_ct_qdr_be => c09f12_01_qdr_ct_qdr_be_net,
      c09f12_01_qdr_ct_qdr_data_in => c09f12_01_qdr_ct_qdr_data_in_net,
      c09f12_01_qdr_ct_qdr_rd_en => c09f12_01_qdr_ct_qdr_rd_en_net,
      c09f12_01_qdr_ct_qdr_wr_en => c09f12_01_qdr_ct_qdr_wr_en_net,
      c09f12_01_rcs_app_user_data_in => c09f12_01_rcs_app_user_data_in_net,
      c09f12_01_rcs_lib_user_data_in => c09f12_01_rcs_lib_user_data_in_net,
      c09f12_01_rcs_user_user_data_in => c09f12_01_rcs_user_user_data_in_net,
      c09f12_01_snap_debug_addr_user_data_in => c09f12_01_snap_debug_addr_user_data_in_net,
      c09f12_01_snap_debug_bram_addr => c09f12_01_snap_debug_bram_addr_net,
      c09f12_01_snap_debug_bram_data_in => c09f12_01_snap_debug_bram_data_in_net,
      c09f12_01_snap_debug_bram_we => c09f12_01_snap_debug_bram_we_net,
      gateway_out => gateway_out_net,
      gateway_out1 => gateway_out1_net,
      gateway_out1_x0 => gateway_out1_x0_net,
      gateway_out1_x1 => gateway_out1_x1_net,
      gateway_out1_x2 => gateway_out1_x2_net,
      gateway_out1_x3 => gateway_out1_x3_net,
      gateway_out1_x4 => gateway_out1_x4_net,
      gateway_out1_x5 => gateway_out1_x5_net,
      gateway_out1_x6 => gateway_out1_x6_net,
      gateway_out2 => gateway_out2_net,
      gateway_out2_x0 => gateway_out2_x0_net,
      gateway_out2_x1 => gateway_out2_x1_net,
      gateway_out2_x2 => gateway_out2_x2_net,
      gateway_out2_x3 => gateway_out2_x3_net,
      gateway_out2_x4 => gateway_out2_x4_net,
      gateway_out2_x5 => gateway_out2_x5_net,
      gateway_out2_x6 => gateway_out2_x6_net,
      gateway_out_x0 => gateway_out_x0_net,
      gateway_out_x1 => gateway_out_x1_net,
      gateway_out_x2 => gateway_out_x2_net,
      gateway_out_x3 => gateway_out_x3_net,
      gateway_out_x4 => gateway_out_x4_net,
      gateway_out_x5 => gateway_out_x5_net,
      gateway_out_x6 => gateway_out_x6_net,
      gateway_t1 => gateway_t1_net,
      gateway_t1_x0 => gateway_t1_x0_net,
      gateway_t1_x1 => gateway_t1_x1_net,
      gateway_t1_x2 => gateway_t1_x2_net,
      gateway_t1_x3 => gateway_t1_x3_net,
      gateway_t1_x4 => gateway_t1_x4_net,
      gateway_t1_x5 => gateway_t1_x5_net,
      gateway_t1_x6 => gateway_t1_x6_net,
      gateway_t2 => gateway_t2_net,
      gateway_t2_x0 => gateway_t2_x0_net,
      gateway_t2_x1 => gateway_t2_x1_net,
      gateway_t2_x2 => gateway_t2_x2_net,
      gateway_t2_x3 => gateway_t2_x3_net,
      gateway_t2_x4 => gateway_t2_x4_net,
      gateway_t2_x5 => gateway_t2_x5_net,
      gateway_t2_x6 => gateway_t2_x6_net,
      gateway_t3 => gateway_t3_net,
      gateway_t3_x0 => gateway_t3_x0_net,
      gateway_t3_x1 => gateway_t3_x1_net,
      gateway_t3_x2 => gateway_t3_x2_net,
      gateway_t3_x3 => gateway_t3_x3_net,
      gateway_t3_x4 => gateway_t3_x4_net,
      gateway_t3_x5 => gateway_t3_x5_net,
      gateway_t3_x6 => gateway_t3_x6_net
    );

  default_clock_driver_c09f12_01_x0: entity work.default_clock_driver_c09f12_01
    port map (
      sysce => '1',
      sysce_clr => '0',
      sysclk => clkNet,
      ce_1 => ce_1_sg_x706,
      clk_1 => clk_1_sg_x706
    );

  persistentdff_inst: xlpersistentdff
    port map (
      clk => clkNet,
      d => persistentdff_inst_q,
      q => persistentdff_inst_q
    );

end structural;
