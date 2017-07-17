library ieee;
use ieee.std_logic_1164.all;
entity configuration_memory is
    generic (
        bits : integer --size of the configuration memory    
    );
    port (
        i           : in std_logic; -- input configuration
        o           : out std_logic_vector(bits-1 downto 0);
        selector    : in std_logic; -- selects the active configuration memory 
        do_config   : in std_logic; -- says when to start reading i port
        config      : in std_logic; -- select which config memory to set 1 or 2
        clock       : in std_logic -- configuration clock
    );
end;

architecture a of configuration_memory is
    signal link1 : std_logic_vector(bits downto 0);
    signal link2 : std_logic_vector(bits downto 0);
    signal clock1, clock2 : std_logic;
    signal internalI : std_logic;
begin
    a : for i in 0 to bits-1 generate
        dff1: entity work.xdff
            port map (
                clock => clock1,
                d     => link1(i),
                q     => link1(i+1)            
            );
        dff2: entity work.xdff
            port map (
                clock => clock2,
                d     => link2(i),
                q     => link2(i+1)            
            );
        mux: entity work.mux21
            port map ( 
                in0     => link1(i+1),
                in1     => link2(i+1),
                o       => o(i),
                config  => selector
            );
    end generate;

    internalI <= i when do_config = '1' else 'Z';

    m : entity work.demux12
            port map (
                i       => internalI,
                o0      => link1(0),
                o1      => link2(0),
                config  => config        
            );
    clock1 <= clock when do_config = '1' and config = '0' else 'Z';
    clock2 <= clock when do_config = '1' and config = '1' else 'Z';
end;
