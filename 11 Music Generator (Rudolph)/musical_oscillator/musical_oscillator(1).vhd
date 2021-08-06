----------------------------------------------------------------------------------
-- Company: University of Sheffield
-- Engineer: Jordan Fisher
-- 
-- Create Date: 08.02.2020 20:40:32
-- Design Name: 
-- Module Name: musical_oscillator - Behavioral
-- Project Name: 
-- Target Devices: BASYS3
-- Tool Versions: 
-- Description: Testing bench for creating a square wave ocsillator at various frequencies
-- 
-- Dependencies: 
-- 
-- Revision: 2.1
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity musical_oscillator is
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (1 downto 0);
           JC_0 : out STD_LOGIC);
end musical_oscillator;

architecture Behavioral of musical_oscillator is

type state_type is (note_A, note_E, note_G, note_C);
signal state_reg, state_next : state_type := note_A;
signal counter_reg, counter_next : UNSIGNED(20 downto 0);
signal squarewave_reg, squarewave_next : STD_LOGIC := '1';
begin

process(clk, state_next, counter_next, squarewave_next)
begin
    if(clk='1' and clk'event) then
        state_reg <= state_next;
        counter_reg <= counter_next;
        squarewave_reg <= squarewave_next;
    end if;
end process; --clock process creating state, squarewave and counter register

process(state_reg, sw, counter_reg, squarewave_reg)
begin
    case state_reg is
        when note_A =>
            if(counter_reg = to_unsigned(16#1BBE4#,21)) then
                counter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                counter_next <= counter_reg + 1;
                squarewave_next <= squarewave_reg;
            end if;
            if(sw = "00") then
                state_next <= note_A;
            elsif(sw = "01") then
                state_next <= note_E;
            elsif(sw = "10") then
                state_next <= note_G;
            else
                state_next <= note_C;
            end if;
        when note_E =>
            if(counter_reg = to_unsigned(16#25086#,21)) then
                counter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                counter_next <= counter_reg + 1;
                squarewave_next <= squarewave_reg;  
            end if;
            if(sw = "00") then
                state_next <= note_A;
            elsif(sw = "01") then
                state_next <= note_E;
            elsif(sw = "10") then
                state_next <= note_G;
            else
                state_next <= note_C;
            end if;
        when note_G =>
            if(counter_reg = to_unsigned(16#1F241#,21)) then
                counter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                counter_next <= counter_reg + 1;
                squarewave_next <= squarewave_reg;
            end if;
            if(sw = "00") then
                state_next <= note_A;
            elsif(sw = "01") then
                state_next <= note_E;
            elsif(sw = "10") then
                state_next <= note_G;
            else
                state_next <= note_C;
            end if;
        when note_C =>
            if(counter_reg = to_unsigned(16#17544#,21)) then
                counter_next <= to_unsigned(0,21);
                squarewave_next <= not squarewave_reg;
            else
                counter_next <= counter_reg + 1;
                squarewave_next <= squarewave_reg;
            end if;
            if(sw = "00") then
                state_next <= note_A;
            elsif(sw = "01") then
                state_next <= note_E;
            elsif(sw = "10") then
                state_next <= note_G;
            else
                state_next <= note_C;
            end if;
         end case;
end process; --assigns cases to be a particular note depending on orientation of the switches

JC_0 <= squarewave_reg;


end Behavioral;