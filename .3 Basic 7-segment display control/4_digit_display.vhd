library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity four_digit_display is
    Port ( led : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (0 to 3));
end four_digit_display;

architecture Behavioral of four_digit_display is
signal counter_reg, counter_next : UNSIGNED(31 downto 0);
signal two_bit_counter : UNSIGNED(1 downto 0);
signal four_bit_counter : UNSIGNED(3 downto 0);
begin

process(clk, counter_next)
begin
    if (clk'event and clk='1') then
    counter_reg <= counter_next;
    end if;
end process;

counter_next <= counter_reg + 1;

--above is a standard 32 bit clock

---- below is for debug
-- led <= STD_LOGIC_VECTOR(counter_reg(31 downto 24));

two_bit_counter <= counter_reg(18 downto 17);

four_bit_counter <= "1110" when two_bit_counter = "00" else
                    "1101" when two_bit_counter = "01" else
                    "1011" when two_bit_counter = "10" else
                    "0111";
    
-- above is a 4 bit counter, using the two bit counter sourced from the 32 bit counter.
-- the 4 different states of the four bit counter are assigned to specific binary numbers

----debug of the 4 bit counter using the LEDs
-- led(3 downto 0) <= STD_LOGIC_VECTOR(four_bit_counter(3 downto 0));

-- below reads 6 -> 0, not other way round.
seg <= "0001000" when two_bit_counter = "00" else --letter A
       "0000011" when two_bit_counter = "01" else --letter b
       "1000110" when two_bit_counter = "10" else --letter C
       "0100001"; --letter d
       
--led(6 downto 0) <= seg(6 downto 0);

an <= STD_LOGIC_VECTOR(four_bit_counter(3 downto 0));



end Behavioral;
