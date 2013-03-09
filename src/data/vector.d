import std.math;

struct Vector
{
	float x;
	float y;
	float z;

	@property pure float length()
	{
		return sqrt(x*x+y*y+z*z);
	}

	@property pure Vector unit(float base = 1f)()
	{
		return Vector(base*x/this.length, base*y/this.length, base*z/this.length);
	}

	pure Vector rotate(Vector rad)
	out(r) {
		Vector a = r;
		assert(a.length.approxEqual(this.length));
	}
	body {
		return Vector(
				cos(rad.y)*cos(rad.z)*this.x + 
					(cos(rad.x)*sin(rad.z) + sin(rad.x)*sin(rad.y)*cos(rad.z))*this.y + 
					(sin(rad.x)*sin(rad.z) - cos(rad.x)*sin(rad.y)*cos(rad.z)) * this.z,
				-cos(rad.y)*sin(rad.z)*this.x + 
					(cos(rad.x)*cos(rad.z) - sin(rad.x)*sin(rad.y)*sin(rad.z))*this.y + 
					(sin(rad.x)*cos(rad.z) + cos(rad.x)*sin(rad.y)*sin(rad.z)) * this.z,
				sin(rad.y)*this.x - 
					sin(rad.x)*cos(rad.y)*this.y + 
					cos(rad.x)*cos(rad.y)*this.z
			);
	}
}
