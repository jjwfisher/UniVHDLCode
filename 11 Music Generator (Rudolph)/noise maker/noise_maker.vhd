----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2020 21:46:57
-- Design Name: 
-- Module Name: noise_maker - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity noise_maker is
    Port ( clk : in STD_LOGIC;
           JC_0 : out STD_LOGIC);
end noise_maker;

architecture Behavioral of noise_maker is

signal counter_reg, counter_next : UNSIGNED(20 downto 0);
signal squarewave_reg, squarewave_next : STD_LOGIC := '1';
begin

process(clk, counter_next, squarewave_next)
begin
    if(clk='1' and clk'event) then
        counter_reg <= counter_next;
        squarewave_reg <= squarewave_next;
    end if;
end process;

process(counter_reg, squarewave_reg)
begin
    if(counter_reg = to_unsigned(16#1BBE4#,21)) then
        counter_next <= to_unsigned(0,21);
        squarewave_next <= not squarewave_reg;
    else
        counter_next <= counter_reg + 1;
        squarewave_next <= squarewave_reg;
    end if;
end process;


JC_0 <= squarewave_reg;

end Behavioral;
