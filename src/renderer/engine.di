import data.image;

interface Engine
{
	/**
	 * Retrieves the last completely rendered image
	 */
	public @property Image currentImage();

	/*
	 * Retrieves the image that is currently being rendered
	 * Note that this image is probably incomplete
	 */
	public @property Image nextImage();
}
