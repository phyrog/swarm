import data.color;
import data.vector;

class VOctree
{
	private VOctreeNode root_;
	private Vector size_;

	this(Vector size, VOctreeNode root = new VOctreeNode())
	{
		this.size_ = size;
		this.root_ = root;
	}

	@property public VOctreeNode root() { return this.root_; }
	@property public void root(VOctreeNode root) { this.root_ = root; }

	@property public Vector size() { return this.size_; }
	@property public void size(Vector size) { this.size_ = size; }
}

class VOctreeNode
{
	private RGBA color_;

	private VOctreeNode parent_;
	private VOctreeNode[8] children_;

	@property public RGBA color() { return (this.color_.invalid ? this.parent_.color : this.color_); }
	@property public void color(RGBA color) { this.color_ = color; }

	@property VOctreeNode parent() { return this.parent_; }
	@property void parent(VOctreeNode node) { this.parent_ = node; }

	@property bool hasChildren() { return this.children[0] !is null; }

	@property VOctreeNode[8] children() { return this.children_; }
	@property void children(VOctreeNode[8] nodes)
	{
		this.children_ = nodes;
		foreach(ref child; children)
		{
			child.parent = this;
		}
	}
}
