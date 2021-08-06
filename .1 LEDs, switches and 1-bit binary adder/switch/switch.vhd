library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switch is
    Port ( led : out STD_LOGIC;
           sw : in STD_LOGIC);
end switch;

architecture Behavioral of switch is

begin

led <= sw;

end Behavioral;
