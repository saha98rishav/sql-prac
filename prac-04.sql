/*
Table: Department
+-------+-----------+
|	id	|	name	|
+-------+-----------+
|	1	|	IT		|
|	2	|	Sales	|
+-------+-----------+


Table: Employee
+-------+-----------+-----------+-------------------+
|id		|	name	|	salary	|	departmentId	|
+-------+-----------+-----------+-------------------+
|1		|	Joe		|	85000	|	1				|
|2		|	Henry	|	80000	|	2				|
|3		|	Sam		|	60000	|	2				|
|4		|	Max		|	90000	|	1				|
|5		|	Janet	|	69000	|	1				|
|6		|	Randy	|	85000	|	1				|
|7		|	Will	|	70000	|	1				|
+-------+-----------+-----------+-------------------+

A company's executives are interested in seeing who earns the most money
in each of the company's departments.
A high earner in a department is an employee who has a salary in the top three
unique salaries for that department.

Write an SQL query to find the employees who are high earners in each of the departments.
Return the result table in any order.

Output:
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+

*/


-- Solution

SELECT
	d.[name] AS Department, zz.Employee, zz.salary
FROM (
SELECT
	e1.[salary],
	e1.[name] AS [Employee],
	e1.[departmentId],
	DENSE_RANK() OVER(PARTITION BY e1.[departmentId] ORDER BY e1.[salary] DESC) AS rnk
FROM dbo.Employee AS e1) AS zz
INNER JOIN dbo.Department AS d ON d.id = zz.departmentId
WHERE zz.rnk <= 3
ORDER BY 1, 3 DESC

