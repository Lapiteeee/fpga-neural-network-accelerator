-------------------------------------------------------------------------------
-- pack_neurones.vhd
-- Shared constants, types and weight LUT for the neural network accelerator.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package pack_neurones is
    constant T    : natural := 200;   -- activation threshold
    constant Vmax : natural := 16;    -- output value when Y > T
    constant Vmin : natural := 1;     -- output value otherwise
    constant N    : natural := 8;     -- inputs per neuron / neurons per layer
    constant Nb_Layers : natural := 3;

    type Tab_int is array (natural range <>) of integer;
    subtype Tab_int_const is Tab_int (1 to N);

    -- Constrained fixed-width types: reduces logic-element/DSP usage on the
    -- MAX 10 FPGA compared to using default 32-bit integers.
    subtype short_natural is natural range 0 to 63;
    subtype long_natural  is natural range 0 to 65535;

    type Tab_short is array (natural range <>) of short_natural;
    subtype Tab_short_const is Tab_short (1 to N);

    -- Static synaptic weight LUT: Wi_LUT(layer, neuron)(input)
    type Quad_Tab_const is array (1 to 4, 1 to 8) of Tab_short_const;
    constant Wi_LUT : Quad_Tab_const := (
        ((1,1,5,5,5,5,1,1),(1,0,3,5,3,5,0,7),(0,1,6,5,4,5,2,1),(8,0,5,0,5,5,0,1),
         (4,4,4,4,2,2,2,2),(4,3,5,0,0,5,3,4),(3,3,3,3,3,3,3,3),(1,2,3,6,6,3,2,1)),
        ((4,6,0,3,1,0,6,4),(5,5,1,1,1,1,5,5),(3,3,3,3,3,3,3,3),(0,1,3,8,8,3,1,0),
         (0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0)),
        ((0,9,9,0,0,0,0,0),(6,6,6,6,0,0,0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0),
         (0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0)),
        others => (others => (others => 0))
    );
end package pack_neurones;
