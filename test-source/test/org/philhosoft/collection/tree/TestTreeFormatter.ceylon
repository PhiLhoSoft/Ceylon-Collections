import ceylon.test { test, assertEquals }
import org.philhosoft.collection.tree { MutableTreeNode, formatAsNewick, formatAsIndentedLines, formatAsDot }

class TestTreeFormatter()
{
	shared test void testFormatEmptyTreeNode_Newick()
	{
		value root = MutableTreeNode<String>();

		value result = formatAsNewick(root);
		assertEquals(result, "()");
	}

	shared test void testFormatEmptyTreeNode_indented()
	{
		value root = MutableTreeNode<String>();

		value result = formatAsIndentedLines(root);
		assertEquals(result, "\n");
	}

	shared test void testFormatSingleRoot_Newick()
	{
		value root = MutableTreeNode<String>("Root");

		value result = formatAsNewick(root);
		assertEquals(result, "()Root");
	}

	shared test void testFormatEmptyTree_dot()
	{
		value root = MutableTreeNode<String>();

		value result = formatAsDot(root);
		assertEquals(result,
			"""digraph G
			   {
			   }""");
	}


	shared test void testFormatSingleRoot_indented()
	{
		value root = MutableTreeNode<String>("Root");

		value result = formatAsIndentedLines(root);
		assertEquals(result, "Root
		                     ");
	}

	shared test void testFormatSingleRoot_dot()
	{
		value root = MutableTreeNode<String>("Root");

		value result = formatAsDot(root);
		assertEquals(result,
			"""digraph G
			   {
			   "Root"
			   }""");
	}


	MutableTreeNode<String> getSimpleTree() => MutableTreeNode("Root", MutableTreeNode("A"), MutableTreeNode("B")).attach();

	shared test void testFormatSimpleTree_Newick()
	{
		value result = formatAsNewick(getSimpleTree());
		assertEquals(result, "(A,B)Root");
	}

	shared test void testFormatSimpleTree_indented()
	{
		value result = formatAsIndentedLines(getSimpleTree(), "*");
		assertEquals(result, "Root
		                      *A
		                      *B
		                      ");
	}

	shared test void testFormatSimpleTree_dot()
	{
		value result = formatAsDot(getSimpleTree());
		assertEquals(result,
			"""digraph G
			   {
			   "Root" -> "A"
			   "Root" -> "B"
			   }""");
	}


	MutableTreeNode<String> getLinearTree() => MutableTreeNode("Root", MutableTreeNode("A", MutableTreeNode("B", MutableTreeNode("C")))).attach();

	shared test void testFormatLinearTree_Newick()
	{
		value result = formatAsNewick(getLinearTree());
		assertEquals(result, "(((C)B)A)Root");
	}

	shared test void testFormatLinearTree_indented()
	{
		value result = formatAsIndentedLines(getLinearTree(), "*");
		assertEquals(result, "Root
		                      *A
		                      **B
		                      ***C
		                      ");
	}

	shared test void testFormatLinearTree_dot()
	{
		value result = formatAsDot(getLinearTree());
		assertEquals(result,
			"""digraph G
			   {
			   "Root" -> "A"
			   "A" -> "B"
			   "B" -> "C"
			   }""");
	}


	MutableTreeNode<String> getLessSimpleTree() =>
			MutableTreeNode("Root",
				MutableTreeNode("A",
					MutableTreeNode("A C"),
					MutableTreeNode("A D")
				),
				MutableTreeNode("B",
					MutableTreeNode("B E")
				)
			).attach();

	shared test void testFormatLessSimpleTree_Newick()
	{
		value result = formatAsNewick(getLessSimpleTree());
		assertEquals(result, "((A C,A D)A,(B E)B)Root");
	}

	shared test void testFormatLessSimpleTree_indented()
	{
		value result = formatAsIndentedLines(getLessSimpleTree(), "*");
		assertEquals(result, "Root
		                      *A
		                      **A C
		                      **A D
		                      *B
		                      **B E
		                      ");
	}

	shared test void testFormatLessSimpleTree_indented_default()
	{
		value result = formatAsIndentedLines(getLessSimpleTree());
		assertEquals(result, "Root
		                      \tA
		                      \t\tA C
		                      \t\tA D
		                      \tB
		                      \t\tB E
		                      ");
	}

	shared test void testFormatLessSimpleTree_indented_multichar()
	{
		value result = formatAsIndentedLines(getLessSimpleTree(), "=> ");
		assertEquals(result, "Root
		                      => A
		                      => => A C
		                      => => A D
		                      => B
		                      => => B E
		                      ");
	}

	shared test void testFormatLessSimpleTree_dot()
	{
		value result = formatAsDot(getLessSimpleTree());
		assertEquals(result,
			"""digraph G
			   {
			   "Root" -> "A"
			   "Root" -> "B"
			   "A" -> "A C"
			   "A" -> "A D"
			   "B" -> "B E"
			   }""");
	}

	shared test void testFormatLessSimpleTree_dot_nonDirected()
	{
		value result = formatAsDot(getLessSimpleTree(), false);
		assertEquals(result,
			"""graph G
			   {
			   "Root" -- "A"
			   "Root" -- "B"
			   "A" -- "A C"
			   "A" -- "A D"
			   "B" -- "B E"
			   }""");
	}


	MutableTreeNode<String> getLastTree() =>
		MutableTreeNode("Root",
			MutableTreeNode("A",
				MutableTreeNode("a C",
					MutableTreeNode("c F"),
					MutableTreeNode("c G")
				),
				MutableTreeNode("a D"),
				MutableTreeNode("""a "last" Z""")
			),
			MutableTreeNode("B",
				MutableTreeNode("b E",
					MutableTreeNode("e H")
				)
			)
		).attach();


	shared test void testFormatLastTree_Newick()
	{
		value result = formatAsNewick(getLastTree());
		assertEquals(result, """(((c F,c G)a C,a D,a "last" Z)A,((e H)b E)B)Root""");
	}

	shared test void testFormatLastTree_indented()
	{
		value result = formatAsIndentedLines(getLastTree(), "*");
		assertEquals(result, """Root
		                        *A
		                        **a C
		                        ***c F
		                        ***c G
		                        **a D
		                        **a "last" Z
		                        *B
		                        **b E
		                        ***e H
		                        """);
	}

	shared test void testFormatLastTree_dot()
	{
		value result = formatAsDot(getLastTree());
		assertEquals(result,
			"""digraph G
			   {
			   "Root" -> "A"
			   "Root" -> "B"
			   "A" -> "a C"
			   "A" -> "a D"
			   "A" -> "a \"last\" Z"
			   "B" -> "b E"
			   "a C" -> "c F"
			   "a C" -> "c G"
			   "b E" -> "e H"
			   }""");
	}


	class Custom(shared Integer n, shared Float whatever) { string => "Custom{``n``, ``whatever``}"; }
	String customAsString(Custom? c) => c?.n?.string else "?";

	shared test void testFormatCustomElement_simple_Newick()
	{
		MutableTreeNode<Custom> rootS = MutableTreeNode(Custom(1, 5.0),
			MutableTreeNode(Custom(2, 5.1)), MutableTreeNode(Custom(3, 5.2))
		).attach();

		value result = formatAsNewick(rootS, customAsString);
		assertEquals(result, "(2,3)1");
	}

	shared test void testFormatCustomElement_simple_indented()
	{
		MutableTreeNode<Custom> rootS = MutableTreeNode(Custom(1, 5.0),
			MutableTreeNode(Custom(2, 5.1)), MutableTreeNode(Custom(3, 5.2))
		).attach();

		value result = formatAsIndentedLines(rootS, "#", customAsString);
		assertEquals(result, "1
		                      #2
		                      #3
		                      ");
	}

	MutableTreeNode<Custom> getCustomTree() =>
			MutableTreeNode(Custom(1, 1.0),
				MutableTreeNode(Custom(2, 2.1),
					MutableTreeNode(Custom(5, 3.1),
						MutableTreeNode(Custom(8, 4.1)),
						MutableTreeNode(Custom(9, 4.2))
					),
					MutableTreeNode(Custom(6, 3.2))
				),
				MutableTreeNode(Custom(3, 2.2),
					MutableTreeNode(Custom(7, 3.3),
						MutableTreeNode(Custom(10, 4.3))
					)
				),
				MutableTreeNode(Custom(4, 2.2), MutableTreeNode<Custom>())
			).attach();

	shared test void testFormatCustomElement_complex_Newick()
	{
		value result = formatAsNewick(getCustomTree(), customAsString);
		assertEquals(result, "(((8,9)5,6)2,((10)7)3,(?)4)1");
	}

	shared test void testFormatCustomElement_complex_indented()
	{
		value result = formatAsIndentedLines(getCustomTree(), "=> ", customAsString);
		assertEquals(result,
				"1
				 => 2
				 => => 5
				 => => => 8
				 => => => 9
				 => => 6
				 => 3
				 => => 7
				 => => => 10
				 => 4
				 => => ?
				 ");
	}
}
