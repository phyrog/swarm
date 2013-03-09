all: link

link: raycaster main data
	cd bin; dmd -of./swarm ./lib/*.o

main:
	cd src; dmd -od../bin/lib ./main.d -c

raycaster:
	cd src; dmd -od../bin/lib ./renderer/engine.d -c
	cd src; dmd -od../bin/lib ./renderer/camera.d -c
	cd src; dmd -od../bin/lib ./renderer/raycaster/ray.d -c
	cd src; dmd -od../bin/lib ./renderer/raycaster/raycaster.d -c

data:
	cd src; dmd -od../bin/lib ./data/color.d -c
	cd src; dmd -od../bin/lib ./data/image.d -c
	cd src; dmd -od../bin/lib ./data/vector.d -c
	cd src; dmd -od../bin/lib ./data/voxel.d -c


.PHONY: all link main raycaster
