SELECT * FROM public.contests con 
/*
contest_id	hacker_id	name
66406		17973		Rose
66556		79153		Angela
94828		80275		Frank
*/
SELECT * FROM public.colleges chal 
/*
college_id	contest_id
11219		66406
32473		66556
56685		94828
 */
SELECT * FROM public.challenges col 
/*
challenge_id	college_id
18765			11219
47127			11219
60292			32473
72974			56685
 */
SELECT * FROM public.view_stats vs 
/*
challenge_id	total_views	total_unique_views
47127				26			19
47127				15			14
18765				43			10
18765				72			13
75516				35			17
60292				11			10
72974				41			15
75516				75			11
*/
SELECT * FROM public.submission_stats ss
/*
challenge_id	total_submissions	total_accepted_submissions
75516					34					12
47127					27					10
47127					56					18
75516					74					12
75516					83					8
72974					68					24
72974					82					14
47127					28					11
 */
-- =============================================================================================
/*
 * John interviews many candidates from different colleges using coding challenges and contests.
 * Write a query which displays the contest_id, hacker_id, name, sums of total_submissions, 
 * total_accepted_submissions, total_views, and total_unique_views for each contest sorted by
 * contest_id.
 * Exclude the contest from the result if all four sums are zero.
 */

-- XX -- WRONG -- XX --
SELECT 
	con.contest_id ,
	con.hacker_id ,
	con."name" ,
	sum(ss.total_submissions) "total_submissions" ,
	sum(ss.total_accepted_submissions) "total_accepted_submission" ,
	sum(vs.total_views) "total_views" ,
	sum(vs.total_unique_views) "total_unique_views"
FROM public.contests con
INNER JOIN public.colleges col ON con.contest_id = col.contest_id 
INNER JOIN public.challenges chal ON chal.college_id = col.college_id 
INNER JOIN public.view_stats vs ON vs.challenge_id = chal.challenge_id 
LEFT JOIN public.submission_stats ss ON ss.challenge_id = chal.challenge_id --AND ss.challenge_id <> vs.challenge_id 
GROUP BY con.contest_id , con.hacker_id , con."name"

-- ++ -- CORRECT -- ++ --

SELECT 
	con.contest_id ,
	con.hacker_id ,
	con."name" ,
	sum(ss.total_submissions) "total_submissions" ,
	sum(ss.total_accepted_submissions) "total_accepted_submission" ,
	sum(vs.total_views) "total_views" ,
	sum(vs.total_unique_views) "total_unique_views"
FROM public.contests con
INNER JOIN public.colleges col ON col.contest_id = con.contest_id 
INNER JOIN public.challenges chal ON chal.college_id = col.college_id 
LEFT JOIN (
	SELECT
		challenge_id ,
		sum(total_views) "total_views" ,
		sum(total_unique_views) "total_unique_views"
	FROM public.view_stats
	GROUP BY challenge_id) vs ON vs.challenge_id = chal.challenge_id 
LEFT JOIN (
	SELECT
		challenge_id ,
		sum(total_submissions) "total_submissions" ,
		sum(total_accepted_submissions) "total_accepted_submissions"
	FROM public.submission_stats
	GROUP BY challenge_id) ss ON ss.challenge_id = chal.challenge_id
GROUP BY con.contest_id, con.hacker_id, con."name"
HAVING sum(ss.total_submissions) <> 0 
	OR sum(ss.total_accepted_submissions) <> 0
	OR sum(vs.total_views) <> 0
	OR sum(vs.total_unique_views) <> 0
ORDER BY con.contest_id;
