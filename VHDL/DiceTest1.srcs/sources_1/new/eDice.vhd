----------------------------------------------------------------------------
-- Dice
-- John Arild Lolland
----------------------------------------------------------------------------
-- Loosly based on 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity eDice is
    Port ( Seg7      : out STD_LOGIC_VECTOR (7 downto 0);   -- 7 Segment output
           AN        : out STD_LOGIC_VECTOR (7 downto 0);   -- Select which display to use (always 11111110)
           JA        : out STD_LOGIC_VECTOR (6 downto 0);   -- LED Dice output (PMOD)
           cheatLED  : out STD_LOGIC;                       -- indicates that cheat is active
           resultSel : in  natural range 7 downto 0;        -- Cheat mode numeric input
           cheat     : in  STD_LOGIC;
           run       : in  STD_LOGIC;
           rst       : in  STD_LOGIC;
           clk       : in  STD_LOGIC
           );
end eDice;

architecture Behavioral of eDice is
    signal number       : natural range 7 downto 0;
    signal DiceOut      : natural range 7 downto 0;
    signal resultSelReg : natural range 7 downto 0;
    signal cheating     : STD_LOGIC;
begin
    process(clk) 
    variable int_count : integer range 7 downto 0; 
    begin
        if rising_edge(clk) then 
            int_count := int_count + 1;
            if rst = '1' then 
                int_count := 0;
                number <= int_count;
            elsif (int_count > 5) AND (cheating = '0') then int_count := 0;
            elsif (int_count > 7) then int_count := 0;
            end if;
            if run = '1' then 
                resultSelReg <= resultSel;
                number <= int_count;
            end if;
        end if;
    end process;
    
    -- Determine if cheating should be active:
    cheating <= '0' when resultSel = 0 else
                '0' when resultSel = 7 else
                cheat;
                
    -- keep the display dark while counter is running (optional)
   DiceOut <=   7 when run = '1' else  -- turns off display while runing
                resultSelReg - 1 when ((number = 6) OR (number = 7)) AND (run = '0') else
                number;
                
    -- Output result:
    cheatLED <= cheating;
    diceOutput: entity work.LedDice_output(LedOutput)
        port map(number=>DiceOut, JA=>JA, Seg7=>Seg7, AN=>AN);

end Behavioral;
