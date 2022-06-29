SELECT * FROM public.student_grades;
/*
"student"	    "subject"	  "grade"
Alice	        Geography       4.0
Alice	        History	        4.5
Alice	        Math	        4.0
Bob	            Geography	    3.0
Bob	            History	        3.0
Bob	            Math	        3.5
Charlie	        Geography	    4.5
Charlie	        History	        4.0
Charlie	        Math	        3.0
*/
CREATE EXTENSION IF NOT EXISTS tablefunc;
-- -------------------------------------------------------------------------------------------------------
-- PIVOT (Row to Column transformation)
-- -------------------------------------------------------------------------------------------------------
SELECT
    *
FROM crosstab('SELECT 
    student, 
    subject, 
    grade 
FROM public.student_grades')
AS final_result (student VARCHAR(50), Geography NUMERIC(2,1), History NUMERIC(2,1), Math NUMERIC(2,1));
-- -------------------------------------------------------------------------------------------------------

/*
"student"	"geography"	"history"	"math"
Alice	        4.0	        4.5	     4.0
Bob	            3.0	        3.0	     3.5
Charlie	        4.5	        4.0	     3.0
*/

SELECT * FROM public.test;
/*
"id"	"a"	"b"	"c"
1	    11	12	13
2	    21	22	23
3	    31	32	33
*/

-- -------------------------------------------------------------------------------------------------------
-- UNPIVOT (Column to Row transformation)
-- -------------------------------------------------------------------------------------------------------
SELECT
    t.id,
    s.col_name,
    s.col_value
FROM public.test t
JOIN LATERAL (VALUES('a',t.a),('b',t.b),('c',t.c)) s(col_name, col_value) ON TRUE;
-- -------------------------------------------------------------------------------------------------------
/*
"id"	"col_name"	"col_value"
1	        a	        11
1	        b	        12
1	        c	        13
2	        a	        21
2	        b	        22
2	        c	        23
3	        a	        31
3	        b	        32
3	        c	        33
*/

