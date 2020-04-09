----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:07:08 04/07/2020 
-- Design Name: 
-- Module Name:    UartController - Behavioral 
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
library work;
use work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UartController is PORT(
	clk: in std_logic;
	rst: in std_logic;
	rx: in std_logic;
	w_start: in std_logic;
	w_data: in std_logic_vector;
	tx: out std_logic;
	w_done: out std_logic;
	r_done: out std_logic;
	r_data: out std_logic_vector);
end UartController;

architecture Behavioral of UartController is
	signal clk, rst, rx, w_start, w_done, r_done, tx: std_logic;
	signal w_data, r_data: std_logic_vector;
	
begin


end Behavioral;

