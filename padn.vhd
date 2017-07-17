library ieee;
use ieee.std_logic_1164.all;
entity padn is
    generic (
        n            : integer := 2; -- number of iob2n per pad
        ntracks      : integer := 2;      -- number of tracks
        ntracks_conf : integer := 1       -- number of bits to encode n tracks       
    );
    port(
        io      : inout std_logic_vector(n-1 downto 0);
        tracks : inout std_logic_vector(ntracks-1 downto 0);
        config  : in    std_logic_vector(n*(ntracks+1)-1 downto 0)
    );
end;

architecture a of padn is
begin
    pad:for x in n-1 downto 0 generate
        e : entity work.iob2n
                generic map (
                    n => ntracks,
                    nbits => ntracks_conf                
                )    
                port map (
                    io      => io(x),
                    i       => tracks,
                    o       => tracks,
                    config  => config(x*(ntracks+1)+ntracks downto x*(ntracks+1))
                );
    end generate;
end;
