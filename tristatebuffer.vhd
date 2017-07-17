LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity tristatebuffer is
  port (
    s : in std_logic;
    d : out std_logic;
    g : in std_logic
);
end;

architecture a of tristatebuffer is
begin
  d <= s when g = '1' else 'Z';
end architecture;
