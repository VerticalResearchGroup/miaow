include ../../make/veriperl.mk

#The basename of pwd gives the unit name
#eg, /miaow/src/verilog/tb/<unit>
#The assumption is that rtl for the unit will reside in:
# /miaow/src/verilog/rtl/<unit>
UNIT_NAME = $(shell basename `pwd`)

build: my_build
	cd ../../rtl/$(UNIT_NAME) ; make build
	echo "+libext+.v" > build/vcs.list
	echo "../../rtl/common/build/global_definitions.v" >> build/vcs.list
	echo "../../rtl/common/build/issue_definitions.v" >> build/vcs.list
	echo "../../rtl/alu/alu_definitions.v" >> build/vcs.list
	ls -d ../../rtl/common/build/ | sed -e 's/\(.*\)/-y &/g' >> build/vcs.list
	ls -d build/* | grep -v vcs.list >> build/vcs.list
	ls -d ../../rtl/$(UNIT_NAME)/build/* >> build/vcs.list
	if ls -d ../../rtl/$(UNIT_NAME)/*.c; then ls -d ../../rtl/$(UNIT_NAME)/*.c >> build/vcs.list; fi

unbuild: my_unbuild
	cd ../../rtl/$(UNIT_NAME) ; make unbuild
