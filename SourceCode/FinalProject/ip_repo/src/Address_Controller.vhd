library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity Address_Controller is
	generic (
		video_h   : integer := 480;
		video_v   : integer := 320 
	);
	port(
		clock_i        : in std_logic; -- 100MHz
		reset_i        : in std_logic; -- pos 
		vga_hs_cnt_i   : in integer;
		vga_vs_cnt_i   : in integer;
		raddr_o        : out std_logic_vector(17 downto 0)
	);
end Address_Controller;

architecture yanxi of Address_Controller is

	signal rst        : std_logic;
	signal vga_vs_cnt : integer;
	signal vga_hs_cnt : integer;
	signal temp       : integer;
	

begin
	rst 		 <= not reset_i;
	vga_hs_cnt   <= vga_hs_cnt_i;
	vga_vs_cnt   <= vga_vs_cnt_i;
	
	raddr:process(clock_i, rst, vga_hs_cnt, vga_vs_cnt)
	begin
		if (rst = '0') then
			temp <= 0;
		elsif rising_edge(clock_i) then
		    if (vga_hs_cnt < video_h) and (vga_vs_cnt < video_v) then
			     temp <= vga_vs_cnt*video_h + vga_hs_cnt;
			end if;
		end if;
	end process;
	raddr_o <= conv_std_logic_vector(temp ,18);
	
end architecture;