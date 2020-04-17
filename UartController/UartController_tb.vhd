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
 
    COMPONENT UartController PORT(
		clk: in std_logic;
		rst: in std_logic;
		rx: in std_logic;
		w_data: in std_logic_vector(7 downto 0);
		w_start: in std_logic;
		tx: out std_logic;
		r_data: out std_logic_vector(7 downto 0);
		r_done: out std_logic;
		w_done: out std_logic);
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rx : std_logic := '0';
	signal w_data: std_logic_vector(7 downto 0) := (others => '0');
   signal w_start : std_logic := '0';

 	--Outputs
   signal tx : std_logic := '0';
   signal w_done : std_logic := '0';
   signal r_done : std_logic := '0';
   signal r_data : std_logic_vector(7 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant rx_period: time:= clk_period*176*16*2;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UartController PORT MAP (
        clk => clk,
        rst => rst,
        rx => rx,
		tx => tx,
        r_data => w_data,
		r_done => w_start,
		w_data => w_data,
        w_start => w_start,
		w_done => w_done);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	rst <= '0', '1' after 1.2ms;
	rx<='1', '0' after rx_period , '1' after 2*rx_period, '0' after 3*rx_period, '0' after 4*rx_period, '0' after 5*rx_period, '1' after 6*rx_period, '1' after 7*rx_period, '0' after 8*rx_period, '1' after 9*rx_period, '1' after 10*rx_period;
				--start					  D0							 D1							D2							  D3							 D4							D5							  D6									D7						  STOP	
   -- 1-idle 0-start  "10001101" 1-stop
	-- r_data="10110001"				
END;
