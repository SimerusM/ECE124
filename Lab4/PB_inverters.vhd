-- Ahmed Mohammed and Simerus Mahesh Lab4_REPORT LS206 Group 23
library ieee;
use ieee.std_logic_1164.all;

-- Declaration of the entity PB_inverters. It serves as the interface of the module,
-- specifying inputs and outputs.
entity PB_inverters is
    port (
        rst_n           : in  std_logic;                -- Active low reset input
        rst             : out std_logic;                -- Active high reset output
        pb_n_filtered   : in  std_logic_vector (3 downto 0); -- Input vector, active low pushbuttons
        pb              : out std_logic_vector(3 downto 0)   -- Output vector, active high pushbuttons
    ); 
end PB_inverters;

-- Architecture ckt of PB_inverters begins. This section defines the internal logic of the entity.
architecture ckt of PB_inverters is
begin
    -- Invert the active low reset input to generate an active high reset output
    rst <= NOT(rst_n);
    
    -- Invert the active low pushbutton inputs to generate active high pushbutton outputs
    pb <= NOT(pb_n_filtered);

end ckt; -- End of architecture
