-- LedDice PMOD by John Arild Lolland

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LedDice_output is
    Port ( 
            JA : out STD_LOGIC_VECTOR (6 downto 0);
            Seg7 : out  STD_LOGIC_VECTOR (7 downto 0);
            AN : out  STD_LOGIC_VECTOR (7 downto 0);
            number : in  natural range 7 downto 0
         );
end LedDice_output;

architecture LedOutput of LedDice_output is
    signal DiceNumber  : natural range 7 downto 0;
    signal DicePattern : unsigned(6 downto 0);
    signal SevenSegPattern : unsigned(7 downto 0);
begin
    -- Dice LED configuration:
    -- 0     4
    -- 1  3  5
    -- 2     6
    DiceNumber <= number;
process(DiceNumber)
begin
    if    DiceNumber = 0 then 
          DicePattern <= "0001000";
          SevenSegPattern <= "11111001";
    elsif DiceNumber = 1 then 
          DicePattern <= "0010100";
          SevenSegPattern <= "10100100";
    elsif DiceNumber = 2 then 
          DicePattern <= "0011100";
          SevenSegPattern <= "10110000";
    elsif DiceNumber = 3 then 
          DicePattern <= "1010101";
          SevenSegPattern <= "10011001";
    elsif DiceNumber = 4 then 
          DicePattern <= "1011101";
          SevenSegPattern <= "10010010";
    elsif DiceNumber = 5 then 
          DicePattern <= "1110111";
          SevenSegPattern <= "10000010";
    else  DicePattern <= "0000000"; -- All LEDs off
          SevenSegPattern <= "11111111";
    end if;
end process;
    JA <= STD_LOGIC_VECTOR(DicePattern);
    Seg7 <= STD_LOGIC_VECTOR(SevenSegPattern);
    AN <= "11111110";
end LedOutput;
