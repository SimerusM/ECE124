---- Members: Ian Korovinsky and Steven Yang | Lab4_REPORT | LS206 | Group 17
--
---- Import packages
--library ieee;
--use ieee.std_logic_1164.all;
--
---- Define synchronizer entity, whose goal is to take in the button inputs asynchronously and synchronize the outputs with the clock
--entity synchronizer is
--  port (
--    clk   : in  std_logic; -- Clock input
--    reset : in  std_logic; -- Reset input
--    din   : in  std_logic; -- Input data bit
--    dout  : out std_logic -- Output data bit
--  );
--end synchronizer;
--
---- Defines the logic of the synchronizer circuit
--architecture circuit of synchronizer is
--  
--  -- Signal (2-bit vector) to keep track of synchronizer register contents
--  signal sreg : std_logic_vector(1 downto 0);
--
--begin
--  -- Process construct that advances based on changes in the clock input
--  synced_process : process(clk)
--  
--  begin
--	-- If the clock is on it's rising edge, continue logic evaluation
--	if rising_edge(clk) then
--		-- If reset is active then reset the register contents both to 0
--		if reset = '1' then
--			sreg <= "00";
--		-- If reset is not active the shift the register (D flip-flop) contents to one to the right
--		else
--			sreg(1) <= sreg(0); -- Shifts from first register to second
--			sreg(0) <= din; -- Takes the data input and assigns it to the first register
--		end if;
--	end if;
--	end process synced_process;
--	dout <= sreg(1); -- Assigns the second register contents to the circuit data output
--end circuit;

library ieee;
use ieee.std_logic_1164.all;


entity synchronizer is port (

			clk			: in std_logic;
			reset		: in std_logic;
			din			: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0);

BEGIN
	-- Counter process
	process (clk)
		begin			

			if (rising_edge(clk)) then
				sreg <= (not reset AND sreg(0)) & (not reset AND din);
			end if;
		dout <= sreg(1);
		end process;
end;