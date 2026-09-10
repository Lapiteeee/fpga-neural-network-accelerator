-------------------------------------------------------------------------------
-- reseau.vhd
-- Parametric feed-forward multi-layer network, built from `neurone`
-- instances using VHDL generate loops. Each layer halves the neuron count
-- (funnel topology); unused matrix positions are tied to zero.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.pack_neurones.all;

entity reseau is
    generic (
        Nb_Layers : short_natural := 3
    );
    port (
        clk  : in std_logic;
        ins  : in Tab_short_const;
        outs : out Tab_short_const
    );
end entity reseau;

architecture comportementale of reseau is
    type Matrix is array (0 to Nb_Layers) of Tab_short_const;
    signal s_Matrix : Matrix := (others => (others => 0));
begin
    s_Matrix(0) <= ins;

    gen_couche : for j in 1 to Nb_Layers generate
        constant Nihno : short_natural := N / (2**(j-1));
    begin
        gen_neurone : for i in 1 to N generate
            normal : if i <= Nihno generate
                nv_neurone : entity work.neurone
                    generic map (
                        Wi => Tab_short_const(Wi_LUT(j, i)(1 to N))
                    )
                    port map (
                        clk => clk,
                        X   => s_Matrix(j-1),
                        Z   => s_Matrix(j)(i)
                    );
            end generate;

            en_trop : if i > Nihno generate
                s_Matrix(j)(i) <= 0;
            end generate;
        end generate gen_neurone;
    end generate gen_couche;

    outs <= s_Matrix(Nb_Layers);
end architecture comportementale;
