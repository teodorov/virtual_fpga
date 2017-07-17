library ieee;
use ieee.std_logic_1164.all;
entity iob is
    port(
        io : inout std_logic;
        i  : in    std_logic;
        o  : out   std_logic;
        config : in std_logic
    );
end;
architecture a of iob is
begin
    process(i, io, config)
    begin
        if config = '1' then
            io <= i;
        else
            io <= 'Z';
        end if;
        o <= io;
    end process;
end;

