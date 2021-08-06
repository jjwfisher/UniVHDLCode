library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fibonacci is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           btnC : in STD_LOGIC);
end fibonacci;

architecture Behavioral of fibonacci is

--counterReg is the signal that gets updated
signal firstfib_reg: UNSIGNED (31 downto 0) := to_unsigned(0,32); --first fib register, set at 0
signal secondfib_reg: UNSIGNED (31 downto 0) := to_unsigned(1,32); --second fib register, set at 1 (to start)
signal firstfib_next, secondfib_next : UNSIGNED  (31 downto 0); --first and second fib next values
signal counter_reg, counter_next: UNSIGNED (31 downto 0) := to_unsigned(2,32); --counter reg and next set at 2
begin

process(clk, firstfib_next, secondfib_next) --begins process to allow sequential operation
begin
    if(clk'event and clk='1') then --if the clock is on it's rising edge, then
    firstfib_reg <= firstfib_next;
    secondfib_reg <= secondfib_next;
    counter_reg <= counter_next;
    end if;
end process;

process(firstfib_reg, secondfib_reg, counter_reg)
begin
    if secondfib_reg < to_unsigned(16#20000000#,32) then
    firstfib_next <= secondfib_reg;
    secondfib_next <= firstfib_reg + secondfib_reg;
    counter_next <= counter_reg + 1;
    else
    firstfib_next <= firstfib_reg;
    secondfib_next <= secondfib_reg;
    counter_next <= counter_reg;
    end if;
end process;

led <= STD_LOGIC_VECTOR(secondfib_reg(31 downto 16)) when btnC = '0' else --display output on LEDs, ommitting first 17 bits as it counts too fast)
    STD_LOGIC_VECTOR(secondfib_reg(15 downto 0)) when btnC='1';


end Behavioral;
