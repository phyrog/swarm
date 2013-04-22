import renderer.raycaster.raycaster;
import renderer.camera;
import std.algorithm;
import event_manager;
import std.stdio;

import data.voxel;

import std.conv;

import derelict.sdl2.sdl;

import data.vector;
import std.math;
import std.datetime;

/+
 + TODO:
 +        Inverted axes
 +
 +        Hidden voxels
 +/

int main(string[] args)
{
    int sizeX = 1000;
    int sizeY = 700;
    if(args.length > 1) sizeX = to!int(args[1]);
    if(args.length > 2) sizeY = to!int(args[2]);
    
    DerelictSDL2.load();

    VOctree world = new VOctree(Vector(10f, 10f, 10f));
    world.root.color = RGBA(204, 204, 204, 255);
    world.root.createChildren();
    world.root.children[2].createChildren();
    
    world.root.children[3].color = RGBA(255, 0, 0, 255);
    world.root.children[1].color = RGBA(255, 255, 0, 255);
    world.root.children[2].children[0].color = RGBA(0, 255, 0, 255);

    Engine rc = new Raycaster(sizeX, sizeY, world);
    rc.activeCamera = new Camera(Vector(10f, 10f, -20f), Vector(0f, 0f, 0f));

    StopWatch sw;

    SDL_Init(SDL_INIT_EVERYTHING);

    SDL_Window* window = SDL_CreateWindow("Swarm", SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED, sizeX, sizeY, SDL_WINDOW_SHOWN);
    

    bool done = false;
    SDL_Event sdl_event;

    bool a;

    StopWatch s;
    while(!done)
    {
        sw.start();
        while(SDL_PollEvent(&sdl_event))
        {
            if(sdl_event.type==SDL_QUIT) done = true;
        }
        foreach(Event e; eventQueue())
        {
            e.fireInstant();
            emptyEventQueue();
        }
        rc.render();
        sw.stop();
        writeln(sw.peek().msecs, "ms / frame");
        sw.reset();
        
        if(a)
        {
            rc.activeCamera.position(Vector(10f, 10f, -20f));
            rc.activeCamera.focus(Vector(5f, 5f, 5f));
        }
        a = !a;
    }
    return 0;
}
