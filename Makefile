##
# Xilinx Simulation
#
# @file
# @version 0.1

tb_top:
	@echo "Start Simulation"
	@cd src/tb && vsim -do "do compile.do"

clean:
	rm -rf work src/tb/vsim.wlf transcript
# end
