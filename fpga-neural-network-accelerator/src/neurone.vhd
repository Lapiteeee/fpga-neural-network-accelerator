-------------------------------------------------------------------------------
-- neurone.vhd
-- Single artificial neuron: weighted sum + threshold activation.
--
-- NOTE ON PIPELINING: an earlier design iteration explored a deeper pipelined
-- datapath (separate registers for input, multiply, and each addition stage --
-- see the commented-out signals below). The version below is the one that was
-- actually synthesized and tested on hardware: it computes the weighted sum
-- and threshold in a single clocked process (one register stage on the
-- output). Kept here for transparency and as a reference for future work.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.pack_neurones.all;

entity neurone is
    generic (
        Wi : Tab_short_const := (others => 27)
    );
    port (
        clk : in std_logic;
        X   : in Tab_short_const;
        Z   : out short_natural
    );
end entity neurone;

architecture comportementale of neurone is
    -- Deeper pipelining explored but not used in the final synthesized design:
    --signal X_reg : Tab_short_const := (others => 0);
    --signal Y_reg : long_natural := 0;
    --type Tab_mult is array (1 to 4) of long_natural;
    --signal mult : Tab_mult := (others => 0);
    --signal add_1 : long_natural := 0;
    --signal add_2 : long_natural := 0;
begin
    process(clk)
        variable Y : long_natural := 0;
    begin
        if rising_edge(clk) then
            Y := 0;
            for i in 1 to N loop
                Y := Y + (Wi(i) * X(i));
            end loop;
            if Y > T then
                Z <= Vmax;
            else
                Z <= Vmin;
            end if;
        end if;
    end process;
end architecture comportementale;
