library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RFN_Module_tb is
end RFN_Module_tb;

architecture Behavioral of RFN_Module_tb is

component reversePolishNotation is
generic(
RAM_WIDTH : integer := 8;
RAM_DEPTH : integer := 16;
RAM_PERFORMANCE : string 	:= "LOW_LATENCY"
);
port(
clk : in std_logic;
rst : in std_logic;
dIn : in std_logic;
dOut : out std_logic
);
end component;

-- Signals
signal clk   : std_logic;
signal rst   : std_logic;
signal dIn   : std_logic;
signal dOut  : std_logic;



begin

UUT : reversePolishNotation 
generic map(
RAM_WIDTH => 8,
RAM_DEPTH => 16,
RAM_PERFORMANCE => "LOW_LATENCY"
)
port map(
clk  => clk,
rst  => rst,
dIn  => dIn,
dOut => dOut
);



--clock stimulus
 clk_process: process
	begin
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
 end process;


 process
begin
-- For Write Operation at least 11 Clock is required so it must be 220 ns for operation here
rst<='1';
wait for  20 ns;
-- Write 11100000 = E0 to BRAM
rst <='0';
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 120 ns;
-- Write 01100000 = 60 to BRAM 
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 120 ns;
-- Write 00110101 = 35 to BRAM 
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;		
dIn <= '0';
wait for 20 ns;
-- Write 00000111 = 07 to BRAM 
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;		
dIn <= '0';
wait for 20 ns;
-- Write 00000010 = 02 to BRAM 
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;		
dIn <= '0';
wait for 20 ns;
-- Write 00000100 = 04 to BRAM 
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;		
dIn <= '0';
wait for 20 ns;
-- Multiplication Operation 1101
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 200 ns;
-- Addition Operation 1101
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 120 ns;
-- Write 00011111 = 1F to BRAM 
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;		
dIn <= '0';
wait for 20 ns;
-- Check Operation 1111
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 200 ns;
-- Clear BRAM 1100
dIn <= '1';
wait for 20 ns;
dIn <= '1';
wait for 20 ns;
dIn <= '0';
wait for 20 ns;
dIn <= '0';

wait;
end process;

end Behavioral;