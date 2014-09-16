import ceylon.test { test, assertEquals }
import org.philhosoft.collection.tree { MutableTreeNode, breadthFirstTraversal, preOrderTraversal, postOrderTraversal }

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

	shared test void testSingleNodeTreeTraversalPreOrder()
	{
		value tt = preOrderTraversal(singleNode, MutableTreeNode<String>.children);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Single" ]);
	}

	shared test void testSingleNodeTreeTraversalPostOrder()
	{
		value tt = postOrderTraversal(singleNode, MutableTreeNode<String>.children);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Single" ]);
	}

	shared test void testSingleNodeTreeTraversalBreadthFirst()
	{
		value tt = breadthFirstTraversal(singleNode, MutableTreeNode<String>.children);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Single" ]);
	}

	shared test void testTreeTraversalPreOrder()
	{
		value tt = preOrderTraversal(root, MutableTreeNode<String>.children);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Root", "A", "a C", "c F", "c G", "a D", "B", "b E", "e H" ]);
	}

	shared test void testTreeTraversalPostOrder()
	{
		value tt = postOrderTraversal(root, MutableTreeNode<String>.children);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "c F", "c G", "a C", "a D", "A", "e H", "b E", "B", "Root" ]);
	}

	shared test void testTreeTraversalBreadthFirst()
	{
		value tt = breadthFirstTraversal(root, MutableTreeNode<String>.children);
		value result = [ for (tn in tt) tn.element ];
		assertEquals(result, [ "Root", "A", "B", "a C", "a D", "b E", "c F", "c G", "e H" ]);
	}
}
