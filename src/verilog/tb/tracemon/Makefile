##########################  Section I - For build  #########################
include ../../make/tb.mk
#This section is for building the tb along with all the unit rtl and 'common' rtl
#Commands supported:
#make build
#make unbuild (Just deletes the build directory)
######################## Section II - VCS commands  ######################## 
#NOTE: Before running these commands, setup the vcs environment variables:
#source ../../../../syn/synopsys/setup_synopsys
#Feel free to edit below lines as and when needed
#Commands supported:
#make compile
#make run
#make waves
#make browse
#make interact
#make clean (Deletes the build directory; Also deletes vcs generated files)

compile: build
	vcs -full64 -f build/vcs.list +lint=all -timescale=1ns/1ns -l compile.log -debug_all +v2k -sverilog

run: simv
	simv +print_outputs=1 -l run.log

waves: simv
	simv +print_outputs=1 +dump_waveforms=1 -l run.log

browse:
	dve -full64 -vpd vcdplus.vpd	

interact: simv
	simv +print_outputs=1 +dump_waveforms=1 -l run.log -gui

clean: unbuild
	rm -rf csrc simv simv.daidir ucli.key compile.log run.log DVEfiles vcdplus.vpd inter.vpd
	rm -f vc_hdrs.h
