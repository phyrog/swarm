import renderer.raycaster.raycaster;
import renderer.camera;
import std.algorithm;
import std.stdio;

import data.voxel;

import data.vector;
import std.math;
import std.datetime;

/+
 + TODO:
 +		Inverted axes
 +
 +		Hidden voxels
 +/

int main(string[] args)
{

	VOctree world = new VOctree(Vector(10f, 10f, 10f));
	world.root.color = RGBA(204, 204, 204, 255);
	VOctreeNode[8] children = [new VOctreeNode(), new VOctreeNode(), new VOctreeNode(), new VOctreeNode(), 
			new VOctreeNode(), new VOctreeNode(), new VOctreeNode(), new VOctreeNode()];
	VOctreeNode[8] children2 = [new VOctreeNode(), new VOctreeNode(), new VOctreeNode(), new VOctreeNode(), 
			new VOctreeNode(), new VOctreeNode(), new VOctreeNode(), new VOctreeNode()];
	children[3].color = RGBA(255, 0, 0, 255);
	children[1].color = RGBA(255, 255, 0, 255);
	children2[0].color = RGBA(0, 255, 0, 255);
	children[2].children = children2;
	world.root.children = children;

	Engine rc = new Raycaster(1000, 700, world);
	rc.activeCamera = new Camera(Vector(10f, 10f, -20f), Vector(0f, 0f, 0f));


	StopWatch sw;
	sw.start();
	rc.render();
	sw.stop();
	writeln("render(): ", sw.peek().msecs, "ms");

    StopWatch sw2;
    sw2.start();
    rc.render();
    sw2.stop();
	writeln("render(): ", sw2.peek().msecs, "ms");
	
    StopWatch sw3;
    sw3.start();
    rc.render();
    sw3.stop();
	writeln("render(): ", sw3.peek().msecs, "ms");
    
    /* write(rc.currentImage.ppm); */

	return 0;
}
