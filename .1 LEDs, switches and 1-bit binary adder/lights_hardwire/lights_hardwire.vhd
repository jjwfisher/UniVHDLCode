library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lights_hardwire is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0));
end lights_hardwire;

architecture Behavioral of lights_hardwire is

begin

led <= "1111111111111111";

end Behavioral;
