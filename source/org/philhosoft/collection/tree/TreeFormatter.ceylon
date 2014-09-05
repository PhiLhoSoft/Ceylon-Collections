import ceylon.collection
{
	StringBuilder,
	Stack,
	LinkedList
}

String defaultAsString<Element>(Element? e) => e?.string else "";

shared String formatAsNewick<in Element>(TreeNode<Element> root,
		String(Element?) asString = defaultAsString<Element>)
{
	class PostOrderIteration(TreeNode<Element> root)
	{
		function wrap(TreeNode<Element> node)
		{
			return [ node, node.children.iterator() ];
		}

		Stack<[ TreeNode<Element>, Iterator<TreeNode<Element>> ]> stack = LinkedList<[ TreeNode<Element>, Iterator<TreeNode<Element>> ]>();
		stack.push(wrap(root));

		shared void iterate(StringBuilder sb)
		{
			variable Boolean firstAtLevel = true;
			while (exists top = stack.top)
			{
				TreeNode<Element> | Finished child = top[1].next();
				if (is TreeNode<Element> child)
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

shared String formatAsIndentedLines<Element>(TreeNode<Element> root, String indentingUnit = "\t",
		String(Element?) asString = defaultAsString<Element>)
{
	Stack<[ Integer, Iterator<TreeNode<Element>> ]> stack = LinkedList<[ Integer, Iterator<TreeNode<Element>> ]>();
	stack.push([ 0, Singleton(root).iterator() ]);

	class PreOrderIteration(TreeNode<Element> root)
	{
		// TODO memoize results
		String indentation(Integer level) => [ indentingUnit ].repeat(level).reduce((String partial, String element) => partial + element) else "";

		shared void iterate(StringBuilder sb)
		{
			while (exists top = stack.top)
			{
				TreeNode<Element> | Finished node = top[1].next();
				if (is TreeNode<Element> node)
				{
					// Found a new node, add an iterator on its children to the stack, for further processing.
					Iterator<TreeNode<Element>> childrenIterator = node.children.iterator();
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
