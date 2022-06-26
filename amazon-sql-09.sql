SELECT * FROM public.user_transactions ut ORDER BY ut.user_id , ut.purchase_date 
SELECT ut2.purchase_date::date FROM public.user_transactions ut2 
/*
 * Write a query that will identify returning users that have made a second
 * purchase within 7 days of any other of their purchases
 */

SELECT 
	DISTINCT ut.user_id 
FROM public.user_transactions ut 
INNER JOIN public.user_transactions ut2 ON ut.user_id = ut2.user_id AND ut.id <> ut2.id 
WHERE ut.purchase_date - ut2.purchase_date BETWEEN 0 AND 7
ORDER BY ut.user_id 


