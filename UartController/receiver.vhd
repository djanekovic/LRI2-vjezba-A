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
	signal prev_tick: std_logic:='0';
	signal cnt: integer range 0 to 15;
	signal b_i: integer range 0 to 7 := 0;
	signal rx_start: std_logic:='1';
	signal prev_rx: std_logic;
	
begin

	process(rx,curr_state, clk, rst)
	begin
	if (rst = '1') then
		cnt <= 0;
		curr_state <= idle;
		b_i <= 0;
		r_done <= '0';
		r_data <=(others => '0');
		
	--samo prvi put preskacemo idle jer idemo odmah u start cim dode rx iz 1 u 0	
	elsif (rx='0' and rx_start='1' and prev_rx='1') then 
		rx_start<='0';
		next_state<=start;
		cnt <= 0;
		r_done <= '0';
	
	elsif (rising_edge(clk)) then
		curr_state <= next_state;
		prev_tick<=tick;
		prev_rx<=rx;
		case curr_state is
			when idle =>
				-- ako smo dobiti rx = 0 onda idemo u stanje start gdje citamo start bit				

				
			when start =>
				
				if (prev_tick='0' and tick='1') then
					-- procitao si rx = 0 odnosno procitao si start bit i mozemo citati bajt
					if ((cnt = 7) and (rx = '0')) then
						b_i <= 0;
						cnt <= 0;
						next_state <= recv;
					-- na ulazu je bila neka kratka promjena i zapravo nemamo start bit
					elsif ((cnt  = 7) and (rx = '1')) then
						next_state <= idle;
						cnt <= 0;
					else
						cnt <= cnt + 1;
					end if;
				end if;   
			when recv =>
				if (prev_tick='0' and tick='1') then
					-- procitao sam cijeli bajt, idemo procitati stop bit
					if ((cnt = 15) and (b_i = 7)) then
						r_data(b_i) <= rx;
						cnt <= 0;
						next_state <= stop;
					-- procitao bajt, idemo procitati jos jedan
					elsif cnt = 15 then
						r_data(b_i) <= rx;
						b_i <= b_i + 1;
						cnt <= 0;
					else
						cnt <= cnt + 1;
					end if;
				end if;
			when stop =>
				if (prev_tick='0' and tick='1') then
					-- ovdje trebamo procitati stop bit
					-- ako ne procitam stop bit, bacam cijeli bajt u smece
					b_i <= 0;
					if ((cnt = 15) and (rx = '1')) then
						r_done <= '1';
						next_state <= idle;
						--spremamo se za novo citanje i novi prijelaz iz 1 u 0
						rx_start<='1';
					elsif ((cnt  = 15) and (rx = '0')) then
						next_state <= idle;
						rx_start<='1';
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
