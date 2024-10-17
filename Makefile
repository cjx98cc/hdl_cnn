##
# Xilinx Simulation
#
# @file
# @version 0.1

add_sim:
	@echo "Start Simulation"
	@cd src/sim && vsim -do "do add_sim.do"

signedm_sim:
	@echo "Start Simulation"
	@cd src/sim && vsim -do "do signedm_sim.do"

pe_sim:
	@echo "Start Simulation"
	@cd src/sim && vsim -do "do pe_sim.do"

tb_top:
	@echo "Start Simulation"
	@cd src/sim && vsim -do "do compile.do"

clean:
	cd src/sim && rm -rf work vsim.wlf transcript wlft*
# end
