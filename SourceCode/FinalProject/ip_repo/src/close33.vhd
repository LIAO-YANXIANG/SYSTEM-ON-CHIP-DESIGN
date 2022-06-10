library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity close33 is

    generic (
        buf_vga_Y_cnt   : integer := 480;
		buf_vga_X_cnt   : integer := 320;
		buf_vga_Y   : integer := 480;
		buf_vga_X   : integer := 320
    );
    port(
   		clk_video  : IN  std_logic;
        rst_system : IN  std_logic;
--**
        data_video: in std_logic_vector ((8-1) downto 0);
--**        
        image_data_enable : in  std_logic;
        cnt_h_sync_vga :in integer;
        cnt_v_sync_vga :in integer;
        buf_vga_Y_out_cnt :in integer;

        
        close_data_out_vga :out std_logic_vector ((8-1) downto 0)

        );
		  
		  
end close33;
 
architecture Behavioral of close33 is


type Array_Erosion_buf is array (integer range 0 to buf_vga_Y-1) of std_logic_vector ((8-1) downto 0);
signal Erosion_buf_0 : Array_Erosion_buf;
signal Erosion_buf_0_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal Erosion_buf_0_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal Erosion_buf_0_data_3 : std_logic_vector((10-1) downto 0):="0000000000";


signal Erosion_buf_1 : Array_Erosion_buf;
signal Erosion_buf_1_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal Erosion_buf_1_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal Erosion_buf_1_data_3 : std_logic_vector((10-1) downto 0):="0000000000";


signal Erosion_buf_2 : Array_Erosion_buf;
signal Erosion_buf_2_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal Erosion_buf_2_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal Erosion_buf_2_data_3 : std_logic_vector((10-1) downto 0):="0000000000";






signal Erosion_buf_in_data : std_logic_vector((8-1) downto 0):="00000000";
signal Erosion_buf_cnt : integer range 0 to buf_vga_Y-1:=0;
signal Erosion_buf_cnt_max : integer range 0 to buf_vga_Y-1:=buf_vga_Y-1; --0~buf_vga_Y-1(799)

signal Erosion_SUN : std_logic_vector((10-1) downto 0):="0000000000";

signal Erosion_data_out_vga : std_logic_vector((8-1) downto 0):="00000000";
----------|
--Erosion End--|
----------|
---------------------|
--Dilation  Buffer--|
---------------------|
type Array_Dilation_buf is array (integer range 0 to 639) of std_logic_vector ((8-1) downto 0);
signal Dilation_buf_0 : Array_Dilation_buf;
signal Dilation_buf_0_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal Dilation_buf_0_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal Dilation_buf_0_data_3 : std_logic_vector((10-1) downto 0):="0000000000";


signal Dilation_buf_1 : Array_Dilation_buf;
signal Dilation_buf_1_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal Dilation_buf_1_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal Dilation_buf_1_data_3 : std_logic_vector((10-1) downto 0):="0000000000";


signal Dilation_buf_2 : Array_Dilation_buf;
signal Dilation_buf_2_data_1 : std_logic_vector((10-1) downto 0):="0000000000";
signal Dilation_buf_2_data_2 : std_logic_vector((10-1) downto 0):="0000000000";
signal Dilation_buf_2_data_3 : std_logic_vector((10-1) downto 0):="0000000000";




signal Dilation_buf_in_data : std_logic_vector((8-1) downto 0):="00000000";
signal Dilation_buf_cnt : integer range 0 to buf_vga_Y-1:=0;
signal Dilation_buf_cnt_max : integer range 0 to buf_vga_Y-1:=buf_vga_Y-1; --0~buf_vga_Y-1(799)

signal Dilation_SUN : std_logic_vector((10-1) downto 0):="0000000000";

signal Dilation_data_out_vga : std_logic:='0';
----------|
--Dilation End--|
----------|

begin

close_data_out_vga <= Erosion_data_out_vga ;




--Erosion-----------------------------------------------
process(rst_system, clk_video)
begin
if rst_system = '0' then
-------------------- Return to begin--------------------
	Erosion_buf_0_data_1 <= "0000000000";
	Erosion_buf_0_data_2 <= "0000000000";
	Erosion_buf_0_data_3 <= "0000000000";
		
	Erosion_buf_1_data_1 <= "0000000000";
	Erosion_buf_1_data_2 <= "0000000000";
	Erosion_buf_1_data_3 <= "0000000000";
	
	Erosion_buf_2_data_1 <= "0000000000";
	Erosion_buf_2_data_2 <= "0000000000";
	Erosion_buf_2_data_3 <= "0000000000";
	
-------------------- Return to begin--------------------	
	Erosion_SUN <= "0000000000";
	
	Erosion_data_out_vga <= "00000000";
-------------------- Return to begin--------------------	

elsif rising_edge(clk_video) then
		if ( cnt_h_sync_vga >= 0 and cnt_h_sync_vga < buf_vga_Y and cnt_v_sync_vga >= 0 and cnt_v_sync_vga < buf_vga_X) then
-- 01 02 03
-- 11 12 13
-- 21 22 (23)   >>(now_data)		 		    				    
					
--------------------GET IN data------------------	
						
						Erosion_buf_0_data_3 <= "00" & Erosion_buf_1(buf_vga_Y_out_cnt);
						Erosion_buf_0_data_2 <= Erosion_buf_0_data_3;
						Erosion_buf_0_data_1 <= Erosion_buf_0_data_2;

						Erosion_buf_1_data_3 <= "00" & Erosion_buf_2(buf_vga_Y_out_cnt);
						Erosion_buf_1_data_2 <= Erosion_buf_1_data_3;
					    Erosion_buf_1_data_1 <= Erosion_buf_1_data_2;

					    -----------****--data in--****---------------------------- 
					    Erosion_buf_2_data_3 <= "00"&  "0000000" & Dilation_data_out_vga;
					    -----------****--data in--****----------------------------
					    Erosion_buf_2_data_2 <= "00" &Erosion_buf_2(buf_vga_Y_out_cnt + 1);
					    Erosion_buf_2_data_1 <= "00" &Erosion_buf_2(buf_vga_Y_out_cnt + 2);

	
						Erosion_buf_0(buf_vga_Y_out_cnt) <= Erosion_buf_1(buf_vga_Y_out_cnt);
						Erosion_buf_1(buf_vga_Y_out_cnt) <= Erosion_buf_2(buf_vga_Y_out_cnt);
						-----------****--data in--****----------------------------
						Erosion_buf_2(buf_vga_Y_out_cnt) <= "0000000" & Dilation_data_out_vga;
						-----------****--data in--****----------------------------
						
--------------------GET IN data------------------	
---------------------- Operation Point Weights--------------------
Erosion_SUN <=      Erosion_buf_0_data_1 + Erosion_buf_0_data_2 + Erosion_buf_0_data_3+
					Erosion_buf_1_data_1 + Erosion_buf_1_data_2 + Erosion_buf_1_data_3+
					Erosion_buf_2_data_1 + Erosion_buf_2_data_2 + Erosion_buf_2_data_3;			
---------------------- Operation Point Weights--------------------

--------------------critical result------------------					    				    
					if Erosion_SUN > "0000001000"  then
						Erosion_data_out_vga <= "11111111";
					else
						Erosion_data_out_vga <= "00000000";
					end if;		    				
--------------------critical result------------------
		elsif image_data_enable = '0' then --range outside
-------------------- Return to begin--------------------		
	Erosion_buf_0_data_1 <= "0000000000";
	Erosion_buf_0_data_2 <= "0000000000";
	Erosion_buf_0_data_3 <= "0000000000";
		
	Erosion_buf_1_data_1 <= "0000000000";
	Erosion_buf_1_data_2 <= "0000000000";
	Erosion_buf_1_data_3 <= "0000000000";
	
	Erosion_buf_2_data_1 <= "0000000000";
	Erosion_buf_2_data_2 <= "0000000000";
	Erosion_buf_2_data_3 <= "0000000000";			
-------------------- Return to begin--------------------
	Erosion_SUN <= "0000000000";
	
	Erosion_data_out_vga <= "00000000";		
-------------------- Return to begin--------------------
		end if;
end if;
end process;
--Erosion-----------------------------------------------

--Dilation-----------------------------------------------
process(rst_system, clk_video)
begin
if rst_system = '0' then
-------------------- Return to begin--------------------
	Dilation_buf_0_data_1 <= "0000000000";
	Dilation_buf_0_data_2 <= "0000000000";
	Dilation_buf_0_data_3 <= "0000000000";
	Dilation_buf_1_data_1 <= "0000000000";
	Dilation_buf_1_data_2 <= "0000000000";
	Dilation_buf_1_data_3 <= "0000000000";
	Dilation_buf_2_data_1 <= "0000000000";
	Dilation_buf_2_data_2 <= "0000000000";
	Dilation_buf_2_data_3 <= "0000000000";
	
-------------------- Return to begin--------------------	
	Dilation_SUN <= "0000000000";
	
	Dilation_data_out_vga <= '0';
-------------------- Return to begin--------------------	

elsif rising_edge(clk_video) then
		if ( cnt_h_sync_vga >= 0 and cnt_h_sync_vga < buf_vga_Y and cnt_v_sync_vga >= 0 and cnt_v_sync_vga < buf_vga_X) then
-- 01 02 03
-- 11 12 13
-- 21 22 (23)   >>(now_data)		 		    				    
					
--------------------GET IN data------------------	
						
						Dilation_buf_0_data_3 <= "00" & Dilation_buf_1(buf_vga_Y_out_cnt);
						Dilation_buf_0_data_2 <= Dilation_buf_0_data_3;
						Dilation_buf_0_data_1 <= Dilation_buf_0_data_2;

						Dilation_buf_1_data_3 <= "00" & Dilation_buf_2(buf_vga_Y_out_cnt);
						Dilation_buf_1_data_2 <= Dilation_buf_1_data_3;
					    Dilation_buf_1_data_1 <= Dilation_buf_1_data_2;

					    -----------****--data in--****---------------------------- 
					    Dilation_buf_2_data_3 <= "00" & "0000000"&data_video(0);
					    -----------****--data in--****----------------------------
					    Dilation_buf_2_data_2 <= "00" &Dilation_buf_2(buf_vga_Y_out_cnt + 1);
					    Dilation_buf_2_data_1 <= "00" &Dilation_buf_2(buf_vga_Y_out_cnt + 2);

	
						Dilation_buf_0(buf_vga_Y_out_cnt) <= Dilation_buf_1(buf_vga_Y_out_cnt);
						Dilation_buf_1(buf_vga_Y_out_cnt) <= Dilation_buf_2(buf_vga_Y_out_cnt);
						-----------****--data in--****----------------------------
						Dilation_buf_2(buf_vga_Y_out_cnt) <= "0000000"&data_video(0);
						-----------****--data in--****----------------------------
						
--------------------GET IN data------------------	
---------------------- Operation Point Weights--------------------
Dilation_SUN <=      Dilation_buf_0_data_1 + Dilation_buf_0_data_2 + Dilation_buf_0_data_3+
					Dilation_buf_1_data_1 + Dilation_buf_1_data_2 + Dilation_buf_1_data_3+
					Dilation_buf_2_data_1 + Dilation_buf_2_data_2 + Dilation_buf_2_data_3;
				
---------------------- Operation Point Weights--------------------

--------------------critical result------------------					    				    
					if Dilation_SUN >= "0000000001"  then
						Dilation_data_out_vga <= '1';
					else
						Dilation_data_out_vga <= '0';
					end if;		    				
--------------------critical result------------------
		elsif image_data_enable = '0' then --range outside
-------------------- Return to begin--------------------		
	Dilation_buf_0_data_1 <= "0000000000";
	Dilation_buf_0_data_2 <= "0000000000";
	Dilation_buf_0_data_3 <= "0000000000";
		
	Dilation_buf_1_data_1 <= "0000000000";
	Dilation_buf_1_data_2 <= "0000000000";
	Dilation_buf_1_data_3 <= "0000000000";
	
	Dilation_buf_2_data_1 <= "0000000000";
	Dilation_buf_2_data_2 <= "0000000000";
	Dilation_buf_2_data_3 <= "0000000000";			
-------------------- Return to begin--------------------
	Dilation_SUN <= "0000000000";
	
	Dilation_data_out_vga <= '0';		
-------------------- Return to begin--------------------
		end if;
end if;
end process;
--Dilation-----------------------------------------------

end architecture;