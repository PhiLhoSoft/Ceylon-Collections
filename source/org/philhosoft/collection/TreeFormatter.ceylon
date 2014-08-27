import ceylon.collection
{
	StringBuilder,
	Stack,
	LinkedList
}

shared class TreeFormatter<Element>()
{
	shared String formatAsNewick(TreeNode<Element> root)
	{
		class PostOrderIteration(TreeNode<Element> root)
		{
			//alias NodeAndIterator => [ TreeNode<Element>, Iterator<TreeNode<Element>> ];

			function wrap(TreeNode<Element> node)
			{
				return [ node, node.children.iterator() ];
			}

			Stack<[ TreeNode<Element>, Iterator<TreeNode<Element>> ]> stack = LinkedList<[ TreeNode<Element>, Iterator<TreeNode<Element>> ]>();
			stack.push(wrap(root));

			shared void iterate(StringBuilder sb)
			{
				while (exists top = stack.top)
				{
					sb.append(",");
					TreeNode<Element> | Finished child = top[1].next();
					if (is TreeNode<Element> child)
					{
						// Add this child for further processing
						sb.append("(");
						stack.push(wrap(child));
					}
					else
					{
						// Exhausted iterator, get rid of it
						stack.pop();
						sb.append(")");
						// And we add the parent
						if (exists e = top[0].element)
						{
							sb.append(e.string);
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
