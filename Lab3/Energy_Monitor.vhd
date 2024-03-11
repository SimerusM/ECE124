library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity Energy_Monitor is port
	(
			vacation_mode, MC_test_mode, window_open, door_open, AGTB, AEQB, ALTB		 	      : IN std_logic;
			furnace, at_temp, AC, blower, window, door, vacation, increase, decrease, run			: OUT std_logic
	);
end Entity;

architecture logic of Energy_Monitor is

--signal furnace1, at_temp1, AC1, blower1, window1 , door1, vacation1, increase1, decrease1, run1 : std_logic;

begin
Energy_Monitor1: 
PROCESS (vacation_mode, MC_test_mode, window_open, door_open, AGTB, AEQB, ALTB) is
 
begin
		IF(door_open = '1') THEN
			door <= '1';
		ELSE
			door <= '0';
		END IF;
		
		
		
		IF(window_open = '1') THEN
			window <= '1';
		ELSE
			window <= '0';
		END IF;
		
		
		
		IF(vacation_mode = '1') THEN
			vacation <= '1';
		ELSE
			vacation <= '0';
		END IF;
		
		
		
		IF(NOT(AEQB = '1') AND (NOT(MC_test_mode = '1' OR window_open = '1' OR door_open = '1'))) THEN
			blower <= '1';
		ELSE
			blower <= '0';
			if(AEQB = '1') THEN
				at_temp <= '1';
			else
				at_temp <= '0';
			end if;
		END IF;
		
		IF (AEQB = '1' OR window_open = '1' OR door_open = '1' OR MC_test_mode = '1') THEN 
			run <= '0';
		Else
			run <= '1';
		END IF;

		
		IF(ALTB = '1') THEN
			AC <= '1';
			increase <= '0';
			decrease <= '1';
		ELSE
			AC <= '0';
			increase <= '1';
			decrease <= '0';
		END IF;
		
		IF(AGTB = '1') THEN
			furnace <= '1';
			increase <= '1';
			decrease <= '0';
		ELSE
			furnace <= '0';
			increase <= '0';
			decrease <= '1';
		END IF;

		
		
		
		
		
end process;

end;

