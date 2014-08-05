import ceylon.collection { LinkedList, MutableList }

shared class SimpleTreeNode<Element>(element = null, parent = null, children = LinkedList<TreeNode<Element>>())
		satisfies TreeNode<Element>
{
	shared actual variable TreeNode<Element>? parent;

	shared actual MutableList<TreeNode<Element>> children;

	shared actual variable Element? element;

	shared actual Boolean isLeaf() => children.empty;

	// According to https://groups.google.com/d/msg/ceylon-users/KkohG7kHI64/Io5uc3759WwJ
	// I cannot put this in the constructor...
	shared void attach()
	{
		if (exists p = parent)
		{
			p.children.add(this);
		}
		for (value child in children)
		{
			child.parent = this;
		}
	}

	shared void removeFromParent()
	{
		if (exists p = parent)
		{
			// Produces strange error: [Backend error] method or attribute does not exist: removeElement in type List
//			p.children.removeElement(this);
			parent = null;
		}
	}
}
