all: raycaster main

main:
	cd src; dmd -of../bin/swarm -od../bin/lib ./main.d ../bin/lib/*.a

raycaster:
	cd src; dmd -lib -Xf../doc/raycaster.json -od../bin/lib ./renderer/raycaster/raycaster.d

.PHONY: all main raycaster
