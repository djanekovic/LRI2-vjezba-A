--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:04:40 04/11/2020
-- Design Name:   
-- Module Name:   C:/Users/Martin/LRI2/UART_top_level_test/UartController_tb.vhd
-- Project Name:  UART_top_level_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UartController
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UartController_tb IS
END UartController_tb;
 
ARCHITECTURE behavior OF UartController_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UartController
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         rx : IN  std_logic;
         w_start : IN  std_logic;
         tx : OUT  std_logic;
         w_done : OUT  std_logic;
         r_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rx : std_logic := '0';
   signal w_start : std_logic := '0';

 	--Outputs
   signal tx : std_logic;
   signal w_done : std_logic;
   signal r_done : std_logic:='0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant rx_period: time:= clk_period*176*16*2;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UartController PORT MAP (
          clk => clk,
          rst => rst,
          rx => rx,
          w_start => w_start,
          tx => tx,
          w_done => w_done,
          r_done => r_done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	
   rx<='1', '0' after rx_period , '1' after 2*rx_period, '0' after 3*rx_period, '0' after 4*rx_period, '0' after 5*rx_period, '1' after 6*rx_period, '1' after 7*rx_period, '0' after 8*rx_period, '1' after 9*rx_period, '1' after 10*rx_period;
				--start					  D0							D1							D2								D3							D4							     D5							D6							    D7								STOP							
END;


