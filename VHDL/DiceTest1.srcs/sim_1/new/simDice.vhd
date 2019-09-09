library ieee;
use ieee.std_logic_1164.all;

entity simDice is
end simDice;

architecture tb of simDice is

    component module_name

    end component;

    signal JA        :  STD_LOGIC_VECTOR (6 downto 0);   -- 7 Segment output
    signal cheatLED  :  STD_LOGIC;                       -- indicates that cheat is active
    signal resultSel :  natural range 7 downto 0;   -- Cheat mode numeric input
    signal cheat     :  STD_LOGIC;
    signal run       :  STD_LOGIC;
    signal rst       :  STD_LOGIC;
    signal clk       :  STD_LOGIC;
    signal check     :  STD_LOGIC;

    constant clk_period : time := 10 ns;

begin

    uut : entity work.eDice
    port map (clk => clk, rst => rst, 
              run => run,  cheat => cheat, 
              cheatLED => cheatLED, 
              resultSel => resultSel,
              JA => JA
              );

clk_process: process 
   begin
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
   end process;

--Stimuli process 
   stim_proc: process
      begin
      -------------------------------
      -- Test no cheat:
      -------------------------------
      --reset to known position (Dice = 1)
        resultSel <= 3;
        cheat <= '0';
        run <= '0';
        rst <= '1';      
        check <= '0';
        wait for clk_period*2;
        for i in 0 to 8 loop
            run <= '1';
            rst <= '1';      
            wait for clk_period;
            rst <= '0'; 
            for ii in 0 to i loop
                wait for clk_period;
            end loop; 
            run <= '0';
            wait for clk_period;
        end loop;
        check <= '1';
        wait for clk_period*4; -- 4 cycles makes it more visible
        -- Dice should now be 2:
        assert (JA = "1010101") -- output for Dice=4
            report "****** test failed *****" severity error; 
        check <= '0';
          
       -------------------------------
      -- Test legal cheat:
      -------------------------------
      --reset to known position (Dice = 1)
        resultSel <= 3;
        cheat <= '1';
        run <= '0';
        rst <= '1';      
        check <= '0';
        wait for clk_period*2;
        for i in 0 to 8 loop
            run <= '1';
            rst <= '1';      
            wait for clk_period;
            rst <= '0'; 
            for ii in 0 to i loop
                wait for clk_period;
            end loop; 
            run <= '0';
            wait for clk_period;
        end loop;
        check <= '1';
        wait for clk_period*4; -- 4 cycles makes it more visible
        -- Dice should now be 2:
        assert (JA = "0010100") -- output for Dice=2
            report "****** test failed *****" severity error; 
        check <= '0';         
  
      -------------------------------
      -- Test illegal cheat:
      -------------------------------
      --reset to known position (Dice = 1)
        resultSel <= 7;
        cheat <= '1';
        run <= '0';
        rst <= '1';      
        check <= '0';
        wait for clk_period*2;
        for i in 0 to 8 loop
            run <= '1';
            rst <= '1';      
            wait for clk_period;
            rst <= '0'; 
            for ii in 0 to i loop
                wait for clk_period;
            end loop; 
            run <= '0';
            wait for clk_period;
        end loop;
        check <= '1';
        wait for clk_period*4; -- 4 cycles makes it more visible
        -- Dice should now be 2:
        assert (JA = "1010101") -- output for Dice=4
            report "****** test failed *****" severity error; 
        check <= '0';
        wait for clk_period*4;
                
      end process ;


end tb;
