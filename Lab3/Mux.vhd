library ieee;
use ieee.std_logic_1164.all;

entity Mux is
port (
	vacation_in1, desired_in2 		: in std_logic_vector(3 downto 0); -- Vaction is input 1, desired is input 2
	vacation_mode						: in std_logic; 						  -- This is the select
	mux_temp								: out std_logic_vector(3 downto 0) -- This is the output
);

end Mux;

architecture MuxArch of Mux is

begin

with vacation_mode select

mux_temp <=  desired_in2 when '0',
				 vacation_in1 when '1';
			  
end MuxArch;


