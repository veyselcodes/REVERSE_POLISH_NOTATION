library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.ram_pkg.all;

entity reversePolishNotation is
generic(
RAM_WIDTH 		: integer := 8;
RAM_DEPTH 		: integer := 16;
RAM_PERFORMANCE : string 	:= "LOW_LATENCY"
);
port(
clk 			: in std_logic;
rst 			: in std_logic;
dIn 			: in std_logic;
dOut 			: out std_logic
);
end reversePolishNotation;

architecture Behavioral of reversePolishNotation is

	-- Components
	component block_ram is
	generic (
	RAM_WIDTH 		: integer 	:= 8;				-- Specify RAM data width
	RAM_DEPTH 		: integer 	:= 16;				-- Specify RAM depth (number of entries)
	RAM_PERFORMANCE : string 	:= "LOW_LATENCY"    -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
	-- RAM_PERFORMANCE : string 	:= "HIGH_PERFORMANCE"    -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
	);
	port (
	addra : in std_logic_vector((clogb2(RAM_DEPTH)-1) downto 0);    -- Address bus, width determined from RAM_DEPTH
	dina  : in std_logic_vector(RAM_WIDTH-1 downto 0);		  		-- RAM input data
	clka  : in std_logic;                       			  		-- Clock
	wea   : in std_logic;                       			  		-- Write enable
	douta : out std_logic_vector(RAM_WIDTH-1 downto 0)   			-- RAM output data
	);
	end component;
	

	-- Signals for RAM
	signal addra 	: std_logic_vector((clogb2(RAM_DEPTH)-1) downto 0)  := (others => '0');
	signal dina 	: std_logic_vector(RAM_WIDTH-1 downto 0)			:= (others => '0');
	signal wea 		: std_logic 										:= '0';
	signal douta 	: std_logic_vector(RAM_WIDTH-1 downto 0) 			:= (others => '0');
	
	-- State Declarations
	type states is (S_IDLE, Number_or_Operator, Number, Operator, First_Operator, Second_Operator, Clear, Addition, Multiply, Check, S_WRITE); 
	signal state : states := S_IDLE;
	
	-- 8 bit Registers for storing data
	signal Number_register  : std_logic_vector(RAM_WIDTH-1 downto 0)			:= (others => '0');
	signal First_Number  	: std_logic_vector(RAM_WIDTH-1 downto 0)			:= (others => '0');
	signal Second_Number 	: std_logic_vector(RAM_WIDTH-1 downto 0)			:= (others => '0');
	
	-- Counter Signals
	signal Number_cnt 		: integer := 0;
	signal BRAM_Adress_cnt  : integer := 0;
	signal Addition_cnt  	: integer := 0;
	signal Multiply_cnt  	: integer := 0;
	signal Check_cnt  		: integer := 0;
	
begin

-- Instatiation of BRAM
BRAM_Ins_8x16 : block_ram
generic map(
RAM_WIDTH 		=> RAM_WIDTH,
RAM_DEPTH 		=> RAM_DEPTH,
RAM_PERFORMANCE => RAM_PERFORMANCE
)
port map(
addra 			=> addra,
dina 			=> dina,
clka 			=> clk,
wea 			=> wea,
douta 			=> douta
);


Project_MAIN : process(clk) is
begin
	if(rst = '1')then
		wea 			<= '0';
		dOut 			<= '0';
		state 			<= S_IDLE;
		-- Clear Registers and Counters
		Number_register <= (others => '0');
		First_Number 	<= (others => '0');
		Second_Number 	<= (others => '0');
		Number_cnt 		<= 0;
		Addition_cnt 	<= 0;
		Multiply_cnt 	<= 0;
		Check_cnt 		<= 0;
		
	elsif(clk'event and clk ='1')then
		case state is
			when S_IDLE =>
				wea 			<= '0';
				dOut 			<= '0';
				-- Clear Registers and Counters
				Number_register <= (others => '0');
				First_Number 	<= (others => '0');
				Second_Number 	<= (others => '0');
				Number_cnt 		<= 0;
				Addition_cnt 	<= 0;
				Multiply_cnt 	<= 0;
				Check_cnt 		<= 0;
				
				-- Decide next state 
				if(dIn = '1')then
					state 		<= Number_or_Operator;
				else
					state 		<= S_IDLE;
				end if;
				
			when Number_or_Operator =>
			
				-- Decide next state 
				if(dIn = '1')then
					state 		<= Operator;
				else
					state 		<= Number;
				end if;
				
			when Number =>
			
				-- Operation of Number State
				Number_register <= Number_register(6 downto 0) & dIn;
				Number_cnt 		<= Number_cnt +1;
				
				
				-- Decide next state 
				if(Number_cnt = 7)then
					state 		<= S_WRITE;
					Number_cnt 	<= 0;
				else
					state 		<= Number;	
				end if;
				
			when Operator =>
			
				-- Decide next state 
				if(dIn = '1')then
					state 		<= Second_Operator;
				else
					state 		<= First_Operator;
				end if;
				
			when First_Operator =>
			
				-- Decide next state 
				if(dIn = '1')then
					state 		<= Addition;
				else
					state 		<= Clear;
				end if;
			
			when Second_Operator =>
			
				-- Decide next state 
				if(dIn = '1')then
					state 		<= Check;
				else
					state 		<= Multiply;
				end if;
				
			when Clear =>
				
				addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-1, addra'length));
				dina 			<= (others => '0'); -- Pop Number
				wea 			<= '1';
				
				-- Decide next state 
				if(BRAM_Adress_cnt-1 = 0)then
					state 			<= S_IDLE;
					BRAM_Adress_cnt <= 0;
				else
					state 			<= Clear;
					BRAM_Adress_cnt <= BRAM_Adress_cnt - 1;
				end if;
			
			when Addition =>
				
				wea 				<= '1';
				
				if(Addition_cnt = 0 and BRAM_Adress_cnt /= 1)then
					-- Take First Number
					addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-1, addra'length));
					First_Number 	<= douta;
					dina 			<= (others => '0');  -- Pop Number
				elsif(Addition_cnt = 1)then
					-- Take Second Number
					addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-2, addra'length));
				elsif(Addition_cnt = 3)then	
					Second_Number 	<= douta;
					dina 			<= (others => '0');  -- Pop Number
				elsif(Addition_cnt = 4)then
					-- Write Result to BRAM
					addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-2, addra'length));
					dina 			<= First_Number + Second_Number;
					BRAM_Adress_cnt <= BRAM_Adress_cnt -1;
				end if;
				
				-- Decide next state 
				if(Addition_cnt = 5 or BRAM_Adress_cnt = 1)then
					-- Writing Completed, Go next Operation
					state 			<= S_IDLE;
					Addition_cnt 	<= 0;
				else
					state <= Addition;
					Addition_cnt 	<= Addition_cnt + 1;
				end if;

			when Multiply =>
				wea 				<= '1';
				
				if(Multiply_cnt = 0 and BRAM_Adress_cnt /= 1)then
					-- Take First Number
					addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-1, addra'length));
					First_Number 	<= douta;
					dina <= (others => '0');  -- Pop Number
				elsif(Multiply_cnt = 1)then
					-- Take Second Number
					addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-2, addra'length));
				elsif(Multiply_cnt = 3)then	
					Second_Number 	<= douta;
					dina <= (others => '0');  -- Pop Number
				elsif(Multiply_cnt = 4)then
					-- Write Result to BRAM
					addra 			<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-2, addra'length));
					dina 			<= std_logic_vector(to_unsigned(to_integer(signed(First_Number))*to_integer(signed(Second_Number)), dina'length));
					BRAM_Adress_cnt <= BRAM_Adress_cnt -1;
				end if;
				
				-- Decide next state 
				if(Multiply_cnt = 5 or BRAM_Adress_cnt = 1)then
					state 			<= S_IDLE;
					Multiply_cnt 	<= 0;
				else
					state 			<= Multiply;
					Multiply_cnt 	<= Multiply_cnt +1;
				end if;
			
			when Check =>
			
				addra 				<= std_logic_vector(to_unsigned(BRAM_Adress_cnt-1, addra'length));
				
				if(Check_cnt = 0)then
					dOut 			<= '1';
				elsif(Check_cnt = 1)then
					dOut 			<= '0';
				else
					dOut 			<= douta(9-Check_cnt);
				end if;
				
				-- Decide next state 
				if(Check_cnt = 9)then
					state 			<= S_IDLE;
				else
					state 			<= Check;
					Check_cnt 		<= Check_cnt + 1;
				end if;
			
			when S_WRITE =>
				-- Write Data to BRAM
				addra 				<= std_logic_vector(to_unsigned(BRAM_Adress_cnt, addra'length));
				dina 				<= Number_register;
				wea 				<= '1';
				state 				<= S_IDLE;
				BRAM_Adress_cnt 	<= BRAM_Adress_cnt + 1;
			
		end case;
	end if;
end process;

end Behavioral;