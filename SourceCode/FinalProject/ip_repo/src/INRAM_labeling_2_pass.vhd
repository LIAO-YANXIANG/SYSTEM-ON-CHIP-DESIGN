-- IN : '0' Background 
--      '1' foreground
-- OUT:  0  Background 
--       1+ foreground

--process chart
--0:pass1 
--    if ram_video_in(r,c)='1'
--        if (pass1(r-1,c)=0 and pass1(r,c-1)=0)
--            pass1(r,c)=label_cnt++
--            table(label_cnt)=label_cnt
--        elsif (pass1(r-1,c)>pass1(r,c-1))
--            pass1(r,c)=pass1(r-1,c)
--            if (pass1(r,c-1)>0)
--                table(pass1(r,c-1))=max(table(pass1(r,c-1)),pass1(r-1,c))
--        elsif (pass1(r-1,c)<pass1(r,c-1))
--            pass1(r,c)=pass1(r,c-1)
--            if (pass1(r-1,c)>0)
--                table(pass1(r-1,c))=max(table(pass1(r-1,c)),pass1(r,c-1))
--        else--(pass1(r-1,c)=pass1(r,c-1))
--            pass1(r,c)=pass1(r,c-1)
--    else
--        pass1(r,c)=0

--1:pass2 
--    if pass1(r,c)>0
--        if    (pass1(r+1,c)>pass1(r,c+1))&(pass1(r,c+1)>0):
--            PASS1(r+0, c+0) = table(pass1(r,c+1)) = max(table(pass1(r,c+1)),pass1(r+1,c))
--        elsif (pass1(r,c+1)>pass1(r+1,c))&(pass1(r+1,c)>0):
--            PASS1(r+0, c+0) = table(pass1(r+1,c)) = max(table(pass1(r+1,c)),pass1(r,c+1))
--        elsif (PASS1(r+0, c+0)>pass1(r,c+1))&(pass1(r,c+1)>0):
--            PASS1(r+0, c+0) = table(pass1(r,c+1)) = max(table(pass1(r,c+1)),pass1(r+1,c))
--        elsif (PASS1(r+0, c+0)>pass1(r+1,c))&(pass1(r+1,c)>0):
--            PASS1(r+0, c+0) = table(pass1(r+1,c)) = max(table(pass1(r+1,c)),pass1(r,c+1))
--        elsif (PASS1(r+0, c+0)<pass1(r,c+1)):
--            PASS1(r+0, c+0) = table(pass1(r,c)) = max(table(pass1(r,c)),pass1(r,c+1))
--        elsif (PASS1(r+0, c+0)<pass1(r+1,c)):
--            PASS1(r+0, c+0) = table(pass1(r,c)) = max(table(pass1(r,c)),pass1(r+1,c))
--    else
--        pass1(r,c)=0

--2:table replace
--    for(int x = label_cnt ; x>0 ;x--)
--        table(x)=table(table(x));

--3:out & wait
--    labeling(r+0, c+0)=table(pass1(r,c))
--    end:if(labeling_start='1')
--        label_cnt<= 0
--        mode     <= 0

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity inram_labeling_2_pass is
generic(
        video_h          : integer :=  480;
        video_v          : integer :=  320;
        labeling_bits    : integer :=    8
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
    max_num             :out std_logic_vector(labeling_bits - 1 downto 0);
    valid               :out std_logic
);
end inram_labeling_2_pass;

architecture behavioral of inram_labeling_2_pass is

component max_c_ram is
generic (
    data_depth : integer    :=  video_v*video_h;
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
--------------------------------------------
-- line buffer (v,h)
--------------------------------------------
signal mode    : integer;
signal mode_cnt: integer;
--0:pass1 
--    0.0:¼g¤Jkernel + pass1_w + table rst
--1:pass2 
--    1.0:¼g¤Jkernel + labeling_table_raddr
--    1.1:¨ú±o labeling_table §PÂ_labeling_table(conv_integer(kernel_buff(1,1)))<=max
--2:table replace
--    2.0:Åªtable(cnt)
--    2.1:Åªtable(table(cnt))ÂÐ»\table(cnt)
--3:out & wait
--    3.0:Åªpass1
--    3.1:Åªlabeling_table(ram_labeling_addr = ram_video_addr_cnt-1)
--    3.end if(labeling_start='1') mode <= 0
--------------------------------------------
signal ram_video_addr_cnt: integer;
signal ram_video_addr_h  : integer;
signal ram_video_addr_v  : integer;
signal label_cnt         : integer;
signal label_cnt_reg     : integer;
signal labeling_grous_cnt: integer;
signal time_cnt:  std_logic_vector(18 - 1 downto 0);
--------------------------------------------
type type_line_buff is array (integer range 1 to 1,integer range 0 to video_h-1) of std_logic_vector(labeling_bits-1 downto 0);
signal line_buff : type_line_buff ;
type type_kernel_buff is array (integer range 0 to 1,integer range 0 to         1) of std_logic_vector(labeling_bits-1 downto 0);
signal kernel_buff : type_kernel_buff ;
--------------------------------------------
signal wire_ram_video_addr: integer;
--------------------------------------------
signal wire_pass1_ram_wen  : std_logic;
signal wire_pass1_ram_waddr: integer;
signal wire_pass1_ram_wd   : std_logic_vector(labeling_bits - 1 downto 0);
signal wire_pass1_ram_raddr: integer;
--------------------------------------------
signal wire_table_ram_wen  : std_logic;
signal wire_table_ram_waddr: std_logic_vector(labeling_bits - 1 downto 0);
signal wire_table_ram_wd   : std_logic_vector(labeling_bits - 1 downto 0);
signal wire_table_ram_wd_buff: std_logic_vector(labeling_bits - 1 downto 0);
signal wire_table_ram_raddr: std_logic_vector(labeling_bits - 1 downto 0);
--------------------------------------------
signal wire_ram_labeling_wen  : std_logic;
signal wire_ram_labeling_waddr: integer;
signal wire_ram_labeling_wd   : std_logic_vector(labeling_bits - 1 downto 0);
--------------------------------------------
signal replace_en  : std_logic;
signal replace_t   : std_logic;
signal replace_l   : std_logic;
signal replace_c   : std_logic;
-------------------------------------------- 
signal wire_find_max_flag: std_logic;
signal wire_find_max_wen: std_logic;
signal wire_find_max_raddr: std_logic_vector(labeling_bits - 1 downto 0);
signal wire_find_max_rd: std_logic_vector(labeling_bits - 1 downto 0);
signal wire_find_max_rclk: std_logic;

signal wire_find_max_waddr: std_logic_vector(labeling_bits - 1 downto 0);
signal wire_find_max_wd: std_logic_vector(labeling_bits - 1 downto 0);
signal wire_find_max_wclk: std_logic;
signal max_cnt: std_logic_vector(labeling_bits - 1 downto 0);

signal wire_find_max_countors: std_logic_vector(labeling_bits - 1 downto 0);
signal max_countors: std_logic_vector(labeling_bits - 1 downto 0);

--------------------------------------------
begin
-------------------------------------------- -------------------------------------------- --------------------------------------------
-------------------------------------------
ram_video_clk       <=not clk;
pass1_ram_wclk      <=clk;
pass1_ram_rclk      <=not clk;
table_ram_wclk      <=clk;
table_ram_rclk      <=not clk;
ram_labeling_clk    <=clk;

wire_find_max_wclk  <=clk;
wire_find_max_rclk  <=not clk;
--------------------------------------------
ram_video_addr      <=wire_ram_video_addr ;

--------------------------------------------
pass1_ram_wen       <=wire_pass1_ram_wen  ;
pass1_ram_waddr     <=wire_pass1_ram_waddr;
pass1_ram_wd        <=wire_pass1_ram_wd   ;
pass1_ram_raddr     <=wire_pass1_ram_raddr;

--------------------------------------------
table_ram_wen       <=wire_table_ram_wen  ;
table_ram_waddr     <=wire_table_ram_waddr;
table_ram_wd        <=wire_table_ram_wd   ;
table_ram_raddr     <=wire_table_ram_raddr;

--------------------------------------------
ram_labeling_wen    <=wire_ram_labeling_wen  ;
ram_labeling_waddr  <=wire_ram_labeling_waddr;
ram_labeling_wd     <=wire_ram_labeling_wd   ;

--------------------------------------------video_in
process( rst , clk)
variable max : std_logic_vector(labeling_bits-1 downto 0);
begin
if rst = '0' or ena = '0'then
    mode               <= 4 ;
    ram_video_addr_cnt <= video_h * video_v+2 ;
    ram_video_addr_h   <= 0 ;
    ram_video_addr_v   <= 0 ;
    label_cnt          <= 0 ;
    time_cnt           <= (others=>'0');
    
    line_buff          <= (others=>(others=>(others=>'1')));
    kernel_buff        <= (others=>(others=>(others=>'1')));
    labeling_error     <='0';
    labeling_use       <= 0 ;
    labeling_grous_cnt <= 0 ;
    labeling_grous     <= 0 ;
    
    wire_pass1_ram_wen <='0';
    wire_table_ram_wen <='1';
    wire_table_ram_waddr<=conv_std_logic_vector(0,labeling_bits);
    wire_table_ram_wd   <=conv_std_logic_vector(0,labeling_bits);
    
    wire_ram_video_addr<= 0 ;
    valid              <='0';
    
    wire_find_max_flag <='0';
    wire_find_max_wen  <='0';
    wire_find_max_raddr<= (others=>'1');

    wire_find_max_waddr<= (others=>'1');
    wire_find_max_wd   <= (others=>'1');
    max_cnt<= (others=>'0');
    max_countors<= (others=>'0');
elsif rising_edge(clk) then
    case mode is
        -------------------------------------------- -------------------------------------------- 
        when 0 =>
            valid <='0';
            time_cnt             <= time_cnt +1 ;
            wire_pass1_ram_wen   <='1';
            wire_ram_labeling_wen<='0';
            wire_find_max_wen    <='0';
            if (replace_en = '1') then
                --¨úTABLE_RD>TABLE_WD?TABLE_WEN=1
                if (wire_table_ram_wd <= table_ram_rd) then
                    wire_table_ram_wen   <='1';
                end if;
                replace_en <='0';
            elsif (replace_t = '1') then
                wire_table_ram_wen  <='0';
                wire_pass1_ram_waddr<=ram_video_addr_cnt-1-video_h;
                wire_pass1_ram_wd   <=          table_ram_rd;
                replace_t           <='0';
            elsif (replace_l = '1') then
                wire_table_ram_wen  <='0';
                wire_pass1_ram_waddr<=ram_video_addr_cnt-1-1;
                wire_pass1_ram_wd   <=          table_ram_rd;
                replace_l           <='0';
                line_buff(1,ram_video_addr_h-1-1)<= table_ram_rd;
            elsif (replace_c = '1') then
                kernel_buff(1,1)               <= table_ram_rd;
                line_buff(1,ram_video_addr_h-1)<= table_ram_rd;
                wire_table_ram_wen  <='0';
                wire_pass1_ram_waddr<=ram_video_addr_cnt-1  ;
                wire_pass1_ram_wd   <=          table_ram_rd;
                replace_c           <='0';
            else
                if (ram_video_addr_cnt < video_h * video_v) then
                    ram_video_addr_cnt  <=ram_video_addr_cnt+1;
                    wire_ram_video_addr <=ram_video_addr_cnt+1;
                    wire_pass1_ram_waddr<=ram_video_addr_cnt  ;
                    if (ram_video_addr_h< video_h - 1 ) then
                        ram_video_addr_h<=ram_video_addr_h+1;
                        
                        kernel_buff(0,0) <= kernel_buff(0,1);
                        kernel_buff(0,1) <= line_buff(1,ram_video_addr_h);
                        
                        kernel_buff(1,0) <= kernel_buff(1,1);
                        
                        if(ram_video_in = '1') then
                            if((not line_buff(1,ram_video_addr_h))=0 )and((not kernel_buff(1,1))=0) then
                                kernel_buff(1,1)               <= conv_std_logic_vector(label_cnt+1,labeling_bits);
                                wire_pass1_ram_wd              <= conv_std_logic_vector(label_cnt+1,labeling_bits);
                                line_buff(1,ram_video_addr_h)  <= conv_std_logic_vector(label_cnt+1,labeling_bits);
                                
                                label_cnt                      <=                       label_cnt+1               ;
                                
                                wire_table_ram_wen             <= '1';
                                wire_table_ram_raddr           <= conv_std_logic_vector(label_cnt+1,labeling_bits);
                                wire_table_ram_waddr           <= conv_std_logic_vector(label_cnt+1,labeling_bits);
                                wire_table_ram_wd              <= conv_std_logic_vector(label_cnt+1,labeling_bits);
                            elsif(line_buff(1,ram_video_addr_h) > kernel_buff(1,1)) then
                                kernel_buff(1,1)               <= kernel_buff(1,1);
                                wire_pass1_ram_wd              <= kernel_buff(1,1);
                                line_buff(1,ram_video_addr_h)  <= kernel_buff(1,1);
                                if((not line_buff(1,ram_video_addr_h))>0) then
                                    replace_en                 <='1';
                                    wire_table_ram_wen         <='0';
                                    wire_table_ram_raddr       <=line_buff(1,ram_video_addr_h);
                                    wire_table_ram_waddr       <=line_buff(1,ram_video_addr_h);
                                    wire_table_ram_wd          <=kernel_buff(1,1);
                                    replace_t                  <='1';
                                    replace_l                  <='1';
                                    replace_c                  <='1';
                                else
                                    replace_en                 <='0';
                                    wire_table_ram_wen         <='0';
                                    wire_table_ram_raddr       <=kernel_buff(1,1);
                                    wire_table_ram_waddr       <=kernel_buff(1,1);
                                    wire_table_ram_wd          <=kernel_buff(1,1);
                                    replace_t                  <='0';
                                    replace_l                  <='1';
                                    replace_c                  <='1';
                                end if;
                            elsif(line_buff(1,ram_video_addr_h) < kernel_buff(1,1)) then
                                kernel_buff(1,1)               <= line_buff(1,ram_video_addr_h);
                                wire_pass1_ram_wd              <= line_buff(1,ram_video_addr_h);
                                line_buff(1,ram_video_addr_h)  <= line_buff(1,ram_video_addr_h);
                                if((not kernel_buff(1,1))>0) then
                                    replace_en                 <='1';
                                    wire_table_ram_wen         <='0';
                                    wire_table_ram_raddr       <=kernel_buff(1,1);
                                    wire_table_ram_waddr       <=kernel_buff(1,1);
                                    wire_table_ram_wd          <=line_buff(1,ram_video_addr_h);
                                    replace_t                  <='1';
                                    replace_l                  <='1';
                                    replace_c                  <='1';
                                else
                                    replace_en                 <='0';
                                    wire_table_ram_wen         <='0';
                                    wire_table_ram_raddr       <=line_buff(1,ram_video_addr_h);
                                    wire_table_ram_waddr       <=line_buff(1,ram_video_addr_h);
                                    wire_table_ram_wd          <=line_buff(1,ram_video_addr_h);
                                    replace_t                  <='1';
                                    replace_l                  <='0';
                                    replace_c                  <='1';
                                end if;
                            else
                                kernel_buff(1,1)               <= line_buff(1,ram_video_addr_h);
                                wire_pass1_ram_wd              <= line_buff(1,ram_video_addr_h);
                                line_buff(1,ram_video_addr_h)  <= line_buff(1,ram_video_addr_h);
                            end if;
                        else
                            kernel_buff(1,1)               <= (others=>'1');
                            wire_pass1_ram_wd              <= (others=>'1');
                            line_buff(1,ram_video_addr_h)  <= (others=>'1');
                            wire_table_ram_wen             <= '1';
                            wire_table_ram_raddr           <= (others=>'1');
                            wire_table_ram_waddr           <= (others=>'1');
                            wire_table_ram_wd              <= (others=>'1');
                        end if;
                    else
                        kernel_buff      <= (others=>(others=>(others=>'1')));
                        wire_pass1_ram_wd<=                   (others=>'1')  ;
                        ram_video_addr_h <=0;
                        if (ram_video_addr_v< video_v - 1 ) then
                            ram_video_addr_v<=ram_video_addr_v+1;
                        else
                            ram_video_addr_v<=0;
                        end if;
                    end if;
                else--pass2
                    line_buff           <= (others=>(others=>(others=>'1')));
                    ram_video_addr_cnt  <= video_h * video_v - 1;
                    ram_video_addr_h    <= 0 ;
                    ram_video_addr_v    <= 0 ;
                    mode                <= mode + 1;
                    mode_cnt            <= 0;
                    
                    labeling_use        <= label_cnt;
                    label_cnt_reg       <= label_cnt;
                    if (label_cnt >= 2**labeling_bits ) then
                        labeling_error<='1';
                    else
                        labeling_error<='0';
                    end if;
                end if;
            end if;
        -------------------------------------------- -------------------------------------------- 
        --1:pass2 
        when 1 =>
            time_cnt             <= time_cnt +1 ;
            valid <='0';
            wire_pass1_ram_wen   <='1';
            wire_ram_labeling_wen<='0';
            wire_find_max_wen <= '0';
            if (replace_en = '1') then
                --¨úTABLE_RD>TABLE_WD?TABLE_WEN=1
                if (wire_table_ram_wd <= table_ram_rd) then
                    wire_table_ram_wen   <='1';
                end if;
                replace_en <='0';
            else
                wire_table_ram_wen   <='0';
                if (ram_video_addr_cnt > 0) then
                    ram_video_addr_cnt  <=ram_video_addr_cnt-1;
                    wire_pass1_ram_raddr<=ram_video_addr_cnt-1;
                    wire_pass1_ram_waddr<=ram_video_addr_cnt  ;
                    if (ram_video_addr_h< video_h - 1 ) then
                        ram_video_addr_h<=ram_video_addr_h+1;
                        
                        
                        kernel_buff(0,1) <= line_buff(1,ram_video_addr_h);
                        
                        kernel_buff(0,0) <= kernel_buff(0,1);
                        kernel_buff(1,0) <= kernel_buff(1,1);
                        
                        if((not pass1_ram_rd)>0) then
                            if((not line_buff(1,ram_video_addr_h))=0 )and((not kernel_buff(1,1))=0) then
                                kernel_buff(1,1)             <= pass1_ram_rd;
                                wire_pass1_ram_wd            <= pass1_ram_rd;
                                line_buff(1,ram_video_addr_h)<= pass1_ram_rd;
                            elsif (line_buff(1,ram_video_addr_h)>kernel_buff(1,1))and(( not line_buff(1,ram_video_addr_h))>0)then
                                kernel_buff(1,1)             <= kernel_buff(1,1);
                                wire_pass1_ram_wd            <= kernel_buff(1,1);
                                line_buff(1,ram_video_addr_h)<= kernel_buff(1,1);
                                replace_en                   <='1';
                                wire_table_ram_wen           <='0';
                                wire_table_ram_raddr         <=line_buff(1,ram_video_addr_h);
                                wire_table_ram_waddr         <=line_buff(1,ram_video_addr_h);
                                wire_table_ram_wd            <=kernel_buff(1,1);
                            elsif (kernel_buff(1,1)>line_buff(1,ram_video_addr_h))and(( not kernel_buff(1,1))>0)then
                                kernel_buff(1,1)             <= line_buff(1,ram_video_addr_h);
                                wire_pass1_ram_wd            <= line_buff(1,ram_video_addr_h);
                                line_buff(1,ram_video_addr_h)<= line_buff(1,ram_video_addr_h);
                                replace_en                   <='1';
                                wire_table_ram_wen           <='0';
                                wire_table_ram_raddr         <=kernel_buff(1,1);
                                wire_table_ram_waddr         <=kernel_buff(1,1);
                                wire_table_ram_wd            <=line_buff(1,ram_video_addr_h);
                            elsif (kernel_buff(1,1) > pass1_ram_rd   )and(( not kernel_buff(1,1))>0)then
                                kernel_buff(1,1)             <= pass1_ram_rd;
                                wire_pass1_ram_wd            <= pass1_ram_rd;
                                line_buff(1,ram_video_addr_h)<= pass1_ram_rd;
                                replace_en                   <='1';
                                wire_table_ram_wen           <='0';
                                wire_table_ram_raddr         <=kernel_buff(1,1);
                                wire_table_ram_waddr         <=kernel_buff(1,1);
                                wire_table_ram_wd            <=pass1_ram_rd;
                            elsif (line_buff(1,ram_video_addr_h)>pass1_ram_rd   )and(( not line_buff(1,ram_video_addr_h))>0)then
                                kernel_buff(1,1)             <= pass1_ram_rd;
                                wire_pass1_ram_wd            <= pass1_ram_rd;
                                line_buff(1,ram_video_addr_h)<= pass1_ram_rd;
                                replace_en                   <='1';
                                wire_table_ram_wen           <='0';
                                wire_table_ram_raddr         <=line_buff(1,ram_video_addr_h);
                                wire_table_ram_waddr         <=line_buff(1,ram_video_addr_h);
                                wire_table_ram_wd            <=pass1_ram_rd;
                            elsif (pass1_ram_rd   >kernel_buff(1,1))and(( not pass1_ram_rd)>0)then
                                kernel_buff(1,1)             <= kernel_buff(1,1);
                                wire_pass1_ram_wd            <= kernel_buff(1,1);
                                line_buff(1,ram_video_addr_h)<= kernel_buff(1,1);
                                replace_en                   <='1';
                                wire_table_ram_wen           <='0';
                                wire_table_ram_raddr         <=pass1_ram_rd;
                                wire_table_ram_waddr         <=pass1_ram_rd;
                                wire_table_ram_wd            <=kernel_buff(1,1);
                            elsif (pass1_ram_rd   >line_buff(1,ram_video_addr_h))and(( not pass1_ram_rd)>0)then
                                kernel_buff(1,1)             <= line_buff(1,ram_video_addr_h);
                                wire_pass1_ram_wd            <= line_buff(1,ram_video_addr_h);
                                line_buff(1,ram_video_addr_h)<= line_buff(1,ram_video_addr_h);
                                replace_en                   <='1';
                                wire_table_ram_wen           <='0';
                                wire_table_ram_raddr         <=pass1_ram_rd;
                                wire_table_ram_waddr         <=pass1_ram_rd;
                                wire_table_ram_wd            <=line_buff(1,ram_video_addr_h);
                            else
                                kernel_buff(1,1)             <= pass1_ram_rd;
                                wire_pass1_ram_wd            <= pass1_ram_rd;
                                line_buff(1,ram_video_addr_h)<= pass1_ram_rd;
                            end if;
                        else
                            kernel_buff(1,1)               <= (others=>'1');
                            wire_pass1_ram_wd              <= (others=>'1');
                            line_buff(1,ram_video_addr_h)  <= (others=>'1');
                        end if;
                    else
                        kernel_buff      <= (others=>(others=>(others=>'1')));
                        wire_pass1_ram_wd<=                (others=>'1')  ;
                        ram_video_addr_h <=0;
                        if (ram_video_addr_v< video_v - 1 ) then
                            ram_video_addr_v<=ram_video_addr_v+1;
                        else
                            ram_video_addr_v<=0;
                        end if;
                    end if;
                else--2:table replace
                    labeling_grous_cnt  <= 0 ;
                    mode                <= mode + 1;
                    ram_video_addr_cnt  <=                      0               ;
                    wire_table_ram_raddr<=conv_std_logic_vector(0,labeling_bits);
                    wire_table_ram_waddr<=conv_std_logic_vector(0,labeling_bits);
                    wire_table_ram_wd   <=(others=>'1');
                end if;
            end if;
        -------------------------------------------- -------------------------------------------- 
        --2:table replace
        --    2.0:Åªtable(cnt)
        --    2.1:Åªtable(table(cnt))ÂÐ»\table(cnt)
        when 2 =>
            time_cnt             <= time_cnt +1 ;
            valid <='0';
            wire_pass1_ram_wen   <='0';
            wire_ram_labeling_wen<='0';
            wire_find_max_wen <= '1';
            wire_find_max_wd  <= (others => '0');
                
            if (replace_en = '1') then
                --¨úTABLE_RD>TABLE_WD?TABLE_WEN=1
                if (wire_table_ram_waddr = table_ram_rd) then
                    labeling_grous_cnt   <=labeling_grous_cnt+1;
                end if;
                if (wire_table_ram_raddr = table_ram_rd) then
                    wire_table_ram_wen    <='1';
                    wire_table_ram_raddr  <=table_ram_rd;
                    wire_table_ram_wd     <=table_ram_rd;
                    replace_en <='0';
                    
                    wire_find_max_waddr   <= table_ram_rd;
                    
                else
                    wire_table_ram_wen    <='0';
                    wire_table_ram_raddr  <=table_ram_rd;
                    wire_table_ram_wd     <=table_ram_rd;
                end if;
            else
                wire_table_ram_wen   <='0';
                replace_en <= '1';
                if (ram_video_addr_cnt < label_cnt_reg) then
                    ram_video_addr_cnt  <=                      ram_video_addr_cnt+1               ;
                    wire_table_ram_raddr<=conv_std_logic_vector(ram_video_addr_cnt+1,labeling_bits);
                    wire_table_ram_waddr<=conv_std_logic_vector(ram_video_addr_cnt+1,labeling_bits);
                    wire_table_ram_wd   <=(others=>'1');
                else--3:out
                    labeling_grous      <= labeling_grous_cnt;
                    ram_video_addr_cnt  <= 0;
                    ram_video_addr_h    <= 0 ;
                    ram_video_addr_v    <= 0 ;
                    max_cnt                <=(others=>'0');
                    wire_find_max_countors <=(others=>'0');
                    max_countors           <=(others=>'0');
                    mode                <= mode + 1;
                end if;
            end if;
        -------------------------------------------- -------------------------------------------- 
        --3:out & wait
        --    3.0:Åªpass1ls
        --    3.1:Åªlabeling_table(ram_labeling_addr = ram_video_addr_cnt-1)
        --    3.end if(labeling_start='1') mode <= 0
        when 3 =>
            time_cnt             <= time_cnt +1 ;
            wire_table_ram_wen   <='0';
            wire_pass1_ram_wen   <='0';
            wire_ram_labeling_wen<='0';
            if(wire_find_max_flag = '1')then
                if(wire_find_max_rd >= max_cnt)then
                    max_cnt <= wire_find_max_rd + 1;
                    if table_ram_rd>0 then
                        wire_find_max_countors <= table_ram_rd;
                    end if;
                    wire_find_max_wd <= wire_find_max_rd + 1;
                    wire_find_max_wen <= '1';
                else
                    wire_find_max_wd  <= wire_find_max_rd + 1;
                    wire_find_max_wen <= '1';
            
                end if;
                wire_find_max_flag <= '0';
            elsif (ram_video_addr_cnt < video_h * video_v+2 ) then

                wire_pass1_ram_wen   <='0';
                wire_table_ram_wen   <='0';
                wire_ram_labeling_wen<='0';
                ram_video_addr_cnt   <=ram_video_addr_cnt+1;
                wire_pass1_ram_raddr <=ram_video_addr_cnt  ;   --clk0
                wire_table_ram_raddr <=pass1_ram_rd;           --clk1
                -------------------------------------------- 
                
                wire_find_max_wen   <= '0';
                if (not table_ram_rd>0)and (table_ram_rd>0)then
                    wire_find_max_flag  <= '1';
                end if;
                wire_find_max_waddr <= table_ram_rd;
                wire_find_max_raddr <= table_ram_rd;
            else
                max_countors        <= wire_find_max_countors;
                ram_video_addr_cnt  <= 0;
                ram_video_addr_h    <= 0 ;
                ram_video_addr_v    <= 0 ;
                wire_table_ram_wd   <= wire_find_max_countors;
--                wire_table_ram_waddr<= time_cnt(17 downto 1);
                mode                <= mode + 1;
            end if;
        when others =>
            time_cnt             <= time_cnt +1 ;
            wire_table_ram_wen   <='0';
            if (ram_video_addr_cnt < video_h * video_v+2 ) then
                if ram_video_addr_cnt >= 2 then  
                    valid <='1';
                end if;
                
                ram_video_addr_cnt  <=ram_video_addr_cnt+1;
                wire_pass1_ram_raddr<=ram_video_addr_cnt  ;   --clk0
                wire_table_ram_raddr<=pass1_ram_rd;           --clk1
                -------------------------------------------- 
                wire_ram_labeling_waddr<=ram_video_addr_cnt-2;--clk2
                if(max_countors = table_ram_rd and table_ram_rd>0)then
                    wire_ram_labeling_wen<='1';
                    wire_ram_labeling_wd   <=table_ram_rd;
                else 
                    wire_ram_labeling_wen<='1';
                    wire_ram_labeling_wd   <=(others=>'1');
                end if;
                max_num <= max_countors;
            else 
				valid <='0';
                time_cnt               <=(others=>'0');
                max_cnt                <=(others=>'0');
                wire_find_max_countors <=(others=>'0');
                max_countors           <=(others=>'0');
                wire_pass1_ram_wen     <='0';
                wire_table_ram_wen     <='1';
                wire_table_ram_waddr   <=conv_std_logic_vector(0,labeling_bits);
                wire_table_ram_wd      <=conv_std_logic_vector(0,labeling_bits);
                wire_ram_labeling_wen  <='0';
                wire_ram_video_addr    <= 0 ;
                label_cnt              <= 0 ;
                if(labeling_start = '1') then
                    ram_video_addr_cnt <= 0 ;
                    ram_video_addr_h   <= 0 ;
                    ram_video_addr_v   <= 0 ;
                    line_buff          <= (others=>(others=>(others=>'1')));
                    kernel_buff        <= (others=>(others=>(others=>'1')));
                    mode               <= 0 ;
                end if;
            end if;
    end case;
end if;
end process;
B_ram : max_c_ram
generic map(
    data_depth  =>  video_v*video_h,
    data_bits   =>  labeling_bits
)
  port map (
    wclk   => wire_find_max_wclk,
    wen    => wire_find_max_wen,
    waddr  => conv_integer(wire_find_max_waddr),
    wdata  => wire_find_max_wd,
    
    rclk   => wire_find_max_rclk,
    raddr  => conv_integer(wire_find_max_raddr),
    rdata  => wire_find_max_rd
  );  

end architecture;