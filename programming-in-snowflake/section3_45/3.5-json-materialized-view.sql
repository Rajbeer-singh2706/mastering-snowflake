-- select context
use schema employees.public;

-- CASE 1
select 
  e.*, d.*
from emp e 
left join dept d 
   on e.deptno = d.deptno;

-- CASE 2 
select 
   d.dname as department, 
   sum(e.sal) as salaries
from emp e 
left join dept d 
  on e.deptno = d.deptno
group by department
order by department;

-- CASE 3
-- (try to) create materialized view
-- (not working with multiple tables!)
-- create view salaries_per_department
--Invalid materialized view definition. More than one table referenced in the view definition

create materialized view salaries_per_department as
select 
    d.dname as department, 
    sum(e.sal) as salaries
from emp e 
left join dept d 
  ON e.deptno = d.deptno
group by department
order by department;


-- CASE 4
-- (try to) create materialized view
-- (not working with ORDER BY!)
create materialized view salaries_per_department as
select 
    deptno as department, 
    sum(sal) as salaries
from emp
group by department
order by department;


-- CASE 5
-- create materialized view
create materialized view salaries_per_department as
select 
   deptno as department, 
   sum(sal) as salaries
from emp
group by department;


-- CHECK IT 
select * from salaries_per_department order by department;
select * from salaries_per_department order by department DESC;
