import ceylon.collection { LinkedList, MutableList }

shared class SimpleTreeNode<Element>(element = null, TreeNode<Element>* initialChildren)
		satisfies TreeNode<Element>
{
	// Must be set after object construction. Bidirectional construction is hard / not possible.
	// See https://groups.google.com/d/msg/ceylon-users/KkohG7kHI64/Io5uc3759WwJ
	shared actual variable TreeNode<Element>? parent = null;

	MutableList<TreeNode<Element>> childList = LinkedList(initialChildren);
	shared actual Iterable<TreeNode<Element>> children => childList;

	shared actual variable Element? element;

	shared actual Boolean isLeaf() => childList.empty;

	"To be called on the root of the full tree after building it, to set up the parents of each node."
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
		if (exists p = parent, is SimpleTreeNode<Element> p)
		{
			p.removeChild(this);
		}
	}

	shared actual void attachTo(TreeNode<Element> newParent)
	{
		if (is SimpleTreeNode<Element> newParent)
		{
			removeFromParent();
			// TODO assert that the given node isn't part of the tree below this node...
			newParent.addChild(this);
		}
	}

	void addChild(TreeNode<Element> child)
	{
		if (!childList.contains(child))
		{
			childList.add(child);
			child.parent = this;
		}
	}

	void removeChild(TreeNode<Element> child)
	{
		childList.remove(child);
		child.parent = null;
	}

	//shared actual TreeNode<Element>? searchElement(
	//	Element item,
	//	Iterable<TreeNode<Element>> transversal)
	//{
	//	for (node in transversal)
	//	{
	//		if (exists node.element && node.element == item)
	//		{
	//			return node;
	//		}
	//	}
	//	return null;
	//}

	string => "SimpleTreeNode{``element else "(no element)"``, ``childList.size`` children}";
}
