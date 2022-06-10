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

-- IP VLNV: xilinx.com:module_ref:CCL_warpper:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_CCL_warpper_0_0 IS
  PORT (
    reset_i : IN STD_LOGIC;
    clock_i : IN STD_LOGIC;
    enable_i : IN STD_LOGIC;
    vga_hs_cnt_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    vga_vs_cnt_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    valid_o : OUT STD_LOGIC
  );
END design_1_CCL_warpper_0_0;

ARCHITECTURE design_1_CCL_warpper_0_0_arch OF design_1_CCL_warpper_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_CCL_warpper_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT CCL_warpper IS
    GENERIC (
      image_size : INTEGER;
      video_h : INTEGER;
      video_v : INTEGER;
      iterated : INTEGER;
      labeling_bits : INTEGER
    );
    PORT (
      reset_i : IN STD_LOGIC;
      clock_i : IN STD_LOGIC;
      enable_i : IN STD_LOGIC;
      vga_hs_cnt_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      vga_vs_cnt_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      valid_o : OUT STD_LOGIC
    );
  END COMPONENT CCL_warpper;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_CCL_warpper_0_0_arch: ARCHITECTURE IS "CCL_warpper,Vivado 2018.3";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_CCL_warpper_0_0_arch : ARCHITECTURE IS "design_1_CCL_warpper_0_0,CCL_warpper,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_1_CCL_warpper_0_0_arch: ARCHITECTURE IS "design_1_CCL_warpper_0_0,CCL_warpper,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=CCL_warpper,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,image_size=40000,video_h=200,video_v=200,iterated=40,labeling_bits=16}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_CCL_warpper_0_0_arch: ARCHITECTURE IS "module_ref";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF clock_i: SIGNAL IS "XIL_INTERFACENAME clock_i, ASSOCIATED_RESET reset_i, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_clock_i_0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF clock_i: SIGNAL IS "xilinx.com:signal:clock:1.0 clock_i CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF reset_i: SIGNAL IS "XIL_INTERFACENAME reset_i, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF reset_i: SIGNAL IS "xilinx.com:signal:reset:1.0 reset_i RST";
BEGIN
  U0 : CCL_warpper
    GENERIC MAP (
      image_size => 40000,
      video_h => 200,
      video_v => 200,
      iterated => 40,
      labeling_bits => 16
    )
    PORT MAP (
      reset_i => reset_i,
      clock_i => clock_i,
      enable_i => enable_i,
      vga_hs_cnt_i => vga_hs_cnt_i,
      vga_vs_cnt_i => vga_vs_cnt_i,
      data_in => data_in,
      data_out => data_out,
      valid_o => valid_o
    );
END design_1_CCL_warpper_0_0_arch;
