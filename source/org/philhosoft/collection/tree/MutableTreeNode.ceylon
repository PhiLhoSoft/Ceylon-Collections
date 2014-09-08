import ceylon.collection { LinkedList, MutableList }
import org.philhosoft.collection.tree { TreeNode }

shared class MutableTreeNode<Element>(element = null, MutableTreeNode<Element>* initialChildren)
		satisfies TreeNode<Element, MutableTreeNode<Element>> & TreeNodeMutator<Element, MutableTreeNode<Element>>
{
	// Must be set after object construction. Bidirectional construction is hard / not possible.
	// See https://groups.google.com/d/msg/ceylon-users/KkohG7kHI64/Io5uc3759WwJ
	variable MutableTreeNode<Element>? mutableParent = null;

	MutableList<MutableTreeNode<Element>> childList = LinkedList(initialChildren);

	shared actual MutableTreeNode<Element>? parent => mutableParent;
	shared actual Collection<MutableTreeNode<Element>> children => childList;
	shared actual Element? element;
	shared actual Boolean isLeaf => children.empty;

	shared actual void setElement(Element element) {}

	shared actual void removeFromParent()
	{
		if (exists p = mutableParent)
		{
			p.removeChild(this);
		}
	}

	shared actual void attachTo(MutableTreeNode<Element> newParent)
	{
		removeFromParent();
		// TODO assert that the given node isn't part of the tree below this node...
		newParent.addChild(this);
	}

	string => "MutableTreeNode{``element else "(no element)"``, ``children.size`` children}";

	"To be called on the root of the full tree after building it, to set up the parents of each node."
	shared MutableTreeNode<Element> attach(MutableTreeNode<Element> node = this)
	{
		for (child in node.children)
		{
			child.mutableParent = node;
			attach(child);
		}
		return this;
	}

	void addChild(MutableTreeNode<Element> child)
	{
		if (!childList.contains(child))
		{
			childList.add(child);
			child.mutableParent = this;
		}
	}

	void removeChild(MutableTreeNode<Element> child)
	{
		childList.remove(child);
		child.mutableParent = null;
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
}

shared interface TreeNodeMutator<in Element, in ActualTreeNode> of ActualTreeNode
		given ActualTreeNode satisfies TreeNodeMutator<Element, ActualTreeNode>
{
	shared formal void setElement(Element element);

	"Removes the current node from its parent, detaching it and its sub-tree from the current tree."
	shared formal void removeFromParent();

	"Attaches the current node (and its sub-tree) to a new parent."
	shared formal void attachTo(ActualTreeNode node);
}
