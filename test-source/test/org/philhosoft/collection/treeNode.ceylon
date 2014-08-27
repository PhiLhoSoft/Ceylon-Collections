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
	value nodeA = SimpleTreeNode("A");
	value nodeB = SimpleTreeNode("B");
	value root = SimpleTreeNode("Root", nodeA, nodeB).attach();
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
	value nodeC = SimpleTreeNode("A C");
	value nodeD = SimpleTreeNode("A D");
	value nodeE = SimpleTreeNode("B E");
	value nodeA = SimpleTreeNode("A", nodeC, nodeD);
	value nodeB = SimpleTreeNode("B", nodeE);
	value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

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
	SimpleTreeNode<String> root = SimpleTreeNode("Root",
		SimpleTreeNode("A",
			SimpleTreeNode("a C",
				SimpleTreeNode("c F"),
				SimpleTreeNode("c G")
				),
			SimpleTreeNode("a D")
		),
		SimpleTreeNode("B",
			SimpleTreeNode("b E",
				SimpleTreeNode("e H")
			)
		)
	).attach();

	value tt = treeTraversal.preOrderTraversal(root); // From treeTraversal.ceylon
	value result1 = [ for (tn in tt) tn.element ];
	assertEquals(result1, [ "Root", "A", "a C", "c F", "c G", "a D", "B", "b E", "e H" ]);

	if (exists a = root.children.first, exists ac = a.children.first)
	{
		assertEquals("a C", ac.element);
		ac.removeFromParent();
		if (exists b = root.children.getFromFirst(1), exists be = b.children.first)
		{
			assertEquals("b E", be.element);
			ac.attachTo(be);
		}
	}

	value result2 = [ for (tn in tt) tn.element ];
	assertEquals(result2, [ "Root", "A", "a D", "B", "b E", "e H", "a C", "c F", "c G" ]);

	if (exists b = root.children.getFromFirst(1), exists be = b.children.first)
	{
		assertEquals("b E", be.element);

		value newNode = SimpleTreeNode("b I");
		newNode.attachTo(b);
		assertEquals(b.children.size, 2);

		if (exists a = root.children.first)
		{
			be.attachTo(a);
		}
	}

	value result3 = [ for (tn in tt) tn.element ];
	assertEquals(result3, [ "Root", "A", "a D", "b E", "e H", "a C", "c F", "c G", "B", "b I" ]);
}
