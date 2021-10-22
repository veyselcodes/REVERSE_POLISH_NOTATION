
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity wallace_8x8 is
	port ( 
			A_in   : in std_logic_vector(7 downto 0);
			B_in   : in std_logic_vector(7 downto 0);
			result : out std_logic_vector(15 downto 0)
		  );
end wallace_8x8;

architecture arch of wallace_8x8 is
-- FA Component
component full_adder is
port (
	   a 	 : in std_logic;
	   b 	 : in std_logic;
	   c 	 : in std_logic;
	   sum   : out std_logic;
	   carry : out std_logic
	);
end component;

-- HA Component
component half_adder is
port ( 
	   a 	 : in std_logic;
	   b 	 : in std_logic;
	   sum 	 : out std_logic;
	   carry : out std_logic
	);
end component;

-- Product of Partials
signal p0	: std_logic_vector(7 downto 0);
signal p1	: std_logic_vector(7 downto 0);
signal p2	: std_logic_vector(7 downto 0);
signal p3	: std_logic_vector(7 downto 0);
signal p4	: std_logic_vector(7 downto 0);
signal p5	: std_logic_vector(7 downto 0);
signal p6	: std_logic_vector(7 downto 0);
signal p7	: std_logic_vector(7 downto 0);

-- Internal Signals:
signal s11,s12,s13,s14,s15, s16, s17, s18, s19, s110, s111, s112, s113, s114, s115, s116, s117, s118, s21,s22,s23,s24,s25, s26, s27, s28, s29, s210, s211, s212, s213, s214, s215, s216, s217, s31, s32, s33, s34, s35, s36, s37, s38, s39, s310, s311, s312, s41, s42, s43, s44, s45, s46, s47, s48, s49, s410, s411, s412: std_logic;
signal c11,c12,c13,c14,c15, c16, c17, c18, c19, c110, c111, c112, c113, c114, c115, c116, c117, c118, c21,c22,c23,c24,c25, c26, c27, c28, c29, c210, c211, c212, c213, c214, c215, c216, c217, c31, c32, c33, c34, c35, c36, c37, c38, c39, c310, c311, c312, c41, c42, c43, c44, c45, c46, c47, c48, c49, c410, c411, c412: std_logic;

-- Final Line:
signal adder_line1	: std_logic_vector(15 downto 0);
signal adder_line2 : std_logic_vector(15 downto 0);

begin

-- Product of Partials Generation:
p0(0) <= A_in(0) and B_in(0);
p1(0) <= A_in(0) and B_in(1);
p2(0) <= A_in(0) and B_in(2);
p3(0) <= A_in(0) and B_in(3);
p4(0) <= A_in(0) and B_in(4);
p5(0) <= A_in(0) and B_in(5);
p6(0) <= A_in(0) and B_in(6);
p7(0) <= A_in(0) and B_in(7);
--
p0(1) <= A_in(1) and B_in(0);
p1(1) <= A_in(1) and B_in(1);
p2(1) <= A_in(1) and B_in(2);
p3(1) <= A_in(1) and B_in(3);
p4(1) <= A_in(1) and B_in(4);
p5(1) <= A_in(1) and B_in(5);
p6(1) <= A_in(1) and B_in(6);
p7(1) <= A_in(1) and B_in(7);
--
p0(2) <= A_in(2) and B_in(0);
p1(2) <= A_in(2) and B_in(1);
p2(2) <= A_in(2) and B_in(2);
p3(2) <= A_in(2) and B_in(3);
p4(2) <= A_in(2) and B_in(4);
p5(2) <= A_in(2) and B_in(5);
p6(2) <= A_in(2) and B_in(6);
p7(2) <= A_in(2) and B_in(7);
--
p0(3) <= A_in(3) and B_in(0);
p1(3) <= A_in(3) and B_in(1);
p2(3) <= A_in(3) and B_in(2);
p3(3) <= A_in(3) and B_in(3);
p4(3) <= A_in(3) and B_in(4);
p5(3) <= A_in(3) and B_in(5);
p6(3) <= A_in(3) and B_in(6);
p7(3) <= A_in(3) and B_in(7);
--
p0(4) <= A_in(4) and B_in(0);
p1(4) <= A_in(4) and B_in(1);
p2(4) <= A_in(4) and B_in(2);
p3(4) <= A_in(4) and B_in(3);
p4(4) <= A_in(4) and B_in(4);
p5(4) <= A_in(4) and B_in(5);
p6(4) <= A_in(4) and B_in(6);
p7(4) <= A_in(4) and B_in(7);
--
p0(5) <= A_in(5) and B_in(0);
p1(5) <= A_in(5) and B_in(1);
p2(5) <= A_in(5) and B_in(2);
p3(5) <= A_in(5) and B_in(3);
p4(5) <= A_in(5) and B_in(4);
p5(5) <= A_in(5) and B_in(5);
p6(5) <= A_in(5) and B_in(6);
p7(5) <= A_in(5) and B_in(7);
--
p0(6) <= A_in(6) and B_in(0);
p1(6) <= A_in(6) and B_in(1);
p2(6) <= A_in(6) and B_in(2);
p3(6) <= A_in(6) and B_in(3);
p4(6) <= A_in(6) and B_in(4);
p5(6) <= A_in(6) and B_in(5);
p6(6) <= A_in(6) and B_in(6);
p7(6) <= A_in(6) and B_in(7);
--
p0(7) <= A_in(7) and B_in(0);
p1(7) <= A_in(7) and B_in(1);
p2(7) <= A_in(7) and B_in(2);
p3(7) <= A_in(7) and B_in(3);
p4(7) <= A_in(7) and B_in(4);
p5(7) <= A_in(7) and B_in(5);
p6(7) <= A_in(7) and B_in(6);
p7(7) <= A_in(7) and B_in(7);

-- process(A_in, B_in)
-- begin
	-- for i in 0 to 7 loop
		-- p0(i) <= A_in(i) and B_in(0);
		-- p1(i) <= A_in(i) and B_in(1);
		-- p2(i) <= A_in(i) and B_in(2);
		-- p3(i) <= A_in(i) and B_in(3);
	-- end loop;
-- end process;

-- First Stage:
ha1: half_adder port map (a => p0(1), b => p1(0), sum => s11, carry => c11);
fa1: full_adder port map (a => p0(2), b => p1(1), c => p2(0), sum => s12, carry => c12);
fa2: full_adder port map (a => p0(3), b => p1(2), c => p2(1), sum => s13, carry => c13);
fa3: full_adder port map (a => p0(4), b => p1(3), c => p2(2), sum => s14, carry => c14);
fa4: full_adder port map (a => p0(5), b => p1(4), c => p2(3), sum => s15, carry => c15);
fa5: full_adder port map (a => p0(6), b => p1(5), c => p2(4), sum => s16, carry => c16);
fa6: full_adder port map (a => p0(7), b => p1(6), c => p2(5), sum => s17, carry => c17);
fa7: full_adder port map (a => p1(7), b => p2(6), c => p3(5), sum => s18, carry => c18);
fa8: full_adder port map (a => p2(7), b => p3(6), c => p4(5), sum => s19, carry => c19);
fa9: full_adder port map (a => p3(7), b => p4(6), c => p5(5), sum => s110, carry => c110);
fa10: full_adder port map (a => p4(7), b => p5(6), c => p6(5), sum => s111, carry => c111);
fa11: full_adder port map (a => p5(7), b => p6(6), c => p7(5), sum => s112, carry => c112);
ha2: half_adder port map (a => p6(7), b => p7(6), sum => s113, carry => c113);
fa12: full_adder port map (a => p3(2), b => p4(1), c => p5(0), sum => s114, carry => c114);
fa13: full_adder port map (a => p3(3), b => p4(2), c => p5(1), sum => s115, carry => c115);
fa14: full_adder port map (a => p3(4), b => p4(3), c => p5(2), sum => s116, carry => c116);
fa15: full_adder port map (a => p4(4), b => p5(3), c => p6(2), sum => s117, carry => c117);
fa16: full_adder port map (a => p5(4), b => p6(3), c => p7(2), sum => s118, carry => c118);



-- Second Stage
ha3: half_adder port map (a => s12,   b => c11, sum => s21, carry => c21);
fa17: full_adder port map (a => s13,   b => c12, c => p3(0), sum => s22, carry => c22);
fa18: full_adder port map (a => s14,   b => c13, c => p3(1), sum => s23, carry => c23);
fa19: full_adder port map (a => s15,   b => c14, c => s114, sum => s24, carry => c24);
fa20: full_adder port map (a => s16,   b => c15, c => s115, sum => s25, carry => c25);
fa21: full_adder port map (a => s17,   b => c16, c => s116, sum => s26, carry => c26);
fa22: full_adder port map (a => s18,   b => c17, c => s117, sum => s27, carry => c27);
fa23: full_adder port map (a => s19,   b => c18, c => s118, sum => s28, carry => c28);
fa24: full_adder port map (a => s110,   b => c19, c => p6(4), sum => s29, carry => c29);
fa25: full_adder port map (a => s111,   b => c110, c => p7(4), sum => s210, carry => c210);
ha4: half_adder port map (a => s112,   b => c111, sum => s211, carry => c211);
ha5: half_adder port map (a => s113,   b => c112, sum => s212, carry => c212);
ha6: half_adder port map (a => p7(7),   b => c113, sum => s213, carry => c213);
ha7: half_adder port map (a => c114,   b => p6(0), sum => s214, carry => c214);
fa26: full_adder port map (a => c115,   b => p6(1), c => p7(0), sum => s215, carry => c215);
ha8: half_adder port map (a => c116,   b => p7(1), sum => s216, carry => c216);
ha9: half_adder port map (a => c118,   b => p7(3), sum => s217, carry => c217);

-- Third Stage
ha10: half_adder port map (a => s22,   b => c21, sum => s31, carry => c31);
fa27: full_adder port map (a => s23,   b => c22, c => p4(0), sum => s32, carry => c32);
ha11: half_adder port map (a => s24,   b => c23, sum => s33, carry => c33);
fa28: full_adder port map (a => s25,   b => c24, c => s214, sum => s34, carry => c34);
fa29: full_adder port map (a => s26,   b => c25, c => s215, sum => s35, carry => c35);
fa30: full_adder port map (a => s27,   b => c26, c => s216, sum => s36, carry => c36);
fa31: full_adder port map (a => s28,   b => c27, c => c117, sum => s37, carry => c37);
fa32: full_adder port map (a => s29,   b => c28, c => s217, sum => s38, carry => c38);
fa33: full_adder port map (a => s210,   b => c29, c => p7(4), sum => s39, carry => c39);
ha12: half_adder port map (a => s211,   b => c210, sum => s310, carry => c310);
ha13: half_adder port map (a => s212,   b => c211, sum => s311, carry => c311);
ha14: half_adder port map (a => s213,   b => c212, sum => s312, carry => c312);

-- Fourth Stage
ha15: half_adder port map (a => s32,   b => c31, sum => s41, carry => c41);
ha16: half_adder port map (a => s33,   b => c32, sum => s42, carry => c42);
ha17: half_adder port map (a => s34,   b => c33, sum => s43, carry => c43);
fa34: full_adder port map (a => s35,   b => c34, c => c214, sum => s44, carry => c44);
fa35: full_adder port map (a => s36,   b => c35, c => c215, sum => s45, carry => c45);
fa36: full_adder port map (a => s37,   b => c36, c => c216, sum => s46, carry => c46);
ha18: half_adder port map (a => s38,   b => c37, sum => s47, carry => c46);
fa37: full_adder port map (a => s39,   b => c38, c => c217, sum => s48, carry => c48);
ha19: half_adder port map (a => s310,   b => c39, sum => s49, carry => c49);
ha20: half_adder port map (a => s311,   b => c310, sum => s410, carry => c410);
ha21: half_adder port map (a => s312,   b => c311, sum => s411, carry => c411);
ha22: half_adder port map (a => c213,   b => c312, sum => s412, carry => c412);

-- Assign Final Lines:
adder_line1(0) <= p0(0);
adder_line1(1) <= s11;
adder_line1(2) <= s21;
adder_line1(3) <= s31;
adder_line1(4) <= s41;
adder_line1(5) <= s42;
adder_line1(6) <= s43;
adder_line1(7) <= s44;
adder_line1(8) <= s45;
adder_line1(9) <= s46;
adder_line1(10) <= s47;
adder_line1(11) <= s48;
adder_line1(12) <= s49;
adder_line1(13) <= s410;
adder_line1(14) <= s411;
adder_line1(15) <= s412; 

adder_line2(0) <= '0';
adder_line2(1) <= '0';
adder_line2(2) <= '0';
adder_line2(3) <= '0';
adder_line2(4) <= '0';
adder_line2(5) <= c41;
adder_line2(6) <= c42;
adder_line2(7) <= c43;
adder_line2(8) <= c44;
adder_line2(9) <= c45;
adder_line2(10) <= c46;
adder_line2(11) <= c47;
adder_line2(12) <= c48;
adder_line2(13) <= c49;
adder_line2(14) <= c410;
adder_line2(15) <= c411;

-- Final Adition:
result <= adder_line1 + adder_line2;

end architecture;
