SELECT * FROM public.cust_dim;
SELECT * FROM public.order_fact;

-- Q1) Which customer in Texas had never made a purchase?

SELECT
    cd.cust_id,
    cd.full_name
FROM public.cust_dim cd
LEFT OUTER JOIN public.order_fact odrfct ON cd.cust_id = odrfct.cust_id
WHERE cd.state = 'TX' AND odrfct.order_id IS NULL

-- Q2) Display the total count of customers and their total item_spent_amount by country
-- who made their purchase through WEB and CUSTOMER SERVICE?

SELECT
    cd.country,
    COUNT(cd.cust_id),
    SUM(cd.item_spend_amt)
FROM public.cust_dim cd
INNER JOIN public.order_fact odrfct ON cd.cust_id = odrfct.cust_id
WHERE odrfct.order_type IN ('WEB', 'CUSTOMER SERVICE')
GROUP BY cd.country;


