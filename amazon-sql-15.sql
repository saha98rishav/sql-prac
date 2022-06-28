SELECT * FROM public.cust_dim;
SELECT * FROM public.order_fact;

-- Q3) Show those order_ids which are placed by same customer but having different order_types

SELECT
    ordfct1.order_id
FROM public.order_fact ordfct1
INNER JOIN public.order_fact ordfct2
    ON ordfct1.cust_id = ordfct2.cust_id
    AND ordfct1.order_type <> ordfct2.order_type
    AND ordfct1.order_id <> ordfct2.order_id

-- Q4) Show those cust_ids by month of order_date who placed the order in same month
-- and year.
-- Display the actual order date along with cust_id and month of order date

SELECT
    odrfct1.cust_id "customer_id",
    EXTRACT (MONTH FROM odrfct1.order_date) AS "month_order_date",
    odrfct1.order_date
FROM public.order_fact odrfct1
INNER JOIN public.order_fact odrfct2 ON odrfct1.order_id <> odrfct2.order_id
    AND odrfct1.cust_id <> odrfct2.cust_id
    AND EXTRACT (MONTH FROM odrfct1.order_date) = EXTRACT (MONTH FROM odrfct2.order_date)
    AND EXTRACT (YEAR FROM odrfct1.order_date) = EXTRACT (YEAR FROM odrfct2.order_date)



