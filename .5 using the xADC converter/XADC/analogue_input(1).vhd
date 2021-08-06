library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analogue_input is
    Port ( DATA_OUT : out STD_LOGIC_VECTOR (15 downto 0); --data output
           clk : in STD_LOGIC; --Clock pulse
           vauxp14 : in STD_LOGIC; --Pin to non inverting ADC input
           vauxn14 : in STD_LOGIC); --Pin to inverting ADC input
end analogue_input;

architecture Behavioral of analogue_input is

signal enable, ready: STD_LOGIC; --internal wiring between pins of ADC device
signal drpaddress: STD_LOGIC_VECTOR(6 downto 0);
signal dataread: STD_LOGIC_VECTOR(15 downto 0);
signal output_reg, output_next: STD_LOGIC_VECTOR(15 downto 0);

begin

-- use port map to connect XADC device
myadc: entity work.xadc_wiz_0
port map (
    daddr_in => drpaddress,     --Address of data channel (14)
    dclk_in => clk,     --100MHz clock into ADC divided down to 1MHz ADC sampling rate
    den_in => enable,   --wire connecting 'data enable in' to 'end of conversion out'
    di_in => "0000000000000000",     --input data bus to dynamically reconfigure XADC
    dwe_in => '0',   --write enable for dynamically reconfiguring XADC (unused)
    busy_out => open,   --the 'open' keyword in VHDL means leave unconnected.
    vauxp14 => vauxp14,     --connect non-inverting input of XADC device to constraint file port
    vauxn14 => vauxn14,     --connect inverting input of XADC device to constraint file port
    vn_in => '0',   --an unused input - inverting side
    vp_in => '0',   --an unsued input - non inverting side
    alarm_out => open,  --output for alarms, but we disabled them all, so leave open
    do_out => dataread,     --Digitized data output
    reset_in => '0',     --disable facility for asynchronous ADC reset
    eoc_out => enable,  --wire connecting 'data enable in' to 'end of conversion out'
    drdy_out => ready);     --signal when data is ready to be read
    
--register to hold data between reads:
process(clk, output_next)
begin
    if(clk'event and clk='1')
    then
        output_reg <= output_next;
    end if;
end process;

--detect and respond to drdy_out signal
process(ready, output_reg, dataread)
begin
    if(ready = '1')
    then
        output_next <= dataread;
    else
        output_next <= output_reg;
    end if;
end process;

--wire ports to pins or values
DATA_OUT <= output_reg;
       
drpaddress <= "0011110"; --this is binary for 14 with 001 appended
                         --to the most significant bits,
                         --corresponding to VAUXP14 and VAUXN14
end Behavioral;