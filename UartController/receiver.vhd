----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:36:00 04/07/2020 
-- Design Name: 
-- Module Name:    receiver - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver is PORT (
	rx: in std_logic;
	clk: in std_logic;
	tick: in std_logic;
	rst: in std_logic;
	r_dataa: out std_logic_vector(7 downto 0);
	r_done: out std_logic);
end receiver;

architecture Behavioral of receiver is
	type state is (idle, start, start_ck, recv);
	signal curr_state, next_state : std_logic;
	signal cnt : integer range 0 to 15 := 0;
	signal b_i : integer range 0 to 7 := 0;
begin

	process(rx, cnt, b_i, state)
	begin
		case state is
			when idle =>
				if rx = 0 then
					next_state <= start;
					cnt <= 0;
				end if;
			when start =>
				if cnt < 7 then
					next_state <= start;
					cnt <= cnt + 1;
				elsif cnt = 7 then
					next_state <= startk_ck;
					cnt <= 0;
				end if;
			when start_ck =>
				if rx = 1 then
					next_state <= idle;
				else
					next_state <= recv;
					cnt <= 0;
					b_i <= 0;
				end if;
			when recv =>
				if cnt < 15 then
					cnt <= ctn + 1;
				elsif cnt = 15 then
					r_data(b_i) <= rx;
					b_i <= b_i + 1;
					cnt <= 0;
				elsif ((cnt = 15) and (b_i = 7)) then
					r_data <= 1;
					next_state <= idle;
				end if;
			when others =>
				null;
		end case;
	end process;

	process(clk, rst)
	begin
		if rising_edge(clk) then
			curr_state <= next_state;
		elsif reset = '1' then
			stanje <= idle;
		end if;
	end process;

end Behavioral;

