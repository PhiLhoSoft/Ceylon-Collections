import ceylon.collection
{
	LinkedList,
	Queue,
	Stack
}

/*
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

   [[children]] function returns the children of the given node (root of tree).
   It allows to abstract the tree implementation.
"""
*/
// Inspired by Guava's TreeTraverser...

class PreOrderIterator<Node>(Node root, {Node*}(Node) children) satisfies Iterator<Node>
{
	Stack<Iterator<Node>> stack = LinkedList<Iterator<Node>>();
	stack.push(Singleton(root).iterator());

	shared actual Node | Finished next()
	{
		while (exists iterator = stack.top)
		{
    		Node | Finished node = iterator.next();
    		if (is Node node)
    		{
    			// Found a new node, add an iterator on its children to the stack, for further processing.
    			Iterator<Node> childrenIterator = children(node).iterator();
    			stack.push(childrenIterator);
    			// And give the found node.
    			return node;
    		}
    		else
    		{
    			// This iterator is exhausted...
    			stack.pop();
    			// try the next one in the loop
    		}
    	}
		return finished;
	}
}

class PostOrderIterator<Node>(Node root, {Node*}(Node) children) satisfies Iterator<Node>
{
	alias NodeAndIterator => [ Node, Iterator<Node> ];

	function wrap(Node node)
	{
		return [ node, children(node).iterator() ];
	}

	Stack<NodeAndIterator> stack = LinkedList<NodeAndIterator>();
	stack.push(wrap(root));

	shared actual Node | Finished next()
	{
		while (exists top = stack.top)
		{
			Node | Finished child = top[1].next();
			if (is Node child)
			{
				// Add this child for further processing
				stack.push(wrap(child));
			}
			else
			{
				// Exhausted iterator, get rid of it
				stack.pop();
				// And we return the parent
				return top[0];
			}
		}
    	return finished;
	}
}

class BreadthFirstIterator<Node>(Node root, {Node*}(Node) children) satisfies Iterator<Node>
{
	Queue<Node> queue = LinkedList<Node>();
	queue.offer(root);

	shared actual Node | Finished next()
	{
		Node? node = queue.accept();
		if (exists node)
		{
			for (child in children(node))
			{
    			queue.offer(child);
    		}
			return node;
		}
    	return finished;
	}
}

"Each parent node is traversed before its children.
 Can be used to clone a tree. Also useful for expression trees."
shared Iterable<Node> preOrderTraversal<Node>(Node root, {Node*}(Node) children)
{
	object iterable satisfies Iterable<Node>
	{
		iterator() => PreOrderIterator(root, children);
	}
	return iterable;
}

"The children are traversed before their respective parents are traversed.<br>
 Useful to delete or free nodes and values of an entire tree."
shared Iterable<Node> postOrderTraversal<Node>(Node root, {Node*}(Node) children)
{
	object iterable satisfies Iterable<Node>
	{
		iterator() => PostOrderIterator(root, children);
	}
	return iterable;
}

"Nodes are traversed level by level, starting with the root node,
 followed by its direct child nodes, followed by its grandchild nodes, etc."
shared Iterable<Node> breadthFirstTraversal<Node>(Node root, {Node*}(Node) children)
{
	object iterable satisfies Iterable<Node>
	{
		iterator() => BreadthFirstIterator(root, children);
	}
	return iterable;
}

