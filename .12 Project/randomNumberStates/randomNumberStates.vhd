library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity randomNumberStates is
    Generic(buttonMaxCount : integer := 22;
            genMaxCount : integer := 15);
    Port ( clk : in STD_LOGIC;
           btnC : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR(2 downto 0));
end randomNumberStates;

architecture Behavioral of randomNumberStates is
    --signals:
    signal buttonCount_reg, buttonCount_next : UNSIGNED(buttonMaxCount-1 downto 0);
    signal genCount_reg, genCount_next : UNSIGNED(4 downto 0);
    signal output_reg, output_next : STD_LOGIC := '0';
    signal shift_reg, shift_next : STD_LOGIC_VECTOR(30 downto 0) := "0110100101011010001110100101101"; --random number shift register
    --state machines:
    type buttonStateType is (pressed, waiting);
    signal buttonState_reg, buttonState_next : buttonStateType := waiting;
    type genStateType is (noGen, randomNumberGen);
    signal genState_reg, genState_next : genStateType := noGen;
begin

process(clk, buttonCount_next, output_next, buttonState_next, genState_next, shift_next)
begin
    if(clk'event and clk='1') then
        --signals
        buttonCount_reg <= buttonCount_next;
        genCount_reg <= genCount_next;
        output_reg <= output_next;
        --state machines
        buttonState_reg <= buttonState_next;
        genState_reg <= genState_next;
        --shift register
        shift_next <= shift_reg;
    end if;
end process;

--DEBOUNCING BUTTON:
buttonState_next <= pressed when (buttonState_reg = waiting and btnC = '1' and buttonCount_reg = to_unsigned(0,buttonMaxCount) ) else
                    waiting when (buttonState_reg = pressed and btnC = '0' and buttonCount_reg = to_unsigned(0,buttonMaxCount) ) else
                    buttonState_reg;
--state machine is above - it only switches from waiting when the button is pressed, and the count is at 0.
--It switches to waiting when the button is not pressed and the count is zero.

--This means that the state can only switch after the dead time (time it takes counter to count 22 bits). 
--This ensures any button input other than the wanted single press isn't detected.

--i.e., after the count up to 22 bits, the state will move back to waiting. (if the button is still not pressed)

buttonCount_next <= buttonCount_reg + 1 when ( (btnC = '1' and buttonState_reg = waiting) or (btnC = '0' and buttonState_reg = pressed) or (buttonCount_reg > to_unsigned(0,buttonMaxCount) ) ) else
                    to_unsigned(0,buttonMaxCount);
--count only increases when 1 of these conditions are filled:
--button is pressed and state is waiting
--button is not pressed and state is pressed
--count is above zero

--Otherwise, the counter resets to zero & does nothing else.

--i.e, when there is a wanted transition (button is pressed) between states, the counter starts counting.
--According to the state machine, it cannot transition until the counter is zero - so the counter has to count until it either overflows,
--or stops detecting an input from the button, eliminating extra unintended button pushes.

output_next <= '1' when (btnC = '1' and buttonState_reg = waiting and buttonCount_reg = to_unsigned(0,buttonMaxCount) ) else
               '0';
--output value only changes when all 3 conditions are filled:
--button is pressed
--state is waiting
--count is zero

--TWO STATES:

process(genState_reg, output_reg, genCount_reg)
begin
    case genState_reg is
        when noGen => --when not generating, keep counter at 0 and indicate the current state via the LED. If debounce button is detected, then move to generating state
            genCount_next <= to_unsigned(0,5);
            led(0) <= '1';
            led(1) <= '0';
            if (output_reg = '1') then
                genState_next <= randomNumberGen;
            else
                genState_next <= noGen;
            end if;
        when randomNumberGen => --when generating, count by 1 every clock cycle and indicate current state via LEDs. If count gets higher than set value, move back to non-generation state.
            shift_next(0) <= shift_reg(27) xnor shift_reg(30);
            shift_next(30 downto 1) <= shift_reg(29 downto 0);
            --the input of the shift registers is the XNOR logic of bit 27 and bit 30
            --Every clock cycle, the value of 1 bit gets copied up to the next bit
            genCount_next <= genCount_reg + 1;
            led(0) <= '0';
            led(1) <= '1';
            if (genCount_reg < genMaxCount) then
                genState_next <= randomNumberGen;
            else
                genState_next <= noGen;
            end if;
    end case;
end process;


end Behavioral;