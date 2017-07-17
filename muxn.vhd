LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity muxn is
  generic (
    n : integer; -- inputs size
    nbits : integer -- number of bits needed to encode n
  );
  port (
    i : in std_logic_vector(n-1 downto 0);
    o : out std_logic;
    config : in std_logic_vector(nbits-1 downto 0)
);
end muxn;
library ieee;
use ieee.std_logic_unsigned.all;
architecture a of muxn is
	signal inC : std_logic_vector(nbits-1 downto 0);
begin
  p : for x in nbits-1 downto 0 generate
    inC(x) <= '0' when config(x) = 'Z' else config(x);
  end generate;
  o <= i(conv_integer (inC));
end architecture;
