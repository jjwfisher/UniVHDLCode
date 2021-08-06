library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_32_bits is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0);
           sw  : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC);
end clock_32_bits;

architecture Behavioral of clock_32_bits is

--counterReg is the signal that gets updated
signal counterReg, counterNext : UNSIGNED(31 downto 0); --two seperate signals defined for the register

begin

process(clk, counterNext) --begins process to allow sequential operation
begin
    if(clk'event and clk='1') then --if the clock is on it's rising edge, then
    counterReg <= counterNext; --update the register with the value of the the current count
    end if;
end process;
counterNext <= counterReg + 1; --update the current count with the value of the register + 1

led <= STD_LOGIC_VECTOR(counterReg(31 downto 16)) and sw; --display output on LEDs, ommitting first 17 bits as it counts too fast)
--adding 'and sw' on the end allows for control of indivudial LEDs

end Behavioral;
