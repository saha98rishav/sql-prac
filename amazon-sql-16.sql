SELECT * FROM public.cust_dim;
SELECT * FROM public.order_fact;
SELECT * FROM public.order_items_fact;
SELECT * FROM public.product_dim;

-- Q) Return the customer IDs who made at least one order with a
-- price greater than $1000

SELECT
    x.cust_id,
    x.order_id,
    SUM(x.price)
FROM (
SELECT
    cd.cust_id,
    odf.order_id,
    oif.product_id,
    (oif.quantity * pd.price) "price"
FROM public.cust_dim cd
INNER JOIN public.order_fact odf ON cd.cust_id = odf.cust_id
INNER JOIN public.order_items_fact oif ON oif.order_id = odf.order_id
INNER JOIN public.product_dim pd ON pd.product_id = oif.product_id
ORDER BY cd.cust_id, odf.order_id, oif.product_id ) x
GROUP BY x.cust_id, x.order_id
HAVING SUM(x.price) >= 1000
ORDER BY x.cust_id;

/*
"cust_id"	"order_id"	"sum"
    1	     ORDER1	    1500
    3	     ORDER3	    15000
    4	     ORDER4	    2500
    6	     ORDER5	    7000
*/

SELECT
    cd.cust_id,
    odf.order_id,
    SUM((oif.quantity * pd.price)) "price"
FROM public.cust_dim cd
INNER JOIN public.order_fact odf ON cd.cust_id = odf.cust_id
INNER JOIN public.order_items_fact oif ON oif.order_id = odf.order_id
INNER JOIN public.product_dim pd ON pd.product_id = oif.product_id
GROUP BY cd.cust_id, odf.order_id
HAVING SUM((oif.quantity * pd.price)) >= 1000
ORDER BY cd.cust_id, odf.order_id

/*
"cust_id"	"order_id"	"sum"
    1	     ORDER1	    1500
    3	     ORDER3	    15000
    4	     ORDER4	    2500
    6	     ORDER5	    7000
*/
