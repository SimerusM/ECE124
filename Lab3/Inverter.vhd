LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY Inverter IS
	PORT
	(
		pb_n : IN std_logic_vector(3 downto 0);
		vacation_mode 	: OUT std_logic;
		MC_test_mode 	: OUT std_logic;
		window_open 	: OUT std_logic;
		door_open 		: OUT std_logic
	);
END Inverter;

ARCHITECTURE gates OF Inverter IS
	

BEGIN

	door_open <= not(pb_n(0));
	window_open <= not(pb_n(1));
	MC_test_mode <= not(pb_n(2));
	vacation_mode <= not(pb_n(3));
	

END gates;