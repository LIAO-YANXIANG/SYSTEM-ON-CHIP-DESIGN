library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pingpong is

	generic (
           DIV_N    : integer := 24;
           LED_N    : integer := 8;
           SCORE_N  : integer := 8
	);
	
    port ( clk_i    : in  std_logic;
           rst_i    : in  std_logic;
           swl_i    : in  std_logic;
           swr_i    : in  std_logic;
           led_o    : out  std_logic_vector (LED_N-1   downto 0)		  
           --scorel_o : out  std_logic_vector (LED_N-1   downto 0);
           --scorer_o : out  std_logic_vector (SCORE_N-1 downto 0)
		);
		
end pingpong;

architecture pingpong_control of pingpong is

	type FSM_state_type is (idle_left, idle_right, serve_left, serve_right, moving_left, moving_right, right_win, left_win);
	signal FSM_state: FSM_state_type;
	
	signal display_div_clk_r : std_logic;
    signal div_clk_r         : std_logic;
	signal led_r             : std_logic_vector (LED_N-1   downto 0);
	signal scorel_r          : std_logic_vector (SCORE_N-1 downto 0);
	signal scorer_r          : std_logic_vector (SCORE_N-1 downto 0);
	signal div_count_r       : std_logic_vector (DIV_N-1   downto 0);
	signal delay_count_r     : std_logic_vector (3         downto 0);
    
    component CRC3 is
	port(
         clk : in std_logic;
         rst : in std_logic;
         random_value_out : out std_logic_vector(2 downto 0)
    );
    end component;	
    signal CRC3_r           : std_logic_vector (2         downto 0);
    
    
begin
	-- ///////////////////////////////////////////////////////////// --
	led_o    <= led_r;
	--scorel_o <= scorel_r;
	--scorer_o <= scorer_r;  
	
	-- ///////////////////////////////////////////////////////////// --
	FSM : process(clk_i, rst_i, led_r, delay_count_r)
	begin
		if (rst_i = '1') then
		
			FSM_state <= idle_left;
			
--			scorer_r <= (others => '0'); -- Mealey machine
--			scorel_r <= (others => '0'); -- Mealey machine
			
		elsif (clk_i'event and clk_i = '1') then
		 
			case FSM_state is
				---------------------------------------
				when idle_left =>
                
					if (swl_i = '1') then  									-- IDLE , Waiting for the winning player button to serve
						FSM_state <= serve_left;
					end if;
                    
				---------------------------------------
				when idle_right =>
                
					if (swr_i = '1') then  									-- IDLE , Waiting for the winning player button to serve
						FSM_state <= serve_right;
					end if;
                   
                ---------------------------------------
				when serve_left =>
                
					if (swl_i = '0') then  									-- Left player ready to serve 
						FSM_state <= moving_right;
					end if;
                
                ---------------------------------------
				when serve_right =>
                
					if (swr_i = '0') then  									-- Right player ready to serve 
						FSM_state <= moving_left;
					end if;
                    
				---------------------------------------
				when moving_left =>
				
					if (not(led_r(LED_N-1) = '1') and (swl_i = '1')) or ((led_r(LED_N-1 downto 0) = "00000000") and (swl_i = '0')) then     -- left player hit the ball, too early or too late
						FSM_state <= right_win;
--						scorer_r <= scorer_r + '1'; 					    -- Right player scorer ++ 
					elsif (led_r(LED_N-1) = '1') and (swl_i = '1') then 	-- left player hit the ball
						FSM_state <= moving_right;
					end if;
				
				---------------------------------------
				when moving_right =>
				
					if (not(led_r(0) = '1') and (swr_i = '1')) or ((led_r(LED_N-1 downto 0) = "00000000") and (swr_i = '0')) then    -- Right player hit the ball, too early or too late
						FSM_state <= left_win;
--						scorel_r <= scorel_r + '1'; 	                    -- Left player score ++ 
					elsif (led_r(0) = '1') and (swr_i = '1') then           -- Right player hit the ball
						FSM_state <= moving_left;
					end if;		 
				
				---------------------------------------
				when left_win =>
			
                    if (delay_count_r(3) = '1') and (swl_i = '0') and (swr_i = '0') then    -- win display 4sec
                        FSM_state <= idle_left;
                    end if;

				---------------------------------------		
				when right_win =>
				                                
					if (delay_count_r(3) = '1') and (swl_i = '0') and (swr_i = '0') then    -- win display 4sec     
						FSM_state <= idle_right;
					end if;		 
                    
				---------------------------------------
				when others => null;
			end case;
			
		end if;
	end process;
    
	-- ///////////////////////////////////////////////////////////// non-blocking
	div_clk : process(clk_i, rst_i)
	begin
		if (rst_i = '1') then
			div_count_r <= (others => '0');
		elsif (clk_i'event and clk_i = '1') then
			div_count_r <= div_count_r + 1; 
		end if;
	end process;
    display_div_clk_r <= div_count_r(DIV_N-1);
	
    -- ///////////////////////////////////////////////////////////// blocking
	case_CRC:process(CRC3_r)
    begin
        case CRC3_r is
            when "001" => div_clk_r <= div_count_r(DIV_N-1);  
            when "100" => div_clk_r <= div_count_r(DIV_N-2);    
            when "111" => div_clk_r <= div_count_r(DIV_N-3);    
            when others => div_clk_r <= div_count_r(DIV_N-1);
        end case;
    end process;
    
    
	-- ///////////////////////////////////////////////////////////// --
	led_actions: process(div_clk_r, rst_i, FSM_state)
	begin
		if (rst_i = '1') then
			led_r <= "10000000";
		elsif (div_clk_r'event and div_clk_r = '1') then
		
			if (FSM_state = idle_left) then
                led_r <= "10000000";
                
			elsif (FSM_state = idle_right) then
                led_r <= "00000001";
				
			elsif (FSM_state = moving_left) then 
                led_r(LED_N-1 downto 1) <= led_r(LED_N-2 downto 0);
                led_r(               0) <='0';
				
			elsif (FSM_state = moving_right) then
                led_r(LED_N-2 downto 0) <= led_r(LED_N-1 downto 1);
                led_r(LED_N-1         ) <='0';		
                
            elsif (FSM_state = left_win) then
                led_r <= "11110000";
                
            elsif (FSM_state = right_win) then
				led_r <= "00001111";
     
			end if; 		
            
		end if;    
	end process;
    
	-- ///////////////////////////////////////////////////////////// --
    delay_counter_actions: process(display_div_clk_r, rst_i, FSM_state)
	begin
		if (rst_i = '1') then
			delay_count_r <= (others=>'0');
		elsif (display_div_clk_r'event and display_div_clk_r = '1') then
			if (FSM_state = left_win) or (FSM_state = right_win) then
                delay_count_r <= delay_count_r + 1; 
            else
                delay_count_r <= (others=>'0');
			end if; 		
		end if;    
	end process;
    
    -- ///////////////////////////////////////////////////////////// --
    CRC3_0 : CRC3
    port map (
        clk                 => clk_i,
        rst                 => rst_i,
        random_value_out    => CRC3_r
    );
    -- ///////////////////////////////////////////////////////////// --
    
    
end architecture;

