import ceylon.test { test, assertTrue, assertFalse, assertNull, assertEquals }
import org.philhosoft.collection.tree { SimpleTreeNode, formatAsNewick,
	formatAsIndentedLines }

class TestTreeNode()
{
	shared test void testEmptyTreeNode()
	{
		value node = SimpleTreeNode<String>();

		assertNull(node.element);
		assertNull(node.parent);
		assertTrue(node.children.empty);
		assertTrue(node.isLeaf);
	}

	shared test void testSingleNodeTree()
	{
		value node = SimpleTreeNode<String>("Root");

		assertEquals(node.element, "Root");
		assertNull(node.parent);
		assertTrue(node.children.empty);
		assertTrue(node.isLeaf);
	}

	shared test void testSimpleTree()
	{
		value nodeA = SimpleTreeNode("A");
		value nodeB = SimpleTreeNode("B");
		value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

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
		value nodeC = SimpleTreeNode("A C");
		value nodeD = SimpleTreeNode("A D");
		value nodeE = SimpleTreeNode("B E");
		value nodeA = SimpleTreeNode("A", nodeC, nodeD);
		value nodeB = SimpleTreeNode("B", nodeE);
		value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

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
		SimpleTreeNode<String> root = SimpleTreeNode("Root",
			SimpleTreeNode("Left Branch",
				SimpleTreeNode("One",
					SimpleTreeNode("Low 1"),
					SimpleTreeNode("Low 2")
				),
				SimpleTreeNode("Two")
			),
			SimpleTreeNode("Right Branch",
				SimpleTreeNode("Down",
					SimpleTreeNode("Lower")
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

			value newNode = SimpleTreeNode("Another");
			newNode.attachTo(b);
			assertEquals(b.children.size, 2);

			if (exists a = root.children.first)
			{
				bd.attachTo(a);
			}
		}

		value result3N = formatAsNewick(root);
		assertEquals(result3N, "((Two,(Lower,(Low 1,Low 2)One)Down)Left Branch,(Another)Right Branch)Root");
		value result3I = formatAsIndentedLines(root, "*");
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

/* TODO
	shared test void testCustomElement()
	{
		SimpleTreeNode<Custom> root = SimpleTreeNode(CustomA("Root"),
			SimpleTreeNode(CustomB("Left", "Branch"),
				SimpleTreeNode(CustomA("One"),
					SimpleTreeNode(CustomB("Low", "1")),
					SimpleTreeNode(CustomB("Low", "2"))
				),
				SimpleTreeNode(CustomA("Two"))
			),
			SimpleTreeNode(CustomB("Right", "Branch"),
				SimpleTreeNode(CustomA("Down"),
					SimpleTreeNode(CustomA("Lower"))
				)
			)
		).attach();
	}
*/
}
