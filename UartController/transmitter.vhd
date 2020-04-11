----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:00:50 04/07/2020 
-- Design Name: 
-- Module Name:    transmitter - Behavioral 
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

entity transmitter is PORT (
	clk: 		in std_logic;
	rst: 		in std_logic;
	tick: 	in std_logic;
	w_data: 	in std_logic_vector(7 downto 0);
	w_start: in std_logic;
	tx: 		out std_logic;
	w_done: 	out std_logic);
end transmitter;

architecture Behavioral of transmitter is
	type state is (idle, start, transmit, stop);
	signal curr_state, next_state : state := idle;
	signal cnt, next_cnt : integer range 0 to 15 := 0;
	signal b_i, next_b_i : integer range 0 to 7 := 0;
	signal tx_next: std_logic := '1';
	signal w_done_next: std_logic := '1';
	signal w_data_next: std_logic_vector(7 downto 0);
	--tx := 1; idle

begin
	process(curr_state, tick) -- mozda w_start ne treba
	begin
		next_state <= curr_state;
		case curr_state is
			when idle =>
				-- ako je stavljen podatak na w_data i ako je transmitter slobodan, idemo u start stanje
				if ((w_start = '1') and (w_done_next = '1')) then -- uvijek udje jer u testbenchu ne mogu promijeniti w_start
					next_state <= start;
					w_done_next <= '0';
					next_cnt <= 0;
					w_data_next <= w_data;
				end if;
			when start =>
				-- salje se start bit
				if rising_edge(tick) then
					if cnt < 7 then
						--next_state <= start;
						next_cnt <= cnt +1;
					elsif cnt = 7 then
						tx_next <= '0';				-- start bit
						next_state <= transmit;
						next_cnt <= 0;
					end if;
				end if;
			when transmit =>
				if rising_edge(tick) then
					if ((cnt = 15) and (b_i = 7))then					
						tx_next <= w_data_next(b_i);
						next_state <= stop;
					elsif cnt = 15 then
						tx_next <= w_data_next(b_i);
						next_b_i <= b_i + 1;
						next_cnt <= 0;
					else 
						next_cnt <= cnt + 1;
					end if;
				end if;
			when stop =>
				if rising_edge(tick) then
					if cnt = 15 then						
						tx_next <= '1'; 			-- stop bit
						w_done_next <= '1';
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
			cnt <= next_cnt;
			b_i <= next_b_i;
			w_done <= w_done_next;
			tx <= tx_next;
		elsif rst = '1' then
			curr_state <= idle;
		end if;
	end process;

end Behavioral;

