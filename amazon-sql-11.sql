SELECT * FROM public.employee e 
SELECT * FROM public.map_employee_hierarchy meh 

SELECT  
	meh.employee_id "employee_id" ,
	e.employee_id "manager_id",
	e.salary "manager_salary"
FROM public.employee e 
INNER JOIN public.map_employee_hierarchy meh ON e.employee_id = meh.manager_employee_id  
ORDER BY e.salary 

-- -- ANSWER -- --

WITH employee_sal AS (
	SELECT 
		e.employee_id "employee_id",
		e.salary "employee_salary"
	FROM public.employee e 
),
manager_sal AS (
	SELECT  
		meh.employee_id "employee_id" ,
		e.employee_id "manager_id",
		e.salary "manager_salary"
	FROM public.employee e 
	INNER JOIN public.map_employee_hierarchy meh ON e.employee_id = meh.manager_employee_id  
	ORDER BY e.salary 
)

SELECT 
	es.employee_id ,
	es."employee_salary"
FROM employee_sal es
INNER JOIN manager_sal ms ON es.employee_id = ms.employee_id
WHERE es.employee_salary > ms.manager_salary;

