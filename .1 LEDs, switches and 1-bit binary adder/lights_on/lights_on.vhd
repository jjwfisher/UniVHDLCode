library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lights_on is
    Port ( led : out STD_LOGIC_VECTOR(3 downto 0));
end lights_on;

architecture Behavioral of lights_on is

begin

led <= "1010";

end Behavioral;
