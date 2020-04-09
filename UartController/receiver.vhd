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
	type state is (idle, start, recv, stop);
	signal curr_state, next_state : state := idle;
	signal r_data_next: std_logic_vector(7 downto 0) := (others => '0');
	signal r_done_next: std_logic := '0';
	signal cnt, next_cnt: integer range 0 to 15;
	signal b_i, next_b_i : integer range 0 to 7 := 0;
begin

	process(rx, tick, curr_state)
	begin
		next_state <= curr_state;
		case curr_state is
			when idle =>
				-- ako smo dobiti rx = 0 onda idemo u stanje start gdje citamo start bit
				if rx = '0' then
					r_done_next <= '0';	-- TODO: Treba li r_done biti trajanja clocka ili duze
					next_cnt <= 0;
					next_state <= start;
				end if;
			when start =>
				-- TODO: mozda se ovo ne mora raditi ali cini mi se krivo ako se koristi tick = 1
				-- u stanju start se moramo sinkronizirati na rising_edge(tick)
				if rising_edge(tick) then
					-- procitao si rx = 0 odnosno procitao si start bit i mozemo citati bajt
					if ((cnt = 7) and (rx = '0')) then
						next_b_i <= 0;
						next_cnt <= 0;
						next_state <= recv;
					-- na ulazu je bila neka kratka promjena i zapravo nemamo start bit
					elsif ((cnt  = 7) and (rx = '1')) then
						next_state <= idle;
						next_cnt <= 0;
					else
						next_cnt <= cnt + 1;
					end if;
				end if;
			when recv =>
				-- opet smo sinkronizirani na rising edge od tick
				if rising_edge(tick) then
					-- procitao sam cijeli bajt, idemo procitati stop bit
					-- TODO: Hendlaj sve brojeve kroz constant
					if ((cnt = 15) and (b_i = 7)) then
						r_data_next(b_i) <= rx;
						next_cnt <= 0;
						next_state <= stop;
					-- procitao bajt, idemo procitati jos jedan
					elsif cnt = 15 then
						r_data_next(b_i) <= rx;
						next_b_i <= b_i + 1;
						next_cnt <= 0;
					else
						next_cnt <= cnt + 1;
					end if;
				end if;
			when stop =>
				-- ovdje trebamo procitati stop bit
				-- ako ne procitam stop bit, bacam cijeli bajt u smece
				if rising_edge(tick) then
					if ((cnt = 15) and (rx = '1')) then
						r_done_next <= '1';
						next_state <= idle;
					elsif ((cnt  = 15) and (rx = '0')) then
						next_state <= idle;
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

