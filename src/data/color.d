import std.math;

struct RGB
{
    private ubyte _r;
    private ubyte _g;
    private ubyte _b;
    private bool _invalid = true;

    this(ubyte r, ubyte g, ubyte b)
    {
        this._r = r;
        this._g = g;
        this._b = b;
        this._invalid = false;
    }

    /**
     * Retrieves the R, G and B values
     */
    public @property ubyte r() { return this._r; }
    public @property ubyte g() { return this._g; }
    public @property ubyte b() { return this._b; }
    public @property bool invalid() { return this._invalid; }
    
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
    private bool _invalid = true;
    
    this(ubyte r, ubyte g, ubyte b, ubyte a)
    {
        this._r = r;
        this._g = g;
        this._b = b;
        this._a = a;
        this._invalid = false;
    }

    /**
     * Retrieves the R, G, B and A values
     */
    @property public ubyte r() { return this._r; }
    @property public ubyte g() { return this._g; }
    @property public ubyte b() { return this._b; }
    @property public ubyte a() { return this._a; }
    @property public bool invalid() { return this._invalid; }
    
    /**
     * Sets the R, G, B and A values
     */
    @property public void r(ubyte r) { this._r = r; }
    @property public void g(ubyte g) { this._g = g; }
    @property public void b(ubyte b) { this._b = b; }
    @property public void a(ubyte a) { this._a = a; }

    public RGB toRGB(RGB background)
    {
        return RGB(cast(ubyte)round(this.r*(this.a/255f) + background.r * ((255-this.a)/255f)),
                cast(ubyte)round(this.g*(this.a/255f) + background.g * ((255-this.a)/255f)),
                cast(ubyte)round(this.b*(this.a/255) + background.b * ((255-this.a)/255f)));
    }
}
