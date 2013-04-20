public import renderer.engine;
public import renderer.raycaster.ray;
import data.vector;
import data.image;
import data.voxel;
import event_manager;
import std.math;
import std.algorithm : min, max;
import std.array;
import std.parallelism;
import std.conv;
import std.typecons;

import std.stdio;
import std.datetime;

class Raycaster : Engine
{

    private VOctree tree;

    private const float angleHoriz = 60f;
    private const float angleVert = 45f;
    private const float fieldOfViewRatio = angleVert/angleHoriz;
    private float anglePerPixel;

    private Vector[][] camRays;
    private Quaternion camRotation;
    private bool calcRays = true;

    this(uint x, uint y, VOctree tree)
    {
        super(x, y);

        (Event.CAMERA_STARTUP).register(&this.calculateCameraRotation);
        (Event.CAMERA_POSITION_CHANGED).register(&this.calculateCameraRotation);
        (Event.CAMERA_FOCUS_CHANGED).register(&this.calculateCameraRotation);
        (Event.CAMERA_STARTUP).register(&this.calculateRayRotation);

        this.tree = tree;

          this.camRays = uninitializedArray!(Vector[][])(y, x);

        if(to!float(y) / to!float(x) > fieldOfViewRatio)
        {
            anglePerPixel = angleVert / y;
        }
        else {
            anglePerPixel = angleHoriz / x;
        }
    }

    private void calculateCameraRotation()
    {
        /* writeln("Recalculating camera rotation..."); */
        Quaternion cameraRotationSide;
        if(this.activeCamera.direction.y.abs().approxEqual(1f))
        {
            cameraRotationSide = Quaternion.fromAxisAngle(0f, Vector(0f, 1f, 0f));
        }
        else if(this.activeCamera.direction.z < 0f && this.activeCamera.direction.x.approxEqual(0f))
        {
            cameraRotationSide = Quaternion.fromAxisAngle(PI, Vector(0f, 1f, 0f));
        }
        else
        {
            cameraRotationSide = Vector(0f, 0f, 1f).rotationTo(
                Vector(this.activeCamera.direction.x, 0f, this.activeCamera.direction.z).unit);
        }

        Quaternion cameraRotationUp;
        if(this.activeCamera.direction.y.abs().approxEqual(1f)) {
            cameraRotationUp = Quaternion.fromAxisAngle(-this.activeCamera.direction.y * PI/2, Vector(1f, 0f, 0f));
        }
        else
        {
            cameraRotationUp = Vector(this.activeCamera.direction.x, 0f, this.activeCamera.direction.z).unit.rotationTo(this.activeCamera.direction.unit);
        }

        this.camRotation = cameraRotationUp * cameraRotationSide;
    }

    private void calculateRayRotation()
    {
        this.calcRays = true;
        /* writeln("Calculating rays next tick..."); */
    }

    override void render()
    {
        StopWatch sw;
        foreach(r, ref row; taskPool.parallel(this.backBuffer.raw))
        {
            foreach(c, ref col; taskPool.parallel(row))
            {
                if(this.calcRays) {
                    Quaternion raySide = Quaternion((c-this.backBuffer.cols/2f)*anglePerPixel/180*PI, Vector(0f, 1f, 0f));
                    Quaternion rayUp = Quaternion((r-this.backBuffer.rows/2f)*anglePerPixel/180*PI, Vector(1f, 0f, 0f));
                    camRays[r][c] = Vector(0f, 0f, 1f).rotate(this.camRotation * raySide * rayUp);
                }
            //  Quaternion cameraRotationAngle = Quaternion(this.activeCamera.rotation/2f, this.activeCamera.direction).unit;

                sw.start();
                VOctreeNode[] nodes = this.traverseTree(camRays[r][c], r, c);
                sw.stop();
                if(nodes.length > 0)
                {
                    VOctreeNode node = nodes[0];
                    col = node.color.toRGB(RGB(0, 0, 0));
                }
                else
                {
                    col = RGB(0, 0, 0);
                }
            }
        }
        
        this.calcRays = false;
        this.swapBuffers();
        /* writeln("traverseTree(): ", sw.peek().msecs, "ms"); */
    }

    private Tuple!(Vector, Vector) intersections(Vector ray, Vector delta, Vector size)
    {
        ubyte index = 0;

        if(this.activeCamera.position.x > delta.x) index+=1;
        if(this.activeCamera.position.y > delta.y) index+=2;
        if(this.activeCamera.position.z > delta.z) index+=4;

        Vector nearPlanes = Vector(delta.x+(index & 1 ? size.x/2f : -size.x/2f), 
                                   delta.y+(index & 2 ? size.y/2f : -size.y/2f), 
                                   delta.z+(index & 4 ? size.z/2f : -size.z/2f));
        Vector farPlanes = delta - (nearPlanes - delta);

        Vector intersectionNear = (nearPlanes - this.activeCamera.position) / ray;
        Vector intersectionFar = (farPlanes - this.activeCamera.position) / ray;
    
        if(intersectionNear.x > intersectionFar.x)
        {
            float tmpX = intersectionNear.x;
            intersectionNear.subst!("x")(intersectionFar.x);
            intersectionFar.subst!("x")(tmpX);
        }
        if(intersectionNear.y > intersectionFar.y)
        {
            float tmpY = intersectionNear.y;
            intersectionNear.subst!("y")(intersectionFar.y);
            intersectionFar.subst!("y")(tmpY);
        }
        if(intersectionNear.z > intersectionFar.z)
        {
            float tmpZ = intersectionNear.z;
            intersectionNear.subst!("z")(intersectionFar.z);
            intersectionFar.subst!("z")(tmpZ);
        }

        return tuple(intersectionNear, intersectionFar);

    }

    private VOctreeNode[] traverseTree(Vector ray, ulong row, ulong column, int depth = 0)
    {
        VOctreeNode node = this.tree.root;
        VOctreeNode prev = null;
        Vector size = this.tree.size;
        Vector delta = Vector(0f, 0f, 0f);
        uint currentDepth = 1;
        
        //   6____7
        //  /|   /|
        // 2____3 |
        // | 4__|_5
        // |/   |/
        // 0____1

        auto intersections = this.intersections(ray, delta, size);

        float dNear = max(intersections[0].x, intersections[0].y, intersections[0].z);
        float dFar = min(intersections[1].x, intersections[1].y, intersections[1].z);

        if(dNear > dFar || dFar < 0f)
        {
            return [];
        }

        Vector collision = this.activeCamera.position + ray * dNear;

        while(node !is null && node.hasChildren)
        {
            ubyte nextNode = 0;
    
            size.x/=2f;
            size.y/=2f;
            size.z/=2f;
    
            if(collision.x > delta.x)
            {
                nextNode+=1;
                delta.x+=size.x/2f;
            } else { delta.x-=size.x/2f; }

            if(collision.y > delta.y)
            {
                nextNode+=2;
                delta.y+=size.y/2f;
            } else { delta.y-=size.y/2f; }

            if(collision.z > delta.z)
            {
                nextNode+=4;
                delta.z+=size.z;
            } else { delta.z-=size.z/2f; }
        
            prev = node;
            node = node.children[nextNode];
            ++currentDepth;
        }

        return [node];
    }
}
