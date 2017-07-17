
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity tile is
  generic (
    n : integer; --number of tracks, assume all have the same size
    nbits : integer --the number of bits needed to encode n tracks
  ); 
  port (
    south : inout std_logic_vector(n-1 downto 0);
    west : inout std_logic_vector(n-1 downto 0);
    north : inout std_logic_vector(n-1 downto 0);
    east : inout std_logic_vector(n-1 downto 0);
    
    config : in std_logic_vector(4*nbits + 2*n + 16 downto 0);
    clock : in std_logic
  );
end entity;

architecture a of tile is
  constant size : integer := 4*nbits + 2*n + 16;
  signal lIn : std_logic_vector(3 downto 0);
  
  signal ss, ww, nn, ee : std_logic_vector(n-1 downto 0);
  signal o : std_logic;
begin
    --buffer them
    bufS: ss <= south;
    bufW: ww <= west;
    bufN: nn <= north;
    bufE: ee <= east;
    -- mux them
    inS : entity work.muxn
            generic map (n, nbits)
            port map (ss, lIn(0), config(size downto size - nbits+1));
    inW : entity work.muxn
            generic map (n, nbits)
            port map (ww, lIn(1), config(size - nbits downto size - 2*nbits+1));
    inN : entity work.muxn
            generic map (n, nbits)
            port map (nn, lIn(2), config(size - 2*nbits downto size - 3*nbits+1));
    inE : entity work.muxn
            generic map (n, nbits)
            port map (ee, lIn(3), config(size - 3*nbits downto size - 4*nbits+1));
    --connect inputs
    lB : entity work.logicBlock
      generic map (4)
      port map (inputs => lIn, output => o, config => config(16 downto 0), clock => clock);
        
    --connect outputs
    pip: for x in n-1 downto 0 generate
        south(x) <= o when config(16+x+1) = '1' else 'Z';
        east(x)  <= o when config(16+n+x+1) = '1' else 'Z';
    end generate;     
              
end;
