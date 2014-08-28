import org.philhosoft.collection { ... }
import ceylon.test { test, assertEquals }

// Restrict scope of tests
class TestTreeFormatter()
{

shared test void testFormatEmptyTreeNode()
{
	value root = SimpleTreeNode<String>();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()");
}

shared test void testFormatSingleRoot()
{
	value root = SimpleTreeNode<String>("Root");

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "()Root");
}

shared test void testFormatSimpleTree()
{
	value nodeA = SimpleTreeNode("A");
	value nodeB = SimpleTreeNode("B");
	value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "(A,B)Root");
}

shared test void testFormatLinearTree()
{
	value root = SimpleTreeNode("Root", SimpleTreeNode("A", SimpleTreeNode("B", SimpleTreeNode("C")))).attach();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "(((C)B)A)Root");
}

shared test void testFormatLessSimpleTree()
{
	value nodeC = SimpleTreeNode("A C");
	value nodeD = SimpleTreeNode("A D");
	value nodeE = SimpleTreeNode("B E");
	value nodeA = SimpleTreeNode("A", nodeC, nodeD);
	value nodeB = SimpleTreeNode("B", nodeE);
	value root = SimpleTreeNode("Root", nodeA, nodeB).attach();

	value result = TreeFormatter<String>().formatAsNewick(root);
	assertEquals(result, "((A C,A D)A,(B E)B)Root");
}

shared test void testFormatLastTree()
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
	assertEquals(result, "(((c F,c G)a C,a D)A,((e H)b E)B)Root");
}

/* TODO deactivated as it throws an error when running. See https://github.com/ceylon/ceylon-runtime/issues/69
test void testFormatCustomElement()
{
	class Custom(shared Integer n, shared Float whatever) { string => "Custom{``n``, ``whatever``}"; }
	function customAsString(Custom? c) => c?.n?.string else "?";

	SimpleTreeNode<Custom> rootS = SimpleTreeNode(Custom(1, 5.0),
		SimpleTreeNode(Custom(2, 5.1)), SimpleTreeNode(Custom(3, 5.2))
	).attach();

	SimpleTreeNode<Custom> rootC = SimpleTreeNode(Custom(1, 1.0),
		SimpleTreeNode(Custom(2, 2.1),
			SimpleTreeNode(Custom(5, 3.1),
				SimpleTreeNode(Custom(8, 4.1)),
				SimpleTreeNode(Custom(9, 4.2))
			),
			SimpleTreeNode(Custom(6, 3.2))
		),
		SimpleTreeNode(Custom(3, 2.2),
			SimpleTreeNode(Custom(7, 3.3),
				SimpleTreeNode(Custom(10, 4.3))
			)
		),
		SimpleTreeNode(Custom(4, 2.2), SimpleTreeNode<Custom>())
	).attach();

	value resultS = TreeFormatter<Custom>(customAsString).formatAsNewick(rootS);
	assertEquals(resultS, "((2,3)1");
	value resultC = TreeFormatter<Custom>(customAsString).formatAsNewick(rootC);
	assertEquals(resultC, "(((8,9)5,6)2,((10)7)3,(?)4)1");
}
*/
class Custom(shared Integer n, shared Float whatever) { string => "Custom{``n``, ``whatever``}"; }
String customAsString(Custom? c) => c?.n?.string else "?";

shared test void testFormatCustomElement()
{
	SimpleTreeNode<Custom> rootS = SimpleTreeNode(Custom(1, 5.0),
		SimpleTreeNode(Custom(2, 5.1)), SimpleTreeNode(Custom(3, 5.2))
	).attach();

	SimpleTreeNode<Custom> rootC = SimpleTreeNode(Custom(1, 1.0),
		SimpleTreeNode(Custom(2, 2.1),
			SimpleTreeNode(Custom(5, 3.1),
				SimpleTreeNode(Custom(8, 4.1)),
				SimpleTreeNode(Custom(9, 4.2))
			),
			SimpleTreeNode(Custom(6, 3.2))
		),
		SimpleTreeNode(Custom(3, 2.2),
			SimpleTreeNode(Custom(7, 3.3),
				SimpleTreeNode(Custom(10, 4.3))
			)
		),
		SimpleTreeNode(Custom(4, 2.2), SimpleTreeNode<Custom>())
	).attach();

	value resultS = TreeFormatter<Custom>(customAsString).formatAsNewick(rootS);
	assertEquals(resultS, "(2,3)1");
	value resultC = TreeFormatter<Custom>(customAsString).formatAsNewick(rootC);
	assertEquals(resultC, "(((8,9)5,6)2,((10)7)3,(?)4)1");
}

}
