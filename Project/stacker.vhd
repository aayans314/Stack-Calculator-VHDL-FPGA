-- CS232 Lab 6: stacker.vhd
-- Aayan Shah
-- 8th April

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stacker is
          -- stacker ports	
	  port( clock: in std_logic;
        data:  in std_logic_vector(3 downto 0);
        b0:    in std_logic; -- switch values to mbr
        b1:    in std_logic; -- push mbr -> stack
        b2:    in std_logic; -- pop stack -> mbr
        mbrview : out std_logic_vector(3 downto 0);
        stackview: out std_logic_vector(3 downto 0);
        stateview: out std_logic_vector(2 downto 0)
        );
		  
end entity;

architecture rtl of stacker is

	-- RAM ports
	component memram_lab 
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);	
	
	end component;
	-- internal signals and registers
	
	signal RAM_input:  std_logic_vector(3 downto 0);
	signal RAM_output: std_logic_vector(3 downto 0);
	signal RAM_we: std_logic;
	signal stack_ptr : std_logic_vector(3 downto 0);
	signal mbr : std_logic_vector(3 downto 0);
	signal state : std_logic_vector(2 downto 0);
	
begin
	
	-- port map the RAM
	
	myram : memram_lab port map(address => stack_ptr, data => RAM_input, wren => RAM_we, q=> RAM_output, clock => clock);
	
	
		
	-- connect the internal signals to their output signals
	
	mbrview <= mbr;
	stackview <= stack_ptr;
	stateview <= state;
	
	-- state machine 
	process (clock, b1, b2) -- remember to update the parameters accordingly
	
	begin
	
	if( b1 = '0' AND b2 = '0') then
		stack_ptr <= (others => '0');
		mbr <= (others => '0');
		RAM_input <= (others => '0');
		RAM_we <= '0';
		state <= (others => '0');
	elsif (rising_edge(clock)) then
		case state is
		
			when "000" =>
				if b0 = '0' then
					mbr <= data;
					state <= "111";
				elsif b1 = '0' then 
					RAM_input <= mbr;
					RAM_we <= '1';
					state <= "001";
				elsif b2 = '0' then
					case stack_ptr is
					when "0000" =>
					when others =>
						stack_ptr <= std_logic_vector(unsigned(stack_ptr)-1);
						state <= "100";
					end case;
				end if;
			
			when "001" =>
				RAM_we <= '0';
				stack_ptr <= std_logic_vector(unsigned(stack_ptr)+1);
				state <= "111";
		
			when "100" =>
				state <= "101";
			
			when "101" =>
				state <= "110";
				
			when "110" =>
				mbr <= RAM_output;
				state <= "111";
				
			when "111" =>
				if b1 = '1' AND b2 = '1' AND b0 = '1' then
					state <= "000";
				end if;
				
				
			when others =>
				 state <= "000";
				 
	 end case;
	 
	end if;
			
	end process;

end rtl;