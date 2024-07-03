library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sensore_example is
port(clk : in std_logic;
	  ECHOin : in std_logic;
	  enable_cont : in std_logic;   
	  trigger : out std_logic;
	  output_LED : out std_logic_vector(1 downto 0) := (others => '0');
	  cont_auto : out integer);
end sensore_example;



architecture behav_arch of sensore_example is

signal microsec : std_logic := '0';
signal counter : std_logic_vector(17 downto 0);

signal fake_cont_display : integer := 0;
signal enable : std_logic := '1';

begin



clock_process : process(clk)
variable count0 : integer := 0;
begin
	if(rising_edge(clk))then
		if(count0=24)then
			microsec<= not microsec;
			count0 := 0;
		end if;
		count0 := count0 + 1;
	end if;
end process clock_process;



process(microsec)
variable count1: integer:=0;
begin
	if rising_edge(microsec) then
		if count1 = 0 then
			counter<="000000000000000000";
			trigger<='1';
		elsif count1 = 10 then
			trigger<='0';
		end if;
		
		if count1 = 249999 then
		count1:=0;
		else
		count1:=count1+1;
		end if;
		
		if ECHOin = '1' then
		counter<=counter+1;
		end if;
		
	end if;
end process;


process(ECHOin,enable_cont)

begin
if enable_cont = '1' then 
	if falling_edge(ECHOin) then
		if (counter < 2321 and counter > 291 and enable = '1') then
			
			fake_cont_display <= fake_cont_display + 1; 
			
			enable <= '0';
			output_LED <= "01";
			
		elsif(counter > 2321 and enable = '0')then
			
			output_LED <= "10";
			enable <= '1';
			
		end if;
	end if;
else
	fake_cont_display <= 0;
	output_LED <= "11";
	
end if;
cont_auto <= fake_cont_display;
end process;


end behav_arch;


