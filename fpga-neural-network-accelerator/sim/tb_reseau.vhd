-------------------------------------------------------------------------------
-- tb_reseau.vhd
-- Testbench for the full `reseau` network: sweeps all 256 combinations of
-- the 8 binary inputs (0 or 16), one combination every 20 ns.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.pack_neurones.all;

entity tb_reseau is
end entity tb_reseau;

architecture sim of tb_reseau is
    signal clk       : std_logic := '0';
    signal ins_test  : Tab_short_const := (others => 0);
    signal outs_test : Tab_short_const;
begin
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    dut : entity work.reseau
        port map (
            clk  => clk,
            ins  => ins_test,
            outs => outs_test
        );

    stimulus : process
    begin
        for i in 0 to 255 loop
            for b in 1 to 8 loop
                if (i / (2**(b-1))) mod 2 = 1 then
                    ins_test(b) <= 16;
                else
                    ins_test(b) <= 0;
                end if;
            end loop;
            wait for 20 ns;
        end loop;
        wait; -- end of simulation
    end process;
end architecture sim;
