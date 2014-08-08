import ceylon.collection { MutableList }

"A node in a tree, holding a value, an element."
shared interface TreeNode<Element>
{
	"The element belonging to this node."
	shared formal variable Element? element;

	"The parent node. `null` at the tree root or if the node isn't attached to a parent."
	shared formal variable TreeNode<Element>? parent;

	"The children below this node. It is empty if it is a leaf."
	shared formal MutableList<TreeNode<Element>> children;

	"Returns `true` if this node has no children."
	shared formal Boolean isLeaf();

	"Removes the current node from its parent, detaching it and its sub-tree from the current tree."
	shared formal void removeFromParent();

	"Attaches the current node (and its sub-tree) to a new parent."
	shared formal void attachTo(TreeNode<Element> node);
}
