----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:19:02 04/07/2020 
-- Design Name: 
-- Module Name:    baud_rate_generator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity baud_rate_generator is port(
		clk: in std_logic;
		rst: in std_logic;
		tick: out std_logic);
end baud_rate_generator;

architecture Behavioral of baud_rate_generator is
	signal counter: std_logic_vector(7 downto 0) := (others => '0');
	signal tmp: std_logic := '0';
begin
	
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst='1' then
				tmp <= '0';
				counter <= (others => '0');
			else
				counter <= counter + '1';
				if counter = "10110000" then
					tmp <= not tmp;
					counter <= (others => '0');
				end if;
			end if;
		end if;
	end process;
	
	tick <= tmp;
end Behavioral;
