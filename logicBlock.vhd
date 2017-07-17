
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

entity logicBlock is
generic (n : integer := 4);
port (
	inputs : in std_logic_vector(n-1 downto 0);
	output : out std_logic;
	config : in std_logic_vector(n**2 downto 0); -- the last bit is the mux config	
	clock : in std_logic
);
end logicBlock;

architecture aLB of logicBlock is
	signal fromlut: std_logic;
	signal fromdff : std_logic;
begin
	lut : entity work.lut 
				generic map (n)
				port map(inputs, fromlut, config(n**2-1 downto 0));
	dff : entity work.xDFF 
				port map (clock, fromlut, fromdff);
	mux : entity work.mux21 
				port map (fromlut, fromdff, output, config(n**2));
end architecture;
