-------------------------------------------------------------------------------
-- tb_neurone.vhd
-- Testbench for the `neurone` entity: two neurons with different weights,
-- driven with a few manual test vectors.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.pack_neurones.all;

entity tb_neurone is
end entity tb_neurone;

architecture sim of tb_neurone is
    signal clk    : std_logic := '0';
    signal X_test : Tab_short_const := (others => 0);
    signal Z1_test, Z2_test : short_natural;

    constant Poids_N1 : Tab_short_const := (10,10,10,10,10,10,10,10);
    constant Poids_N2 : Tab_short_const := (30,0,30,0,30,0,30,0);
begin
    -- 50 MHz-style clock (period arbitrary for simulation purposes)
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    Neurone_1 : entity work.neurone
        generic map (Wi => Poids_N1)
        port map (clk => clk, X => X_test, Z => Z1_test);

    Neurone_2 : entity work.neurone
        generic map (Wi => Poids_N2)
        port map (clk => clk, X => X_test, Z => Z2_test);

    stimulus : process
    begin
        X_test <= (others => 0);
        wait for 40 ns;
        X_test <= (2,2,2,2,2,2,2,2);
        wait for 40 ns;
        X_test <= (5,0,5,0,5,0,5,0);
        wait for 40 ns;
        X_test <= (5,5,5,5,5,5,5,5);
        wait for 40 ns;
        wait; -- end of simulation
    end process;
end architecture sim;
