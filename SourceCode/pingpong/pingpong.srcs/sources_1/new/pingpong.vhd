library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pingpong is

	generic (
	       DIV_N    : integer := 2;
		   LED_N    : integer := 8;
		   SCORE_N  : integer := 8
	);
	
    port ( clk_i    : in  std_logic;
           rst_i    : in  std_logic;
           swl_i    : in  std_logic;
           swr_i    : in  std_logic;
           led_o    : out  std_logic_vector (LED_N-1   downto 0);			  
           scorel_o : out  std_logic_vector (LED_N-1   downto 0);
           scorer_o : out  std_logic_vector (SCORE_N-1 downto 0)
		);
		
end pingpong;

architecture pingpong_control of pingpong is

	type FSM_state_type is (moving_left, moving_right, right_win, left_win);
	signal FSM_state: FSM_state_type;
	
	signal div4_clk_r : std_logic;
	signal led_r      : std_logic_vector (LED_N-1   downto 0);
	signal scorel_r   : std_logic_vector (SCORE_N-1 downto 0);
	signal scorer_r   : std_logic_vector (SCORE_N-1 downto 0);
	signal count_r    : std_logic_vector (DIV_N-1   downto 0);

	

begin
	-- ///////////////////////////////////////////////////////////// --
	led_o    <= led_r;
	scorel_o <= scorel_r;
	scorer_o <= scorer_r;  
	
	-- ///////////////////////////////////////////////////////////// --
	FSM : process(clk_i, rst_i, led_r)
	begin
		if (rst_i = '1') then
		
			FSM_state <= moving_left;
			scorer_r <= (others => '0'); -- Mealey machine
			scorel_r <= (others => '0'); -- Mealey machine
			
		elsif (clk_i'event and clk_i = '1') then
		 
			case FSM_state is
				---------------------------------------
				when moving_left =>
				
					if not(led_r(LED_N-1) = '1') and (swl_i = '1') then 	-- left player hit the ball, too early or too late
						FSM_state <= right_win;
						scorer_r <= scorer_r + '1'; 					    -- Right player scorer ++ 
					elsif (led_r(LED_N-1) = '1') and (swl_i = '1') then 	-- left player hit the ball
						FSM_state <= moving_right;
					end if;
				
				---------------------------------------
				when moving_right =>
				
					if not(led_r(0) = '1') and (swr_i = '1') then 	        -- Right player hit the ball, too early or too late
						FSM_state <= left_win;
						scorel_r <= scorel_r + '1'; 	                    -- Left player score ++ 
					elsif (led_r(0) = '1') and (swr_i = '1') then           -- Right player hit the ball
						FSM_state <= moving_left;
					end if;		 
				
				---------------------------------------
				when left_win =>
				
					if (swl_i = '1') then                                   -- Left player ready to serve 
						FSM_state <= moving_right;
					end if;	
					
				---------------------------------------		
				when right_win =>
				
					if (swr_i = '1') then                                   -- Right player ready to serve 
						FSM_state <= moving_left;
					end if;		 
					
				---------------------------------------
				when others => null;
			end case;
			
		end if;
	end process;
	-- ///////////////////////////////////////////////////////////// --
	div_clk : process(clk_i, rst_i)
	begin
		if (rst_i = '1') then
			count_r <= (others => '0');
		elsif (clk_i'event and clk_i = '1') then
			count_r <= count_r + 1; 
		end if;
	end process;
	div4_clk_r <= count_r(DIV_N-1);
	
	-- ///////////////////////////////////////////////////////////// --
	led_actions: process(div4_clk_r, rst_i, FSM_state)
	begin
		if (rst_i = '1') then
			led_r <= "00000001";
		elsif (div4_clk_r'event and div4_clk_r = '1') then
			if (FSM_state = moving_left) then     -- led << 1;
                led_r(LED_N-1 downto 1) <= led_r(LED_N-2 downto 0);
                led_r(               0) <='0';
			elsif (FSM_state = moving_right) then -- led >> 1;
                led_r(LED_N-2 downto 0) <= led_r(LED_N-1 downto 1);
                led_r(LED_N-1         ) <='0';		
			end if; 				
		end if;    
	end process;
	-- ///////////////////////////////////////////////////////////// --

end architecture;

