library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity Address_Controller is
	generic (
		video_h   : integer := 200;
		video_v   : integer := 200 
	);
	port(
		clock_i        : in std_logic; -- 100MHz
		reset_0_i        : in std_logic; 
		vga_hs_cnt_i   : in integer;
		vga_vs_cnt_i   : in integer;
		raddr_o        : out std_logic_vector(15 downto 0)
	);
end Address_Controller;

architecture yanxi of Address_Controller is

	signal vga_vs_cnt : integer;
	signal vga_hs_cnt : integer;
	signal temp       : integer;
	

begin
	vga_hs_cnt   <= vga_hs_cnt_i;
	vga_vs_cnt   <= vga_vs_cnt_i;
	
	raddr:process(clock_i, reset_0_i, vga_hs_cnt, vga_vs_cnt)
	begin
		if (reset_0_i = '0') then
			temp <= 0;
		elsif rising_edge(clock_i) then
		    if (vga_hs_cnt < video_h) and (vga_vs_cnt < video_v) then
			     temp <= vga_vs_cnt*video_h + vga_hs_cnt;
			end if;
		end if;
	end process;
	raddr_o <= conv_std_logic_vector(temp ,16);
	
end architecture;