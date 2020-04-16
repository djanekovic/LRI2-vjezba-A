--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:20:15 04/07/2020
-- Design Name:   
-- Module Name:   Z:/LRI2-vjezba-A/UartController/receiver_tb.vhd
-- Project Name:  UartController
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: receiver
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
 
ENTITY receiver_tb IS
END receiver_tb;
 
ARCHITECTURE behavior OF receiver_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT receiver
    PORT(
         rx : IN  std_logic;
         clk : IN  std_logic;
         tick : IN  std_logic;
         rst : IN  std_logic;
         r_data : OUT  std_logic_vector(7 downto 0);
         r_done : OUT  std_logic);
    END COMPONENT;
    

   --Inputs
   signal rx : std_logic := '1';
   signal clk : std_logic := '0';
   signal tick : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal r_data : std_logic_vector(7 downto 0);
   signal r_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant tick_period: time := clk_period * 170;
   constant rx_period: time := tick_period * 16;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: receiver PORT MAP (
          rx => rx,
          clk => clk,
          tick => tick,
          rst => rst,
          r_data => r_data,
          r_done => r_done);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

	tick_process: process
	begin
		tick <= '0';
		wait for tick_period/2;
		tick <= '1';
		wait for tick_period/2;
	end process;

	rx_process: process
	begin
		rx <= '1';
		wait for 4 * rx_period;
		rx <= '0';
		wait for 1 * rx_period;
		rx <= '1';
		wait for 1 * rx_period;
		rx <= '0';
		wait for 2 * rx_period;
		rx <= '1';
		wait for 1 * rx_period;
		rx <= '0';
		wait for 1 * rx_period;
		rx <= '1';
		wait for 2 * rx_period;
		rx <= '0';
		wait for 1 * rx_period;
		rx <= '1';
		wait for 3 * rx_period;
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;