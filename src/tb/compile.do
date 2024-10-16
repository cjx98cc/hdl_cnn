vlib work
vmap work work

# Library
# vlog -work work ../../library/artix7/*.v

# IP
# vlog -work work ../../../source_code/ROM_IP/rom_controller.v

# Source code
vlog -work work ../rtl/*.v

# Testbench
vlog -work work testbench_top.v

vsim -voptargs=+acc work.testbench_top

# Add signal into wave window
do wave.do

run -all
