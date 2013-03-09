
struct RGB
{
	private ubyte _r;
	private ubyte _g;
	private ubyte _b;

	/**
	 * Retrieves the R, G and B values
	 */
	public @property ubyte r() { return this._r; }
	public @property ubyte g() { return this._g; }
	public @property ubyte b() { return this._b; }
	
	/**
	 * Sets the R, G and B values
	 */
	public @property void r(ubyte r) { this._r = r; }
	public @property void g(ubyte g) { this._g = g; }
	public @property void b(ubyte b) { this._b = b; }
}

struct RGBA
{
	private ubyte _r;
	private ubyte _g;
	private ubyte _b;
	private ubyte _a;
	
	/**
	 * Retrieves the R, G, B and A values
	 */
	@property public ubyte r() { return this._r; }
	@property public ubyte g() { return this._g; }
	@property public ubyte b() { return this._b; }
	@property public ubyte a() { return this._a; }
	
	/**
	 * Sets the R, G, B and A values
	 */
	@property public void r(ubyte r) { this._r = r; }
	@property public void g(ubyte g) { this._g = g; }
	@property public void b(ubyte b) { this._b = b; }
	@property public void a(ubyte a) { this._a = a; }
}
