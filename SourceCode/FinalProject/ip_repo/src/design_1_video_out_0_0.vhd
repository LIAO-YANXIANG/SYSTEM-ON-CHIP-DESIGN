-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:video_out:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_video_out_0_0 IS
  PORT (
    clock_i : IN STD_LOGIC;
    reset_i : IN STD_LOGIC;
    mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Orignal_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    ThrdTarget_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    SB_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    Close_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    CCL_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    enable_o : OUT STD_LOGIC;
    Rout_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    Gout_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    Bout_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    vga_hs_cnt_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    vga_vs_cnt_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    hsync_o : OUT STD_LOGIC;
    vsync_o : OUT STD_LOGIC
  );
END design_1_video_out_0_0;

ARCHITECTURE design_1_video_out_0_0_arch OF design_1_video_out_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_video_out_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT video_out IS
    GENERIC (
      video_h : INTEGER;
      video_v : INTEGER;
      P_video_h : INTEGER;
      P_video_v : INTEGER
    );
    PORT (
      clock_i : IN STD_LOGIC;
      reset_i : IN STD_LOGIC;
      mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      Orignal_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      ThrdTarget_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      SB_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Close_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      CCL_data_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      enable_o : OUT STD_LOGIC;
      Rout_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      Gout_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      Bout_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      vga_hs_cnt_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      vga_vs_cnt_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      hsync_o : OUT STD_LOGIC;
      vsync_o : OUT STD_LOGIC
    );
  END COMPONENT video_out;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_video_out_0_0_arch: ARCHITECTURE IS "video_out,Vivado 2018.3";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_video_out_0_0_arch : ARCHITECTURE IS "design_1_video_out_0_0,video_out,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_1_video_out_0_0_arch: ARCHITECTURE IS "design_1_video_out_0_0,video_out,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=video_out,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,video_h=800,video_v=600,P_video_h=200,P_video_v=200}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_video_out_0_0_arch: ARCHITECTURE IS "module_ref";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF reset_i: SIGNAL IS "XIL_INTERFACENAME reset_i, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF reset_i: SIGNAL IS "xilinx.com:signal:reset:1.0 reset_i RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF clock_i: SIGNAL IS "XIL_INTERFACENAME clock_i, ASSOCIATED_RESET reset_i, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_clock_i_0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF clock_i: SIGNAL IS "xilinx.com:signal:clock:1.0 clock_i CLK";
BEGIN
  U0 : video_out
    GENERIC MAP (
      video_h => 800,
      video_v => 600,
      P_video_h => 200,
      P_video_v => 200
    )
    PORT MAP (
      clock_i => clock_i,
      reset_i => reset_i,
      mode => mode,
      Orignal_data_i => Orignal_data_i,
      ThrdTarget_data_i => ThrdTarget_data_i,
      SB_data_i => SB_data_i,
      Close_data_i => Close_data_i,
      CCL_data_i => CCL_data_i,
      enable_o => enable_o,
      Rout_o => Rout_o,
      Gout_o => Gout_o,
      Bout_o => Bout_o,
      vga_hs_cnt_o => vga_hs_cnt_o,
      vga_vs_cnt_o => vga_vs_cnt_o,
      hsync_o => hsync_o,
      vsync_o => vsync_o
    );
END design_1_video_out_0_0_arch;
