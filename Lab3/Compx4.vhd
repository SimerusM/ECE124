library ieee;
use ieee.std_logic_1164.all;

entity Compx4 is

port ( --declaring inpput and output variables
   A,B																			  : in std_logic_vector(3 downto 0);
	AGTB,AEQB,ALTB																	  : out std_logic 
	
); 

end Compx4;

architecture logic of Compx4 is

component Compx1 is port (
          A,B 							: in std_logic;
			 AGB,AEB,ALB 				: out std_logic
);
end component;


signal AGTB2					: std_logic_vector(3 downto 0);
signal AEQB2					: std_logic_vector(3 downto 0);
signal ALTB2					: std_logic_vector(3 downto 0);



begin
	inst1: Compx1 port map (A(3), B(3), AGTB2(3), AEQB2(3), ALTB2(3));
	inst2: Compx1 port map (A(2), B(2), AGTB2(2), AEQB2(2), ALTB2(2));
	inst3: Compx1 port map (A(1), B(1), AGTB2(1), AEQB2(1), ALTB2(1));
	inst4: Compx1 port map (A(0), B(0), AGTB2(0), AEQB2(0), ALTB2(0));

ALTB <= ALTB2(3) OR (AEQB2(3) AND ALTB2(2)) OR (AEQB2(3) AND AEQB2(2) AND ALTB2(1)) OR (AEQB2(3) AND AEQB2(2) AND AEQB2(1) AND ALTB2(0));
AEQB <= AEQB2(3) AND AEQB2(2) AND AEQB2(1) AND AEQB2(0);
AGTB <= AGTB2(3) OR (AEQB2(3) AND AGTB2(2)) OR (AEQB2(3) AND AEQB2(2) AND AGTB2(1)) OR (AEQB2(3) AND AEQB2(2) AND AEQB2(1) AND AGTB2(0));


	
end logic;