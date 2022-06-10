--8CC  => 8 connected component
library IEEE;


use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sobel is
	generic (
--		b  : natural range 4 to 32 := 20;
        buf_vga_Y_cnt   : integer := 200;
		buf_vga_X_cnt   : integer := 200;
		buf_vga_Y   : integer := 200;
		buf_vga_X   : integer := 200
    );
    port(
   		clk_video  : IN  std_logic;
        rst_system : IN  std_logic;
--**
        data_video: in std_logic_vector ((8-1) downto 0);
        water      : in std_logic_vector ((3-1) downto 0);        
--**        
        image_data_enable : in  std_logic;
        cnt_h_sync_vga :in integer;
        cnt_v_sync_vga :in integer;
        buf_vga_Y_out_cnt :in integer;

        SB_data_out_vga :out std_logic_vector ((8-1) downto 0)
);
end sobel;
architecture Behavioral of sobel is
	
 
---------------------|
--SB = Sobel Buffer--|
---------------------|
type Array_Sobel_buf is array (integer range 0 to buf_vga_Y - 1) of std_logic_vector ((8-1) downto 0);
signal SB_buf_0 : Array_Sobel_buf;
signal SB_buf_0_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_buf_0_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_buf_0_data_3 : std_logic_vector((10-1) downto 0):="0000000000";

signal SB_buf_1 : Array_Sobel_buf;
signal SB_buf_1_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_buf_1_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_buf_1_data_3 : std_logic_vector((10-1) downto 0):="0000000000";

signal SB_buf_2 : Array_Sobel_buf;
signal SB_buf_2_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_buf_2_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_buf_2_data_3 : std_logic_vector((10-1) downto 0):="0000000000";

signal water_cnt : std_logic_vector((10-1) downto 0);

signal SB_XSCR : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_YSCR : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_XYSCR : std_logic_vector((10-1) downto 0):="0000000000";
signal SB_XYSCR_BUR : std_logic_vector((20-1) downto 0):="00000000000000000000";
--signal SB_data_out_vga : std_logic:='0';


component SQRT is
	Generic ( b  : natural range 4 to 32 := 20 ); 
    Port ( value  : in   STD_LOGIC_VECTOR ((20-1) downto 0);
           result : out  STD_LOGIC_VECTOR ((10-1) downto 0));
end component SQRT;	

----------|
--SB End--|
----------|
begin

process(rst_system, clk_video)

   
variable sobel_x_cc_1 : std_logic_vector(9 downto 0);
variable sobel_x_cc_2 : std_logic_vector(9 downto 0);
variable sobel_y_cc_1 : std_logic_vector(9 downto 0);
variable sobel_y_cc_2 : std_logic_vector(9 downto 0);
begin
if rst_system = '0' then

-------------------- Return to begin--------------------
	SB_buf_0_data_1 <= "0000000000";
	SB_buf_0_data_2 <= "0000000000";
	SB_buf_0_data_3 <= "0000000000";
	SB_buf_1_data_1 <= "0000000000";
	SB_buf_1_data_2 <= "0000000000";
	SB_buf_1_data_3 <= "0000000000";
	SB_buf_2_data_1 <= "0000000000";
	SB_buf_2_data_2 <= "0000000000";
	SB_buf_2_data_3 <= "0000000000";
	
-------------------- Return to begin--------------------	
	SB_XSCR <= "0000000000";
	SB_YSCR <= "0000000000";
	SB_data_out_vga <= "00000000";
-------------------- Return to begin--------------------	

elsif rising_edge(clk_video) then
		if ( cnt_h_sync_vga >= 0 and cnt_h_sync_vga < buf_vga_Y and cnt_v_sync_vga >= 0 and cnt_v_sync_vga < buf_vga_X) then
-- 01 02 03
-- 11 12 13
-- 21 22 (23)   >>(now_data)		 		    				    
					
--------------------GET IN data------------------	
						
						SB_buf_0_data_3 <= "00" & SB_buf_1(buf_vga_Y_out_cnt);
						SB_buf_0_data_2 <= SB_buf_0_data_3;
						SB_buf_0_data_1 <= SB_buf_0_data_2;

						SB_buf_1_data_3 <= "00" & SB_buf_2(buf_vga_Y_out_cnt);
						SB_buf_1_data_2 <= SB_buf_1_data_3;
					    SB_buf_1_data_1 <= SB_buf_1_data_2;

					    -----------****--data in--****---------------------------- 
					    SB_buf_2_data_3 <= "00" & data_video;
					    -----------****--data in--****----------------------------
					    SB_buf_2_data_2 <= "00" &SB_buf_2(buf_vga_Y_out_cnt + 1);
					    SB_buf_2_data_1 <= "00" &SB_buf_2(buf_vga_Y_out_cnt + 2);

	
						SB_buf_0(buf_vga_Y_out_cnt) <= SB_buf_1(buf_vga_Y_out_cnt);
						SB_buf_1(buf_vga_Y_out_cnt) <= SB_buf_2(buf_vga_Y_out_cnt);
						-----------****--data in--****----------------------------
						SB_buf_2(buf_vga_Y_out_cnt) <= data_video;
						-----------****--data in--****----------------------------
						
--------------------GET IN data------------------	
---------------------- Operation Point Weights--------------------
				sobel_x_cc_1 := SB_buf_0_data_1 + SB_buf_0_data_2 + SB_buf_0_data_2 + SB_buf_0_data_2 + SB_buf_0_data_3;				
				sobel_x_cc_2 := SB_buf_2_data_1 + SB_buf_2_data_2 + SB_buf_2_data_2 + SB_buf_2_data_2 + SB_buf_2_data_3;				
				sobel_y_cc_1 := SB_buf_0_data_1 + SB_buf_1_data_1 + SB_buf_1_data_1 + SB_buf_1_data_1 + SB_buf_2_data_1;				
				sobel_y_cc_2 := SB_buf_0_data_3 + SB_buf_1_data_3 + SB_buf_1_data_3 + SB_buf_1_data_3 + SB_buf_2_data_3;

						if sobel_x_cc_1 >= sobel_x_cc_2 then
							SB_XSCR <= sobel_x_cc_1 - sobel_x_cc_2;
						else
							SB_XSCR <= sobel_x_cc_2 - sobel_x_cc_1;
						end if;
						
						if sobel_y_cc_1 >= sobel_y_cc_2 then
							SB_YSCR <= sobel_y_cc_1 - sobel_y_cc_2;
						else
							SB_YSCR <= sobel_y_cc_2 - sobel_y_cc_1;
						end if;
---------------------- Operation Point Weights--------------------
                SB_XYSCR_BUR <=  conv_std_logic_vector((Conv_Integer(SB_YSCR)*Conv_Integer(SB_YSCR) + Conv_Integer(SB_XSCR)*Conv_Integer(SB_XSCR)), 20);
                water_cnt <= conv_std_logic_vector(Conv_Integer(WATER)*32, 10);
                --Guass_data_out_vga <= Guass_SUN(11 downto 4);
                if (water_cnt <= SB_XYSCR(7 downto 0))then
                    SB_data_out_vga <= "00000000";
                else
                    SB_data_out_vga <= "11111111";
                end if;
--				SB_data_out_vga <= SB_XYSCR(7 downto 0);
--------------------critical result------------------					    				    
				--if (SB_XYSCR > water) then				
				--	SB_data_out_vga <= '1';
				--else
				--	SB_data_out_vga <= '0';
				--end if;			    				
				--if (SB_YSCR > water or SB_XSCR > water) then				
				--	SB_data_out_vga <= '1';
				--else
				--	SB_data_out_vga <= '0';
				--end if;	
--------------------critical result------------------
		elsif image_data_enable = '0' then --range outside
-------------------- Return to begin--------------------		
			SB_buf_0_data_1 <= "0000000000";
			SB_buf_0_data_2 <= "0000000000";
			SB_buf_0_data_3 <= "0000000000";
			SB_buf_1_data_1 <= "0000000000";
			SB_buf_1_data_2 <= "0000000000";
			SB_buf_1_data_3 <= "0000000000";
			SB_buf_2_data_1 <= "0000000000";
			SB_buf_2_data_2 <= "0000000000";
			SB_buf_2_data_3 <= "0000000000";			
-------------------- Return to begin--------------------
			SB_XSCR <= "0000000000";
			SB_YSCR <= "0000000000";
			SB_data_out_vga <= "00000000";			
-------------------- Return to begin--------------------
		end if;
end if;
end process;
--Sobel-------------------------------------------------------------------------------------------------
u0:SQRT
    port map(      
        value => SB_XYSCR_BUR,     
        result => SB_XYSCR
    );
end architecture;


