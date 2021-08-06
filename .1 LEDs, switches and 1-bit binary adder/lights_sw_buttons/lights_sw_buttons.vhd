
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lights_sw_buttons is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           btnC : in STD_LOGIC);
end lights_sw_buttons;

architecture Behavioral of lights_sw_buttons is

begin

led <= sw when btnC='0' else
    not sw when btnC='1';

end Behavioral;
