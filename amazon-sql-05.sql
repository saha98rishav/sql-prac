select * from public.sales_products sp 
select * from public.donations_products dp 
select * from public.donations d 

-- Q1) Give a monthly report of sales figures for each product for year 2021

select
	extract (year from sp.sales_date) "sales_year" ,
	extract (month from sp.sales_date) "sales_month" ,
	--sp.product_id ,
	sum(sp.sales_amount)
from public.sales_products sp 
where extract (year from sp.sales_date) = 2021
group by --sp.product_id, 
	extract (year from sp.sales_date), 
	extract (month from sp.sales_date)
order by extract (year from sp.sales_date),
		extract (month from sp.sales_date) 

/*
 * Q2) Give list of all products donated but not sold
 * List should include year of sales, product_id, donation_id, desc, date of donation,
 * sales amount of product
 */

select
	extract (year from dp.product_date) "donation_year" ,
	dp.product_id ,
	dp.donation_id ,
	dp.description ,
	dp.product_price
from public.sales_products sp 
right outer join public.donations_products dp on sp.product_id = dp.product_id 
where sp.sales_id is null

