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
	w_done: 	out std_logic
	);
end transmitter;

architecture Behavioral of transmitter is
	type state is (idle, start, transmit);
	signal curr_state, next_state : std_logic;
	signal cnt : integer range 0 to 15 := 0;
	signal b_i : integer range 0 to 7 := 0;
	--w_done := 1; idle // kako staviti pocetne vrijednosti
	--tx := 1; idle

begin
	process(w_start, b_i, state, tick) --tick umjesto cnt?, mozda w_start ne treba
	begin
		case state is
			when idle =>
				if ((w_start = 1) and (w_done = 1)) then -- dogovor
					next_state <= start;
					w_done <= 0;
					cnt <= 0;
				end if;
			when start =>
				if cnt < 7 then
					next_state <= start;
					cnt <= cnt +1;
				elsif cnt = 7 then
					tx <= 0;				-- start bit
					next_state <= transmit;
					cnt <= 0;
				end if;			
			when transmit =>
				if cnt < 15 then
					cnt <= cnt +1;
				elsif cnt = 15 then
					tx <= w_data(b_i);
					b_i <= b_i + 1;
					cnt <= 0;
				elsif ((cnt = 15) and (b_i = 7)) then -- 8?
					tx <= 1; 			-- stop bit
					w_done <= 1;
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
			curr_state <= idle;
		end if;
	end process;

end Behavioral;
