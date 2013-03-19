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

	pure Vector opBinary(string op)(Vector v)
	{
		switch(op)
		{
			case "+":
				return Vector(this.x + v.x, this.y+v.y, this.z+v.z);
				break;
			case "-":
				return Vector(this.x - v.x, this.y-v.y, this.z-v.z);
				break;
			case "/":
				return Vector(this.x/v.x, this.y/v.y, this.z/v.z);
				break;
			case "*":
				return Vector(this.y*v.x, this.y*v.y, this.z*v.z);
				break;
			default:
				throw new Exception("No such operator");
		}
	}

	pure Vector opBinary(string op)(float scalar)
	{
		switch(op)
		{
			case "*":
				return Vector(this.x*scalar, this.y*scalar, this.z*scalar);
				break;
			case "/":
				return Vector(this.y/scalar, this.y/scalar, this.z/scalar);
				break;
			default:
				throw new Exception("No such operator");
		}
	}

	pure float dot(Vector v)
	{
		return this.x*v.x + this.y*v.y + this.z*v.z;
	}

	pure Vector cross(Vector v)
	{
		return Vector(this.y*v.z - this.z*v.y,
					  this.z*v.x - this.x*v.z,
					  this.x*v.y - this.y*v.x);
	}

	/**
	 * Rotates the vector with the given quaternion
	 */
	pure Vector rotate(Quaternion q)
	{
		return (q * this * q.inv).vector;
	}

	pure Quaternion rotationTo(Vector v)
	{
		float s = sqrt((1+this.dot(v))*2);
		float invs = 1/s;

		Vector c = this.cross(v);

		return Quaternion(s*0.5f,
						  Vector(c.x*invs,
								 c.y*invs,
								 c.z*invs));
	}
}

struct Quaternion
{
	float angle;
	Vector vector;

	@property public pure float w() { return this.angle; }
	@property public pure float x() { return this.vector.x; }
	@property public pure float y() { return this.vector.y; }
	@property public pure float z() { return this.vector.z; }

	@property public pure Quaternion inv() { return Quaternion(this.w, Vector(-this.x, -this.y, -this.z)); }

	@property public float length()
	{
		return sqrt(this.w*this.w + this.x*this.x + this.y*this.y + this.z*this.z);
	}

	@property public Quaternion unit(float base = 1f)()
	{
		return Quaternion(base*this.w/this.length,
						  Vector(base*this.x/this.length,
								 base*this.y/this.length,
								 base*this.z/this.length));
	}

	public static pure Quaternion fromAxisAngle(float angle, Vector axis)
	{
		return Quaternion(cos(angle/2f), axis * sin(angle/2f));
	}

	public Quaternion opBinary(string op)(Quaternion q)
	{
		static if(op == "*")
		{
			return Quaternion(this.w*q.w - this.x*q.x - this.y*q.y - this.z*q.z,
					   Vector(this.w*q.x + this.x*q.w + this.y*q.z - this.z*q.y,
							  this.w*q.y - this.x*q.z + this.y*q.w + this.z*q.x,
							  this.w*q.z + this.x*q.y - this.y*q.x + this.z*q.w));
		}
		else throw new Exception("Unsupported operation");
	}

	public Quaternion opBinary(string op)(Vector v)
	{
		static if(op == "*")
		{
			return this * Quaternion(0f, v);
			/*return Quaternion(-this.x*v.x - this.y*v.y - this.z*v.z,
					   Vector(this.w*v.x + this.y*v.z - this.z*v.y,
							  this.w*v.y - this.x*v.z + this.z*v.x,
							  this.w*v.z + this.x*v.y - this.y*v.x));*/
		}
		else throw new Exception("Unsupported operation");
	}
}
