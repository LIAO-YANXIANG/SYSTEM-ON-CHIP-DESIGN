library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity video_out is
	generic (
			video_h     : integer := 800 ;
			video_v     : integer := 600 ;
			P_video_h   : integer := 480;
			P_video_v   : integer := 320
		);
	port(
		clock_i        : in std_logic; -- 100MHz
		reset_i        : in std_logic; -- pos 
	    mode           : in  std_logic_vector(2 downto 0);
	    
	    Orignal_data_i    : in  std_logic_vector(7 downto 0);
	    ThrdTarget_data_i  : in  std_logic_vector(7 downto 0);
		SB_data_i         : in  std_logic_vector(7 downto 0);
		Close_data_i      : in  std_logic_vector(7 downto 0);
		CCL_data_i       : in  std_logic_vector(7 downto 0);
		
		enable_o       : out std_logic;
		Rout_o         : out std_logic_vector(3 downto 0);
		Gout_o         : out std_logic_vector(3 downto 0);
		Bout_o         : out std_logic_vector(3 downto 0);	
		vga_hs_cnt_o   : out integer;
		vga_vs_cnt_o   : out integer;
		hsync_o        : out std_logic;
		vsync_o        : out std_logic
	);
end video_out;

architecture yanxi of video_out is

	signal rst         		: std_logic ;
	signal video_start_en_s : std_logic ;

	component vga   
		generic (
			horizontal_resolution : integer :=1280 ;
			horizontal_Front_porch: integer :=  48 ;
			horizontal_Sync_pulse : integer := 112 ;
			horizontal_Back_porch : integer := 248 ;
			h_sync_Polarity       : std_logic:= '1';
			vertical_resolution   : integer :=1024 ;
			vertical_Front_porch  : integer :=   1 ;
			vertical_Sync_pulse   : integer :=   3 ;
			vertical_Back_porch   : integer :=  38 ;
			v_sync_Polarity       : std_logic:= '1' 
		);
		port(
			clk 			: in std_logic;
			rst 			: in std_logic;
			video_start_en 	: in std_logic;
			vga_hs_cnt 		: out integer;
			vga_vs_cnt 		: out integer;
			hsync 			: out std_logic;
			vsync 			: out std_logic
		);
	end component;
	signal CLK50MHz   : std_logic;
	signal vga_vs_cnt : integer ;
	signal vga_hs_cnt : integer ;
	

begin
	rst 		 <= not reset_i;
	vga_hs_cnt_o <= vga_hs_cnt;
	vga_vs_cnt_o <= vga_vs_cnt;
------------------------------vga---------------------------
	vga_1 :vga  
	generic map(
		horizontal_resolution  => 800,
        horizontal_Front_porch => 56,
        horizontal_Sync_pulse  => 120,
        horizontal_Back_porch  => 64,
        h_sync_Polarity        => '1',
        vertical_resolution    => 600,
        vertical_Front_porch   => 37,
        vertical_Sync_pulse    => 6,
        vertical_Back_porch    => 23,
        v_sync_Polarity        => '1'
	)
	port map( 
		clk 			    => CLK50MHz,
        rst 			    => rst,
        video_start_en 	=> '1',
        vga_hs_cnt 		=> vga_hs_cnt,
        vga_vs_cnt 		=> vga_vs_cnt,
        hsync 			=> hsync_o,
        vsync 			=> vsync_o
	);

------------------------------vga out ª¬ºA¾÷°Ê§@-------------------------
	Display_Area:process(CLK50MHz, rst, vga_hs_cnt, vga_vs_cnt)
	begin
		if (rst = '0') then
		    enable_o <= '0';
			Rout_o <= (others=>'0');
			Gout_o <= (others=>'0');
			Bout_o <= (others=>'0');
		elsif rising_edge(CLK50MHz) then
			if (vga_hs_cnt < video_h  and vga_vs_cnt < video_v ) then
			    if (vga_hs_cnt < P_video_h) and (vga_vs_cnt < P_video_v) then
			        enable_o <= '1';
			        if (mode = "000") then
			             Rout_o <= Orignal_data_i(7 downto 4);
                        Gout_o <= Orignal_data_i(7 downto 4);
                        Bout_o <= Orignal_data_i(7 downto 4);
			        elsif (mode = "001") then
			             Rout_o <= ThrdTarget_data_i(7 downto 4);
                        Gout_o <= ThrdTarget_data_i(7 downto 4);
                        Bout_o <= ThrdTarget_data_i(7 downto 4);
			        elsif (mode = "010") then
			             Rout_o <= SB_data_i(7 downto 4);
                        Gout_o <= SB_data_i(7 downto 4);
                        Bout_o <= SB_data_i(7 downto 4);
			        elsif (mode = "011") then
			             Rout_o <= Close_data_i(7 downto 4);
                        Gout_o <= Close_data_i(7 downto 4);
                        Bout_o <= Close_data_i(7 downto 4);
			        elsif (mode = "100") then
		               Rout_o <= CCL_data_i(7 downto 4);
                        Gout_o <= CCL_data_i(7 downto 4);
                        Bout_o <= CCL_data_i(7 downto 4);
                    else
                        Rout_o <= (others=>'0');
                        Gout_o <= (others=>'0');
                        Bout_o <= (others=>'0');
                    end if;
                else
                    enable_o <= '0';
                    Rout_o <= (others=>'0');
                    Gout_o <= (others=>'0');
                    Bout_o <= (others=>'0');
                end if;
			else
			    enable_o <= '0';
				Rout_o <= (others=>'0');
				Gout_o <= (others=>'0');
				Bout_o <= (others=>'0');
			end if;	
		end if;
	end process;
	
------------------------------DIV_CLK 50M-------------------------	
	DIV_CLK:process(clock_i, rst)
	begin
		if (rst = '0') then
			CLK50MHz <= '0';
		elsif (clock_i 'event and clock_i = '1') then
			CLK50MHz <= not CLK50MHz;
		end if;
	 end process;
	  
end architecture;