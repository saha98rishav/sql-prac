SELECT * FROM public.customer c;
SELECT * FROM public.customer_sales_fact csf;


/*
 * Q1) Find the customer with the highest daily total order cost between 2019-02-01
 * to 2019-05-01. If the customer had more than one order on a certain day, sum the order
 * costs of daily basis.
 * Output their first name, order date, total cost for the order date
 */

SELECT
	x.customer_name,
	x.order_date,
	x.total_cost
FROM (
	SELECT
		c.customer_name ,
		csf.order_date ,
		sum(csf.order_value) "total_cost" ,
		DENSE_RANK() OVER(ORDER BY sum(csf.order_value) DESC) rnk
	FROM public.customer_sales_fact csf 
	INNER JOIN public.customer c ON c.customer_id = csf.customer_id
	WHERE csf.order_date BETWEEN to_date('2021-10-01', 'YYYY-MM-DD') AND to_date('2022-03-31', 'YYYY-MM-DD')
	GROUP BY c.customer_name, csf.order_date 
) x
WHERE x.rnk = 1

