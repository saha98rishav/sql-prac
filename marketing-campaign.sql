/*
Marketing Campaign Success

You have a table of in-app puchases by user. Users that make their first in-app puchases
are placed in a marketing campaign where they see call-to-actions for more
in-app purchases. Find the number of users who made additional in-app purchases
due to the success of the marketing campaign.

The marketing campaign doesn't start until one day after the initial
in-app purchases so users that make multiple purchases on the same day
do not count, nor do we count users that make only the same purchases
over time.

Table:: marketing_campaign
+---------+------------+------------+----------+-------+
| user_id | created_at | product_id | quantity | price |
+---------+------------+------------+----------+-------+
| 10	  |	1/1/2019   |	101		|	3	   |  55   |
+---------+------------+------------+----------+-------+
| 10	  |	1/2/2019   |	119		|	5	   |  29   |
+---------+------------+------------+----------+-------+
| 10	  |	3/31/2019  |	111		|	2	   |  149  |
+---------+------------+------------+----------+-------+
| 11	  |	1/2/2019   |	105		|	3	   |  234  |
+---------+------------+------------+----------+-------+
| 11	  |	2/31/2019  |	120		|	3	   |  99   |
+---------+------------+------------+----------+-------+

*/

/*

-- To be considered in the marketing campaign, user needs to buy a product that isn't the 
	same product as what was brought in their first purchase date
	-- Product needs to be different
	-- Product needs to be purchased on a different date

Scenarios to consider
-- 1 item, 1 date of purchase (not eligible)
-- multiple products, 1 date of purchase (not eligible)
-- 1 product, multiple days (not eligible)
-- multiple products, multiple days, but same products of the 1st day of purchase
-- multiple dates, multiple products (eligible)

*/


select
	user_id
from marketing_campaign
group by user_id
having count(distinct product_id) > 1 -- user must purchase multiple different product
and count(distinct created_at) > 1 -- user must purchase on different dates

-- getting the first purchase only
select user_product (
select
	*,
	rank() over(partition by user_id order by created_at) as rn,
	concat(user_id, '_', product_id) as user_product
from marketing_campaign ) x
where x.rn = 1


-- combining above two queries

select
	count(distinct user_id)
from marketing_campaign
where user_id in (
	select
		user_id
	from marketing_campaign
	group by user_id
	having count(distinct product_id) > 1 -- user must purchase multiple different product
	and count(distinct created_at) > 1 -- user must purchase on different dates
)
and concat(user_id, '_', product_id) not in (
	select user_product (
		select
			*,
			rank() over(partition by user_id order by created_at) as rn,
			concat(user_id, '_', product_id) as user_product
		from marketing_campaign 
	) x
	where x.rn = 1
)