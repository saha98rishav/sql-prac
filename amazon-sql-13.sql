SELECT * FROM public.cust_dim;

-- How many customers older than 40 years old, by state, have spent at least 1000 USD?
SELECT 
    temp01.state,
    COUNT(temp01.cust_id)
FROM (
    SELECT
        cd.country,
        cd.state,
        cd.cust_id,
        cd.full_name,
        (DATE_PART('year', CAST(to_char(now(), 'YYYY-MM-DD') AS DATE)) - DATE_PART('year', cd.birth_date::DATE))::INTEGER "age",
        SUM(cd.item_spend_amt) "spent_amount"
    FROM public.cust_dim cd
    WHERE cd.item_spend_amt >= 1000
        AND (DATE_PART('year', CAST(to_char(now(), 'YYYY-MM-DD') AS DATE)) - DATE_PART('year', cd.birth_date::DATE))::INTEGER > 40
    GROUP BY cd.country, cd.state, cd.cust_id, cd.full_name,
            (DATE_PART('year', CAST(to_char(now(), 'YYYY-MM-DD') AS DATE)) - DATE_PART('year', cd.birth_date::DATE))::INTEGER
) temp01
GROUP BY temp01.state;

