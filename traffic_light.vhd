library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity traffic_light is
	port(	clk_fpga : in std_logic; 																				
			passing_signal_12 : in std_logic;			
			light_traffic1 : out std_logic_vector(2 downto 0); 			
			light_traffic2 : out std_logic_vector(2 downto 0);												
			light_traffic3 : out std_logic_vector(2 downto 0);
			light_traffic4 : out std_logic_vector(2 downto 0);
			light_traffic5 : out std_logic_vector(2 downto 0);
			light_traffic6 : out std_logic_vector(2 downto 0);
			light_traffic7 : out std_logic_vector(2 downto 0);
			
			--people_light_traffic1 : out std_logic_vector(2 downto 0); 	
			--people_light_traffic2 : out std_logic_vector(2 downto 0);	
			--people_light_traffic3 : out std_logic_vector(2 downto 0);
			--people_light_traffic4 : out std_logic_vector(2 downto 0);
			
			debug_led1 : out std_logic_vector(1 downto 0);
			debug_led2 : out std_logic_vector(1 downto 0);
			debug_led3 : out std_logic_vector(1 downto 0);	 
			debug_led4 : out std_logic_vector(1 downto 0); 
			debug_led5 : out std_logic_vector(1 downto 0);
			debug_led6 : out std_logic_vector(1 downto 0);
			debug_led7	: out std_logic_vector(1 downto 0);
			
			led_for_visual_state : out std_logic_vector(2 downto 0);
			ECHO_in_pin : in std_logic_vector(6 downto 0); 
			trigger_pin : out std_logic_vector(6 downto 0));  
end traffic_light;

architecture manage_traffic of traffic_light is


signal clk : std_logic := '0';  			
signal count : std_logic_vector (24 downto 0) := "0000000000000000000000000";


type state is (tr_st1,tr_st2,tr_st3,tr_st4,tr_st5); 	
signal tr_pres_state : state := tr_st1;
signal tr_next_state : state;


signal passing_signal_23 : std_logic := '0';
signal passing_signal_34 : std_logic := '0';
signal passing_signal_45 : std_logic := '0';
signal passing_signal_52 : std_logic := '0';


signal fake_light_traffic : std_logic_vector(2 downto 0) := "010"; 


signal contatore_del_verde : integer := 30;
signal contatore_del_giallo : integer := 5;


signal enable2 : std_logic := '1'; 
signal enable3 : std_logic := '1';  
signal enable4 : std_logic := '1';
signal enable5 : std_logic := '1';


signal cont_auto1 : integer := 0;    
signal cont_auto2 : integer := 0;
signal cont_auto3 : integer := 0;
signal cont_auto4 : integer := 0;
signal cont_auto5 : integer := 0;
signal cont_auto6 : integer := 0;
signal cont_auto7 : integer := 0;

	 
signal sum_st2 : integer := 0;
signal sum_st3 : integer := 0;
signal sum_st4 : integer := 0;
signal sum_st5 : integer := 0;


signal enable_sensore1 : std_logic;
signal enable_sensore2 : std_logic;
signal enable_sensore3 : std_logic;
signal enable_sensore4 : std_logic;
signal enable_sensore5 : std_logic;
signal enable_sensore6 : std_logic;
signal enable_sensore7 : std_logic;


signal variab_temp : integer;


component sensore_example is
port(clk : in std_logic;
	  ECHOin : in std_logic;
	  enable_cont : in std_logic;
	  trigger : out std_logic;
	  output_LED : OUT STD_LOGIC_VECTOR(1 downto 0) := (OTHERS => '0');
	  cont_auto : out integer);
end component;



-----------------------------------------------------------------------------------------------------------
-- START DI TUTTI I PROCESSI.
----------------------------------------------------------------------------------------------------------


begin


A1 : sensore_example port map(clk_fpga,ECHO_in_pin(0),enable_sensore1,trigger_pin(0),debug_led1,cont_auto1);
A2 : sensore_example port map(clk_fpga,ECHO_in_pin(1),enable_sensore2,trigger_pin(1),debug_led2,cont_auto2);
A3 : sensore_example port map(clk_fpga,ECHO_in_pin(2),enable_sensore3,trigger_pin(2),debug_led3,cont_auto3);
A4 : sensore_example port map(clk_fpga,ECHO_in_pin(3),enable_sensore4,trigger_pin(3),debug_led4,cont_auto4);
A5 : sensore_example port map(clk_fpga,ECHO_in_pin(4),enable_sensore5,trigger_pin(4),debug_led5,cont_auto5);
A6 : sensore_example port map(clk_fpga,ECHO_in_pin(5),enable_sensore6,trigger_pin(5),debug_led6,cont_auto6);
A7 : sensore_example port map(clk_fpga,ECHO_in_pin(6),enable_sensore7,trigger_pin(6),debug_led7,cont_auto7);


clk_process :	process(clk_fpga)
	begin
		if rising_edge(clk_fpga) then
			count <= count + '1';
			if count = "1011111010111100000111111" then   
				clk <= not clk;										
				count <= "0000000000000000000000000";
			end if;
		end if;
end process clk_process;
	

	

next_state_traffic_process : process(tr_pres_state,passing_signal_12,passing_signal_23,passing_signal_34,passing_signal_45,passing_signal_52)
	begin

		case tr_pres_state is
			when tr_st1 => case passing_signal_12 is
									when '0' => tr_next_state <= tr_st1;
									when '1' => tr_next_state <= tr_st2;
								end case;
		
			when tr_st2 => case passing_signal_23 is
									when '1' => tr_next_state <= tr_st3;
									when '0' => tr_next_state <= tr_st2;
								end case;
			when tr_st3 => case passing_signal_34 is
									when '1' => tr_next_state <= tr_st4;
									when '0' => tr_next_state <= tr_st3;
								end case;
			when tr_st4 => case passing_signal_45 is
									when '1' => tr_next_state <= tr_st5;
									when '0' => tr_next_state <= tr_st4;
								end case;
			when tr_st5 => case passing_signal_52 is
									when '1' => tr_next_state <= tr_st2;
									when '0' => tr_next_state <= tr_st5;
								end case;
		end case;

	if passing_signal_12 = '0' then

		tr_next_state <= tr_st1;
	
	end if;

end process next_state_traffic_process;
	

manage_every_traffic_state_process : process(tr_pres_state,clk)

begin
if rising_edge(clk) then

	case tr_pres_state is

		when tr_st1 => 
							contatore_del_verde <= 30; 
							contatore_del_giallo <= 5; 
							
							enable_sensore1 <= '0';  
							enable_sensore2 <= '0';
							enable_sensore3 <= '0';
							enable_sensore4 <= '0';
							enable_sensore5 <= '0';
							enable_sensore6 <= '0';
							enable_sensore7 <= '0';
							
							sum_st2 <= 0;  
							sum_st3 <= 0; 
							sum_st4 <= 0;
							sum_st5 <= 0;
							variab_temp <= 0;
							
							fake_light_traffic(1) <= not fake_light_traffic(1);
							
							light_traffic1 <=  fake_light_traffic; 
							light_traffic2 <=  fake_light_traffic;
							light_traffic3 <=  fake_light_traffic;
							light_traffic4 <=  fake_light_traffic;
							light_traffic5 <=  fake_light_traffic;
							light_traffic6 <=  fake_light_traffic;
							light_traffic7 <=  fake_light_traffic;
							--people_light_traffic1 <= fake_light_traffic;
							--people_light_traffic2 <= fake_light_traffic;
							--people_light_traffic3 <= fake_light_traffic;
							--people_light_traffic4 <= fake_light_traffic;
				
		when tr_st2 => passing_signal_52 <= '0';
							enable5 <= '1';  
							
							if enable2 = '1' then    										
									enable_sensore2 <= '1';		
									enable_sensore5 <= '1';
									
									
									contatore_del_verde <= contatore_del_verde-1; 
									variab_temp <= variab_temp + 1 ; 
									light_traffic1 <=  "100";
									light_traffic2 <=  "001";
									light_traffic3 <=  "100";
									light_traffic4 <=  "100";
									light_traffic5 <=  "001";
									light_traffic6 <=  "100";
									light_traffic7 <=  "100";
									sum_st2 <= cont_auto2 + cont_auto5;
									
									if variab_temp = 9 and sum_st2 <= 3 then
										contatore_del_verde <= 0;
									end if;
										
									
									--people_light_traffic1 <=  "100";
									--people_light_traffic2 <=  "001";
									--people_light_traffic3 <=  "100";
									--people_light_traffic4 <=  "001";
							
									if contatore_del_verde <= 1 then				
											
											contatore_del_giallo <= contatore_del_giallo-1;
											light_traffic1 <=  "100";
											light_traffic2 <=  "001"; 
											light_traffic3 <=  "100";
											light_traffic4 <=  "100";
											light_traffic5 <=  "010";
											light_traffic6 <=  "100";
											light_traffic7 <=  "100";
											----people_light_traffic1 <=  "100";    
											----people_light_traffic2 <=  "010";
											----people_light_traffic3 <=  "100";
											----people_light_traffic4 <=  "010";
												if contatore_del_giallo <= 1 then
													
													contatore_del_verde <= 30 + integer((sum_st3));
													contatore_del_giallo <= 5;
													enable2 <= '0'; 
													enable_sensore2 <= '0'; 
													enable_sensore5 <= '0';  
													variab_temp <= 0;
													passing_signal_23 <= '1'; 
												end if;							 
												
												
									end if;
								end if;
								
							
							
			when tr_st3 => 	passing_signal_23 <= '0'; 
									enable2 <= '1'; 
									if enable3 = '1' then
										enable_sensore1 <= '1';
										enable_sensore2 <= '1';
									
										contatore_del_verde <= contatore_del_verde-1;
										variab_temp <= variab_temp + 1 ;
										light_traffic1 <=  "001";
										light_traffic2 <=  "001";
										light_traffic3 <=  "100";
										light_traffic4 <=  "100";                 
										light_traffic5 <=  "100";
										light_traffic6 <=  "100";
										light_traffic7 <=  "100";
										sum_st3 <= cont_auto1 + cont_auto2;
										--people_light_traffic1 <=  "100";
										--people_light_traffic2 <=  "001";
										--people_light_traffic3 <=  "100";
										--people_light_traffic4 <=  "001";
									
									
										if variab_temp = 9 and sum_st3  <= 3 then
											contatore_del_verde <= 0;
										end if;
									
									
									
										if contatore_del_verde <= 1 then
												contatore_del_giallo <= contatore_del_giallo-1;
												light_traffic1 <=  "010";
												light_traffic2 <=  "010";
												light_traffic3 <=  "100";
												light_traffic4 <=  "100";
												light_traffic5 <=  "100";
												light_traffic6 <=  "100";
												light_traffic7 <=  "100";
												--people_light_traffic1 <=  "100";
												--people_light_traffic2 <=  "010";
												--people_light_traffic3 <=  "100";
												--people_light_traffic4 <=  "010";
													if contatore_del_giallo <= 1 then
														contatore_del_verde <= 30 + integer((sum_st4));
														contatore_del_giallo <= 5;
														enable3 <= '0';
														enable_sensore1 <= '0';
														enable_sensore2 <= '0';
														variab_temp <= 0;
														passing_signal_34 <= '1';
													end if;
										end if;
								end if;
							
			
			
			when tr_st4 => passing_signal_34 <= '0';
								enable3 <= '1';
							
								if enable4 = '1'then
										enable_sensore4 <= '1';
										enable_sensore7 <= '1';
										
										contatore_del_verde <= contatore_del_verde-1;
										variab_temp <= variab_temp + 1 ;
										light_traffic1 <=  "100";
										light_traffic2 <=  "100";
										light_traffic3 <=  "100";
										light_traffic4 <=  "001";
										light_traffic5 <=  "100";
										light_traffic6 <=  "100";
										light_traffic7 <=  "001";
										sum_st4 <= cont_auto4 + cont_auto7;
										--people_light_traffic1 <=  "001";
										--people_light_traffic2 <=  "100";
										--people_light_traffic3 <=  "001";
										--people_light_traffic4 <=  "100";
										
										if variab_temp = 9 and sum_st4  <= 3 then
											contatore_del_verde <= 0;
										end if;
										
										if contatore_del_verde <= 1 then
												contatore_del_giallo <= contatore_del_giallo-1;
												light_traffic1 <=  "100";
												light_traffic2 <=  "100";
												light_traffic3 <=  "100";
												light_traffic4 <=  "010";
												light_traffic5 <=  "100";
												light_traffic6 <=  "100";
												light_traffic7 <=  "010";
												----people_light_traffic1 <=  "010";
												----people_light_traffic2 <=  "100";
												----people_light_traffic3 <=  "010";
												----people_light_traffic4 <=  "100";
												
												if contatore_del_giallo <= 1 then
													contatore_del_verde <= 30 + integer((sum_st5));
													contatore_del_giallo <= 5;
													enable4 <= '0';
													enable_sensore4 <= '0';
													enable_sensore7 <= '0';
													variab_temp <= 0;
													passing_signal_45 <= '1';
												end if;
										end if;
							end if;
							
			when tr_st5 => passing_signal_45 <= '0';
								enable4 <= '1';
								
								if enable5 = '1' then
										enable_sensore3 <= '1';
										enable_sensore6 <= '1';
										
										contatore_del_verde <= contatore_del_verde-1;
										variab_temp <= variab_temp + 1;
										light_traffic1 <=  "100";
										light_traffic2 <=  "100";
										light_traffic3 <=  "001";
										light_traffic4 <=  "100";
										light_traffic5 <=  "100";
										light_traffic6 <=  "001";
										light_traffic7 <=  "100";
										sum_st5 <= cont_auto3 + cont_auto6;
										--people_light_traffic1 <=  "001";
										--people_light_traffic2 <=  "100";
										--people_light_traffic3 <=  "001";
										--people_light_traffic4 <=  "100";
										
										if variab_temp = 9 and sum_st5  <= 3 then
											contatore_del_verde <= 0;
										end if;
										
										
										if contatore_del_verde <= 1 then
												contatore_del_giallo <= contatore_del_giallo-1;
												light_traffic1 <=  "100";
												light_traffic2 <=  "100";
												light_traffic3 <=  "010";
												light_traffic4 <=  "100";
												light_traffic5 <=  "100";
												light_traffic6 <=  "010";
												light_traffic7 <=  "100";
												--people_light_traffic1 <=  "010";
												--people_light_traffic2 <=  "100";
												--people_light_traffic3 <=  "010";
												--people_light_traffic4 <=  "100";
												if contatore_del_giallo <= 1 then
													contatore_del_verde <= 30 + (sum_st2);
													contatore_del_giallo <= 5;
													enable5 <= '0';
													enable_sensore3 <= '0';
													enable_sensore6 <= '0';
													variab_temp <= 0;
													passing_signal_52 <= '1';
												end if;
										end if;
							end if;
						
							
	end case;
end if;
end process manage_every_traffic_state_process;


real_passaggio_next_to_pres_state_process : process(clk)
begin
    if rising_edge(clk) then
        tr_pres_state <= tr_next_state;
    end if;
end process real_passaggio_next_to_pres_state_process;


vedere_stato_sui_led_process : process(tr_pres_state)
begin
case tr_pres_state is
	when tr_st1 => led_for_visual_state <= "001";
	when tr_st2 => led_for_visual_state <= "010";
	when tr_st3 => led_for_visual_state <= "011";
	when tr_st4 => led_for_visual_state <= "100";
	when tr_st5 => led_for_visual_state <= "101";
end case;
end process vedere_stato_sui_led_process;


end manage_traffic;