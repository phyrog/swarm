all: raycaster main

main:
	cd src; dmd -of../bin/swarm -od../bin/lib ./main.d ../bin/lib/*.a

raycaster:
	cd src; dmd -lib ./renderer/raycaster/raycaster.d -of../bin/raycaster.a

.PHONY: all main raycaster
