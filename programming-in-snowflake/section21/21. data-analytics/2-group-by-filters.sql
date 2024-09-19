-- select database and schema
use schema employees.public;

-- GROUP BY with WHERE and HAVING
select deptno,
  to_char(year(hiredate)) as year,
  sum(sal) sals
from emp
where year > '1980'
group by deptno, year    
-- group by all
having sum(sal) > 5000
order by deptno, year;

-- GROUP BY with QUALIFY
select deptno,
  row_number() over (order by deptno) as rn,
  to_char(year(hiredate)) as year,
  sum(sal) sals
from emp
where year > '1980'
group by deptno, year
having sum(sal) > 5000
qualify rn > 1
order by deptno, year;

-- alternative (with CTE) to QUALIFY
with q as (
  select deptno,
    row_number() over (order by deptno) as rn,
    to_char(year(hiredate)) as year,
    sum(sal) sals
  from emp
  where year > '1980'
  group by deptno, year 
  having sum(sal) > 5000
  -- qualify rn > 1
  order by deptno, year)
select * from q where rn > 1;


-- same as union (one with deptno, one with year)
  select deptno,
    to_char(year(hiredate)) as year,
    sum(sal) sals
  from emp
  where year > '1980'
  group by grouping sets(deptno, year)
  having sum(sal) > 5000
    order by deptno, year

-- same as union (one with deptno, one with year)
  select deptno,
    to_char(year(hiredate)) as year,
    grouping(deptno),
    grouping(year),
    grouping(deptno,year),
    sum(sal) sals
  from emp
  where year > '1980'
  --group by grouping sets(deptno, year)
  group by rollup(deptno, year)

  having sum(sal) > 5000
    order by deptno, year