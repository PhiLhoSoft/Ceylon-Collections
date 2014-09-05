import ceylon.test { test, assertTrue, assertFalse, assertNull, assertEquals }
import org.philhosoft.collection.tree { MutableTreeNode, formatAsNewick,
	formatAsIndentedLines }
import ceylon.collection {
	LinkedList
}

class TestTreeNode()
{
	shared test void testEmptyTreeNode()
	{
		value node = MutableTreeNode<String>();

		assertNull(node.element);
		assertNull(node.parent);
		assertTrue(node.children.empty);
		assertTrue(node.isLeaf);
	}

	shared test void testSingleNodeTree()
	{
		value node = MutableTreeNode<String>("Root");

		assertEquals(node.element, "Root");
		assertNull(node.parent);
		assertTrue(node.children.empty);
		assertTrue(node.isLeaf);
	}

	shared test void testSimpleTree()
	{
		value nodeA = MutableTreeNode("A");
		value nodeB = MutableTreeNode("B");
		value root = MutableTreeNode("Root", nodeA, nodeB).attach();

		assertFalse(root.isLeaf);
		assertTrue(nodeA.isLeaf);
		assertTrue(nodeB.isLeaf);
		assertTrue(root.children.contains(nodeA));
		assertTrue(root.children.contains(nodeB));
		assertEquals(root, nodeA.parent);
		assertEquals(root, nodeB.parent);
	}

	shared test void testLessSimpleTree()
	{
		value nodeC = MutableTreeNode("A C");
		value nodeD = MutableTreeNode("A D");
		value nodeE = MutableTreeNode("B E");
		value nodeA = MutableTreeNode("A", nodeC, nodeD);
		value nodeB = MutableTreeNode("B", nodeE);
		value root = MutableTreeNode("Root", nodeA, nodeB).attach();

		assertFalse(root.isLeaf);
		assertFalse(nodeA.isLeaf);
		assertFalse(nodeB.isLeaf);
		assertTrue(nodeC.isLeaf);
		assertTrue(nodeD.isLeaf);
		assertTrue(nodeE.isLeaf);
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

	shared test void testDetachAttach()
	{
		MutableTreeNode<String> root = MutableTreeNode("Root",
			MutableTreeNode("Left Branch",
				MutableTreeNode("One",
					MutableTreeNode("Low 1"),
					MutableTreeNode("Low 2")
				),
				MutableTreeNode("Two")
			),
			MutableTreeNode("Right Branch",
				MutableTreeNode("Down",
					MutableTreeNode("Lower")
				)
			)
		).attach();

		value result1N = formatAsNewick(root);
		assertEquals(result1N, "(((Low 1,Low 2)One,Two)Left Branch,((Lower)Down)Right Branch)Root");
		value result1I = formatAsIndentedLines(root, "#");
		assertEquals(result1I, "Root
		                        #Left Branch
		                        ##One
		                        ###Low 1
		                        ###Low 2
		                        ##Two
		                        #Right Branch
		                        ##Down
		                        ###Lower
		                        ");

		if (exists a = root.children.first, exists ac = a.children.first)
		{
			assertEquals("One", ac.element);
			ac.removeFromParent();
			if (exists b = root.children.getFromFirst(1), exists bd = b.children.first)
			{
				assertEquals("Down", bd.element);
				ac.attachTo(bd);
			}
		}

		value result2N = formatAsNewick(root);
		assertEquals(result2N, "((Two)Left Branch,((Lower,(Low 1,Low 2)One)Down)Right Branch)Root");
		value result2I = formatAsIndentedLines(root, "#");
		assertEquals(result2I, "Root
		                        #Left Branch
		                        ##Two
		                        #Right Branch
		                        ##Down
		                        ###Lower
		                        ###One
		                        ####Low 1
		                        ####Low 2
		                        ");

		if (exists b = root.children.getFromFirst(1), exists bd = b.children.first)
		{
			assertEquals("Down", bd.element);

			value newNode = MutableTreeNode("Another");
			newNode.attachTo(b);
			assertEquals(b.children.size, 2);

			if (exists a = root.children.first)
			{
				bd.attachTo(a);
			}
		}

		value result3N = formatAsNewick(root);
		assertEquals(result3N, "((Two,(Lower,(Low 1,Low 2)One)Down)Left Branch,(Another)Right Branch)Root");
		value result3I = formatAsIndentedLines(root, "#");
		assertEquals(result3I, "Root
		                        #Left Branch
		                        ##Two
		                        ##Down
		                        ###Lower
		                        ###One
		                        ####Low 1
		                        ####Low 2
		                        #Right Branch
		                        ##Another
		                        ");
	}

	interface Custom
	{
		shared formal String name;
	}
	class CustomA(String n) satisfies Custom
	{
		name => n;
	}
	class CustomB(String n, String m) satisfies Custom
	{
		name => n + " " + m;
	}

//* TODO
	shared test void testCustomElement()
	{
		List<Custom> lc = LinkedList<Custom>({ CustomA("foo"), CustomB("gah", "buh") });

		MutableTreeNode<out Custom> root = MutableTreeNode(CustomA("Root"),
			MutableTreeNode(CustomB("Left", "Branch"),
				MutableTreeNode(CustomA("One"),
					MutableTreeNode(CustomB("Low", "1")),
					MutableTreeNode(CustomB("Low", "2"))
				),
				MutableTreeNode(CustomA("Two"))
			),
			MutableTreeNode(CustomB("Right", "Branch"),
				MutableTreeNode(CustomA("Down"),
					MutableTreeNode(CustomA("Lower"))
				)
			)
		).attach();
	}
//*/
}
