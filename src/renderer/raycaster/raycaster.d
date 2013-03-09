public import renderer.engine;
public import renderer.raycaster.ray;
import data.vector;
import data.image;
import std.math;
import std.array;
import std.parallelism;
import std.conv;

import std.stdio;

class Raycaster : Engine
{

	private Vector[][] cameraMat;

	private const float fieldOfViewRatio = 130f/180f;
	private float anglePerPixel;

	this(uint x, uint y)
	{
		super(x, y);
		this.cameraMat = uninitializedArray!(Vector[][])(y, x);

		if(to!float(y) / to!float(x) > fieldOfViewRatio)
		{
			anglePerPixel = 130f / y;
		}
		else {
			anglePerPixel = 180f / x;
		}

		foreach(r, ref row; taskPool.parallel(this.cameraMat))
		{
			foreach(c, ref col; taskPool.parallel(row))
			{
				col = Vector(0, 0, 1f).rotate(
						Vector((y/2f-r)*anglePerPixel*PI/180,
							   (x/2f-c)*anglePerPixel*PI/180,
							   0f)
					);
				if(r > y/2-2 && r < y/2+2 && c > x/2-2 && c < x/2+2) {
					writeln(col);
				}
			}
		}
	}

	override void render()
	{
		// TODO: Stub
		this.swapBuffers();
	}
}
