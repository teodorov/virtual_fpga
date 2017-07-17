library ieee;
use ieee.std_logic_1164.all;
package fpga_pack is
    constant width       : integer := 3;  --width of the domain
    constant height      : integer := 2;   --height of the domain
    constant ntracks        : integer := 2;
    constant ntracks_conf   : integer := 1;
    constant iob_per_pad     : integer := 2;

    constant cbits_sb_corners : integer := 4*ntracks*2;
    constant cbits_sb_sides   : integer := 2*(width+height-2) * ntracks * 6;
    constant cbits_sb_middle  : integer := (width-1)*(height-1) * ntracks * 12;
    constant cbits_pads       : integer := 2*(width+height)*iob_per_pad*(ntracks+1);
    constant bits_logic       : integer := 4*ntracks_conf + 2*ntracks + 16+1;
    constant cbits_logic      : integer := width*height*bits_logic;
    constant size_config      : integer := cbits_sb_corners + cbits_sb_sides + cbits_sb_middle + cbits_pads + cbits_logic;


    type pad_t  is array(Integer range <>) of std_logic_vector(iob_per_pad-1 downto 0);
    type nopad_t  is array(Integer range <>) of std_logic_vector(ntracks-1 downto 0);
    type link_t is array(Integer range <>) of std_logic_vector(ntracks-1 downto 0);
    type lb_conf_t is array(Integer range <>, Integer range <>) of 
                        std_logic_vector(4*ntracks_conf + 2*ntracks + 16 downto 0);
    --4*ntracks_conf : configuration of the 4 input muxes
    --2*n            : configuration of the 2 output tristate buffers
    --1              : configuration of the luts output register
    --15             : configuration of the lut
    type sb_corner_conf_t is array(Integer range <>) of std_logic_vector(ntracks*2-1 downto 0);
    type sb_side_conf_t is array(Integer range <>) of std_logic_vector(ntracks*6-1 downto 0);
    type sb_middle_conf_t is array(Integer range <>, Integer range <>) of std_logic_vector(ntracks*12-1 downto 0);
    type pad_conf_t is array(Integer range <>) of std_logic_vector(iob_per_pad*(ntracks+1)-1 downto 0);

    type config_t is record
        pads       : pad_conf_t(0 to 2*(width+height)-1);
        sb_corners : sb_corner_conf_t(0 to 3);
        sb_sides   : sb_side_conf_t(0 to 2*(width+height-2)-1);
        sb_middle  : sb_middle_conf_t(0 to (width-2), 0 to (height-2));
        logic      : lb_conf_t(0 to width-1, 0 to height-1);
    end record;

    type config_nopad_t is record
        sb_corners : sb_corner_conf_t(0 to 3);
        sb_sides   : sb_side_conf_t(0 to 2*(width+height-2)-1);
        sb_middle  : sb_middle_conf_t(0 to (width-2), 0 to (height-2));
        logic      : lb_conf_t(0 to width-1, 0 to height-1);
    end record;

end package;
