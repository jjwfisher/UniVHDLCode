library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncing_button is
    Port ( btnC : in STD_LOGIC;
           led : out STD_LOGIC;
           clk : in STD_LOGIC);
end debouncing_button;

architecture Behavioral of debouncing_button is

type state_type is (volt_high, volt_low, bounce); --states (volt high = LED on, volt low = LED off, bounce is intermediary state between the two)
signal state_reg, state_next : state_type;
signal counter_reg, counter_next : UNSIGNED(26 downto 0);

begin

process(clk, state_next, counter_next)
begin
    if(clk='1' and clk'event) then
        state_reg <= state_next;
        counter_reg <= counter_next;
    end if;
end process; --clock process creating two registers, state and counter

counter_reg <= counter_next + 1; --counter is a 27-bit counter

process(btnC, state_reg, counter_next)
begin
    case state_reg is
        when volt_low =>
            if(btnC = '1') then
                state_next <= bounce; --if button is pressed then set the next state to be the bounce state (which will happen upon the next clock cycle)
            else
                state_next <= volt_low; --if button is not pressed keep in volt low state
            end if;
        when volt_high =>
            if(btnC = '0') then
                state_next <= bounce; --if button is not pressed then move from volt high to bounce
            else
                state_next <= volt_high; --if button is pressed stay in volt high
            end if;
        when bounce =>
            counter_next <= to_unsigned(0,27); --when in bounce reset counter
            if(btnC = '1' and counter_next = to_unsigned(16#8000000#,27)) then
                state_next <= volt_high; --if button is pressed and after a certain amount of time (specified by to_unsigned), move to volt high state
            elsif(btnC = '0' and counter_next = to_unsigned(16#8000000#,27)) then
                state_next <= volt_low; --if button is unpressed and after the same amount of time, move to volt low state
            else
                state_next <= bounce; --if nothing stay in bounce
            end if;
    end case;
end process;

led <= '1' when state_reg = volt_high else
       '0' when state_reg = volt_low;
end Behavioral;