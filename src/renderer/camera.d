public import data.vector;
import event_manager;

class Camera
{
    private Vector position_;
    private Vector focus_;
    private float rotation_;

    this()
    {
        this.position_ = Vector(0f, 0f, 0f);
        this.focus_ = Vector(0f, 0f, 0f);
        this.rotation_ = 0f;
        (Event.CAMERA_STARTUP).fire();
    }

    this(Vector position, Vector focus, float rotation = 0f)
    {
        this.position_ = position;
        this.focus_ = focus;
        this.rotation_ = rotation;
        (Event.CAMERA_STARTUP).fire();
    }

    /**
     * Retrieves the position of the camera
     */
    @property public Vector position() { return this.position_; }

    /**
     * Sets the position of the camera
     */
    @property public void position(Vector position) { this.position_ = position; (Event.CAMERA_POSITION_CHANGED).fire(); }

    /**
     * Retrieves the focal point of the camera
     */
    @property public Vector focus() { return this.focus_; }

    /**
     * Sets the focus of the camera.
     */
    @property public void focus(Vector focus) { this.focus_ = focus; (Event.CAMERA_FOCUS_CHANGED).fire(); }

    @property public float rotation() { return this.rotation_; }

    @property public void rotation(float rotation) { this.rotation_ = rotation; }

    @property public Vector direction() { return (this.focus_ - this.position_).unit; }
}
