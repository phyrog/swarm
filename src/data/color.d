
struct RGB
{
	private byte _r;
	private byte _g;
	private byte _b;

	/**
	 * Retrieves the R, G and B values
	 */
	public @property byte r() { return this._r; }
	public @property byte g() { return this._g; }
	public @property byte b() { return this._b; }
	
	/**
	 * Sets the R, G and B values
	 */
	public @property void r(byte r) { this._r = r; };
	public @property void g(byte g) { this._g = g; };
	public @property void b(byte b) { this._b = b; };
}
