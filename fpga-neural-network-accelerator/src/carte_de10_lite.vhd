-------------------------------------------------------------------------------
-- carte_de10_lite.vhd
-- Top-level entity: wires the neural network to the DE10-Lite board's
-- switches, LEDs, and two 7-segment displays.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.pack_neurones.all;

entity carte_DE10_lite is
    port (
        MAX10_CLK1_50 : in std_logic;
        SW   : in std_logic_vector(9 downto 0);
        LEDR : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0)
    );
end entity carte_DE10_lite;

architecture rtl of carte_DE10_lite is
    signal s_ins  : Tab_short_const;
    signal s_outs : Tab_short_const;
begin
    -- 1. Visual feedback: switches mirrored on LEDs
    LEDR(7 downto 0) <= SW(7 downto 0);

    -- 2. Switch (0/1) -> network input (0/16) conversion
    gen_in : for i in 1 to 8 generate
        s_ins(i) <= 16 when SW(i-1) = '1' else 0;
    end generate;

    -- 3. Network instance
    inst_reseau : entity work.reseau
        port map (
            clk  => MAX10_CLK1_50,
            ins  => s_ins,
            outs => s_outs
        );

    -- 4. HEX0: shows '8' if output neuron 1 is active, '0' otherwise
    process(s_outs(1))
    begin
        if s_outs(1) >= 16 then
            HEX0 <= "0000000"; -- 8, all segments on
        else
            HEX0 <= "1000000"; -- 0, middle segment off
        end if;
    end process;

    -- 5. HEX1: same logic for output neuron 2
    process(s_outs(2))
    begin
        if s_outs(2) >= 16 then
            HEX1 <= "0000000"; -- 8
        else
            HEX1 <= "1000000"; -- 0
        end if;
    end process;
end architecture rtl;
