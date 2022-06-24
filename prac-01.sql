/*

Table: Customer

+-------------------+-------------------+-----------------------+
|	Sign_up_date	|	customer_id		|	transaction_id		|
+-------------------+-------------------+-----------------------+

Table: Transaction
+---------------+-----------+-----------------------+-----------+
|	timestamps	|	items	|	transaction_id		|	sales	|
+---------------+-----------+-----------------------+-----------+

Intended audience - company executives

-- Metrics --

A) Product
	1) top 5 products with maximum number of sales

B) Monetory
	1) total sales over time (monthly grain)
	2) avg sales per customer (monthly grain)

*/

-- A) Product
--		1) top 5 products with maximum number of sales

with temp as (
select
	items as product_name
	count(transaction_id) as no_of_transactions
from Transaction
group by items )
select top 5
	product_name,
	no_of_transactions
from temp
order by 2 desc

 

-- B) Monetory
--		1) total sales over time (monthly grain)

select
	month(t.timestamps) as order_month,
	sum(t.sales) as total_sales
from Transaction as t
group by 1
order by 1


-- B) Monetory
--		2) avg sales per customer (monthly grain)

with temp_cte as (
	select
		month(t.timestamps) as order_month,
		sum(t.sales) as total_sales,
		count(distinct t.transaction_id) as order_count
	from Transaction as t
	left inner join Customer as c on t.transaction_id = c.transaction_id
	group by month(t.timestamps)
)
select top 100
	order_month,
	total_sales*1.00 / order_count as cart_size
from temp_cte
order by 2 desc
