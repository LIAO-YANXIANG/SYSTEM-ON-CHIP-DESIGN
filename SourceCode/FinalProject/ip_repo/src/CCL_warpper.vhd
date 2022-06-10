
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CCL_warpper is
    generic 
    (
        image_size       : integer :=200*200 ;--video_h*video_v
        video_h          : integer :=200;--解析度
        video_v          : integer :=200;--解析度
        iterated         : integer := 40;
        labeling_bits    : integer := 16
    );
            
    port(
        reset_i        : in std_logic;
        clock_i        : in std_logic;
        enable_i       : in std_logic;
        vga_hs_cnt_i   : in integer;
        vga_vs_cnt_i   : in integer;
        data_in        : in std_logic_vector(7 downto 0);
        data_out       : out std_logic_vector(7 downto 0);
        valid_o        : out std_logic
        
    );
end CCL_warpper;

architecture behavioral of CCL_warpper is
    -------------------------------------------------------------------------------------
    signal rst         : std_logic;
    signal fun_ena     : std_logic;
    signal waddr_temp  : integer ;
    signal raddr_temp  : integer ;
    signal valid_wire  : std_logic;
    -------------------------------------------------------------------------------------
    component out_ram is
    generic (
        data_depth : integer    :=  image_size;
        data_bits  : integer    :=  labeling_bits
    );
    port
    (
        wclk  : in std_logic;
        wen   : in std_logic;
        waddr : in integer range 0 to data_depth-1;
        wdata : in std_logic_vector(data_bits-1 downto 0);
        rclk  : in std_logic;
        raddr : in integer range 0 to data_depth-1;
        rdata :out std_logic_vector(data_bits-1 downto 0)
    );
    end component;
    -------------------------------------------------------------------------------------  
    component B_ram
    generic (
        data_depth : integer    :=  image_size;
        data_bits  : integer    :=  1
    );
    port
    (
        wclk  : in std_logic;
        wen   : in std_logic;
        waddr : in integer range 0 to data_depth-1;
        wdata : in std_logic_vector(data_bits-1 downto 0);
        rclk  : in std_logic;
        raddr : in integer range 0 to data_depth-1;
        rdata :out std_logic_vector(data_bits-1 downto 0)
    );
    end component;
    signal bin_ram_cnt     : integer range 0 to image_size-1;     
    signal bin_ram_cnt_reg : integer range 0 to image_size-1;     
    signal bin_ram_wd      : std_logic;     
    signal bin_ram_wen     : std_logic;     
    -------------------------------------------------------------------------------------
    component inram_labeling_2_pass
    generic(
        video_h          : integer :=  video_h;
        video_v          : integer :=  video_v;
        iterated         : integer :=    2;
        labeling_bits    : integer :=    labeling_bits
    );
    port(
        rst                 : in std_logic;
        ena                 : in std_logic;
        clk                 : in std_logic;
        labeling_start      : in std_logic;
        ----video_in----    
        ram_video_clk       :out std_logic;
        ram_video_addr      :out integer;
        ram_video_in        : in std_logic;
        ----pass1_ram
        pass1_ram_wclk      :out std_logic;
        pass1_ram_wen       :out std_logic;
        pass1_ram_waddr     :out integer;
        pass1_ram_wd        :out std_logic_vector(labeling_bits - 1 downto 0);
        pass1_ram_rclk      :out std_logic;
        pass1_ram_raddr     :out integer;
        pass1_ram_rd        : in std_logic_vector(labeling_bits - 1 downto 0);
        ----table_ram
        table_ram_wclk      :out std_logic;
        table_ram_wen       :out std_logic;
        table_ram_waddr     :out std_logic_vector(labeling_bits - 1 downto 0);
        table_ram_wd        :out std_logic_vector(labeling_bits - 1 downto 0);
        table_ram_rclk      :out std_logic;
        table_ram_raddr     :out std_logic_vector(labeling_bits - 1 downto 0);
        table_ram_rd        : in std_logic_vector(labeling_bits - 1 downto 0);
        ----labeling_use----
        labeling_use        :out integer;
        labeling_error      :out std_logic;
        labeling_grous      :out integer;
        ----labeling_out----
        ram_labeling_clk    :out std_logic;
        ram_labeling_wen    :out std_logic;
        ram_labeling_waddr  :out integer;
        ram_labeling_wd     :out std_logic_vector(labeling_bits - 1 downto 0);
        valid               :out std_logic
    );
    end component;
    signal labeling_start      : std_logic;
    signal ram_video_clk       : std_logic;
    signal ram_video_addr      : integer;
    signal ram_video_in        : std_logic;
    signal pass1_ram_wclk      : std_logic;
    signal pass1_ram_wen       : std_logic;
    signal pass1_ram_waddr     : integer;
    signal pass1_ram_wd        : std_logic_vector(labeling_bits - 1 downto 0);
    signal pass1_ram_rclk      : std_logic;
    signal pass1_ram_raddr     : integer;
    signal pass1_ram_rd        : std_logic_vector(labeling_bits - 1 downto 0);
    signal table_ram_wclk      : std_logic;
    signal table_ram_wen       : std_logic;
    signal table_ram_waddr     : std_logic_vector(labeling_bits - 1 downto 0);
    signal table_ram_wd        : std_logic_vector(labeling_bits - 1 downto 0);
    signal table_ram_rclk      : std_logic;
    signal table_ram_raddr     : std_logic_vector(labeling_bits - 1 downto 0);
    signal table_ram_rd        : std_logic_vector(labeling_bits - 1 downto 0);
    signal labeling_use        : integer;
    signal labeling_error      : std_logic;
    signal labeling_grous      : integer;
    signal ram_labeling_clk    : std_logic;
    signal ram_labeling_wen    : std_logic;
    signal ram_labeling_waddr  : integer;
    signal ram_labeling_wd     : std_logic_vector(labeling_bits - 1 downto 0);
--///////////////////////////////////////////////////////////////////////////////////// 
begin
    rst 		<= not reset_i;
    fun_ena     <= enable_i;
    valid_o     <= valid_wire and clock_i;
    data_out    <= ram_labeling_wd(7 downto 0);
    -------------------------------------------- 
    IMP_ram_0 : B_ram
    generic map (
        data_depth => video_h*video_v,
        data_bits  => 1
    )
    port map (
        wclk     => clock_i  ,
        wen      => '1',
        waddr    => waddr_temp,
        wdata(0) => data_in(0) ,
        rclk     => ram_video_clk ,
        raddr    => raddr_temp,
        rdata(0) => ram_video_in 
    );
    waddr_temp <= vga_vs_cnt_i*video_h + vga_hs_cnt_i;
    raddr_temp <= (ram_video_addr mod video_h)*2 + (ram_video_addr / video_h)*2*video_h;
    -------------------------------------------- 
    table_ram_0 : out_ram
    generic map(
        data_depth  =>  video_h*video_v ,
        data_bits   =>  labeling_bits
    )
    port map (
        wclk  => table_ram_wclk      ,
        wen   => table_ram_wen       ,
        waddr => conv_integer(table_ram_waddr)     ,
        wdata  => table_ram_wd        ,
        rclk  => table_ram_rclk      ,
        raddr => conv_integer(table_ram_raddr)     ,
        rdata => table_ram_rd        
    );  
    -------------------------------------------- 
    pass_ram_0 : out_ram
    generic map(
        data_depth  =>  video_h*video_v ,
        data_bits   =>  labeling_bits
    )
    port map (
        wclk  => pass1_ram_wclk ,
        wen   => pass1_ram_wen  ,
        waddr => pass1_ram_waddr,
        wdata => pass1_ram_wd   ,
        rclk  => pass1_ram_rclk ,
        raddr => pass1_ram_raddr,
        rdata => pass1_ram_rd   
    );  
    -------------------------------------------- 
    inram_labeling_2_pass_1: inram_labeling_2_pass
    generic map(
        video_h      => video_h,
        video_v      => video_v,
        iterated     => iterated,
        labeling_bits=> labeling_bits
    )
    port map(
        rst                 => rst                ,
        ena                 => fun_ena            ,
        clk                 => clock_i              ,
        labeling_start      => labeling_start     ,
        ----video_in----    => ----video_in----    ,
        ram_video_clk       => ram_video_clk       ,
        ram_video_addr      => ram_video_addr      ,
        ram_video_in        => ram_video_in        ,
        ----pass1_ram=>reset   =>----pass1_ram       
        pass1_ram_wclk      => pass1_ram_wclk      ,
        pass1_ram_wen       => pass1_ram_wen       ,
        pass1_ram_waddr     => pass1_ram_waddr     ,
        pass1_ram_wd        => pass1_ram_wd        ,
        pass1_ram_rclk      => pass1_ram_rclk      ,
        pass1_ram_raddr     => pass1_ram_raddr     ,
        pass1_ram_rd        => pass1_ram_rd        ,
        ----table_ram=>reset   =>----table_ram       
        table_ram_wclk      => table_ram_wclk      ,
        table_ram_wen       => table_ram_wen       ,
        table_ram_waddr     => table_ram_waddr     ,
        table_ram_wd        => table_ram_wd        ,
        table_ram_rclk      => table_ram_rclk      ,
        table_ram_raddr     => table_ram_raddr     ,
        table_ram_rd        => table_ram_rd        ,
        ----labeling_use----=> ----labeling_use----,
        labeling_use        => labeling_use        ,
        labeling_error      => labeling_error      ,
        labeling_grous      => labeling_grous      ,
        ----labeling_out----=> ----labeling_out----,
        ram_labeling_clk    => ram_labeling_clk    ,
        ram_labeling_wen    => ram_labeling_wen    ,
        ram_labeling_waddr  => ram_labeling_waddr  ,
        ram_labeling_wd     => ram_labeling_wd     ,
        ----valid_o----
        valid               => valid_wire
    );
    -------------------------------------------- 
    labeling_star_0t:process(clock_i, rst)
    begin
        if (rst = '0') then
            labeling_start<='0';
        elsif rising_edge(clock_i) then
            if (vga_hs_cnt_i = 0) and (vga_vs_cnt_i = 0) then
                labeling_start<='1';
            else
                labeling_start<='0';
            end if;
        end if;
    end process;
    -------------------------------------------- 

end architecture;