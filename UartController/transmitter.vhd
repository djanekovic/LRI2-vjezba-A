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


begin
	process(w_start, tick, rst, curr_state) 
	begin
	if (rst = '1') then
		cnt <= 0;
		curr_state <= idle;
		b_i <= 0;
		w_done <= '1';
		tx <= '1';
		
	else
		curr_state <= next_state;
		
		case curr_state is
			when idle =>
				tx <= '1';
				-- ako je stavljen podatak na w_data i ako je transmitter slobodan, idemo u start stanje
				if (w_start = '1') then -- uvijek udje jer u testbenchu ne mogu promijeniti w_start
					next_state <= start;
					w_done <= '0';
					cnt <= 0;
					tx <= '0';
					--w_data_next <= w_data;
				end if;
			when start =>
				-- salje se start bit
				tx <= '0';	
				if rising_edge(tick) then
					if cnt < 15 then
						cnt <= cnt +1;					
					elsif cnt = 15 then
						next_state <= transmit;
						cnt <= 0;
						b_i <= 0;
					end if;
				end if;
			when transmit =>	
				tx <= w_data(b_i);
				if rising_edge(tick) then				
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
					if rising_edge(tick) then
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
