SELECT * FROM public.employee e 
SELECT * FROM public.map_employee_hierarchy meh 

/*
 * Display employee id and employee name for employees who are also managers
 */

SELECT DISTINCT 
	e.employee_id ,
	e.employee_name 
FROM public.employee e 
INNER JOIN public.map_employee_hierarchy meh
	ON e.employee_id = meh.manager_employee_id 

/*
 * Show top 3 highest earning employee
 */
	
SELECT 
	x.employee_id ,
	x.salary
FROM (
SELECT 
	e.employee_id ,
	e.salary ,
	DENSE_RANK () OVER(ORDER BY e.salary DESC) rnk
FROM public.employee e 
) x
WHERE x.rnk <= 3
	

/*
 * Display those employees who are reporting to same manager
 */

SELECT
	emp.employee_id ,
	mgr.manager_employee_id 
FROM public.map_employee_hierarchy emp
INNER JOIN public.map_employee_hierarchy mgr ON emp.manager_employee_id = mgr.manager_employee_id 
WHERE emp.employee_id <> mgr.employee_id
ORDER BY mgr.manager_employee_id 





