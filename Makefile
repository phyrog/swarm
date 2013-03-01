all: raycaster

raycaster:
	cd src; dmd -lib ./renderer/raycaster/raycaster.d -of../bin/raycaster.a

.PHONY: all raycaster
