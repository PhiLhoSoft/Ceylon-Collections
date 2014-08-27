import org.philhosoft.collection { ... }
import ceylon.test { test, assertTrue, assertFalse, assertNull, assertEquals }

test void testFormatEmptyTreeNode()
{
	value root = SimpleTreeNode<String>();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()");
}

test void testFormatSingleRoot()
{
	value root = SimpleTreeNode<String>("Root");

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()");
}

test void testFormatSimpleTree()
{
	value nodeA = SimpleTreeNode("A");
	value nodeB = SimpleTreeNode("B");
	value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()");
}

test void testFormatLessSimpleTree()
{
	value nodeC = SimpleTreeNode("A C");
	value nodeD = SimpleTreeNode("A D");
	value nodeE = SimpleTreeNode("B E");
	value nodeA = SimpleTreeNode("A", nodeC, nodeD);
	value nodeB = SimpleTreeNode("B", nodeE);
	value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()");
}

test void testFormatLastTree()
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

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()");
}
