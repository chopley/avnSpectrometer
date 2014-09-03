-------------------------------------------------------------------------------
-- system_c09f12_01_leds_roach_gpioa6_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library gpio_simulink2ext_v1_00_a;
use gpio_simulink2ext_v1_00_a.all;

entity system_c09f12_01_leds_roach_gpioa6_wrapper is
  port (
    gateway : in std_logic_vector(0 to 0);
    io_pad : out std_logic_vector(0 to 0);
    clk : in std_logic;
    clk90 : in std_logic
  );
end system_c09f12_01_leds_roach_gpioa6_wrapper;

architecture STRUCTURE of system_c09f12_01_leds_roach_gpioa6_wrapper is

  component gpio_simulink2ext is
    generic (
      WIDTH : INTEGER;
      DDR : INTEGER;
      CLK_PHASE : INTEGER;
      REG_IOB : STRING
    );
    port (
      gateway : in std_logic_vector((WIDTH-1) to 0);
      io_pad : out std_logic_vector((WIDTH/(DDR+1))-1 to 0);
      clk : in std_logic;
      clk90 : in std_logic
    );
  end component;

begin

  c09f12_01_leds_roach_gpioa6 : gpio_simulink2ext
    generic map (
      WIDTH => 1,
      DDR => 0,
      CLK_PHASE => 0,
      REG_IOB => "true"
    )
    port map (
      gateway => gateway,
      io_pad => io_pad,
      clk => clk,
      clk90 => clk90
    );

end architecture STRUCTURE;

