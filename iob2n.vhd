library ieee;
use ieee.std_logic_1164.all;
entity iob2n is
    generic (
        n : integer := 2;    -- number of tracks
        nbits : integer := 1 -- number of bits to encode n tracks       
    );
    port(
        io      : inout std_logic;
        i       : in    std_logic_vector(n-1 downto 0);
        o       : out   std_logic_vector(n-1 downto 0);
        config  : in    std_logic_vector(n downto 0)
        -- config(nbits-1 downto 0) if config(n) = '1' from n tracks to exterior; (cannot be more than one, thus the multiplexor)
        -- config(n-1 downto 0) if config(n) <> '1' from exterior to a set of tracks from the n tracks (can be more than one, thus a tristate)
        -- config(n) the configuration of the IOB as input or output
    );
end;
library ieee;
use ieee.std_logic_unsigned.all;
architecture a of iob2n is
    signal toIO, reg   : std_logic;
    signal fromIO : std_logic;
    signal inC    : std_logic_vector(nbits-1 downto 0);
begin
    e : entity work.iob
            port map(
                io      => io,
                i       => toIO,
                o       => fromIO,
                config  => config(n)                
            );
    p : for x in nbits-1 downto 0 generate
        inC(x) <= '0' when config(x) = 'Z' else config(x);
    end generate;
    toIO <= i(conv_integer(inC(nbits-1 downto 0))) when config(n) = '1' else 'Z';

    t:for x in n-1 downto 0 generate
        o(x) <= fromIO when config(n) /= '1' and config(x) = '1' else 'Z';
    end generate;
end;

