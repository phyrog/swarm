all: link

link: raycaster main event_manager data
	cd bin; dmd -of./swarm ./lib/*.o

main:
	cd src; dmd -od../bin/lib ./main.d -c

raycaster:
	cd src; dmd -od../bin/lib ./renderer/engine.d -c
	cd src; dmd -od../bin/lib ./renderer/camera.d -c
	cd src; dmd -od../bin/lib ./renderer/raycaster/ray.d -c
	cd src; dmd -od../bin/lib ./renderer/raycaster/raycaster.d -c

event_manager:
	cd src; dmd -od../bin/lib ./event_manager.d -c

data:
	cd src; dmd -od../bin/lib ./data/color.d -c
	cd src; dmd -od../bin/lib ./data/image.d -c
	cd src; dmd -od../bin/lib ./data/vector.d -c
	cd src; dmd -od../bin/lib ./data/voxel.d -c
	cd src; dmd -od../bin/lib ./data/event.d -c


.PHONY: all link main raycaster data event_manager
