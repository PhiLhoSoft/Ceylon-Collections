import org.philhosoft.collection { ... }
import ceylon.test { test, assertEquals, beforeTest }


SimpleTreeNode<String> nodeF = SimpleTreeNode<String>("c F");
SimpleTreeNode<String> nodeG = SimpleTreeNode<String>("c G");
SimpleTreeNode<String> nodeH = SimpleTreeNode<String>("e H");
SimpleTreeNode<String> nodeC = SimpleTreeNode<String>("a C", nodeF, nodeG);
SimpleTreeNode<String> nodeD = SimpleTreeNode<String>("a D");
SimpleTreeNode<String> nodeE = SimpleTreeNode<String>("b E", nodeH);
SimpleTreeNode<String> nodeA = SimpleTreeNode<String>("A", nodeC, nodeD);
SimpleTreeNode<String> nodeB = SimpleTreeNode<String>("B", nodeE);
SimpleTreeNode<String> root = SimpleTreeNode<String>("Root", nodeA, nodeB).attach();

SimpleTreeNode<String> singleNode = SimpleTreeNode<String>("Single");

object treeTraversal extends TreeTraversal<TreeNode<String>>()
{
	shared actual {TreeNode<String>*} children(TreeNode<String> root) => root.children;
}

test void testSingleNodeTreeTraversalPreOrder()
{
	value tt = treeTraversal.preOrderTraversal(singleNode);
	value result = [ for (tn in tt) tn.element ];
	assertEquals(result, [ "Single" ]);
}

test void testSingleNodeTreeTraversalPostOrder()
{
	value tt = treeTraversal.postOrderTraversal(singleNode);
	value result = [ for (tn in tt) tn.element ];
	assertEquals(result, [ "Single" ]);
}

test void testSingleNodeTreeTraversalBreadthFirst()
{
	value tt = treeTraversal.breadthFirstTraversal(singleNode);
	value result = [ for (tn in tt) tn.element ];
	assertEquals(result, [ "Single" ]);
}

test void testTreeTraversalPreOrder()
{
	value tt = treeTraversal.preOrderTraversal(root);
	value result = [ for (tn in tt) tn.element ];
	assertEquals(result, [ "Root", "A", "a C", "c F", "c G", "a D", "B", "b E", "e H" ]);
}

test void testTreeTraversalPostOrder()
{
	value tt = treeTraversal.postOrderTraversal(root);
	value result = [ for (tn in tt) tn.element ];
	assertEquals(result, [ "c F", "c G", "a C", "a D", "A", "e H", "b E", "B", "Root" ]);
}

test void testTreeTraversalBreadthFirst()
{
	value tt = treeTraversal.breadthFirstTraversal(root);
	value result = [ for (tn in tt) tn.element ];
	assertEquals(result, [ "Root", "A", "B", "a C", "a D", "b E", "c F", "c G", "e H" ]);
}
