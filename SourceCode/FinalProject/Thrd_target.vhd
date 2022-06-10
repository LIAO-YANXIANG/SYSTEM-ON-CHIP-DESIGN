library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity Thrd_target is
    generic(
	    thrd           : integer := 60
	);
	port(
		clock_i        : in std_logic; -- 100MHz
		reset_0_i       : in std_logic; -- 
		data_i         : in std_logic_vector(7 downto 0);
		data_o         : out std_logic_vector(7 downto 0)
	);
end Thrd_target;

architecture yanxi of Thrd_target is
begin

	thrd_target_0:process(clock_i, reset_0_i)
	begin
		if (reset_0_i = '0') then
			data_o <= (others =>'0');
		elsif rising_edge(clock_i) then
		    if (data_i <= thrd) then
				data_o <= data_i;
			else
			    data_o <= (others =>'0');
			end if;
		end if;
	end process;

end architecture;