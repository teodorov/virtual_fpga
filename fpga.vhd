library ieee;
use ieee.std_logic_1164.all;
use work.fpga_pack.all;
entity fpga is
  port (
        south   : inout pad_t(0 to width-1);
        west    : inout pad_t(0 to height-1);
        north   : inout pad_t(0 to width-1);
        east    : inout pad_t(0 to height-1);
        config  : in config_t;
        clock   : in std_logic
);
end entity;

architecture a of fpga is
  signal hlink : link_t(0 to width*(height+1)-1);
  signal vlink : link_t(0 to (width+1)*height-1);
begin
  --generate the IO pads
  hPad : for i in 0 to width-1 generate
    N:entity work.padn
        generic map (
            n => iob_per_pad,
            ntracks => ntracks,
            ntracks_conf => ntracks_conf
        )
        port map (
            io      => north(i),
            tracks => hlink(i),
            config  => config.pads(i)
        );
    S:entity work.padn
        generic map (
            n => iob_per_pad,
            ntracks => ntracks,
            ntracks_conf => ntracks_conf
        )
        port map (
            io      => south(i),
            tracks => hlink(width*(height+1) - width + i),
            config  => config.pads(width+i)
        );
  end generate;
  vPad : for i in 0 to height-1 generate
    E:entity work.padn
        generic map (
            n => iob_per_pad,
            ntracks => ntracks,
            ntracks_conf => ntracks_conf
        )
        port map (
            io      => east(i),
            tracks => vlink(i),
            config  => config.pads(2*width+i)
        );
    W:entity work.padn
        generic map (
            n => iob_per_pad,
            ntracks => ntracks,
            ntracks_conf => ntracks_conf
        )
        port map (
            io      => west(i),
            tracks => vlink((width+1)*height-height + i),
            config  => config.pads(2*width+height+i)
        );
  end generate;
  --generate the switches
  y: for j in 0 to height generate
    x : for i in 0 to width generate
      --line 0
      l0:if j = 0 generate
        --column 0
        c0:if i = 0 generate
          e:entity work.switch_box_corner
            generic map (n=>ntracks)
            port map (
              side1 => vlink(i*height+j), -- south
              side2 => hlink(j*width+i), --east
              config=> config.sb_corners(0)
            );
        end generate;
        --column i
        ci:if i > 0 and i < width generate
          e:entity work.switch_box_side
            generic map (n=>ntracks)
            port map (
              side1 => vlink(i*height+j), --south
              side2 => hlink(j*width+i-1),--west
              side3 => hlink(j*width+i),  --east
              config=> config.sb_sides(i-1)
            );
        end generate;
        --column n
        cn:if i=width generate
          e:entity work.switch_box_corner
            generic map (n=>ntracks)
            port map (
              side1 => vlink(i*height+j), --south
              side2 => hlink(j*width+i-1),--west
              config=> config.sb_corners(1)
            );
        end generate;
      end generate;
      --line j 
      lj:if j > 0 and j < height generate
        --column 0
        c0:if i = 0 generate
           e:entity work.switch_box_side
            generic map (n=>ntracks)
            port map (
              side1 => vlink(i*height+j),--south
              side2 => vlink(i*height+j-1),--north
              side3 => hlink(j*width+i),--east
              config=> config.sb_sides(2*(width-1)+j-1)
            );
        end generate;
        --column i
        ci:if i > 0 and i < width generate
          e:entity work.switch_box
            generic map (n=>ntracks)
            port map (
              south => vlink(i*height+j),
              west  => hlink(j*width+i-1),
              north => vlink(i*height+j-1),
              east  => hlink(j*width+i),
              config=> config.sb_middle(i-1,j-1)
            );
        end generate;
        --column n
        cn:if i=width generate
          e:entity work.switch_box_side
            generic map (n=>ntracks)
            port map (
              side1 => vlink(i*height+j), --south
              side2 => hlink(j*width+i-1),--west
              side3 => vlink(i*height+j-1),--north
              config=> config.sb_sides(2*(width-1)+(height-1)+j-1)
            );
        end generate;
      end generate;
      --line m
      lm:if j = height generate
        --column 0
        c0:if i = 0 generate
          e:entity work.switch_box_corner
            generic map (n=>ntracks)
            port map (
              side1 => vlink(i*height+j-1),--north
              side2 => hlink(j*width+i),--east
              config=> config.sb_corners(2) 
            );
        end generate;
        --column i
        ci:if i > 0 and i < width generate
          e:entity work.switch_box_side
            generic map (n=>ntracks)
            port map (
              side1 => hlink(j*width+i-1), --west
              side2 => vlink(i*height+j-1),--north
              side3 => hlink(j*width+i),--east
              config=> config.sb_sides((width-1)+i-1)
            );
        end generate;
        --column n
        cn:if i=width generate
          e:entity work.switch_box_corner
            generic map (n=>ntracks)
            port map (
              side1 => hlink(j*(width-1)+i-1),--west
              side2 => vlink(i*(height-1)+j-1),--north
              config=> config.sb_corners(3) 
            );
        end generate;
      end generate;
    end generate;
  end generate;

  --generate the logic tiles
  ly: for j in 0 to height-1 generate
    lx : for i in 0 to width-1 generate
        lb:entity work.tile
            generic map (n=>ntracks, nbits=>ntracks_conf)
            port map (
              south => hlink((j+1)*width+i),
              west  => vlink(i*height+j),
              north => hlink(j*width+i),
              east  => vlink((i+1)*height+j),
              config  => config.logic(i,j),
              clock   => clock
            );  
    end generate;
  end generate;
end architecture;


