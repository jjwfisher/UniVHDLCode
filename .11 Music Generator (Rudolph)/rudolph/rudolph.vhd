----------------------------------------------------------------------------------
-- Company: University of Sheffield
-- Engineer: Jordan Fisher
-- 
-- Create Date: 03.03.2020 17:32:20
-- Design Name: 
-- Module Name: rudolph - Behavioral
-- Project Name: Rudolph music
-- Target Devices: BASYS3
-- Tool Versions: 
-- Description: 
-- 
-- 
-- Revision: 1.0
-- Revision 1.0 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rudolph is
    Port ( clk : in STD_LOGIC;
           JC_0 : out STD_LOGIC;
           btnC : in STD_LOGIC);
end rudolph;

architecture Behavioral of rudolph is

type state_type is (note_silent, note_G1, note_A1, note_E, note_C);
signal state_reg, state_next : state_type := note_silent;
signal wavecounter_reg, wavecounter_next : UNSIGNED(20 downto 0);
signal squarewave_reg, squarewave_next : STD_LOGIC := '1';
signal silent_reg, silent_next : STD_LOGIC;
signal fasttime_reg, fasttime_next : UNSIGNED(17 downto 0);
signal slowtime_reg, slowtime_next : UNSIGNED(1 downto 0);

begin

process(clk, state_next, wavecounter_next, squarewave_next, silent_next, fasttime_next, slowtime_next)
begin
    if(clk='1' and clk'event) then
        state_reg <= state_next;
        wavecounter_reg <= wavecounter_next;
        squarewave_reg <= squarewave_next;
        silent_reg <= silent_next;
        fasttime_reg <= fasttime_next;
        slowtime_reg <= slowtime_next;
    end if;
end process;

process(state_reg, wavecounter_reg, squarewave_reg, btnC, slowtime_reg, fasttime_reg)
begin
    case state_reg is
        when note_silent =>
            squarewave_next <= '0';
            silent_next <= '0';
            if(btnC = '1') then
                state_next <= note_G1;
                slowtime_next <= to_unsigned(0,2);
                fasttime_next <= to_unsigned(0,18);
            else
                state_next <= note_silent;
            end if;
        when note_G1 =>
            silent_next <= '1';
            if(wavecounter_reg = to_unsigned(16#1F241#,21)) then
                wavecounter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                wavecounter_next <= wavecounter_reg + 1;
                squarewave_next <= squarewave_reg;
            end if;
            if(fasttime_reg = to_unsigned(16#FE502B#,18)) then
                slowtime_next <= slowtime_reg + 1;
                fasttime_next <= to_unsigned(0,18);
            else
                slowtime_next <= slowtime_reg;
                fasttime_next <= fasttime_reg + 1;
            end if;
            if(slowtime_reg =  "10") then
                state_next <= note_A1;
                slowtime_next <= to_unsigned(0,2);
                fasttime_next <= to_unsigned(0,18);
                wavecounter_next <= to_unsigned(0,21);
            else
                state_next <= note_G1;
            end if;
        when note_A1 =>
            silent_next <= '1';
            if(wavecounter_reg = to_unsigned(16#1BBE4#,21)) then
                wavecounter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                wavecounter_next <= wavecounter_reg + 1;
                squarewave_next <= squarewave_reg;
            end if;
            if(fasttime_reg = to_unsigned(16#FE502B#,18)) then
                slowtime_next <= slowtime_reg + 1;
                fasttime_next <= to_unsigned(0,18);
            else
                slowtime_next <= slowtime_reg;
                fasttime_next <= fasttime_reg + 1;
            end if;
            if(slowtime_reg = "11") then
                state_next <= note_silent;
            else
                state_next <= note_A1;
            end if;
        when note_E =>
            silent_next <= '1';
            if(wavecounter_reg = to_unsigned(16#25086#,21)) then
                wavecounter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                wavecounter_next <= wavecounter_reg + 1;
                squarewave_next <= squarewave_reg;  
            end if;

        when note_C =>
            silent_next <= '1';
            if(wavecounter_reg = to_unsigned(16#17544#,21)) then
                wavecounter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                wavecounter_next <= wavecounter_reg + 1;
                squarewave_next <= squarewave_reg;
            end if;
         end case;
end process; --assigns cases to be a particular note depending on orientation of the switches

JC_0 <= squarewave_reg and silent_reg;


end Behavioral;
