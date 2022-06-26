SELECT * FROM public.user_transactions ut ORDER BY ut.user_id , ut.purchase_date 

/*
 * Find out daily active users - display purchase_date and daily_active_users
 */

SELECT
	ut.purchase_date ,
	count(DISTINCT (ut.user_id)) "daily_active_users"
FROM public.user_transactions ut 
GROUP BY ut.purchase_date
ORDER BY ut.purchase_date;


/*
 * Find out Monthly Active users - display purchase_year, purchase_month, monthly_active_users
 */

SELECT 
	EXTRACT (YEAR FROM ut.purchase_date) "purchase_year",
	to_char (ut.purchase_date, 'Mon') "purchase_month",
	count(DISTINCT ut.user_id) "monthly_active_users"
FROM public.user_transactions ut 
GROUP BY EXTRACT (YEAR FROM ut.purchase_date), to_char (ut.purchase_date, 'Mon')
ORDER BY EXTRACT (YEAR FROM ut.purchase_date), to_char (ut.purchase_date, 'Mon');

/*
 * Find out Yearly Active users - display purchase_year, yearly_active_users
 */

SELECT 
	EXTRACT (YEAR FROM ut.purchase_date) "purchase_year" ,
	count(DISTINCT ut.user_id) "yearly_active_users"
FROM public.user_transactions ut 
GROUP BY EXTRACT (YEAR FROM ut.purchase_date)
ORDER BY EXTRACT (YEAR FROM ut.purchase_date);


