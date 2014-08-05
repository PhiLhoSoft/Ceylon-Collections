import ceylon.collection { LinkedList, MutableList }

"""Provides methods to traverse a tree with various strategies.<br>
   Given a tree:
   <pre>
            a
           /|\
          / | \
         b  c  d
        /|\    | \
       e f g   h  i
   </pre>
   it can be iterated in pre-order (parents before children, abefgcdhi),
   in post-order (children before parents, efgbchida)
   or in breadth-first order (first level, second level, etc., abcdefghi).
"""
shared abstract class TreeTraversal<Node>()
{
	"Returns the children of the given node (root of tree). Abstracts the tree implementation."
	shared formal Iterable<Node> children(Node root);

	class PreOrderIterator(Node root) satisfies Iterator<Node>
	{
		MutableList<Iterator<Node>> stack = LinkedList<Iterator<Node>>();

    	shared actual Node | Finished next()
    	{
    		Iterator<Node>? iterator = stack.last;
        	if (exists iterator)
        	{
        		Node | Finished node = iterator.next();
        		if (is Finished node)
        		{
        			// This iterator is exhausted...
        			stack.removeLast();
        			// try the next one
        			return next();
        		}
        		else if (is Node node) // TODO ask why I need this second if
        		{
        			// Found a new node, add an iterator on its children to the stack, for further processing.
        			Iterator<Node> childrenIterator = children(node).iterator();
        			stack.add(childrenIterator);
        			// And give the found node.
        			return node;
        		}
        	}
        	return finished;
    	}
	}

	class PostOrderIterator(Node root) satisfies Iterator<Node>
	{
		class NodeAndIterator<Node>(shared Node node, shared Iterator<Node> iterator)
		{
		}

		NodeAndIterator<Node> wrap(Node node)
		{
			return NodeAndIterator<Node>(node, children(node).iterator());
		}

		MutableList<NodeAndIterator<Node>> stack = LinkedList<NodeAndIterator<Node>>();
		stack.add(wrap(root));

    	shared actual Node | Finished next()
    	{
			while (!stack.empty)
			{
				NodeAndIterator<Node>? top = stack.last;
				if (exists top)
				{
					Node | Finished child = top.iterator.next();
					if (is Node child)
					{
						// Add this child for further processing
						stack.add(wrap(child));
					}
					else
					{
						// Exhausted iterator, get rid of it
						stack.removeLast();
						// And we return the parent
						return top.node;
					}
				}
			}
        	return finished;
    	}
	}

	class BreadthFirstIterator(Node root) satisfies Iterator<Node>
	{
		MutableList<Node> queue = LinkedList<Node>();
		queue.add(root);

    	shared actual Node | Finished next()
    	{
    		Node? node = queue.removeLast();
    		if (exists node)
    		{
    			queue.addAll(children(node));
    			return node;
    		}
        	return finished;
    	}
	}

	"Each parent node is traversed before its children."
	shared default Iterator<Node> preOrderTraversal(Node root) => PreOrderIterator(root);
	"The children are traversed before their respective parents are traversed."
	shared default Iterator<Node> postOrderTraversal(Node root) => PostOrderIterator(root);
	"Nodes are traversed level by level, starting with the root node,
	 followed by its direct child nodes, followed by its grandchild nodes, etc."
	shared default Iterator<Node> breadthFirstTraversal(Node root) => BreadthFirstIterator(root);
}

