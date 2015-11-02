build:
	cd common && make my_build
	cd decode && make my_build
	cd exec && make my_build
	cd fetch && make my_build
	cd instr_buffer && make my_build
	cd issue && make my_build
	cd lsu && make my_build
	cd memory && make my_build
	cd salu && make my_build
	cd sgpr && make my_build
	cd simd && make my_build
	cd tracemon && make my_build
	cd vgpr && make my_build
	cd wavepool && make my_build
	cd compute_unit && make my_build
	cd simf && make my_build
	cd rfa && make my_build
	cd alu && make my_build
	cd dispatcher && make my_build

fpga: build
	mkdir -p fpga_core
	cp common/build/* fpga_core/
	cp decode/build/* fpga_core/
	cp exec/build/* fpga_core/
	cp fetch/build/* fpga_core/
	cp issue/build/* fpga_core/
	cp lsu/build/* fpga_core/
	cp salu/build/* fpga_core/
	cp sgpr/build/* fpga_core/
	cp simd/build/* fpga_core/
	cp vgpr/build/* fpga_core/
	cp wavepool/build/* fpga_core/
	cp simf/build/* fpga_core/
	cp rfa/build/* fpga_core/
	cp alu/build/* fpga_core/
	./fpga_make.sh
	cp fpga/* fpga_core/

compile: build
	vcs -full64 +libext+.v compute_unit/build/*.v decode/build/*.v exec/build/*.v fetch/build/*.v instr_buffer/build/*.v issue/build/*.v lsu/build/*.v memory/build/*.v salu/build/*.v sgpr/build/*.v simd/build/*.v tracemon/build/*.v tracemon/*.c vgpr/build/*.v wavepool/build/*.v -y common/build/ +lint=all -timescale=1ns/1ns -l compile.log -debug_all +v2k -sverilog

check:
	cd decode && make clean && make compile
	cd exec && make clean && make compile
	cd fetch && make clean && make compile
	cd instr_buffer && make clean && make compile
	cd issue && make clean && make compile
	cd lsu && make clean && make compile
	cd memory && make clean && make compile
	cd salu && make clean && make compile
	cd sgpr && make clean && make compile
	cd simd && make clean && make compile
	cd tracemon && make clean && make compile
	cd vgpr && make clean && make compile
	cd wavepool && make clean && make compile
	cd simf && make clean && make compile
	cd rfa && make clean && make compile
	cd alu && make clean && make compile
	make compile

unbuild:
	cd common && make my_unbuild
	cd decode && make my_unbuild
	cd exec && make my_unbuild
	cd fetch && make my_unbuild
	cd instr_buffer && make my_unbuild
	cd issue && make my_unbuild
	cd lsu && make my_unbuild
	cd memory && make my_unbuild
	cd salu && make my_unbuild
	cd sgpr && make my_unbuild
	cd simd && make my_unbuild
	cd tracemon && make my_unbuild
	cd vgpr && make my_unbuild
	cd wavepool && make my_unbuild
	cd compute_unit && make my_unbuild
	cd simf && make my_unbuild
	cd rfa && make my_unbuild
	cd alu && make my_unbuild

uncheck:
	cd decode && make clean
	cd exec && make clean
	cd fetch && make clean
	cd instr_buffer && make clean
	cd issue && make clean
	cd lsu && make clean
	cd memory && make clean
	cd salu && make clean
	cd sgpr && make clean
	cd simd && make clean
	cd tracemon && make clean
	cd vgpr && make clean
	cd wavepool && make clean
	cd simf && make clean
	cd rfa && make clean
	cd dispatcher && make clean
	cd alu && make clean

clean: unbuild uncheck
	rm -rf csrc/ simv simv.daidir/ compile.log
