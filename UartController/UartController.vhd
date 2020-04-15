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
	tx: out std_logic;
	r_data: out std_logic_vector(7 downto 0);
	r_done: out std_logic;
	w_data: in std_logic_vector(7 downto 0);
	w_start: in std_logic;
	w_done: out std_logic
);
end UartController;

architecture Behavioral of UartController is
	
	component transmitter is
		port(
			clk: 		in std_logic;
			rst: 		in std_logic;
			tick: 		in std_logic;
			w_data: 	in std_logic_vector(7 downto 0);
			w_start: 	in std_logic;
			tx: 		out std_logic;
			w_done: 	out std_logic
		);
	end component;
	
	component receiver is
		port(
			rx: in std_logic;
			clk: in std_logic;
			tick: in std_logic;
			rst: in std_logic;
			r_data: out std_logic_vector(7 downto 0) := (others => '0');
			r_done: out std_logic := '0'
		);
	end component;
	
	component baud_rate_generator is
		port(
			clk: in std_logic;
			rst: in std_logic;
			tick: out std_logic
		);
	end component;
	
	signal tick: std_logic;
begin
	-- ovako ne znam jel tocno ili ne, ali moja logika je, ako zelimo testirati reciever i transmitter (pise u vjezbi da radimo preko rx linije)
	-- za to nam trebaju 3 dodatna signala DATA, TICK, DONE
	-- ne vjerujem da ne postoje blok komentari na netu
	-- ideja: dovedemo neki testni niz na RX, kada reciever primi sve podatke on ih posalje na DATA te postavi DONE u 1
	-- TX_START pove�emo na DONE tj cim se RX_DONE prebaci u 1 automatski pokrece na� transmitter koji za 
	-- svoj input uzima isto ono �to je reciever primio tj. DATA i prosljeduje ga na TX
	-- time testiramo i reciever da dobro prima i transmitter koji isti taj podatak �alje "u prazno"
	
	--znaci u TEST-BENCH radimo samo rx='0' , after 10ns rx='1' itd itd i naravno 1 reset za probu
	--test bench krenem radit kada se testira transmitter
	
	--ovakav pristup na ostavlja neke pinove od UARTA u zraku, ne znam mo�e li se staviti na kraj koda nesto tipa r_done<=done, w_done<=
	
	trans: component transmitter port map(
										clk=>clk,
										rst=>rst,
										tick=>tick,
										w_data=>w_data,
										w_start=>w_start,
										tx=>tx,
										w_done=>w_done											
										);
										
	rec: component receiver port map(
										rx=>rx,
										clk=>clk,
										tick=>tick,
										rst=>rst,
										r_data=>r_data,
										r_done=>r_done
										);									
	
	baud_generator: component baud_rate_generator port map(
										clk=>clk,
										rst=>rst,
										tick=>tick
										);
end Behavioral;