# FPGA Neural Network Accelerator

A feed-forward neural network accelerator modelled in VHDL and synthesized
on an Intel MAX 10 FPGA (Terasic DE10-Lite board). Built as part of the
Programmable Logic course at INSA Rennes (4th year, Electronics & Industrial
Computer Science), with [Léonard Faure](https://github.com/) (co-author).

## Overview

- **Neuron model**: weighted sum of inputs followed by a threshold
  activation (`Z = Vmax if sum(Wi*Xi) > T else Vmin`).
- **Network**: 3-layer feed-forward topology (8 → 4 → 2 neurons), built
  entirely with VHDL `generate` constructs so the layer structure scales
  automatically with the neuron count. Synaptic weights are static,
  read from a compile-time lookup table (`Wi_LUT`).
- **Optimisation**: inputs, weights and outputs use a constrained
  6-bit (`short_natural`) type instead of default 32-bit integers, to
  reduce logic-element and DSP block usage on the MAX 10 during multiply
  operations.
- **Hardware integration**: the network is driven by the DE10-Lite's
  8 switches (binary inputs) and its two output neurons are shown on the
  board's 7-segment displays.

## Repository structure

```
src/
  pack_neurones.vhd     -- shared types, constants, weight LUT
  neurone.vhd            -- single neuron (weighted sum + threshold)
  reseau.vhd              -- parametric multi-layer network (generate loops)
  carte_de10_lite.vhd     -- top-level: DE10-Lite switches/LEDs/7-seg wiring
sim/
  tb_neurone.vhd          -- unit testbench for a single neuron
  tb_reseau.vhd            -- testbench sweeping all 256 input combinations
  run_modelsim.do          -- ModelSim script: correct compile order + run
docs/
  Rapport_Logique_prog.pdf -- original project report (French)
```

## A note on the pipelining

An earlier design iteration explored a deeper pipelined datapath — separate
registers after the input stage, each multiply, and each addition stage —
to shorten the critical path and increase throughput. The version in this
repository (`neurone.vhd`) is the one that was actually synthesized and
tested on hardware: it computes the weighted sum and threshold in a single
clocked process. The unused pipelining signals are left commented in
`neurone.vhd` as a reference for that exploration.

## Running the simulation (ModelSim)

```
cd sim
vsim -do run_modelsim.do
```

This compiles all sources in the correct dependency order and runs both
testbenches, waveforms included.

## Synthesis (Quartus Prime)

1. Create a new Quartus project targeting the **Intel MAX 10 (10M50DAF484C7G)**
   device used on the DE10-Lite.
2. Add all files under `src/` to the project.
3. Set `carte_DE10_lite` as the top-level entity.
4. Assign pins to match the DE10-Lite's `MAX10_CLK1_50`, `SW[9:0]`,
   `LEDR[9:0]`, `HEX0[6:0]` and `HEX1[6:0]` signals (see the board's
   official pin assignment file / user manual).
5. Compile and program the board.

## Tools used

VHDL, ModelSim (simulation), Quartus Prime (synthesis), Terasic DE10-Lite
(Intel MAX 10 FPGA).
