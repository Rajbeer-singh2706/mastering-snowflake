-- select context
use schema employees.public;

/*
{
    "data": [
        { "DEPTNO": 10, "DNAME": "ACCOUNTING", "LOC": "NEW YORK" },
        { "DEPTNO": 20, "DNAME": "RESEARCH", "LOC": "DALLAS" },
        { "DEPTNO": 30, "DNAME": "SALES", "LOC": "CHICAGO" },
        { "DEPTNO": 40, "DNAME": "OPERATIONS", "LOC": "BOSTON" }
    ]
}*/

-- test all
select *
  from deptt,
  lateral flatten(input => deptt.v, path => 'data') d;

-- flatten JSON into tabular data format
-- fields name are case sensitive
create table dept as
select d.value:DEPTNO::number(2,0) as deptno,
    d.value:DNAME::varchar(20) as dname,
    d.value:LOC::varchar(20) as loc
  from deptt,
  lateral flatten(input => deptt.v, path => 'data') d;

select * from dept
