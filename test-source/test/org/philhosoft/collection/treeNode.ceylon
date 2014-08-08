import org.philhosoft.collection { ... }
import ceylon.test { test, assertTrue, assertFalse, assertNull, assertEquals }

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
	value root = SimpleTreeNode<String>("Root", nodeA, nodeB).attach();
	assertFalse(root.isLeaf());
	assertTrue(nodeA.isLeaf());
	assertTrue(nodeB.isLeaf());
	assertTrue(root.children.contains(nodeA));
	assertTrue(root.children.contains(nodeB));
	assertEquals(root, nodeA.parent);
	assertEquals(root, nodeB.parent);
}

test void testLessSimpleTree()
{
	value nodeC = SimpleTreeNode<String>("A C");
	value nodeD = SimpleTreeNode<String>("A D");
	value nodeE = SimpleTreeNode<String>("B E");
	value nodeA = SimpleTreeNode<String>("A", nodeC, nodeD);
	value nodeB = SimpleTreeNode<String>("B", nodeE);
	value root = SimpleTreeNode<String>("Root", nodeA, nodeB).attach();

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
	assertEquals(root, nodeA.parent);
	assertEquals(root, nodeB.parent);
	assertEquals(nodeA, nodeC.parent);
	assertEquals(nodeA, nodeD.parent);
	assertEquals(nodeB, nodeE.parent);
}

test void testDetachAttach()
{
	SimpleTreeNode<String> root = SimpleTreeNode<String>("Root",
		SimpleTreeNode<String>("A",
			SimpleTreeNode<String>("a C",
				SimpleTreeNode<String>("c F"),
				SimpleTreeNode<String>("c G")
				),
			SimpleTreeNode<String>("a D")
		),
		SimpleTreeNode<String>("B",
			SimpleTreeNode<String>("b E",
				SimpleTreeNode<String>("e H")
			)
		)
	).attach();

	value tt = treeTraversal.preOrderTraversal(root);
	value result1 = [ for (tn in tt) tn.element ];
	assertEquals(result1, [ "Root", "A", "a C", "c F", "c G", "a D", "B", "b E", "e H" ]);

	if (exists a = root.children[0], exists ac = a.children[0])
	{
		assertEquals("a C", ac.element);
		ac.removeFromParent();
		if (exists b = root.children[1], exists be = b.children[0])
		{
			assertEquals("b E", be.element);
			ac.attachTo(be);
		}
	}

	value result2 = [ for (tn in tt) tn.element ];
	assertEquals(result2, [ "Root", "A", "a D", "B", "b E", "e H", "a C", "c F", "c G" ]);

	if (exists b = root.children[1], exists be = b.children[0])
	{
		assertEquals("b E", be.element);
		if (exists a = root.children[0])
		{
			be.attachTo(a);
		}
	}

	value result3 = [ for (tn in tt) tn.element ];
	assertEquals(result3, [ "Root", "A", "a D", "b E", "e H", "a C", "c F", "c G", "B" ]);
}
