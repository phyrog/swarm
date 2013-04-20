CC=dmd
SRC=src
AFLAGS=
CFLAGS=-od../bin/lib -c $(AFLAGS)
LFLAGS=-L-lDerelictSDL2 -L-lDerelictUtil -L-ldl $(AFLAGS)

all: link

release: AFLAGS += -release
release: link

link: raycaster main event_manager data
	cd bin; $(CC) $(LFLAGS) -of./swarm ./lib/*.o

main:
	cd $(SRC); $(CC) $(CFLAGS) ./main.d

raycaster:
	cd $(SRC); $(CC) $(CFLAGS) ./renderer/engine.d
	cd $(SRC); $(CC) $(CFLAGS) ./renderer/camera.d
	cd $(SRC); $(CC) $(CFLAGS) ./renderer/raycaster/ray.d
	cd $(SRC); $(CC) $(CFLAGS) ./renderer/raycaster/raycaster.d

event_manager:
	cd $(SRC); $(CC) $(CFLAGS) ./event_manager.d

data:
	cd $(SRC); $(CC) $(CFLAGS) ./data/color.d
	cd $(SRC); $(CC) $(CFLAGS) ./data/image.d
	cd $(SRC); $(CC) $(CFLAGS) ./data/vector.d
	cd $(SRC); $(CC) $(CFLAGS) ./data/voxel.d
	cd $(SRC); $(CC) $(CFLAGS) ./data/event.d


.PHONY: all link main raycaster data event_manager
