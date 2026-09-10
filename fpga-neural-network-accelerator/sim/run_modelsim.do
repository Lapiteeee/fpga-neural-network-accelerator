; run_modelsim.do
; Compile order matters: pack_neurones -> neurone -> reseau -> carte_de10_lite
; Run from the sim/ directory: vsim -do run_modelsim.do

vlib work

vcom -93 ../src/pack_neurones.vhd
vcom -93 ../src/neurone.vhd
vcom -93 ../src/reseau.vhd
vcom -93 ../src/carte_de10_lite.vhd

vcom -93 tb_neurone.vhd
vcom -93 tb_reseau.vhd

; --- Single-neuron testbench ---
vsim work.tb_neurone
add wave -radix unsigned *
run 200 ns
quit -sim

; --- Full network testbench ---
vsim work.tb_reseau
add wave -radix unsigned *
run 5200 ns
quit -sim
