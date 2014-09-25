browse:
	dve -full64 -vpd vcdplus.vpd

run:
	../simv |& tee run.log

waves:
	../simv +dump_waveforms=1 |& tee run.log
