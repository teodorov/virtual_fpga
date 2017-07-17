LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity xDFF is
port (
	clock : in std_logic;
	d : in std_logic;
	q : out std_logic
);
end xDFF;

architecture adff of xDFF is
begin
	q <= d when clock'event and clock = '1' and clock'last_value = '0';
end architecture;


