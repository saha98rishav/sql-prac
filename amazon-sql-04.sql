SELECT * FROM public.customer;
SELECT * FROM public.customer_sales_fact;
SELECT * FROM public.customer_territory;
SELECT * FROM public.product;

-- Q1) Return Arizona territory's sales growth from
-- 2021 to 2022 (compare growth between 2021 and 2022)

with sales_2021 as (
    select
        extract(year from csf.order_date) "year",
        ct.territory_id,
        sum(csf.order_value) total_sales_2021
    from public.customer_sales_fact csf
    inner join public.customer_territory ct on csf.customer_id = ct.customer_id
    where ct.territory_id = 'AZ'
    and extract(year from csf.order_date) = 2021
    group by extract(year from csf.order_date), ct.territory_id
),
sales_2022 as (
    select
        extract(year from csf.order_date) "year",
        ct.territory_id,
        sum(csf.order_value) total_sales_2022
    from public.customer_sales_fact csf
    inner join public.customer_territory ct on csf.customer_id = ct.customer_id
    where ct.territory_id = 'AZ'
    and extract(year from csf.order_date) = 2022
    group by extract(year from csf.order_date), ct.territory_id
)

select 
    a.territory_id,
    (((b.total_sales_2022 - a.total_sales_2021) * 100) / a.total_sales_2021) "sales_growth"
from sales_2021 a 
join sales_2022 b on a.territory_id = b.territory_id

-- ----------------------------------------------------------------------------------------------

-- Q2) Fetch the % share of each product compared to its total market

with prod_tot_sales as (
	select
		p.market_name ,
		p.product_sku_name ,
		round(sum(csf.order_value), 2) "product_sales" 
	from public.customer_sales_fact csf 
	inner join public.product p on csf.product_sku_id = p.product_sku_id 
	group by p.product_sku_name, p.market_name
),
market_tot_sales as (
	select
		p2.market_name ,
		round(sum(csf2.order_value), 2) "market_sales"
	from public.customer_sales_fact csf2 
	inner join public.product p2 on csf2.product_sku_id = p2.product_sku_id 
	group by p2.market_name
)

select 
	pts.market_name,
	pts.product_sku_name,
	round(((pts.product_sales * 100) / mts.market_sales), 2) "market_share"
from prod_tot_sales pts
inner join market_tot_sales mts on pts.market_name = mts.market_name
order by 1





