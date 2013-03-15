public import data.image;
import renderer.camera;

abstract class Engine
{
	private Camera activeCam;

	protected Image frontBuffer;
	protected Image backBuffer;

	this(uint x, uint y)
	{
		this.frontBuffer = new Image(x, y);
		this.backBuffer = new Image(x, y);
	}

	/**
	 * Retrieves the currently active camera
	 */
	public final @property Camera activeCamera() { return this.activeCam; }

	/**
	 * Sets the active camera
	 */
	public final @property void activeCamera(Camera cam) { this.activeCam = cam; }

	/**
	 * Swaps the front and back buffer
	 */
	public final void swapBuffers()
	{
		auto tmp = this.frontBuffer;
		this.frontBuffer = this.backBuffer;
		this.backBuffer = tmp;
	}

	/**
	 * Renders the next image into the back buffer
	 */
	public abstract void render();

	/**
	 * Retrieves the last completely rendered image
	 */
	public final @property Image currentImage() { return this.frontBuffer; }

	/*
	 * Retrieves the image that is currently being rendered
	 * Note that this image is probably incomplete
	 */
	public final @property Image nextImage() { return this.backBuffer; }
}
