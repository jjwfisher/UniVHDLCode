--16-bit binary to hex converter.
--Jordan Fisher, 29/10/2019

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hex_display is
    Port ( clk : in STD_LOGIC;
           segments : out STD_LOGIC_VECTOR (6 downto 0);
           seg_address : out STD_LOGIC_VECTOR (0 to 3);
           in_bus : in STD_LOGIC_VECTOR (15 downto 0));
end hex_display;

architecture Behavioral of hex_display is

signal counter_reg, counter_next : UNSIGNED(31 downto 0);
signal two_bit_counter : UNSIGNED(1 downto 0);
signal hex_bank : UNSIGNED(6 downto 0);
signal sw_in : UNSIGNED(3 downto 0);

begin

process(clk, counter_next)
begin
    if (clk'event and clk='1') then
    counter_reg <= counter_next;
    end if;
end process;

counter_next <= counter_reg + 1;

--above is a standard 32 bit clock

two_bit_counter <= counter_reg(18 downto 17); --two bit counter, selects a fast enough refresh rate for the display. (1kHz refresh rate)

seg_address <= "1110" when two_bit_counter = "00" else
               "1101" when two_bit_counter = "01" else
               "1011" when two_bit_counter = "10" else
               "0111";
    
-- counter for the anodes (cycles the 4 different 7-segment displays)
-- This is synced with the switch inputs (same counter) so that the correct set of switches corresponds to the correct digit of the display

sw_in <= UNSIGNED(in_bus(15 downto 12)) when two_bit_counter = "00" else
         UNSIGNED(in_bus(11 downto 8)) when two_bit_counter = "01" else
         UNSIGNED(in_bus(7 downto 4)) when two_bit_counter = "10" else
         UNSIGNED(in_bus(3 downto 0));
         
--sw_in takes the input of 4 switches at once, which 4 switches is synced with an & the 2-bit counter.

hex_bank <= "1000000" when sw_in = "0000" else --0
            "1001111" when sw_in = "0001" else --1
            "0100100" when sw_in = "0010" else --2
            "0110000" when sw_in = "0011" else --3 
            "0011001" when sw_in = "0100" else --4
            "0010010" when sw_in = "0101" else --5
            "0000010" when sw_in = "0110" else --6
            "1111000" when sw_in = "0111" else --7
            "0000000" when sw_in = "1000" else --8
            "0011000" when sw_in = "1001" else --9
            "0001000" when sw_in = "1010" else --A
            "0000011" when sw_in = "1011" else --b
            "1000110" when sw_in = "1100" else --C
            "0100001" when sw_in = "1101" else --d
            "0000110" when sw_in = "1110" else --E
            "0001110" when sw_in = "1111"; --F
            
--displays a 7 digit display code corresponding to the 4 bit input. Allows for up to the decimal 16 per 4 switches, meaning overall a 16 bit input. (4 digit hex)

segments <= STD_LOGIC_VECTOR(hex_bank); --displays output of display on the actual display module.
            
end Behavioral;
