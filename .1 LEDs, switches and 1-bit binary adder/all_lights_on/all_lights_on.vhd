library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity all_lights_on is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0));
end all_lights_on;

architecture Behavioral of all_lights_on is

begin

led <= (others => '1');

end Behavioral;
