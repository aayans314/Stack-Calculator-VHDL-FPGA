library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binToDec is
port(
    inp : in unsigned (7 downto 0);
    leftDispOut: out unsigned (6 downto 0);
    midDispOut: out unsigned (6 downto 0);
    rightDispOut: out unsigned (6 downto 0)
);
end entity;--

architecture add of binToDec is
signal dec : integer range 0 to 255;
signal hundreds : integer range 0 to 2;
signal tens : integer range 0 to 9;
signal ones : integer range 0 to 9;
signal leftDisp, midDisp, rightDisp : unsigned (3 downto 0);

component displayhex
    port(
        a : in unsigned (3 downto 0);
        result : out unsigned (6 downto 0)
    );
end component;

begin
    dec <= to_integer(inp);
    
    hundreds <= dec / 100;
    tens <= (dec / 10) mod 10;
    ones <= dec mod 10;
    
    with hundreds select
        leftDisp <= "0000" when 0,
                   "0001" when 1,
                   "0010" when 2,
                   "0000" when others;
    
    with tens select
        midDisp <= "0000" when 0,
                  "0001" when 1,
                  "0010" when 2,
                  "0011" when 3,
                  "0100" when 4,
                  "0101" when 5,
                  "0110" when 6,
                  "0111" when 7,
                  "1000" when 8,
                  "1001" when 9,
                  "0000" when others;
    
    with ones select
        rightDisp <= "0000" when 0,
                    "0001" when 1,
                    "0010" when 2,
                    "0011" when 3,
                    "0100" when 4,
                    "0101" when 5,
                    "0110" when 6,
                    "0111" when 7,
                    "1000" when 8,
                    "1001" when 9,
                    "0000" when others;
    
    leftDisplay : displayhex port map(a=>leftDisp, result=>leftDispOut);
    midDisplay : displayhex port map(a=>midDisp, result=>midDispOut);
    rightDisplay : displayhex port map(a=>rightDisp, result=>rightDispOut);
    
end add;