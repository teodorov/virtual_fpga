LIBRARY ieee ;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lut is
  generic (n : integer := 4);
port (
	i : in std_logic_vector(n-1 downto 0);
	o : out std_logic;
	config : in std_logic_vector (2**n - 1 downto 0)
);
end;

architecture alut of lut is
	signal inLut : std_logic_vector(n-1 downto 0);
begin
    p: for x in n-1 downto 0 generate
        inLut(x) <= '0' when i(x) = 'Z' else i(x);    
    end generate;
	o <= config( conv_integer (inLut));
end architecture;
