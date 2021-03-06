import ceylon.collection
{
	StringBuilder,
	Stack,
	LinkedList
}

String defaultAsString<Element>(Element? e) => e?.string else "";

shared String formatAsNewick<Element, ActualTreeNode>(ActualTreeNode root,
		String(Element?) asString = defaultAsString<Element>)
		given ActualTreeNode satisfies TreeNode<Element, ActualTreeNode>
{
	// We need a custom iterator as we do a specific action on each step.
	class PostOrderIteration(ActualTreeNode root)
	{
		function wrap(ActualTreeNode node)
		{
			return [ node, node.children.iterator() ];
		}

		Stack<[ ActualTreeNode, Iterator<ActualTreeNode> ]> stack = LinkedList<[ ActualTreeNode, Iterator<ActualTreeNode> ]>();
		stack.push(wrap(root));

		shared void iterate(StringBuilder sb)
		{
			variable Boolean firstAtLevel = true;
			while (exists top = stack.top)
			{
				ActualTreeNode | Finished child = top[1].next();
				if (is ActualTreeNode child)
				{
					// Add this child for further processing
					if (child.isLeaf)
					{
						if (firstAtLevel)
						{
							sb.append("(");
							firstAtLevel = false;
						}
						else
						{
							sb.append(",");
						}
						sb.append(asString(child.element));
					}
					else
					{
						if (firstAtLevel)
						{
							sb.append("(");
						}
						else
						{
							sb.append(",");
						}
						stack.push(wrap(child));
						firstAtLevel = true;
					}
				}
				else
				{
					// Exhausted iterator, get rid of it
					stack.pop();
					if (firstAtLevel) // We get an empty tree
					{
						sb.append("(");
					}
					sb.append(")");
					// And we add the parent
					if (exists e = top[0].element)
					{
						sb.append(asString(e));
					}
				}
			}
		}
	}

	value ppi = PostOrderIteration(root);
	value sb = StringBuilder();
	ppi.iterate(sb);

	return sb.string;
}

shared String formatAsIndentedLines<Element, ActualTreeNode>(ActualTreeNode root, String indentingUnit = "\t",
			String(Element?) asString = defaultAsString<Element>)
		given ActualTreeNode satisfies TreeNode<Element, ActualTreeNode>
{
	// We need a specific iterator to be able to push the node depth without recomputing it on each node (costly).
	Stack<[ Integer, Iterator<ActualTreeNode> ]> stack = LinkedList<[ Integer, Iterator<ActualTreeNode> ]>();
	stack.push([ 0, Singleton(root).iterator() ]);

	class PreOrderIteration(ActualTreeNode root)
	{
		// Memoization of results
		variable String maxIndentation = indentingUnit;
		String indentation_(Integer level) => [ indentingUnit ].repeat(level).reduce((String partial, String element) => partial + element) else "";
		String indentation(Integer level)
		{
			Integer currentMax = maxIndentation.size / indentingUnit.size;
			if (level <= currentMax)
			{
				return maxIndentation[0 : (level * indentingUnit.size)];
			}
			if (level == currentMax + 1) // The most common case here
			{
				maxIndentation += indentingUnit;
				return maxIndentation;
			}
			// Should never be called here, but just in case...
			maxIndentation = indentation_(level);
			return maxIndentation;
		}

		shared void iterate(StringBuilder sb)
		{
			while (exists top = stack.top)
			{
				ActualTreeNode | Finished node = top[1].next();
				if (is ActualTreeNode node)
				{
					// Found a new node, add an iterator on its children to the stack, for further processing.
					Iterator<ActualTreeNode> childrenIterator = node.children.iterator();
					stack.push([ top[0] + 1, childrenIterator ]);
					// And give the found node.
					sb.append(indentation(top[0])).append(asString(node.element)).append("\n");
				}
				else
				{
					// This iterator is exhausted...
					stack.pop();
					// try the next one in the loop
				}
			}
		}
	}

	value ppi = PreOrderIteration(root);
	value sb = StringBuilder();
	ppi.iterate(sb);

	return sb.string;
}

// Output can be tested at http://cpettitt.github.io/project/dagre-d3/latest/demo/interactive-demo.html for example
shared String formatAsDot<Element, ActualTreeNode>(ActualTreeNode root, Boolean directed = true,
			String(Element?) asString = defaultAsString<Element>)
		given ActualTreeNode satisfies TreeNode<Element, ActualTreeNode> & ParentedTreeNode<Element, ActualTreeNode>
{
	String asDot(TreeNode<Element, ActualTreeNode> node)
	{
		value dq = "\"";
		return dq + asString(node.element).replace(dq, "\\" + dq) + dq;
	}

	// Maybe we could pass a tree traversal as parameter, not sure if that's useful...
	value nodes = breadthFirstTraversal(root, TreeNode<Element, ActualTreeNode>.children);
	value sb = StringBuilder();
	sb.append("``directed then "di" else ""``graph G
	           {
	           ");
	if (root.children.empty)
	{
		if (exists e = root.element)
		{
			sb.append(asDot(root)).append("\n");
		}
	}
	else
	{
		for (n in nodes)
		{
			if (is ParentedTreeNode<Element, ActualTreeNode> n, exists np = n.parent)
			{
				sb.append("``asDot(np)`` -``directed then ">" else "-"`` ``asDot(n)``\n");
			}
		}
	}
	sb.append("}");

	return sb.string;
}
