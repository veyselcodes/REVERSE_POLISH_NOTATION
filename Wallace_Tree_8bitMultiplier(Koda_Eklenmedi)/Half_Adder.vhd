library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity half_adder is
	port ( 
		a	  : in STD_LOGIC;
		b 	  : in STD_LOGIC;
		sum   : out STD_LOGIC;
		carry : out STD_LOGIC);
end half_adder;

architecture arch of half_adder is
begin
	sum <= a xor b;
	carry <= a and b;
end arch;