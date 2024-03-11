library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0); -- Active Low to start
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;

component Compx4 port (
          A,B 							: in std_logic_vector(3 downto 0);
			 AGTB							: out std_logic;
			 AEQB							: out std_logic;
			 ALTB							: out std_logic
			 
        );
end component Compx4;

component Bidir_shift_reg port (
			CLK				: in std_logic := '0';
			RESET				: in std_logic := '0';
			CLK_EN			: in std_logic := '0';
			LEFT0_RIGHT1	: in std_logic := '0';
			REG_BITS			: out std_logic_vector(7 downto 0)
		  );
end component Bidir_shift_reg;

component U_D_Bin_Counter8bit port (
			CLK				: in std_logic;
			RESET				: in std_logic;
			CLK_EN			: in std_logic;
			UP1_DOWN0		: in std_logic;
			COUNTER_BITS	: out std_logic_vector(7 downto 0)
		  );
end component U_D_Bin_Counter8bit;

component Inverter port (
			pb_n 				: IN std_logic_vector(3 downto 0);
			vacation_mode 	: OUT std_logic;
			MC_test_mode 	: OUT std_logic;
			window_open 	: OUT std_logic;
			door_open 		: OUT std_logic
		  );
end component Inverter;

	
component Tester port (
	MC_TESTMODE				: in  std_logic;
	I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
); 
end component Tester;
--	

component HVAC port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
);
end component HVAC;


component Mux port (
	vacation_in1, desired_in2 		: in std_logic_vector(3 downto 0); -- Vaction is input 1, desired is input 2
	vacation_mode						: in std_logic; 						  -- This is the select
	mux_temp								: out std_logic_vector(3 downto 0) -- This is the output
);
end component Mux;


component Energy_Monitor port (
	vacation_mode, MC_test_mode, window_open, door_open, AGTB, AEQB, ALTB		 	      : IN std_logic;
	furnace, at_temp, AC, blower, window, door, vacation, increase, decrease, run			: OUT std_logic
);
end component Energy_Monitor;

------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------

------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
--signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);
signal vacation_mode, MC_test_mode, window_open, door_open	: std_logic;

-- HVAC AND ENERGY_MoNITOR SIGNALS
signal run 						: std_logic;
signal increase, decrease	: std_logic;
signal current_temp			: std_logic_vector(3 downto 0);

-- Mux Signals
signal desired_temp			: std_logic_vector(3 downto 0);
signal vacation_temp			: std_logic_vector(3 downto 0);
signal mux_temp				: std_logic_vector(3 downto 0);
-- Hooking these temps up to switches



-- Compx signals
signal AGTB						: std_logic;
signal AEQB						: std_logic;
signal ALTB						: std_logic;

-- Energy Monitor signals





--signal AGTB                : std_logic_vector(3 downto 0);
--signal AEQB                : std_logic_vector(3 downto 0);
--signal ALTB                : std_logic_vector(3 downto 0);

------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input
desired_temp <= sw(3 downto 0);
vacation_temp <= sw(7 downto 4);



inst1: sevensegment port map (mux_temp, hexA_7seg);
inst2: sevensegment port map (current_temp, hexB_7seg);
inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
inst4: inverter port map (pb_n, vacation_mode, MC_test_mode, window_open, door_open);
inst5: HVAC port map (FALSE, clk_in, run, increase, decrease, current_temp);
inst6: Mux port map (vacation_temp, desired_temp, vacation_mode, mux_temp);
inst7: Compx4 port map (mux_temp, current_temp, AGTB, AEQB, ALTB);
inst8: Tester port map (MC_test_mode, AEQB, AGTB, ALTB, desired_temp, current_temp, leds(6));
inst9: Energy_Monitor port map (vacation_mode, MC_test_mode, window_open, door_open, AGTB, AEQB, ALTB, leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7), increase, decrease, run);

--inst4: Compx4 port map (hex_A, hex_B, leds(2), leds(1), leds(0));
--inst5: Bidir_shift_reg port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
--inst6: U_D_Bin_Counter8bit port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));

		
end design;

