public import data.vector;

class Camera
{
	private Vector position_;
	private Vector direction_;

	this()
	{
		this.position_ = Vector(0f, 0f, 0f);
		this.direction_ = Vector(0f, 0f, 1f);
	}

	this(Vector position, Vector direction)
	{
		this.position_ = position;
		this.direction_ = direction.unit;
	}

	/**
	 * Retrieves the position of the camera
	 */
	@property public Vector position() { return this.position_; }

	/**
	 * Sets the position of the camera
	 */
	@property public void position(Vector position) { this.position_ = position; }

	/**
	 * Retrieves the direction of the camera as a unit vector
	 */
	@property public Vector direction() { return this.direction_.unit!1f; }

	/**
	 * Sets the direction of the camera.
	 * Converts the vector to a unit vector
	 */
	@property public void direction(Vector direction) { this.direction_ = direction.unit!1f; }
}
