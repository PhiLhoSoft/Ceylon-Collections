import org.philhosoft.collection { ... }
import ceylon.test { test, assertTrue, assertFalse, assertEquals, assertNull }
import ceylon.collection { LinkedList, MutableList }

test void testEmptyTreeNode()
{
	value node = SimpleTreeNode<String>();
	assertNull(node.element);
	assertNull(node.parent);
	assertTrue(node.children.empty);
	assertTrue(node.isLeaf());
}

test void testSimpleTree()
{
	value nodeA = SimpleTreeNode<String>("A");
	value nodeB = SimpleTreeNode<String>("B");
	value root = SimpleTreeNode<String>("Root", nodeA, nodeB);
	nodeA.parent = nodeB.parent = root;
	assertFalse(root.isLeaf());
	assertTrue(nodeA.isLeaf());
	assertTrue(nodeB.isLeaf());
	assertTrue(root.children.contains(nodeA));
	assertTrue(root.children.contains(nodeB));
}

test void testLessSimpleTree()
{
	value nodeC = SimpleTreeNode<String>("A C");
	value nodeD = SimpleTreeNode<String>("A D");
	value nodeE = SimpleTreeNode<String>("B E");
	value nodeA = SimpleTreeNode<String>("A", nodeC, nodeD);
	value nodeB = SimpleTreeNode<String>("B", nodeE);
	value root = SimpleTreeNode<String>("Root", nodeA, nodeB);
	nodeC.parent = nodeD.parent = nodeA;
	nodeE.parent = nodeB;
	nodeA.parent = nodeB.parent = root;

	assertFalse(root.isLeaf());
	assertFalse(nodeA.isLeaf());
	assertFalse(nodeB.isLeaf());
	assertTrue(nodeC.isLeaf());
	assertTrue(nodeD.isLeaf());
	assertTrue(nodeE.isLeaf());
	assertTrue(root.children.contains(nodeA));
	assertTrue(root.children.contains(nodeB));
	assertTrue(nodeA.children.contains(nodeC));
	assertTrue(nodeA.children.contains(nodeD));
	assertTrue(nodeB.children.contains(nodeE));
}

