LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity switch_box is
  generic (n : integer); -- number of tracks
  port (
    south : inout std_logic_vector(n-1 downto 0);
    west : inout std_logic_vector(n-1 downto 0);
    north : inout std_logic_vector(n-1 downto 0);
    east : inout std_logic_vector(n-1 downto 0);

    config : in std_logic_vector(n*12 -1 downto 0)
);
end;

architecture a of switch_box is
begin
    s: for i in n-1 downto 0 generate
      x:entity work.switch 
        port map (
            south   => south(i), 
            west    => west(i), 
            north   => north(i), 
            east    => east(i), 
            config  => config(i*12+11 downto i*12)
        );
    end generate;
end;

library ieee;
USE ieee.std_logic_1164.all;
entity switch_box_corner is
  generic (n : integer); -- number of tracks
  port (
    side1 : inout std_logic_vector(n-1 downto 0);
    side2 : inout std_logic_vector(n-1 downto 0);

    config : in std_logic_vector(n*2 -1 downto 0)
);
end;

architecture a of switch_box_corner is
begin
    s: for i in n-1 downto 0 generate
      x:entity work.switch_corner
        port map (
            side1 => side1(i),
            side2 => side2(i),
            config=> config(i*2+1 downto i*2)
        );
    end generate;
end;

library ieee;
USE ieee.std_logic_1164.all;
entity switch_box_side is
  generic (n : integer); -- number of tracks
  port (
    side1 : inout std_logic_vector(n-1 downto 0);
    side2 : inout std_logic_vector(n-1 downto 0);
    side3 : inout std_logic_vector(n-1 downto 0);

    config : in std_logic_vector(n*6 -1 downto 0)
);
end;

architecture a of switch_box_side is
begin
    s: for i in n-1 downto 0 generate
      x:entity work.switch_side
        port map (
            side1 => side1(i),
            side2 => side2(i),
            side3 => side3(i),
            config=> config(i*6+5 downto i*6)
        );
    end generate;
end;
