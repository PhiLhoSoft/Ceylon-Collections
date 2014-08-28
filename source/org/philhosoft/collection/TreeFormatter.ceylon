import ceylon.collection
{
	StringBuilder,
	Stack,
	LinkedList
}

shared class TreeFormatter<Element>(String(Element?) asString = (Element? e) => e?.string else "")
		given Element satisfies Object
{
	shared String formatAsNewick(TreeNode<Element> root)
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
}
