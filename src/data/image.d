import std.array;
import std.conv;
import std.algorithm;
public import data.color;

class Image
{

	RGB[][] data;

	alias data this;

	public this(uint x, uint y)
	{
		this.data = uninitializedArray!(RGB[][])(y, x);
	}

	/**
	 * Returns the number of rows of the image
	 */
	@property public uint rows() { return cast(uint)this.data.length; }

	/**
	 * Returns the number of columns of the image
	 */
	@property public uint cols() { return cast(uint)this.data[0].length; }

	/**
	 * Returns the row with the given index as a range
	 */
	public RGB[] row(uint row) { return this.data[row]; }

	/**
	 * Returns the column with the given index as a range
	 */
	public RGB[] column(uint col) { return array(map!(a => a[col])(this.data)); }

	/**
	 * Returns the current image as Portable Pixmap
	 */
	@property public string ppm()
	{
		string head = "P3\n"
					~ to!string(this.cols) ~ " " ~ to!string(this.rows) ~ "\n"
					~ to!string(0xFF) ~ "\n";
		string colors;
		foreach(row; this.data)
		{
			foreach(col; row)
			{
				colors ~= to!string(col.r) ~ " " ~ to!string(col.g) ~ " " ~ to!string(col.b) ~ " ";
			}
		}

		return head ~ colors;
	}
}
