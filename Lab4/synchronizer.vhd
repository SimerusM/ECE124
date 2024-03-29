-- Ahmed Mohammed and Simerus Mahesh Lab4_REPORT LS206 Group 23
library ieee;
use ieee.std_logic_1164.all;

-- This component is designed to synchronize an asynchronous input signal 'din' to the clock domain of 'clk'.
-- The synchronized output is provided as 'dout'.
entity synchronizer is port (
			clk			: in std_logic;
			reset		        : in std_logic;
			din			: in std_logic;
			dout		        : out std_logic
  );
end synchronizer;
 
-- Implementation of the 'synchronizer' using a 2-bit shift register
architecture circuit of synchronizer is
    -- 2-bit shift register for synchronizing the input signal
    Signal sreg				: std_logic_vector(1 downto 0);

BEGIN
    -- Process triggered by the clock signal
    process (clk)
	begin			
	    if (rising_edge(clk)) then
		-- When 'reset' is asserted (high), the inputs to the shift register are forced to '0'.
		sreg <= (not reset AND sreg(0)) & (not reset AND din);
	    end if;
            -- The most significant bit of the shift register is assigned to 'dout' continuously.
            -- This outputs the synchronized version of 'din', delayed by two clock cycles.
	    dout <= sreg(1);
	end process;
end;
