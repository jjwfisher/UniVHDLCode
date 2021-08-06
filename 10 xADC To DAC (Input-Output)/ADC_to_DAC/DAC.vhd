library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DAC is
    Port ( clk : in STD_LOGIC;
           SYNC : out STD_LOGIC;
           DATA1 : out STD_LOGIC;
           DATA2 : out STD_LOGIC;
           DCLK : out STD_LOGIC;
           DATA_IN : in STD_LOGIC_VECTOR(15 downto 0);
           reset_btn : in STD_LOGIC);
end DAC;

architecture Behavioral of DAC is

signal counter_reg, counter_next : UNSIGNED(1 downto 0);
signal slow_count_reg, slow_count_next : UNSIGNED(4 downto 0);
signal data_reg, data_next : UNSIGNED(15 downto 0);

begin
  
process(clk, counter_next, slow_count_next, data_next)
begin
    if(clk='1' and clk'event) then
        counter_reg <= counter_next;
        slow_count_reg <= slow_count_next;
        data_reg <= data_next;
    end if;
end process;

counter_next <= counter_reg + 1 when reset_btn = '0' else
                to_unsigned(0,2); --if btnC pressed, reset counter to 0

process(slow_count_reg, counter_reg)
begin
    if(counter_reg = to_unsigned(10#3#,2) and reset_btn = '0') then --if counter = 3 (in decimal)
        if(slow_count_reg <= to_unsigned(10#15#,5)) then --if slow count is equal to or less than 15
            slow_count_next <= slow_count_reg + 1; --add 1 to slow count
        elsif(slow_count_reg = to_unsigned(10#16#,5)) then --if slow count is 16
            slow_count_next <= to_unsigned(0,5); --set slow count to 0
        end if;
    elsif(reset_btn = '1') then
        slow_count_next <= to_unsigned(10#16#,5); --if btnC is pressed, set slow count so SYNC is high (and data_reg is read to DATA1)
    else
        slow_count_next <= slow_count_reg; --if counter is not 3, do nothing with slow count
    end if;
end process; --makes the slow count go from 0 to 16 inclusive, ticking +1 every 40ns (in sync with counter)

DCLK <= not counter_reg(1);

process(slow_count_reg, data_reg)
begin
    if(slow_count_reg = to_unsigned(16#10#,5)) then --if slow count is 16
        SYNC <= '1'; --sync is high
        data_next <= UNSIGNED(DATA_IN);
    else
        SYNC <= '0'; --otherwise, sync is low
        data_next <= data_reg; 
    end if;
end process;

DATA1 <= '0' when slow_count_reg = to_unsigned(10#16#,5) else
         data_reg(4) when slow_count_reg = to_unsigned(10#15#,5) else
         data_reg(5) when slow_count_reg = to_unsigned(10#14#,5) else
         data_reg(6) when slow_count_reg = to_unsigned(10#13#,5) else
         data_reg(7) when slow_count_reg = to_unsigned(10#12#,5) else
         data_reg(8) when slow_count_reg = to_unsigned(10#11#,5) else
         data_reg(9) when slow_count_reg = to_unsigned(10#10#,5) else
         data_reg(10) when slow_count_reg = to_unsigned(10#9#,5) else
         data_reg(11) when slow_count_reg = to_unsigned(10#8#,5) else
         data_reg(12) when slow_count_reg = to_unsigned(10#7#,5) else
         data_reg(13) when slow_count_reg = to_unsigned(10#6#,5) else
         data_reg(14) when slow_count_reg = to_unsigned(10#5#,5) else
         data_reg(15) when slow_count_reg = to_unsigned(10#4#,5) else
         '0' when slow_count_reg = to_unsigned(10#3#,5) else
         '0' when slow_count_reg = to_unsigned(10#2#,5) else
         '0' when slow_count_reg = to_unsigned(10#1#,5) else
         '0';
         
DATA2 <= '0';

end Behavioral;
