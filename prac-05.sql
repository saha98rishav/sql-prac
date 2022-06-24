-- Tree Node
/*
					6
				  /	  \
				 5     4
				/ \		\
			   3   2     1


Input: Tree_Noes
+----+-------+
| N	 |	P	 |
+----+-------+
| 5	 |	6	 |
| 4	 |	6	 |
| 6	 |	NULL |
| 3	 |	5    |
| 2	 |	5	 |
| 1	 |	4	 |
+----+-------+

Output:

+--------+-------+
| Node	 |	Type |
+--------+-------+
| 6		 |	Root |
| 5		 |	Inner|
| 4		 |	Inner|
| 3		 |	Leaf |
| 2		 |	Leaf |
| 1		 |	Leaf |
+--------+-------+

Write a SQL query to determine the type of nodes in the binary tree
*/

SELECT * FROM dbo.Tree_Nodes;

SELECT
	[N] AS [Node],
	CASE 
		WHEN [P] IS NULL THEN 'Root'
		WHEN [N] NOT IN (SELECT DISTINCT [P] FROM dbo.Tree_Nodes WHERE [P] IS NOT NULL) THEN 'Leaf'
		ELSE 'Inner'
	END AS [Type]
FROM dbo.Tree_Nodes
ORDER BY [N] DESC;
