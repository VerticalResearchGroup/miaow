#This Makefile supports the following commands:
#make build
#make clean
#make unbuild (same as clean)

include ../../make/rtl.mk
clean: unbuild
	rm -rf csrc/ simv simv.daidir/ compile.log

compile: build
	vcs -full64 +libext+.v build/*.v -y ../common/build/ +lint=all -timescale=1ns/1ns -l compile.log -debug_all +v2k
