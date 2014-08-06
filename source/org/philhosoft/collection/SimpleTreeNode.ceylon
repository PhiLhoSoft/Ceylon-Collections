import ceylon.collection { LinkedList, MutableList }

shared class SimpleTreeNode<Element>(element = null, TreeNode<Element>* initialChildren)
		satisfies TreeNode<Element>
{
	// Must be set after object construction. Bidirectional construction is hard / not possible.
	// See https://groups.google.com/d/msg/ceylon-users/KkohG7kHI64/Io5uc3759WwJ
	shared actual variable TreeNode<Element>? parent = null;

	shared actual MutableList<TreeNode<Element>> children = LinkedList(initialChildren);

	shared actual variable Element? element;

	shared actual Boolean isLeaf() => children.empty;

	shared SimpleTreeNode<Element> attach(TreeNode<Element> node = this)
	{
		for (child in node.children)
		{
			child.parent = node;
			attach(child);
		}
		return this;
	}

	shared void removeFromParent()
	{
		if (exists p = parent)
		{
			p.children.removeElement(this);
			parent = null;
		}
	}

	string => "SimpleTreeNode{``element else "(no element)"``, ``children.size`` children}";
}
