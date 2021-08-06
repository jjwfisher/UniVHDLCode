library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity threeLEDStates is
    Generic(maxCount : integer := 22);
    Port ( clk : in STD_LOGIC;
           btnC : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR(2 downto 0));
end threeLEDStates;

architecture Behavioral of threeLEDStates is
    signal count_reg, count_next : UNSIGNED(maxCount-1 downto 0);
    signal output_reg, output_next : STD_LOGIC := '0';
    type buttonStateType is (pressed, waiting);
    signal buttonState_reg, buttonState_next : buttonStateType := waiting;
    type ledStateType is (led1, led2, led3);
    signal ledState_reg, ledState_next : ledStateType;
begin

process(clk, count_next, output_next, buttonState_next, ledState_next)
begin
    if(clk'event and clk='1') then
        count_reg <= count_next;
        output_reg <= output_next;
        buttonState_reg <= buttonState_next;
        ledState_reg <= ledState_next;
    end if;
end process;

buttonState_next <= pressed when (buttonState_reg = waiting and btnC = '1' and count_reg = to_unsigned(0,maxCount) ) else
                    waiting when (buttonState_reg = pressed and btnC = '0' and count_reg = to_unsigned(0,maxCount) ) else
                    buttonState_reg;
--state machine is above - it only switches from waiting when the button is pressed, and the count is at 0.
--It switches to waiting when the button is not pressed and the count is zero.

--This means that the state can only switch after the dead time (time it takes counter to count 22 bits). 
--This ensures any button input other than the wanted single press isn't detected.

--i.e., after the count up to 22 bits, the state will move back to waiting. (if the button is still not pressed)

count_next <= count_reg + 1 when ( (btnC = '1' and buttonState_reg = waiting) or
                                   (btnC = '0' and buttonState_reg = pressed) or
                                   (count_reg > to_unsigned(0,maxCount) ) ) else
              to_unsigned(0,maxCount);
--count only increases when 1 of these conditions are filled:
--button is pressed and state is waiting
--button is not pressed and state is pressed
--count is above zero

--Otherwise, the counter resets to zero & does nothing else.

--i.e, when there is a wanted transition (button is pressed) between states, the counter starts counting.
--According to the state machine, it cannot transition until the counter is zero - so the counter has to count until it either overflows,
--or stops detecting an input from the button, eliminating extra unintended button pushes.

output_next <= '1' when (btnC = '1' and buttonState_reg = waiting and count_reg = to_unsigned(0,maxCount) ) else
               '0';
--output value only changes when all 3 conditions are filled:
--button is pressed
--state is waiting
--count is zero

ledState_next <= led1 when (ledState_reg = led3 and output_reg = '1') else
                 led2 when (ledState_reg = led1 and output_reg = '1') else
                 led3 when (ledState_reg = led2 and output_reg = '1') else
                 ledState_reg;
--It's only able to switch states when output = '1', so it cannot switch more than one state at a time, since output is only '1' for 1 clock period 
--(counter will only be 0 for one clock period)

led(0) <= '1' when ledState_reg = led1 else
          '0';
led(1) <= '1' when ledState_reg = led2 else
          '0';
led(2) <= '1' when ledState_reg = led3 else
          '0';
--1 LED is assigned to one state, so only 1 LED is lit at a time.
end Behavioral;