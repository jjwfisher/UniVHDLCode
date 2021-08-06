library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity all_lights_sw is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0));
end all_lights_sw;

architecture Behavioral of all_lights_sw is

begin

led <= sw;

end Behavioral;
