/*

Table 1: Employees
+-----------+---------------+
|	id		|	salary		|
+-----------+---------------+

Table 2: Projects
+-------------------+-------------------+---------------+---------------+
|	employee_id		|	project_id		|	start_dt 	|	end_dt		|
+-------------------+-------------------+---------------+---------------+

*/


-- Q1) Take the 5 lowest paid employees who have done at least 10 projects.

SELECT
	e.id
FROM Projects AS p
LEFT OUTER JOIN Employees AS e
GROUP BY e.employee_id
HAVING COUNT(e.end_dt) >= 10
ORDER BY e.Salary ASC


-- Q2) What is the sum of salaries of employees who haven't finished a project?

/*
	Definitions of "haven't finished a project"
	1. end_dt is NULL
	2. end_dt is in the future (end_dt > CURRENT_DATE)
	3. there's no project_id associated with an employee in the table 2
	
	Updated question: What is the sum of salaries of employees who have started a project but haven't finished yet?
*/

SELECT
	SUM(e.salary) AS total_salary
FROM Employees AS e
WHERE e.id NOT IN (
	SELECT
		p.employee_id
	FROM Projects AS p
	WHERE p.end_dt IS NOT NULL
)