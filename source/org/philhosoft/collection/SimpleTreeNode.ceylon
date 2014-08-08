import ceylon.collection { LinkedList, MutableList }

shared class SimpleTreeNode<Element>(element = null, TreeNode<Element>* initialChildren)
		satisfies TreeNode<Element>
{
	// Must be set after object construction. Bidirectional construction is hard / not possible.
	// See https://groups.google.com/d/msg/ceylon-users/KkohG7kHI64/Io5uc3759WwJ
	shared actual variable TreeNode<Element>? parent = null;

	// TODO Should we hide this list, to control what is going on, to avoid loops and such?
	// Or should we leave the user the possibility to shoot on his foot?
	shared actual MutableList<TreeNode<Element>> children = LinkedList(initialChildren);

	shared actual variable Element? element;

	shared actual Boolean isLeaf() => children.empty;

	"To be called on root of the full tree to set up the parents of each node."
	shared SimpleTreeNode<Element> attach(TreeNode<Element> node = this)
	{
		for (child in node.children)
		{
			child.parent = node;
			attach(child);
		}
		return this;
	}

	shared actual void removeFromParent()
	{
		if (exists p = parent)
		{
			p.children.removeElement(this);
			parent = null;
		}
	}

	shared actual void attachTo(TreeNode<Element> node)
	{
		removeFromParent();
		// TODO assert that the given node isn't part of the tree below this node...
		parent = node;
		if (!node.children.contains(this))
		{
			node.children.add(this);
		}
	}

	string => "SimpleTreeNode{``element else "(no element)"``, ``children.size`` children}";
}
