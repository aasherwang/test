all: clean compile simulate


compile:
	vcs -full64 \
	-sverilog \
	-debug_acc+all \
	-l com.log \
	-f rtl.lst \
	-timescale=1ns/1ps

simulate:
	./simv -l sim.log 

verdi:
	verdi -f rtl.lst -ssf sync_fifo.fsdb &

clean:
	@rm -rf csrc DVEfiles simv simv.daidir ucli.key VCS*
	@rm -rf *.log *.vpd *.ddc *.svf *.SDF *Synth *Netlist*
	@rm -rf alib-52 vsim* work *.fsdb  verdiLog *.conf
