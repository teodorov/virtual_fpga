LIBRARY ieee ;
USE ieee.std_logic_1164.all;
entity mux21 is
port (
	in0 : in std_logic;
	in1 : in std_logic;
	o : out std_logic;
	config : in std_logic
);
end mux21;

architecture amux21 of mux21 is
begin
	o <= in0 when config = '0' else
		in1 when config = '1' else
		'Z';
end architecture;


