--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:44:28 04/10/2020
-- Design Name:   
-- Module Name:   C:/Users/ivan/workspace-lri2/UartController/transmitter_tb.vhd
-- Project Name:  UartController
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: transmitter
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
 
ENTITY transmitter_tb IS
END transmitter_tb;
 
ARCHITECTURE behavior OF transmitter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT transmitter
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         tick : IN  std_logic;
         w_data : IN  std_logic_vector(7 downto 0);
         w_start : IN  std_logic;
         tx : OUT  std_logic;
         w_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal tick : std_logic := '0';
   signal w_data : std_logic_vector(7 downto 0) := (others => '0');
   signal w_start : std_logic := '0';

 	--Outputs
   signal tx : std_logic;
   signal w_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
			constant tick_period: time := clk_period * 170;
			constant tx_period: time := tick_period * 16;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: transmitter PORT MAP (
          clk => clk,
          rst => rst,
          tick => tick,
          w_data => w_data,
          w_start => w_start,
          tx => tx,
          w_done => w_done
        );

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
 
	tx_process: process
	begin
		w_data <= "00001111";
		w_start <= '1';
		wait for 16 * 4 * tx_period;
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
