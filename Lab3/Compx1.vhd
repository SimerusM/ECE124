library ieee;
use ieee.std_logic_1164.all;

entity Compx1 is port (
	A,B 							: in std_logic;
	AGB,AEB,ALB 				: out std_logic
	
	
);

end Compx1;

architecture logic of Compx1 is

begin

AGB <= (NOT B) AND A;
AEB <= A XNOR B;
ALB <= (NOT A) AND B; 
			  
end logic;
