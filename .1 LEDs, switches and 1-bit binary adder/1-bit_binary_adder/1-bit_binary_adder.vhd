library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_binary_adder is
    Port ( led : out STD_LOGIC_VECTOR(1 downto 0);
           sw : in STD_LOGIC_VECTOR(1 downto 0));
end bit_binary_adder;

architecture Behavioral of bit_binary_adder is

begin

led(0) <= sw(0) xor sw(1);
led(1) <= sw(0) and sw(1);

end Behavioral;