LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity demux12 is
port (
	i : in std_logic;
	o0 : out std_logic;
	o1 : out std_logic;
	config : in std_logic
);
end;

architecture a of demux12 is
begin
    o0 <= i when config = '0' else 'Z';
    o1 <= i when config = '1' else 'Z';
end architecture;


