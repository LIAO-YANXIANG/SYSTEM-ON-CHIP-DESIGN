library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity testbench is
end;

architecture bench of testbench is

  component pingpong
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
  end component;

  signal clk_i: std_logic;
  signal rst_i: std_logic;
  signal swl_i: std_logic;
  signal swr_i: std_logic;
  signal led_o: std_logic_vector (8-1 downto 0);
  signal scorel_o: std_logic_vector (8-1 downto 0);
  signal scorer_o: std_logic_vector (8-1 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: pingpong generic map ( DIV_N    => 2,
                              LED_N    => 8,
                              SCORE_N  => 8 )
                   port map ( clk_i    => clk_i,
                              rst_i    => rst_i,
                              swl_i    => swl_i,
                              swr_i    => swr_i,
                              led_o    => led_o,
                              scorel_o => scorel_o,
                              scorer_o => scorer_o );

  stimulus: process
  begin
  
    -- Initialize System
    rst_i <= '1';
    swl_i <= '0';
    swr_i <= '0';
    wait for clock_period;
    
    --  Led << 1 
    rst_i <= '0';
    swl_i <= '0';
    swr_i <= '0';
    wait for clock_period*7*4; -- 7 (led_state) * 4 (div_clk)
    
    --  Left  player hit the ball,  Led >> 1
    swl_i <= '1';
    swr_i <= '0';
    wait for clock_period*7*4; -- 7 (led_state) * 4 (div_clk)
    
    --  Right  player hit the ball,  Led << 1
    swl_i <= '0';
    swr_i <= '1';
    wait for clock_period*5*4; -- 5 (led_state) * 4 (div_clk)
    
    --  Left  player hit the ball too early,  Right  player scorer ++ 
    swl_i <= '1';
    swr_i <= '0';
    
    stop_the_clock <= False;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk_i <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  