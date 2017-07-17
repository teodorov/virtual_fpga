

library ieee;
use ieee.std_logic_1164.all;

entity switch is
  port (
    south : inout std_logic;
    west : inout std_logic;
    north : inout std_logic;
    east : inout std_logic;

    config : in std_logic_vector(11 downto 0)
);
end entity;

architecture a of switch is
begin
    p0 : entity work.tristatebuffer port map (south, west, config(0));
    p1 : entity work.tristatebuffer port map (south, north, config(1));
    p2 : entity work.tristatebuffer port map (south, east, config(2));

    p3 : entity work.tristatebuffer port map (west, south, config(3));
    p4 : entity work.tristatebuffer port map (west, north, config(4));
    p5 : entity work.tristatebuffer port map (west, east, config(5));

    p6 : entity work.tristatebuffer port map (north, south, config(6));
    p7 : entity work.tristatebuffer port map (north, west, config(7));
    p8 : entity work.tristatebuffer port map (north, east, config(8));

    p9 : entity work.tristatebuffer port map (east, south, config(9));
    p10 : entity work.tristatebuffer port map (east, west, config(10));
    p11 : entity work.tristatebuffer port map (east, north , config(11));
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity switch_corner is
  port (
  side1 : inout std_logic;
  side2 : inout std_logic;
  
  config : in std_logic_vector(1 downto 0)
);
end entity;

architecture a of switch_corner is
begin
    p0 : entity work.tristatebuffer port map (side1, side2, config(0));
    p1 : entity work.tristatebuffer port map (side2, side1, config(1));
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity switch_side is
    port (
    side1 : inout std_logic;
    side2 : inout std_logic;
    side3 : inout std_logic;
    
    config : in std_logic_vector(5 downto 0)
    );
end entity;

architecture a of switch_side is
begin
    p0 : entity work.tristatebuffer port map (side1, side2, config(0));
    p1 : entity work.tristatebuffer port map (side1, side3, config(1));
    
    p2 : entity work.tristatebuffer port map (side2, side1, config(2));
    p3 : entity work.tristatebuffer port map (side2, side3, config(3));
    
    p4 : entity work.tristatebuffer port map (side3, side1, config(4));
    p5 : entity work.tristatebuffer port map (side3, side1, config(5));
end architecture;
