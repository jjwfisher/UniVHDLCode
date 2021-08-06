library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switch_to_2lights is
    Port ( led : out STD_LOGIC_VECTOR(1 downto 0);
           sw : in STD_LOGIC);
end switch_to_2lights;

architecture Behavioral of switch_to_2lights is

begin

led(0)<=sw;
led(1)<=sw;

end Behavioral;
