-------------------------------------------------------------------------------
-- system_c09f12_01_adc_snap1_bram_ramblk_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_c09f12_01_adc_snap1_bram_ramblk_wrapper is
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
end system_c09f12_01_adc_snap1_bram_ramblk_wrapper;

architecture STRUCTURE of system_c09f12_01_adc_snap1_bram_ramblk_wrapper is

  component bram_block_custom is
    generic (
      C_PORTA_DWIDTH : integer;
      C_PORTA_AWIDTH : integer;
      C_PORTA_NUM_WE : integer;
      C_PORTA_DEPTH : integer;
      OPTIMIZATION : string;
      REG_CORE_OUTPUT : string;
      REG_PRIM_OUTPUT : string;
      C_PORTB_DWIDTH : integer;
      C_PORTB_AWIDTH : integer;
      C_PORTB_NUM_WE : integer;
      C_PORTB_DEPTH : integer
    );
    port (
      clk : in std_logic;
      bram_en_a : in std_logic;
      bram_we : in std_logic;
      bram_addr : in std_logic_vector(C_PORTA_DEPTH -1 downto 0);
      bram_rd_data : out std_logic_vector(C_PORTA_DWIDTH-1 downto 0);
      bram_wr_data : in std_logic_vector(C_PORTA_DWIDTH-1 downto 0);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to C_PORTB_NUM_WE-1);
      BRAM_Addr_B : in std_logic_vector(0 to C_PORTB_AWIDTH-1);
      BRAM_Din_B : out std_logic_vector(0 to C_PORTB_DWIDTH-1);
      BRAM_Dout_B : in std_logic_vector(0 to C_PORTB_DWIDTH-1)
    );
  end component;

begin

  c09f12_01_adc_snap1_bram_ramblk : bram_block_custom
    generic map (
      C_PORTA_DWIDTH => 32,
      C_PORTA_AWIDTH => 32,
      C_PORTA_NUM_WE => 4,
      C_PORTA_DEPTH => 10,
      OPTIMIZATION => "Minimum_Area",
      REG_CORE_OUTPUT => "true",
      REG_PRIM_OUTPUT => "true",
      C_PORTB_DWIDTH => 32,
      C_PORTB_AWIDTH => 32,
      C_PORTB_NUM_WE => 4,
      C_PORTB_DEPTH => 10
    )
    port map (
      clk => clk,
      bram_en_a => bram_en_a,
      bram_we => bram_we,
      bram_addr => bram_addr,
      bram_rd_data => bram_rd_data,
      bram_wr_data => bram_wr_data,
      BRAM_Rst_B => BRAM_Rst_B,
      BRAM_Clk_B => BRAM_Clk_B,
      BRAM_EN_B => BRAM_EN_B,
      BRAM_WEN_B => BRAM_WEN_B,
      BRAM_Addr_B => BRAM_Addr_B,
      BRAM_Din_B => BRAM_Din_B,
      BRAM_Dout_B => BRAM_Dout_B
    );

end architecture STRUCTURE;

