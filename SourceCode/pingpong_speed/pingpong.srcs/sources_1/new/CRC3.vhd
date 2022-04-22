library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CRC3 is                                                    
  Port ( clk : in std_logic;
         rst : in std_logic;
         random_value_out : out std_logic_vector(2 downto 0)
       );
end CRC3;

architecture Behavioral of CRC3 is
    signal div_count    : integer range 0 to 50000000;
    signal div_clk      : std_logic;
    signal random_value : std_logic_vector(2 downto 0);
begin
random_value_out <= random_value;

DIV:process(clk, rst)                                               
begin
    if rst = '1' then
        div_count <= 0;
        div_clk <= '0';
    elsif clk 'event and clk = '1' then
        if div_count >= 5000000 then
            div_count <= 0;
            div_clk <= not div_clk;
        else
            div_count <= div_count + 1;
        end if;
    end if;
end process;

random_generate:process(div_clk, rst)                             
begin
  if rst = '1' then
    random_value <= "111";
  elsif div_clk 'event and div_clk = '1' then
    random_value(0) <= random_value(2);
    random_value(1) <= random_value(0) xor random_value(2);
    random_value(2) <= random_value(1);  
  end if;
end process;

end Behavioral;
