-- 1) Employee with highest salary in the department

-- -----------
-- Approach 1
-- -----------

SELECT
	emp.employee_key,
	emp.first_name,
	emp.last_name,
	emp.department_name,
	emp.salary
FROM public.employee emp
INNER JOIN (SELECT department_name, MAX(salary) max_dept_salary
			FROM public.employee
			GROUP BY department_name) max_sal_emp
	ON emp.department_name = max_sal_emp.department_name
	AND emp.salary = max_sal_emp.max_dept_salary


-- -----------
-- Approach 2
-- -----------

SELECT
	x.employee_key,
	x.first_name,
	x.last_name,
	x.department_name,
	x.salary,
FROM (
	SELECT
		emp.employee_key,
		emp.first_name,
		emp.last_name,
		emp.department_name,
		emp.salary,
		DENSE_RANK() OVER(PARTITION BY emp.department_name ORDER BY emp.salary DESC) rnk
	FROM public.employee emp ) x
WHERE x.rnk = 1;

-- 2) Employees having greater than average salary of the department

/*
"emp_id"	"emp_name"	"salary"	"department"
1001			Nick	 10000			IT
1002			Sam		 15000			IT
1003			Perth	 17000			Infra
1004			Rhea	 9000			BMS
1005			Alex	 40000			IT
1006			Mate	 18000			BMS
1007			Daniel	 16500			Infra
*/


SELECT
    x.emp_id,
    x.emp_name,
    x.salary,
    x.department
FROM (
SELECT
    emp.emp_id,
    emp.emp_name,
    emp.salary,
    emp.department,
    AVG(emp.salary) OVER(PARTITION BY emp.department ORDER BY emp.department) "avg_dept_salary"
FROM prac01.employee emp
GROUP BY emp.emp_id, emp.emp_name, emp.salary, emp.department ) x
WHERE x.salary > x.avg_dept_salary

/*
"emp_id"	"emp_name"	"salary"	"department"
1006			Mate	 18000			BMS
1003			Perth	 17000			Infra
1005			Alex	 40000			IT
*/

-- 3) Employees having greater than average salary of the department but less than overall average

SELECT
    x.emp_id,
    x.emp_name,
    x.salary,
    x.department
FROM (
SELECT
    emp.emp_id,
    emp.emp_name,
    emp.salary,
    emp.department,
    AVG(emp.salary) OVER(PARTITION BY emp.department ORDER BY emp.department) "avg_dept_salary"
FROM prac01.employee emp
GROUP BY emp.emp_id, emp.emp_name, emp.salary, emp.department ) x
WHERE x.salary > x.avg_dept_salary
AND x.salary < (SELECT AVG(salary) FROM prac01.employee)

/*
"emp_id"	"emp_name"	"salary"	"department"
1003			Perth	 17000			Infra

*/

-- 4) Employees having less than average salary of the department but greater
-- than the average salary of any other department

WITH cte01 AS (
SELECT
    emp.emp_id,
    emp.emp_name,
    emp.salary,
    emp.department,
    AVG(emp.salary) OVER(PARTITION BY emp.department ORDER BY emp.department) "avg_dept_salary"
FROM prac01.employee emp
GROUP BY emp.emp_id, emp.emp_name, emp.salary, emp.department )

SELECT
    a.*
FROM cte01 AS a
WHERE a.salary < a.avg_dept_salary
AND a.salary > ANY (SELECT AVG(salary) FROM prac01.employee GROUP BY department)

-- 5) Employees with salary greater than their manager's salary


Select
	EmployeeKey, 
	FirstName,
	LastName,
	DepartmentName,
	Salary
	from dbo.Employee emp 
WHERE salary > (Select salary from dbo.EMployee where employeekey = emp.managerkey)