import ceylon.test { test, assertEquals }
import org.philhosoft.collection.tree { SimpleTreeNode, formatAsNewick, formatAsIndentedLines }

class TestTreeFormatter()
{
	shared test void testFormatEmptyTreeNode_Newick()
	{
		value root = SimpleTreeNode<String>();

		value result = formatAsNewick(root);
		assertEquals(result, "()");
	}

	shared test void testFormatEmptyTreeNode_indented()
	{
		value root = SimpleTreeNode<String>();

		value result = formatAsIndentedLines(root);
		assertEquals(result, "\n");
	}

	shared test void testFormatSingleRoot_Newick()
	{
		value root = SimpleTreeNode<String>("Root");

		value result = formatAsNewick(root);
		assertEquals(result, "()Root");
	}

	shared test void testFormatSingleRoot_indented()
	{
		value root = SimpleTreeNode<String>("Root");

		value result = formatAsIndentedLines(root);
		assertEquals(result, "Root
		                     ");
	}

	SimpleTreeNode<String> getSimpleTree() => SimpleTreeNode("Root", SimpleTreeNode("A"), SimpleTreeNode("B")).attach();

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

	SimpleTreeNode<String> getLinearTree() => SimpleTreeNode("Root", SimpleTreeNode("A", SimpleTreeNode("B", SimpleTreeNode("C")))).attach();

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

	SimpleTreeNode<String> getLessSimpleTree() =>
			SimpleTreeNode("Root",
				SimpleTreeNode("A",
					SimpleTreeNode("A C"),
					SimpleTreeNode("A D")
				),
				SimpleTreeNode("B",
					SimpleTreeNode("B E")
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

	shared test void testFormatLessSimpleTree_default()
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

	shared test void testFormatLessSimpleTree_multichar()
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

	SimpleTreeNode<String> getLastTree() =>
		SimpleTreeNode("Root",
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


	shared test void testFormatLastTree_Newick()
	{
		value result = formatAsNewick(getLastTree());
		assertEquals(result, "(((c F,c G)a C,a D)A,((e H)b E)B)Root");
	}

	shared test void testFormatLastTree_indented()
	{
		value result = formatAsIndentedLines(getLastTree(), "*");
		assertEquals(result, "Root
		                      *A
		                      **a C
		                      ***c F
		                      ***c G
		                      **a D
		                      *B
		                      **b E
		                      ***e H
		                      ");
	}

	class Custom(shared Integer n, shared Float whatever) { string => "Custom{``n``, ``whatever``}"; }
	String customAsString(Custom? c) => c?.n?.string else "?";

	SimpleTreeNode<Custom> getCustomTree() =>
			SimpleTreeNode(Custom(1, 1.0),
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

	shared test void testFormatCustomElement_Newick()
	{
		SimpleTreeNode<Custom> rootS = SimpleTreeNode(Custom(1, 5.0),
			SimpleTreeNode(Custom(2, 5.1)), SimpleTreeNode(Custom(3, 5.2))
		).attach();

		value resultS = formatAsNewick(rootS, customAsString);
		assertEquals(resultS, "(2,3)1");
		value resultC = formatAsNewick(getCustomTree(), customAsString);
		assertEquals(resultC, "(((8,9)5,6)2,((10)7)3,(?)4)1");
	}

	shared test void testFormatCustomElement_indented()
	{
		SimpleTreeNode<Custom> rootS = SimpleTreeNode(Custom(1, 5.0),
			SimpleTreeNode(Custom(2, 5.1)), SimpleTreeNode(Custom(3, 5.2))
		).attach();

		value resultS = formatAsIndentedLines(rootS, "#", customAsString);
		assertEquals(resultS, "1
		                       #2
		                       #3
		                       ");
		value resultC = formatAsIndentedLines(getCustomTree(), "=> ", customAsString);
		assertEquals(resultC,
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
