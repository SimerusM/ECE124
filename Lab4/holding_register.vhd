-- Importing the IEEE standard logic library which provides definitions for different logic signal types.
library ieee;
use ieee.std_logic_1164.all;

-- Definition of the holding_register entity
-- This component is designed to store a single bit of digital data.
entity holding_register is 
    port (
        clk             : in std_logic;   -- Clock input for synchronization
        reset           : in std_logic;   -- Reset input to initialize or clear the register
        register_clr    : in std_logic;   -- Clear input specifically for clearing the stored data
        din             : in std_logic;   -- Data input to be stored in the register
        dout            : out std_logic   -- Data output that reflects the stored value
    );
end holding_register;

-- Implementation of the holding_register's functionality.
architecture circuit of holding_register is
    -- Internal signal declaration for storing the data bit.
    Signal sreg             : std_logic;
BEGIN
    -- Process block sensitive to the clk, reset, register_clr, and din signals.
    -- This means the process block is executed on changes to any of these signals.
    process (clk, reset, register_clr, din)
    begin
        -- Check for a rising edge on the clock signal to update the register's value synchronously.
        if (rising_edge(clk)) then
            -- Boolean logic for determining the value to store in the register.
            -- If reset or register_clr is active, sreg will be cleared (logic 0).
            -- Otherwise, sreg stores the value of din or retains its own value if din is logic 0.
            sreg <= (NOT((register_clr OR reset)) AND (din OR sreg));
        end if;
        -- The output signal dout is continuously assigned the value of sreg.
        dout <= sreg;
    end process;
end;
