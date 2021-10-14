#
# Building Chisel examples without too much sbt/scala/... stuff
#
# sbt looks for default into a folder ./project and . for build.sdt and Build.scala
# sbt creates per default a ./target folder

SBT = sbt

init:
	git submodule update --init && git -C rocket-chip submodule update --init


# Generate Verilog code
thread:
	$(SBT) "runMain thread.ThreadMain"

xbar:
	mkdir -p build
	$(SBT) "runMain thread.TopMain -td build --full-stacktrace --output-file threadtop.v --infer-rw --repl-seq-mem -c:thread.TopMain:-o:build/threadtop.v.conf "
	./scripts/vlsi_mem_gen build/threadtop.v.conf --tsmc28 --output_file build/tsmc28_sram.v > build/tsmc28_sram.v.conf
	./scripts/vlsi_mem_gen build/threadtop.v.conf --output_file build/sim_sram.v


# Generate run vcd
thread-test:
	$(SBT) "test:runMain thread.ThreadTester"


# clean everything (including IntelliJ project settings)

clean:
	git clean -fd

