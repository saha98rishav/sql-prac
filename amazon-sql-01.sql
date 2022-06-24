/*
Table:: Movies
+----------+----------+-------------+--------------+
| movie_id | actor_id | director_id | release_date |
+----------+----------+-------------+--------------+

Table:: Movies_Type
+----------+--------+
| movie_id | type   |
+----------+--------+
| 	M1	   | ACTION |
|	M2	   |ROMANCE	| 
|	M3	   |COMEDY	|
+----------+--------+
*/
select * from public.movies m 
-- Q1) Write a query to list the actor - director pair who have worked on 
--		more than 2 movies together

select
	m.actor_id,
	m.director_id,
	count(m.movie_id) as "CountOfMovies"
from public.movies m 
group by m.actor_id , m.director_id 
having count(m.movie_id) > 2;

-- Q2) List the actor, each director has done the most movies with in each year

select
	z.actor_id,
	z.director_id,
	z."Year"
from (
	select
		m.actor_id ,
		m.director_id ,
		extract (year from m.release_date) as "Year",
		dense_rank() over(partition by m.director_id order by count(distinct m.movie_id) desc) as rank_num
	from public.movies m
	group by m.actor_id , m.director_id , extract (year from m.release_date)
) as z
where z.rank_num = 1;

-- Q3) List the movies which are either ACTION movie or doesn't have any
--		movie type associated with it

select
	distinct m.movie_id
from public.movies m 
left outer join public.movie_type mt on m.movie_id = mt.movie_id
where mt."type" = 'ACTION'
or m.movie_id not in (select mt2.movie_id from public.movie_type mt2)
order by 1;
