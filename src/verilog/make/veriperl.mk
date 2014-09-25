VERIPERL = $(wildcard *.vp)
VERIPERL_TARGET = $(VERIPERL:%.vp=%.v)
	
$(VERIPERL_TARGET): %.v: %.vp
	mkdir -p build
	../../../../scripts/veriperl.pl -i $< -o build/$@

VERILOG:
	mkdir -p build
	if ls *.v; then cp *.v build/. ; fi

my_build: $(VERIPERL_TARGET) VERILOG

my_unbuild:
	rm -rf build
