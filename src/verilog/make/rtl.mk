include ../../make/veriperl.mk
build: my_build
	cd ../common && make my_build
unbuild: my_unbuild
	cd ../common && make my_unbuild
