-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
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
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
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
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
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
      epb_data => epb_data,
      epb_addr => epb_addr,
      epb_addr_gp => epb_addr_gp,
      epb_cs_n => epb_cs_n,
      epb_be_n => epb_be_n,
      epb_r_w_n => epb_r_w_n,
      epb_oe_n => epb_oe_n,
      epb_rdy => epb_rdy,
      ppc_irq_n => ppc_irq_n,
      mgt_ref_clk_top_n => mgt_ref_clk_top_n,
      mgt_ref_clk_top_p => mgt_ref_clk_top_p,
      mgt_ref_clk_bottom_n => mgt_ref_clk_bottom_n,
      mgt_ref_clk_bottom_p => mgt_ref_clk_bottom_p,
      mgt_rx_top_1_n => mgt_rx_top_1_n,
      mgt_rx_top_1_p => mgt_rx_top_1_p,
      mgt_tx_top_1_n => mgt_tx_top_1_n,
      mgt_tx_top_1_p => mgt_tx_top_1_p,
      mgt_rx_top_0_n => mgt_rx_top_0_n,
      mgt_rx_top_0_p => mgt_rx_top_0_p,
      mgt_tx_top_0_n => mgt_tx_top_0_n,
      mgt_tx_top_0_p => mgt_tx_top_0_p,
      mgt_rx_bottom_1_n => mgt_rx_bottom_1_n,
      mgt_rx_bottom_1_p => mgt_rx_bottom_1_p,
      mgt_tx_bottom_1_n => mgt_tx_bottom_1_n,
      mgt_tx_bottom_1_p => mgt_tx_bottom_1_p,
      mgt_rx_bottom_0_n => mgt_rx_bottom_0_n,
      mgt_rx_bottom_0_p => mgt_rx_bottom_0_p,
      mgt_tx_bottom_0_n => mgt_tx_bottom_0_n,
      mgt_tx_bottom_0_p => mgt_tx_bottom_0_p,
      adc0_ser_clk => adc0_ser_clk,
      adc0_ser_dat => adc0_ser_dat,
      adc0_ser_cs => adc0_ser_cs,
      adc0clk_p => adc0clk_p,
      adc0clk_n => adc0clk_n,
      adc0sync_p => adc0sync_p,
      adc0sync_n => adc0sync_n,
      adc0overrange_p => adc0overrange_p,
      adc0overrange_n => adc0overrange_n,
      adc0di_d_p => adc0di_d_p,
      adc0di_d_n => adc0di_d_n,
      adc0di_p => adc0di_p,
      adc0di_n => adc0di_n,
      adc0dq_d_p => adc0dq_d_p,
      adc0dq_d_n => adc0dq_d_n,
      adc0dq_p => adc0dq_p,
      adc0dq_n => adc0dq_n,
      adc0rst => adc0rst,
      adc0powerdown => adc0powerdown,
      adc0_iic_sda => adc0_iic_sda,
      adc0_iic_scl => adc0_iic_scl,
      c09f12_01_leds_roach_gpioa0_ext => c09f12_01_leds_roach_gpioa0_ext(0 to 0),
      c09f12_01_leds_roach_gpioa1_ext => c09f12_01_leds_roach_gpioa1_ext(0 to 0),
      c09f12_01_leds_roach_gpioa2_ext => c09f12_01_leds_roach_gpioa2_ext(0 to 0),
      c09f12_01_leds_roach_gpioa3_ext => c09f12_01_leds_roach_gpioa3_ext(0 to 0),
      c09f12_01_leds_roach_gpioa4_ext => c09f12_01_leds_roach_gpioa4_ext(0 to 0),
      c09f12_01_leds_roach_gpioa5_ext => c09f12_01_leds_roach_gpioa5_ext(0 to 0),
      c09f12_01_leds_roach_gpioa6_ext => c09f12_01_leds_roach_gpioa6_ext(0 to 0),
      c09f12_01_leds_roach_gpioa7_ext => c09f12_01_leds_roach_gpioa7_ext(0 to 0),
      c09f12_01_leds_roach_gpioa_oe_ext => c09f12_01_leds_roach_gpioa_oe_ext(0 to 0),
      c09f12_01_leds_roach_led0_ext => c09f12_01_leds_roach_led0_ext(0 to 0),
      c09f12_01_leds_roach_led1_ext => c09f12_01_leds_roach_led1_ext(0 to 0),
      c09f12_01_leds_roach_led2_ext => c09f12_01_leds_roach_led2_ext(0 to 0),
      c09f12_01_leds_roach_led3_ext => c09f12_01_leds_roach_led3_ext(0 to 0),
      qdr0_k_n => qdr0_k_n,
      qdr0_k => qdr0_k,
      qdr0_d => qdr0_d,
      qdr0_bw_n => qdr0_bw_n,
      qdr0_sa => qdr0_sa,
      qdr0_w_n => qdr0_w_n,
      qdr0_r_n => qdr0_r_n,
      qdr0_q => qdr0_q,
      qdr0_cq_n => qdr0_cq_n,
      qdr0_cq => qdr0_cq,
      qdr0_qvld => qdr0_qvld,
      qdr0_dll_off_n => qdr0_dll_off_n
    );

end architecture STRUCTURE;

