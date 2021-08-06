library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timing_delay is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (15 downto 0);
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (15 downto 0));
end timing_delay;

architecture Behavioral of timing_delay is

signal delayData0_reg, delayData0_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData1_reg, delayData1_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData2_reg, delayData2_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData3_reg, delayData3_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData4_reg, delayData4_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData5_reg, delayData5_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData6_reg, delayData6_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData7_reg, delayData7_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData8_reg, delayData8_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData9_reg, delayData9_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData10_reg, delayData10_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData11_reg, delayData11_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData12_reg, delayData12_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData13_reg, delayData13_next : STD_LOGIC_VECTOR (15 downto 0);
signal delayData14_reg, delayData14_next : STD_LOGIC_VECTOR (15 downto 0);

begin

process(clk, delayData0_next, delayData1_next, delayData2_next, delayData3_next, delayData4_next, delayData5_next, delayData6_next, delayData7_next, delayData8_next, delayData9_next, delayData10_next, delayData11_next, delayData12_next, delayData13_next, delayData14_next)
begin
    if(clk'event and clk='1')
    then
        delayData0_reg <= delayData0_next;
        delayData1_reg <= delayData1_next;
        delayData2_reg <= delayData2_next;
        delayData3_reg <= delayData3_next;
        delayData4_reg <= delayData4_next;
        delayData5_reg <= delayData5_next;
        delayData6_reg <= delayData6_next;
        delayData7_reg <= delayData7_next;
        delayData8_reg <= delayData8_next;
        delayData9_reg <= delayData9_next;
        delayData10_reg <= delayData10_next;    
        delayData11_reg <= delayData11_next;
        delayData12_reg <= delayData12_next;
        delayData13_reg <= delayData13_next;
        delayData14_reg <= delayData14_next; 
    end if;
end process;

delayData0_next <= DATA_IN;
delayData1_next <= delayData0_reg;
delayData2_next <= delayData1_reg;
delayData3_next <= delayData2_reg;
delayData4_next <= delayData3_reg;
delayData5_next <= delayData4_reg;
delayData6_next <= delayData5_reg;
delayData7_next <= delayData6_reg;
delayData8_next <= delayData7_reg;
delayData9_next <= delayData8_reg;
delayData10_next <= delayData9_reg;
delayData11_next <= delayData10_reg;
delayData12_next <= delayData11_reg;
delayData13_next <= delayData12_reg;
delayData14_next <= delayData13_reg;

DATA_OUT <= delayData0_reg when sw = "0001" else
            delayData1_reg when sw = "0010" else
            delayData2_reg when sw = "0011" else
            delayData3_reg when sw = "0100" else
            delayData4_reg when sw = "0101" else
            delayData5_reg when sw = "0110" else
            delayData6_reg when sw = "0111" else
            delayData7_reg when sw = "1000" else
            delayData8_reg when sw = "1001" else
            delayData9_reg when sw = "1010" else
            delayData10_reg when sw = "1011" else
            delayData11_reg when sw = "1100" else
            delayData12_reg when sw = "1101" else
            delayData13_reg when sw = "1110" else
            delayData14_reg when sw = "1111" else
            DATA_IN;
            
end Behavioral;
