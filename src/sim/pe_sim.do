# pe_sim.do
# This script sets up the simulation environment and runs the testbench

# Set up the simulation environment
# Create a working library
vlib work
# Map the work library
vmap work work

# Compile design files
vlog -work work ../rtl/*.v

# Testbench
vlog -work work ../tb/pe_tb.v

# Library
# vlog -work work ../../library/artix7/*.v

# IP
# vlog -work work ../../../source_code/ROM_IP/rom_controller.v

vsim -voptargs=+acc work.pe_tb

# Add signal into wave window
# do wave.do
add wave *

run -all
