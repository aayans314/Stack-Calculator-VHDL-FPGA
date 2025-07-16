library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extensionplus is
	port(
		clock : in std_logic;
		b0 :  in std_logic;
		b1 :  in std_logic;
		b2 :  in std_logic;
		op : in std_logic_vector(1 downto 0);
		data : in std_logic_vector(7 downto 0);
		digit0 : out std_logic_vector(6 downto 0);
		digit1 : out std_logic_vector(6 downto 0);
		digit2 : out std_logic_vector(6 downto 0);
		stackptr : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of extensionplus is

	component memram
		PORT (
			address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			clock		: IN STD_LOGIC := '1';
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wren		: IN STD_LOGIC;
			q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	end component;

	component binToDec 
		port(
			inp : in unsigned (7 downto 0);
			leftDispOut: out unsigned (6 downto 0);
			midDispOut: out unsigned (6 downto 0);
			rightDispOut: out unsigned (6 downto 0)
		);
	end component;

	signal RAM_input:  std_logic_vector(7 downto 0);
	signal RAM_output: std_logic_vector(7 downto 0);
	signal RAM_we: std_logic;
	signal stack_ptr : std_logic_vector(3 downto 0);
	signal mbr : std_logic_vector(7 downto 0);
	signal state : std_logic_vector(2 downto 0);

begin

	myram : memram port map(address => stack_ptr, data => RAM_input, wren => RAM_we, q => RAM_output, clock => clock);
	display : binToDec port map(inp => unsigned(mbr), std_logic_vector(leftDispOut) => (digit2), std_logic_vector(midDispOut) => (digit1), std_logic_vector(rightDispOut) => (digit0));
	stackptr <= stack_ptr;

	process (clock, b1, b2)
	begin
		if (b1 = '0' AND b2 = '0') then
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
						if unsigned(stack_ptr) < 15 then
							RAM_input <= mbr;
							RAM_we <= '1';
							state <= "001";
						end if;
					elsif b2 = '0' then
						if stack_ptr /= "0000" then
							stack_ptr <= std_logic_vector(unsigned(stack_ptr)-1);
							state <= "100";
						end if;
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
					case op is 
						when "00" =>
							mbr <= std_logic_vector(unsigned(RAM_output) + unsigned(mbr));
						when "01" =>
							mbr <= std_logic_vector(unsigned(RAM_output) - unsigned(mbr));
						when "10" =>
							mbr <= std_logic_vector(resize(unsigned(RAM_output(3 downto 0)) * unsigned(mbr(3 downto 0)), 8));
						when "11" =>
							if mbr /= "00000000" then
								mbr <= std_logic_vector(unsigned(RAM_output) / unsigned(mbr));
							end if;
						when others =>
							mbr <= (others => '0');
					end case;
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
