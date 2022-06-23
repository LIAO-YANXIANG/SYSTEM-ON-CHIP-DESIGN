library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Master_myip_v1_0_M00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- The master will start generating data from the C_M_START_DATA_VALUE value
		C_M_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		-- The master requires a target slave base address.
    -- The master will initiate read and write transactions on the slave with base address specified here as a parameter.
		--C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"43C00000";
		-- Width of M_AXI address bus. 
    -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		-- Width of M_AXI data bus. 
    -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		-- Transaction number is the number of write 
    -- and read transactions the master will perform as a part of this example memory test.
		--C_M_TRANSACTIONS_NUM	: integer	:= 4
		C_M_TRANSACTIONS_NUM	: integer	:= 1
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Initiate AXI transactions
		INIT_AXI_TXN	: in std_logic;
		-- Asserts when ERROR is detected
		ERROR	: out std_logic;
		-- Asserts when AXI transactions is complete
		TXN_DONE	: out std_logic;
		-- AXI clock signal
		M_AXI_ACLK	: in std_logic;
		-- AXI active low reset signal
		M_AXI_ARESETN	: in std_logic;
		-- Master Interface Write Address Channel ports. Write address (issued by master)
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type.
    -- This signal indicates the privilege and security level of the transaction,
    -- and whether the transaction is a data access or an instruction access.
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		-- Write address valid. 
    -- This signal indicates that the master signaling valid write address and control information.
		M_AXI_AWVALID	: out std_logic;
		-- Write address ready. 
    -- This signal indicates that the slave is ready to accept an address and associated control signals.
		M_AXI_AWREADY	: in std_logic;
		-- Master Interface Write Data Channel ports. Write data (issued by master)
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. 
    -- This signal indicates which byte lanes hold valid data.
    -- There is one write strobe bit for each eight bits of the write data bus.
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		-- Write valid. This signal indicates that valid write data and strobes are available.
		M_AXI_WVALID	: out std_logic;
		-- Write ready. This signal indicates that the slave can accept the write data.
		M_AXI_WREADY	: in std_logic;
		-- Master Interface Write Response Channel ports. 
    -- This signal indicates the status of the write transaction.
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		-- Write response valid. 
    -- This signal indicates that the channel is signaling a valid write response
		M_AXI_BVALID	: in std_logic;
		-- Response ready. This signal indicates that the master can accept a write response.
		M_AXI_BREADY	: out std_logic;
		-- Master Interface Read Address Channel ports. Read address (issued by master)
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. 
    -- This signal indicates the privilege and security level of the transaction, 
    -- and whether the transaction is a data access or an instruction access.
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		-- Read address valid. 
    -- This signal indicates that the channel is signaling valid read address and control information.
		M_AXI_ARVALID	: out std_logic;
		-- Read address ready. 
    -- This signal indicates that the slave is ready to accept an address and associated control signals.
		M_AXI_ARREADY	: in std_logic;
		-- Master Interface Read Data Channel ports. Read data (issued by slave)
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the read transfer.
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is signaling the required read data.
		M_AXI_RVALID	: in std_logic;
		-- Read ready. This signal indicates that the master can accept the read data and response information.
		M_AXI_RREADY	: out std_logic;
		
		water_led_o  : out std_logic_vector(2 downto 0)
		
	);
end Master_myip_v1_0_M00_AXI;

architecture implementation of Master_myip_v1_0_M00_AXI is

	-- function called clogb2 that returns an integer which has the
	-- value of the ceiling of the log base 2
	function clogb2 (bit_depth : integer) return integer is            
	 	variable depth  : integer := bit_depth;                               
	 	variable count  : integer := 1;                                       
	 begin                                                                   
	 	 for clogb2 in 1 to bit_depth loop  -- Works for up to 32 bit integers
	      if (bit_depth <= 2) then                                           
	        count := 1;                                                      
	      else                                                               
	        if(depth <= 1) then                                              
	 	       count := count;                                                
	 	     else                                                             
	 	       depth := depth / 2;                                            
	          count := count + 1;                                            
	 	     end if;                                                          
	 	   end if;                                                            
	   end loop;                                                             
	   return(count);        	                                              
	 end;                                                                    

	-- Example user application signals

	-- TRANS_NUM_BITS is the width of the index counter for
	-- number of write or read transaction..
	 constant  TRANS_NUM_BITS  : integer := clogb2(C_M_TRANSACTIONS_NUM-1);

	-- Example State machine to initialize counter, initialize write transactions, 
	 -- initialize read transactions and comparison of read data with the 
	 -- written data words.
	 type state is ( IDLE, INIT_READ);
	 signal FSM : state ; 

	-- AXI4LITE signals
	--write address valid
	signal axi_awvalid	: std_logic;
	--write data valid
	signal axi_wvalid	: std_logic;
	--read address valid
	signal axi_arvalid	: std_logic;
	--read data acceptance
	signal axi_rready	: std_logic;
	--write response acceptance
	signal axi_bready	: std_logic;
	--write address
	signal axi_awaddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	--write data
	signal axi_wdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
	--read addresss
	signal axi_araddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    --read data
	signal axi_rdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
	--A pulse to initiate a read transaction
	signal start_single_read	: std_logic;
	--flag that marks the completion of read trasactions. The number of read transaction is user selected by the parameter C_M_TRANSACTIONS_NUM
	signal reads_done	: std_logic;
	--Flag is asserted when the read index reaches the last read transction number
	signal init_txn_ff	: std_logic;
	signal init_txn_ff2	: std_logic;
	signal init_txn_pulse	: std_logic;

begin
-- I/O Connections assignments
------------------------------------------------------------------------------------------------WRITE
	--M_AXI_AWADDR	<= std_logic_vector (unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_awaddr));
	M_AXI_AWADDR	<= std_logic_vector (unsigned(C_M_TARGET_SLAVE_BASE_ADDR));
	M_AXI_WDATA	    <= axi_wdata;
	M_AXI_AWPROT	<= "000";
	M_AXI_AWVALID	<= axi_awvalid;
	M_AXI_WVALID	<= axi_wvalid;
	M_AXI_WSTRB	    <= "1111";
	M_AXI_BREADY	<= axi_bready;
------------------------------------------------------------------------------------------------ READ
    -- M_AXI_ARADDR	<= std_logic_vector(unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_araddr));
    M_AXI_ARADDR	<= std_logic_vector(unsigned(C_M_TARGET_SLAVE_BASE_ADDR));
	M_AXI_ARVALID	<= axi_arvalid;
	M_AXI_ARPROT	<= "001";
	M_AXI_RREADY	<= axi_rready;
------------------------------------------------------------------------------------------------ PULSE SIGNAL
	init_txn_pulse	<= ( not init_txn_ff2)  and  init_txn_ff;                                                        
------------------------------------------------------------------------------------------------ TOP_FSM   
--                                    
	  process(M_AXI_ACLK)                                                         
	  begin                                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                                                              
	      if (M_AXI_ARESETN = '0' ) then                                                                                         
	        FSM <= IDLE;                                                                                                                                                                                             
	        start_single_read  <= '0';                                                                                                                                                                                                      
	      else                                                                                          
	        -- state transition                                                                         
	        case (FSM) is                                                                    
	          --                                                                                          
	          when IDLE =>      
                start_single_read <= '0';
	            if ( init_txn_pulse = '1') then    
                  FSM  <= INIT_READ;  
	            else                                                                                    
	              FSM  <= IDLE;                                                      
	            end if;                                                                                 
              --                                                             
	          when INIT_READ =>  
                                                                                                                                          
	            if (reads_done = '1') then                                                              
                    FSM <= IDLE; 
                    start_single_read <= '0';                      
	            else                                                                                    
                    FSM  <= INIT_READ;                                                         
                    if (axi_arvalid = '0' and M_AXI_RVALID = '0' and start_single_read = '0') then                                 
                        start_single_read <= '1';                                                                                                                     
                    else                                                                                  
                        start_single_read <= '0';                            
                    end if;                                                                               
	            end if;                                                                                 
              --                                
	          when others  => NULL;                                                   
	        end case  ;                                                                                 
	      end if;                                                                                       
	    end if;                                                                                         
	  end process;                                                                                      
------------------------------------------------------------------------------------------------
    --Generate a pulse to initiate AXI transaction.
	process(M_AXI_ACLK)                                                          
	begin                                                                             
	  if (rising_edge (M_AXI_ACLK)) then                                              
	      -- Initiates AXI transaction delay        
	    if (M_AXI_ARESETN = '0' ) then                                                
	        init_txn_ff <= '0';                                                   
	        init_txn_ff2 <= '0';                                                          
	    else                                                                                       
	      init_txn_ff <= INIT_AXI_TXN;
	      init_txn_ff2 <= init_txn_ff;                                                                     
	    end if;                                                                       
	  end if;                                                                         
	end process; 
-------------------------------------------------------------------------------------------------
	  process(M_AXI_ACLK)                                                              
	  begin                                                                            
	    if (rising_edge (M_AXI_ACLK)) then                                             
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                               
                axi_rdata <= (others => '0');                                             
	      else                                                                         
	        if (start_single_read = '1') then                                          
                axi_rdata <= M_AXI_RDATA;              
	        end if;                                                                    
	      end if;                                                                      
	    end if;                                                                        
	  end process;    
      water_led_o <= axi_rdata(2 downto 0);      
------------------------------------------------------------------------------------------------	                                                                                                                                                   
	  process(M_AXI_ACLK)                                                              
	  begin                                                                            
	    if (rising_edge (M_AXI_ACLK)) then                                             
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                               
	        axi_arvalid <= '0';                                                        
	      else                                                                         
	        if (start_single_read = '1') then                                                   
	          axi_arvalid <= '1';                                                      
	        elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then                     
	          axi_arvalid <= '0';                                                      
	        end if;                                                                    
	      end if;                                                                      
	    end if;                                                                        
	  end process;                                                                     
------------------------------------------------------------------------------------------------
	  process(M_AXI_ACLK)                                             
	  begin                                                                 
	    if (rising_edge (M_AXI_ACLK)) then                                  
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                    
	        axi_rready <= '1';                                              
	      else                                                              
	        if (M_AXI_RVALID = '1' and axi_rready = '0') then                                   
	          axi_rready <= '1';                                            
	        elsif (axi_rready = '1') then                                                              
	          axi_rready <= '0';                                            
	        end if;                                                         
	      end if;                                                           
	    end if;                                                             
	  end process;  
------------------------------------------------------------------------------------------------
    process(M_AXI_ACLK)                                                                               
      begin                                                                                             
        if (rising_edge (M_AXI_ACLK)) then                                                              
          if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                                
            reads_done <= '0';                                                                          
          else                                                                                          
            if (M_AXI_RVALID = '1' and axi_rready = '1') then                                           
              reads_done <= '1';                                                                        
            end if;                                                                                     
          end if;                                                                                       
        end if;                                                                                         
      end process; 
end implementation;
