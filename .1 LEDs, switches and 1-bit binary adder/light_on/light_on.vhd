library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity light_on is
    Port ( led : out STD_LOGIC);
end light_on;

architecture Behavioral of light_on is

begin

led <= '1';

end Behavioral;
