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
	r_data: out std_logic_vector(7 downto 0) := (others => '0');
	r_done: out std_logic := '0');
end receiver;

architecture Behavioral of receiver is
	type state is (idle, start, recv);
	signal curr_state, next_state : state := idle;
	signal r_data_next: std_logic_vector(7 downto 0) := (others => '0');
	signal r_done_next: std_logic := '0';
	signal cnt_enable : std_logic := '0';
	signal cnt, next_cnt: integer range 0 to 15;
	signal b_i, next_b_i : integer range 0 to 7 := 0;
begin

	process(rx, tick, curr_state)
	begin
		next_state <= curr_state;
		case curr_state is
			when idle =>
				r_done_next <= '0';
				if rx = '0' then
					next_cnt <= 0;
					cnt_enable <= '1';
					next_state <= start;
				end if;
			when start =>
				if rising_edge(tick) then
					if ((cnt = 7) and (rx = '0')) then
						next_b_i <= 0;
						next_cnt <= 0;
						next_state <= recv;
					elsif ((cnt  = 7) and (rx = '1')) then
						cnt_enable <= '0';
						next_state <= idle;
						next_cnt <= 0;
					else
						next_cnt <= cnt + 1;
					end if;
				end if;
			when recv =>
				if rising_edge(tick) then
					if ((cnt = 15) and (b_i = 7)) then
						r_done_next <= '1';
						cnt_enable <= '0';
						next_state <= idle;
					elsif cnt = 15 then
						r_data_next(b_i) <= rx;
						next_b_i <= b_i + 1;
						next_cnt <= 0;
					else
						next_cnt <= cnt + 1;
					end if;
				end if;
			when others =>
				null;
		end case;
	end process;

	process(clk, rst)
	begin
		if rising_edge(clk) then
			curr_state <= next_state;
			r_data <= r_data_next;
			r_done <= r_done_next;
			b_i <= next_b_i;
			cnt <= next_cnt;
		elsif rst = '1' then
			curr_state <= idle;
		end if;
	end process;

end Behavioral;

