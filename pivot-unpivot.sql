-- PIVOT

SELECT [Year], Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, [Dec]
FROM (
SELECT
	[Month],
	[Year],
	[Sale]
FROM dbo.Sales ) AS t1
PIVOT (
	SUM([Sale]) FOR [Month] IN (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, [Dec])
) AS t2
ORDER BY t2.[Year]

-- UNPIVOT

SELECT StudentId, StudentName, Course, Marks FROM (
	SELECT
		StudentId,
		StudentName,
		[C++],
		Java,
		Network
	FROM dbo.StudentMarks ) AS t1
UNPIVOT(
	Marks FOR Course IN ([C++], Java, Network)
) AS t2