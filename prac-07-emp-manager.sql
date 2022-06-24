/*
create table if not exists prac01.employee (
	emp_id int,
	emp_name varchar(20),
	salary int
);

create table if not exists prac01.emp_hierarchy (
	emp_id int,
	manager_id int
);
*/

/*
insert into prac01.employee (emp_id, emp_name, salary) values
(1001, 'Nick', 10000),
(1002, 'Sam', 15000),
(1003, 'Perth', 17000),
(1004, 'Rhea', 9000),
(1005, 'Alex', 40000),
(1006, 'Mate', 18000),
(1007, 'Daniel', 16500);

insert into prac01.emp_hierarchy (emp_id, manager_id) values
(1001, 1003),
(1002, 1003),
(1003, 1005),
(1004, 1006),
(1005, null),
(1006, 1005),
(1007, 1007);
*/
select * from prac01.emp_hierarchy eh2 
select * from prac01.employee e2 

-- salary of managers
select distinct 
	e.emp_id as "manager_id" ,
	e.salary as "manager_salary"
from prac01.employee e
inner join prac01.emp_hierarchy eh on eh.manager_id = e.emp_id 
/*
+------------+----------------+
| manager_id | manager_salary |
+------------+----------------+
| 1003		 |		17,000	  |
| 1006		 | 		18,000	  |
| 1005 	 	 |		20,000	  |
+------------+----------------+
*/

-- average salary of employees reporting to their managers

select
	eh.manager_id as "manager_id",
	(select e1.salary from prac01.employee e1 where eh.manager_id = e1.emp_id) as "manager_salary" ,
	avg(e.salary) as avg_salary_reporting_employee
from prac01.employee e 
inner join prac01.emp_hierarchy eh on e.emp_id = eh.emp_id 
where eh.manager_id is not null
group by eh.manager_id 
having (select e2.salary from prac01.employee e2 where eh.manager_id = e2.emp_id) < 2 * avg(e.salary);

 


