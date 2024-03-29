-- Ahmed Mohammed and Simerus Mahesh Lab4_REPORT LS206 Group 23
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declares the top file/overall circuit input and output bits/vectors
ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	
    seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	

	);
END LogicalStep_Lab4_top;

-- Defines the architecture of the overall circuit
ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   
	-- Defines the segment7_mux component
	component segment7_mux port (
             clk        	: in  	std_logic := '0'; -- Input, clock-style
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0); -- Output, 7 bit vector
			 DIG2			: out	std_logic; -- Output, 1 bit relating to digit 2
			 DIG1			: out	std_logic -- Output, 1 bit relating to digit 1
   );
   end component;

   -- Defines the clock generator component
   component clock_generator port (
			sim_mode			: in boolean; -- Boolean for simulation true/false status
			reset				: in std_logic; -- Input reset bit
            clkin      		    : in  std_logic; -- Clock input bit
			sm_clken			: out	std_logic; -- Clock enable output bit
			blink		  		: out std_logic -- Blink output bit
  );
   end component;

   -- Defines the pb filter component
    component pb_filters port (
			clkin				: in std_logic; -- Input clock bit
			rst_n				: in std_logic; -- Reset input bit (active low)
			rst_n_filtered	    : out std_logic; -- Filtered reset output bit (active low)
			pb_n				: in  std_logic_vector (3 downto 0); -- Button input 4-bit vector (active low)
			pb_n_filtered	    : out	std_logic_vector(3  downto 0) -- Filtered button output 4-bit vector (active low)							 
 );
   end component;

   -- Defines the pb inverter component
	component pb_inverters port (
			rst_n				: in  std_logic; -- Input reset bit
			rst				    : out	std_logic; -- Output reset bit (inverted)							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0); -- Input 4 bit button vector
			pb					: out	std_logic_vector(3 downto 0) -- Output 4 bit vector corresponding to inverted buttons							 
  );
   end component;
	
   -- Defines the synchronizer component
	component synchronizer port(
			clk					: in std_logic; -- Clock input
			reset					: in std_logic; -- Reset input
			din					: in std_logic; -- Input data bit
			dout					: out std_logic -- Output data bit
  );
   end component; 

   -- Defines the holding register component
  component holding_register port (
			clk					: in std_logic; -- Input bit for clock
			reset					: in std_logic; -- Input bit for reset
			register_clr		: in std_logic; -- Input bit for register clear
			din					: in std_logic; -- Input bit for data input
			dout					: out std_logic -- Output bit for data output
  );
  end component;

  -- Defines the state machine component
	component State_Machine port (
		clk_input, reset, sm_clken, blink_sig, ns_request, ew_request			: IN std_logic; -- Input bits for clock, reset, enable, blink signal, and pedestrian requests
		ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red						: OUT std_logic; -- Output bits for the red, amber and green traffic lights (0 when not-active, 1 when light is active), for both NS and EW directions
		ns_crossing, ew_crossing	: OUT std_logic; -- Output bits to symbolize crossing periods
		fourbit_state_number : OUT std_logic_vector(3 downto 0); -- Output logic vector to represent state (unsigned decimal) as a binary number
		ns_clear, ew_clear : OUT std_logic -- Output bits to clear pedestrian requests
	);
	end component;
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads, set to TRUE for SIMULATIONS
	
	-- All of the signals are defined below
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic; -- For holding reset values
	SIGNAL sm_clken, blink_sig							: std_logic;  -- For holding the enable and blink signal
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0);  -- For holding the button values
	SIGNAL ew_req, ns_req					: std_logic; -- For holding the crossing requests
	SIGNAL ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red : std_logic; -- For holding the traffic light values
	SIGNAL ns_crossing, ew_crossing : std_logic; -- For holding the active crossing values
	SIGNAL NSLIGHTS, EWLIGHTS	: std_logic_vector(6 downto 0); -- For holding the overall concatenated traffic digit value
	SIGNAL ns_clear, ew_clear : std_logic; -- For holding the pedestrian request clear signals
	SIGNAL ew_out, ns_out : std_logic; -- For holding the traffic light outputs
	
BEGIN
----------------------------------------------------------------------------------------------------
-- Filters and inverts the buttons
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
-- Used to generate the waveform in part B
--INST2: synchronizer     port map (clkin_50,synch_rst, rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
--leds(0) <= blink_sig;
--leds(2) <= sm_clken;

-- Used to generate the clock signal
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);

-- Used for the synchronizer which generates the synchronous reset signal
INSTMID: synchronizer port map (clkin_50, synch_rst, rst, synch_rst);

-- Synchronizer and holding register for the EW traffic light
INSTEW: synchronizer port map (clkin_50, synch_rst, pb(1), ew_req);
INSTEWHOLDREG: holding_register port map (clkin_50, synch_rst, ew_clear, ew_req, ew_out);
leds(3) <= ew_out;

-- Synchronizer and holding register for the NS traffic light
INSTNS: synchronizer port map (clkin_50, synch_rst, pb(0), ns_req);
INSTNSHOLDREG : holding_register port map (clkin_50, synch_rst, ns_clear, ns_req, ns_out);
leds(1) <= ns_out;

-- Generates an instance of the state machine which transitions between states and controls most of the traffic light
INSTSTATEMACHINE : State_Machine port map (clkin_50, synch_rst, sm_clken, blink_sig, ns_out, ew_out, ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red, ns_crossing, ew_crossing, leds(7 downto 4), ns_clear, ew_clear);

-- Displays the NS and EW crossing state values on the leds
leds(0) <= ns_crossing;
leds(2) <= ew_crossing;

-- Holds the concatenated traffic light digit values
NSLIGHTS(6 downto 0) <= ns_amber & "00" & ns_green & "00" & ns_red;
EWLIGHTS(6 downto 0) <= ew_amber & "00" & ew_green & "00" & ew_red; 

-- Uses the segment7_mux to display the traffic light digit values on the FPGA (or waveform if in SIM_MODE)
INSTLIGHTS : segment7_mux port map (clkin_50, NSLIGHTS, EWLIGHTS, seg7_data, seg7_char2, seg7_char1);

-- All of the simulated values for the final waveform
--sim_sm_clken <= sm_clken;
--sim_blink_sig <= blink_sig;
--sim_ns_green <= ns_green;
--sim_ns_amber <= ns_amber;
--sim_ns_red <= ns_red;
--sim_ew_green <= ew_green;
--sim_ew_amber <= ew_amber;
--sim_ew_red <= ew_red;


END SimpleCircuit;
