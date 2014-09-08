import ceylon.test { test, assertEquals }
import org.philhosoft.collection.tree { MutableTreeNode, formatAsNewick, formatAsIndentedLines,
	TreeNode }

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

	shared test void testFormatSingleRoot_indented()
	{
		value root = MutableTreeNode<String>("Root");

		value result = formatAsIndentedLines(root);
		assertEquals(result, "Root
		                     ");
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

	MutableTreeNode<String> getLastTree() =>
		MutableTreeNode("Root",
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

	shared test void testFormatCustomElement_simple_Newick()
	{
		MutableTreeNode<Custom> rootS = MutableTreeNode(Custom(1, 5.0),
			MutableTreeNode(Custom(2, 5.1)), MutableTreeNode(Custom(3, 5.2))
		).attach();

		value resultS = formatAsNewick<Custom, MutableTreeNode<Custom>>(rootS, customAsString);
		assertEquals(resultS, "(2,3)1");
		value resultC = formatAsNewick<Custom, MutableTreeNode<Custom>>(getCustomTree(), customAsString);
		assertEquals(resultC, "(((8,9)5,6)2,((10)7)3,(?)4)1");
	}

	shared test void testFormatCustomElement_simple_indented()
	{
		MutableTreeNode<Custom> rootS = MutableTreeNode(Custom(1, 5.0),
			MutableTreeNode(Custom(2, 5.1)), MutableTreeNode(Custom(3, 5.2))
		).attach();

		value resultS = formatAsIndentedLines<Custom, MutableTreeNode<Custom>>(rootS, "#", customAsString);
		assertEquals(resultS, "1
		                       #2
		                       #3
		                       ");
		value resultC = formatAsIndentedLines<Custom, MutableTreeNode<Custom>>(getCustomTree(), "=> ", customAsString);
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

	shared test void testFormatCustomElement_comple_Newick()
	{
		MutableTreeNode<Custom> rootS = getCustomTree();

		value resultS = formatAsNewick<Custom, MutableTreeNode<Custom>>(rootS, customAsString);
		assertEquals(resultS, "(2,3)1");
		value resultC = formatAsNewick<Custom, MutableTreeNode<Custom>>(getCustomTree(), customAsString);
		assertEquals(resultC, "(((8,9)5,6)2,((10)7)3,(?)4)1");
	}

	shared test void testFormatCustomElement_complex_indented()
	{
		MutableTreeNode<Custom> rootS = getCustomTree();

		value resultS = formatAsIndentedLines<Custom, MutableTreeNode<Custom>>(rootS, "#", customAsString);
		assertEquals(resultS, "1
		                       #2
		                       #3
		                       ");
		value resultC = formatAsIndentedLines<Custom, MutableTreeNode<Custom>>(getCustomTree(), "=> ", customAsString);
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
