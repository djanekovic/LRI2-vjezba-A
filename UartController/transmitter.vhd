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
	w_done: 	out std_logic := '1');
end transmitter;

architecture Behavioral of transmitter is
	type state is (idle, start, transmit, stop);
	signal curr_state, next_state : state := idle;
	signal cnt: integer range 0 to 15 := 0;
	signal b_i : integer range 0 to 7 := 0;
	signal prev_tick: std_logic:='0';
	signal w_done_next: std_logic:='1';
	

begin
	process(w_start, curr_state, clk, rst) 
	begin
	if (rst = '1') then
		cnt <= 0;
		curr_state <= idle;
		b_i <= 0;
		w_done <= '1';
		tx <= '1';
		
	elsif (w_start='1' and w_done_next='1') then 
		w_done_next <= '0';
		next_state<=start;
		
	elsif rising_edge(clk) then
		curr_state <= next_state;
		w_done <= w_done_next;
		prev_tick <= tick;
		
		case curr_state is
			when idle =>
				tx <= '1';
				-- ako je stavljen podatak na w_data, idemo u start stanje
				if (prev_tick='0' and tick='1') then
					if (w_start = '1') then 
						next_state <= start;
						w_done_next <= '0';
						cnt <= 0;
					end if;
				end if;
				
			when start =>
				-- salje se start bit
				tx <= '0';	
				b_i <= 0;
				if (prev_tick='0' and tick='1') then
					if cnt < 15 then
						cnt <= cnt +1;					
					elsif cnt = 15 then
						next_state <= transmit;
						cnt <= 0;					
					end if;
				end if;
				
			when transmit =>			
					tx <= w_data(b_i);
					if (prev_tick='0' and tick='1') then
						if ((cnt = 15) and (b_i = 7))then					
							next_state <= stop;
							cnt <= 0;
						elsif cnt = 15 then
							b_i <= b_i + 1;
							cnt <= 0;
						else 
							cnt <= cnt + 1;
						end if;
					end if;
				
			when stop =>
					b_i <= 0;
					tx <= '1';		-- stop bit
					w_done <= '1';
					if (prev_tick='0' and tick='1') then
						if (cnt = 15) then											
							next_state <= idle;
						else
							cnt <= cnt + 1;
						end if;
					end if;

			when others =>
				null;
		end case;
		end if;
	end process;
	

end Behavioral;
