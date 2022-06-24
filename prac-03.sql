/*
+---+---+
| A | B	|
+---+---+
| 1 | 2	| (1)
| 3 | 2	|
| 2 | 4	| (2)
| 2 | 1	| (1)
| 5 | 6	|
| 4 | 2 | (2)
+---+---+
*/

-- Approach 1: using JOIN and WHERE conditions

SELECT
	t1.*
FROM dbo.number_pairs AS t1
LEFT OUTER JOIN dbo.number_pairs AS t2 ON t1.A = t2.B AND t1.B = t2.A
WHERE t2.A IS NULL
OR t1.A <= t2.A

-- Approach 2: using NOT EXISTS and WHERE conditions

SELECT
	*
FROM dbo.number_pairs AS t1
WHERE NOT EXISTS (
	SELECT
		*
	FROM dbo.number_pairs AS t2
	WHERE t1.A = t2.B
	AND t1.B = t2.A
	AND t1.A > t2.A
)
