"A node in a tree, holding a value, an element."
shared interface TreeNode<out Element, out ActualTreeNode> of ActualTreeNode
		given ActualTreeNode satisfies TreeNode<Element, ActualTreeNode>
{
//	"The unique id of this node"
//	shared formal String id;

	"The optional data attached to this node."
	shared formal Element? element;

	"The children below this node. Empty on a leaf."
	shared formal Collection<ActualTreeNode> children;

	"Returns `true` if this node has no children."
	shared formal Boolean isLeaf;

	//"Search for a given element, using the given tree transversal method. Returns null if not found."
	// Might need to provide an equals method too, or to bound Element.
	//shared formal TreeNode<Element>? searchElement(
	//	Element item,
	//	Iterable<TreeNode<Element>> transversal);

	// TODO add methods to compute depth (from a node to the deepest child) and height (from a node to its root).
}
