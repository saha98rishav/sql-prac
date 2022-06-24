/*
 * Q1) Write a Query to display those customer names and
 * their occurrences when customer names appears more then once
 */

select
	c.customer_name ,
	count(c.customer_name) as occurences
from public.customer c 
group by c.customer_name 
having count(c.customer_name) > 1;

/*
 * Q2) Write a Query to get the employees who are responsible
 * for maximum number of customers
 */

select 
	z.employee_id
from (
select
	met.employee_id ,
	count(ct.customer_id) as count_customers ,
	dense_rank() over(order by count(ct.customer_id) desc) as rnk
from public.map_employee_territory met
inner join public.customer_territory ct on met.territory_id = ct.territory_id 
group by met.employee_id ) as z
where z.rnk = 1;

/*
 * Q3) Write a query to get those employees having no customer
 */

select 
	met.employee_id 
from public.map_employee_territory met 
left outer join public.customer_territory ct on ct.territory_id = met.territory_id 
where ct.customer_id is null;

select
	met.employee_id 
from public.map_employee_territory met
where met.territory_id  not in (select ct.territory_id from public.customer_territory ct)

