import ceylon.test { test, assertEquals }
import org.philhosoft.collection.tree { MutableTreeNode, TreeTraversal }

class TestTreeTraversal()
{
	MutableTreeNode<String> root = MutableTreeNode("Root",
		MutableTreeNode("A",
			MutableTreeNode("a C",
				MutableTreeNode("c F"),
				MutableTreeNode("c G")
				),
			MutableTreeNode("a D")
		),
		MutableTreeNode("B",
			MutableTreeNode("b E",
				MutableTreeNode("e H")
			)
		)
	).attach();

	MutableTreeNode<String> singleNode = MutableTreeNode("Single");

	TreeTraversal<MutableTreeNode<String>> treeTraversal = TreeTraversal<MutableTreeNode<String>>(MutableTreeNode<String>.children);

	shared test void testSingleNodeTreeTraversalPreOrder()
	{
		value tt = treeTraversal.preOrderTraversal(singleNode);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Single" ]);
	}

	shared test void testSingleNodeTreeTraversalPostOrder()
	{
		value tt = treeTraversal.postOrderTraversal(singleNode);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Single" ]);
	}

	shared test void testSingleNodeTreeTraversalBreadthFirst()
	{
		value tt = treeTraversal.breadthFirstTraversal(singleNode);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Single" ]);
	}

	shared test void testTreeTraversalPreOrder()
	{
		value tt = treeTraversal.preOrderTraversal(root);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Root", "A", "a C", "c F", "c G", "a D", "B", "b E", "e H" ]);
	}

	shared test void testTreeTraversalPostOrder()
	{
		value tt = treeTraversal.postOrderTraversal(root);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "c F", "c G", "a C", "a D", "A", "e H", "b E", "B", "Root" ]);
	}

	shared test void testTreeTraversalBreadthFirst()
	{
		value tt = treeTraversal.breadthFirstTraversal(root);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Root", "A", "B", "a C", "a D", "b E", "c F", "c G", "e H" ]);
	}
}
