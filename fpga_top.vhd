library ieee;
use ieee.std_logic_1164.all;
use work.fpga_pack.all;
entity fpga_top is
  port (
    io          : inout pad_t(1 to 2*(width+height));
    in_conf     : in std_logic; -- input configuration
    sel_conf    : in std_logic; -- selects the active configuration memory 
    do_conf     : in std_logic; -- says when to start reading i port
    c_conf      : in std_logic; -- select which config memory to set 1 or 2
    clock_conf  : in std_logic; -- configuration clock
    clock       : in std_logic
  );
end;
architecture a of fpga_top is
   signal config  : config_t;
begin
    fpga : entity work.fpga
        port map (
          south => io(1 to width),
          west  => io(width+1 to width+height),
          north => io(width+height+1 to 2*width+height),
          east  => io(2*width+height+1 to 2*(width+height)),
          config=> config,
          clock => clock
      );

    cmem : entity work.configuration_memory_map 
    port map (
        i           => in_conf,
        o           => config,
        selector    => sel_conf,
        do_config   => do_conf,
        config      => c_conf,
        clock       => clock_conf
    );
end;
