library ieee;
use ieee.std_logic_1164.all;
use work.fpga_pack.all;
entity configuration_memory_map is
    port (
        i           : in std_logic; -- input configuration
        o           : out config_t;
        selector    : in std_logic; -- selects the active configuration memory 
        do_config   : in std_logic; -- says when to start reading i port
        config      : in std_logic; -- select which config memory to set 1 or 2
        clock       : in std_logic -- configuration clock
    );
end;

architecture a of configuration_memory_map is
    signal mem : std_logic_vector(0 to size_config-1);
begin
    m : entity work.configuration_memory
        generic map(size_config)
        port map(
            i => i,
            o => mem,
            selector => selector,
            do_config => do_config,
            config => config,
            clock => clock
        );
    pc: for i in 0 to 2*(width+height)-1 generate
        o.pads(i) <= mem(i*iob_per_pad*(ntracks+1) to (i+1)*iob_per_pad*(ntracks+1)-1);
    end generate;

    cc: for i in 0 to 3 generate
        o.sb_corners(i) <= mem(cbits_pads+i*ntracks*2 to cbits_pads+(i+1)*ntracks*2-1);
    end generate;

    sc: for i in 0 to 2*(width+height-2)-1 generate
        o.sb_sides(i) <= mem(cbits_pads+cbits_sb_corners+i*ntracks*6 to cbits_pads+cbits_sb_corners+(i+1)*ntracks*6-1);
    end generate;

    sxc: for i in 0 to width-2 generate
        syc: for j in 0 to height-2 generate
            o.sb_middle(i,j) <= mem(cbits_pads+cbits_sb_corners+cbits_sb_sides+i*ntracks*12 to cbits_pads+cbits_sb_corners+cbits_sb_sides+(i+1)*ntracks*12-1);        
        end generate;
    end generate;

    lxc: for i in 0 to width-1 generate
        lyc: for j in 0 to height-1 generate
            o.logic(i,j) <= mem(cbits_pads+cbits_sb_corners+cbits_sb_sides+cbits_sb_middle+i*bits_logic to cbits_pads+cbits_sb_corners+cbits_sb_sides+cbits_sb_middle+(i+1)*bits_logic-1);        
        end generate;
    end generate;

end;
