library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity full_adder is
	port ( a : in STD_LOGIC;
		   b : in STD_LOGIC;
		   c : in STD_LOGIC;
		   sum : out STD_LOGIC;
		   carry : out STD_LOGIC
		  );
end full_adder;

architecture Behavioral of full_adder is
begin

	sum <= (a xor b xor c);
	carry <= (a and b) xor (c and (a xor b));
	
end Behavioral;