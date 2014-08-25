import ceylon.collection
{
	StringBuilder
}

shared class TreeFormatter<Element>()
		given Element satisfies Object
{
	shared String formatAsNewick(TreeNode<Element> root)
	{
		object treeTraversal extends TreeTraversal<TreeNode<Element>>()
		{
			shared actual {TreeNode<Element>*} children(TreeNode<Element> root) => root.children;
		}
		value tt = treeTraversal.postOrderTraversal(root);
		value sb = StringBuilder();

		for (node in tt)
		{
			sb.append(""); // TODO!
		}

		return sb.string;
	}
}
