select * from public.product p 
select * from public.customer_sales_fact csf 
select * from public.employee e 
select * from public.map_employee_hierarchy meh 

/*
 * Q1) Write a query to list the product names (SKUs) that
 * 		did not have any sales
 */

select
	p.product_sku_name 
from public.product p 
where p.product_sku_id not in (
	select
		csf.product_sku_id 
	from public.customer_sales_fact csf 
);

/*
 * Q2) Write a query to list the managers whose salary is less
 * 		then twice the average salary of employees reporting
 * 		to them
 */








