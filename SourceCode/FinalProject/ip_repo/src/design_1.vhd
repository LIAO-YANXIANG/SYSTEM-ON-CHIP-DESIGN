--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
--Date        : Wed Jun  8 13:22:24 2022
--Host        : LAPTOP-34RLFJ84 running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    Bout_o_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Gout_o_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Rout_o_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clock_i_0 : in STD_LOGIC;
    hsync_o_0 : out STD_LOGIC;
    mode_0 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    reset_i_0 : in STD_LOGIC;
    vsync_o_0 : out STD_LOGIC;
    water_0 : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=10,numReposBlks=10,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=6,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=4,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_blk_mem_gen_0_0 is
  port (
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 15 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1_blk_mem_gen_0_0;
  component design_1_util_vector_logic_0_0 is
  port (
    Op1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    Res : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_util_vector_logic_0_0;
  component design_1_Thrd_target_0_0 is
  port (
    clock_i : in STD_LOGIC;
    reset_i : in STD_LOGIC;
    data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    data_o : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1_Thrd_target_0_0;
  component design_1_Address_Controller_0_0 is
  port (
    clock_i : in STD_LOGIC;
    reset_i : in STD_LOGIC;
    vga_hs_cnt_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    vga_vs_cnt_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    raddr_o : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component design_1_Address_Controller_0_0;
  component design_1_video_out_0_0 is
  port (
    clock_i : in STD_LOGIC;
    reset_i : in STD_LOGIC;
    mode : in STD_LOGIC_VECTOR ( 2 downto 0 );
    Orignal_data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ThrdTarget_data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    SB_data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Close_data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    CCL_data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    enable_o : out STD_LOGIC;
    Rout_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Gout_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Bout_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    vga_hs_cnt_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    vga_vs_cnt_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    hsync_o : out STD_LOGIC;
    vsync_o : out STD_LOGIC
  );
  end component design_1_video_out_0_0;
  component design_1_util_vector_logic_0_2 is
  port (
    Op1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Res : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1_util_vector_logic_0_2;
  component design_1_close33_0_0 is
  port (
    clk_video : in STD_LOGIC;
    rst_system : in STD_LOGIC;
    data_video : in STD_LOGIC_VECTOR ( 7 downto 0 );
    image_data_enable : in STD_LOGIC;
    cnt_h_sync_vga : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cnt_v_sync_vga : in STD_LOGIC_VECTOR ( 31 downto 0 );
    buf_vga_Y_out_cnt : in STD_LOGIC_VECTOR ( 31 downto 0 );
    close_data_out_vga : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1_close33_0_0;
  component design_1_ila_0_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_ila_0_0;
  component design_1_CCL_warpper_0_0 is
  port (
    reset_i : in STD_LOGIC;
    clock_i : in STD_LOGIC;
    enable_i : in STD_LOGIC;
    vga_hs_cnt_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    vga_vs_cnt_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    data_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    data_out : out STD_LOGIC_VECTOR ( 7 downto 0 );
    valid_o : out STD_LOGIC
  );
  end component design_1_CCL_warpper_0_0;
  component design_1_sobel_0_0 is
  port (
    clk_video : in STD_LOGIC;
    rst_system : in STD_LOGIC;
    data_video : in STD_LOGIC_VECTOR ( 7 downto 0 );
    water : in STD_LOGIC_VECTOR ( 2 downto 0 );
    image_data_enable : in STD_LOGIC;
    cnt_h_sync_vga : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cnt_v_sync_vga : in STD_LOGIC_VECTOR ( 31 downto 0 );
    buf_vga_Y_out_cnt : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SB_data_out_vga : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1_sobel_0_0;
  signal Address_Controller_0_raddr_o : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal CCL_warpper_0_data_out : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute DEBUG : string;
  attribute DEBUG of CCL_warpper_0_data_out : signal is "true";
  attribute MARK_DEBUG : boolean;
  attribute MARK_DEBUG of CCL_warpper_0_data_out : signal is std.standard.true;
  signal CCL_warpper_0_valid_o : STD_LOGIC;
  signal Net : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute DEBUG of Net : signal is "true";
  attribute MARK_DEBUG of Net : signal is std.standard.true;
  signal Net1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute DEBUG of Net1 : signal is "true";
  attribute MARK_DEBUG of Net1 : signal is std.standard.true;
  signal Thrd_target_0_data_o : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal blk_mem_gen_0_douta : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal clock_i_0_1 : STD_LOGIC;
  signal mode_0_1 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal reset_i_0_1 : STD_LOGIC;
  signal sobel_0_SB_data_out_vga : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal util_vector_logic_0_Res : STD_LOGIC_VECTOR ( 0 to 0 );
  signal util_vector_logic_1_Res : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute DEBUG of util_vector_logic_1_Res : signal is "true";
  attribute MARK_DEBUG of util_vector_logic_1_Res : signal is std.standard.true;
  signal util_vector_logic_2_Res : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute DEBUG of util_vector_logic_2_Res : signal is "true";
  attribute MARK_DEBUG of util_vector_logic_2_Res : signal is std.standard.true;
  signal video_out_0_Bout_o : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal video_out_0_Gout_o : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal video_out_0_Rout_o : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal video_out_0_enable_o : STD_LOGIC;
  signal video_out_0_hsync_o : STD_LOGIC;
  signal video_out_0_vsync_o : STD_LOGIC;
  signal water_0_1 : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clock_i_0 : signal is "xilinx.com:signal:clock:1.0 CLK.CLOCK_I_0 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clock_i_0 : signal is "XIL_INTERFACENAME CLK.CLOCK_I_0, ASSOCIATED_RESET reset_i_0, CLK_DOMAIN design_1_clock_i_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000";
  attribute X_INTERFACE_INFO of reset_i_0 : signal is "xilinx.com:signal:reset:1.0 RST.RESET_I_0 RST";
  attribute X_INTERFACE_PARAMETER of reset_i_0 : signal is "XIL_INTERFACENAME RST.RESET_I_0, INSERT_VIP 0, POLARITY ACTIVE_LOW";
begin
  Bout_o_0(3 downto 0) <= video_out_0_Bout_o(3 downto 0);
  Gout_o_0(3 downto 0) <= video_out_0_Gout_o(3 downto 0);
  Rout_o_0(3 downto 0) <= video_out_0_Rout_o(3 downto 0);
  clock_i_0_1 <= clock_i_0;
  hsync_o_0 <= video_out_0_hsync_o;
  mode_0_1(2 downto 0) <= mode_0(2 downto 0);
  reset_i_0_1 <= reset_i_0;
  vsync_o_0 <= video_out_0_vsync_o;
  water_0_1(2 downto 0) <= water_0(2 downto 0);
Address_Controller_0: component design_1_Address_Controller_0_0
     port map (
      clock_i => clock_i_0_1,
      raddr_o(17 downto 0) => Address_Controller_0_raddr_o(17 downto 0),
      reset_i => reset_i_0_1,
      vga_hs_cnt_i(31 downto 0) => Net(31 downto 0),
      vga_vs_cnt_i(31 downto 0) => Net1(31 downto 0)
    );
CCL_warpper_0: component design_1_CCL_warpper_0_0
     port map (
      clock_i => clock_i_0_1,
      data_in(7 downto 0) => util_vector_logic_1_Res(7 downto 0),
      data_out(7 downto 0) => CCL_warpper_0_data_out(7 downto 0),
      enable_i => video_out_0_enable_o,
      reset_i => reset_i_0_1,
      valid_o => CCL_warpper_0_valid_o,
      vga_hs_cnt_i(31 downto 0) => Net(31 downto 0),
      vga_vs_cnt_i(31 downto 0) => Net1(31 downto 0)
    );
Thrd_target_0: component design_1_Thrd_target_0_0
     port map (
      clock_i => clock_i_0_1,
      data_i(7 downto 0) => blk_mem_gen_0_douta(7 downto 0),
      data_o(7 downto 0) => Thrd_target_0_data_o(7 downto 0),
      reset_i => reset_i_0_1
    );
blk_mem_gen_0: component design_1_blk_mem_gen_0_0
     port map (
      addra(15 downto 0) => Address_Controller_0_raddr_o(15 downto 0),
      clka => clock_i_0_1,
      douta(7 downto 0) => blk_mem_gen_0_douta(7 downto 0)
    );
close33_0: component design_1_close33_0_0
     port map (
      buf_vga_Y_out_cnt(31 downto 0) => Net(31 downto 0),
      clk_video => clock_i_0_1,
      close_data_out_vga(7 downto 0) => util_vector_logic_1_Res(7 downto 0),
      cnt_h_sync_vga(31 downto 0) => Net(31 downto 0),
      cnt_v_sync_vga(31 downto 0) => Net1(31 downto 0),
      data_video(7 downto 0) => util_vector_logic_2_Res(7 downto 0),
      image_data_enable => video_out_0_enable_o,
      rst_system => util_vector_logic_0_Res(0)
    );
ila_0: component design_1_ila_0_0
     port map (
      clk => clock_i_0_1,
      probe0(7 downto 0) => util_vector_logic_2_Res(7 downto 0),
      probe1(7 downto 0) => util_vector_logic_1_Res(7 downto 0),
      probe2(7 downto 0) => CCL_warpper_0_data_out(7 downto 0),
      probe3(31 downto 0) => Net(31 downto 0),
      probe4(31 downto 0) => Net1(31 downto 0),
      probe5(0) => CCL_warpper_0_valid_o
    );
sobel_0: component design_1_sobel_0_0
     port map (
      SB_data_out_vga(7 downto 0) => sobel_0_SB_data_out_vga(7 downto 0),
      buf_vga_Y_out_cnt(31 downto 0) => Net(31 downto 0),
      clk_video => clock_i_0_1,
      cnt_h_sync_vga(31 downto 0) => Net(31 downto 0),
      cnt_v_sync_vga(31 downto 0) => Net1(31 downto 0),
      data_video(7 downto 0) => Thrd_target_0_data_o(7 downto 0),
      image_data_enable => video_out_0_enable_o,
      rst_system => util_vector_logic_0_Res(0),
      water(2 downto 0) => water_0_1(2 downto 0)
    );
util_vector_logic_0: component design_1_util_vector_logic_0_0
     port map (
      Op1(0) => reset_i_0_1,
      Res(0) => util_vector_logic_0_Res(0)
    );
util_vector_logic_2: component design_1_util_vector_logic_0_2
     port map (
      Op1(7 downto 0) => sobel_0_SB_data_out_vga(7 downto 0),
      Res(7 downto 0) => util_vector_logic_2_Res(7 downto 0)
    );
video_out_0: component design_1_video_out_0_0
     port map (
      Bout_o(3 downto 0) => video_out_0_Bout_o(3 downto 0),
      CCL_data_i(7 downto 0) => CCL_warpper_0_data_out(7 downto 0),
      Close_data_i(7 downto 0) => util_vector_logic_1_Res(7 downto 0),
      Gout_o(3 downto 0) => video_out_0_Gout_o(3 downto 0),
      Orignal_data_i(7 downto 0) => blk_mem_gen_0_douta(7 downto 0),
      Rout_o(3 downto 0) => video_out_0_Rout_o(3 downto 0),
      SB_data_i(7 downto 0) => util_vector_logic_2_Res(7 downto 0),
      ThrdTarget_data_i(7 downto 0) => Thrd_target_0_data_o(7 downto 0),
      clock_i => clock_i_0_1,
      enable_o => video_out_0_enable_o,
      hsync_o => video_out_0_hsync_o,
      mode(2 downto 0) => mode_0_1(2 downto 0),
      reset_i => reset_i_0_1,
      vga_hs_cnt_o(31 downto 0) => Net(31 downto 0),
      vga_vs_cnt_o(31 downto 0) => Net1(31 downto 0),
      vsync_o => video_out_0_vsync_o
    );
end STRUCTURE;
