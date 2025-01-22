create or replace database time_travel;
create or replace table persons (id int, name string, ts timestamp);

-- Time travel=>  0 - disble , 1 - ...90 days 



-- =============================================================
-- time travel settings
show parameters like 'data_retention_time_in_days' in account;          --1 days (default)
show parameters like 'data_retention_time_in_days' in database;         -- 1 days(default)
show parameters like 'data_retention_time_in_days' in schema;           -- 1 days(default)
show parameters like 'data_retention_time_in_days' for table persons;   -- 1 days(default)

alter table persons set data_retention_time_in_days = 3;

-- =============================================================
-- time travel SELECT (looking back in time)
insert into persons values (1, 'Mike', current_timestamp());

set ts = (select current_timestamp());
insert into persons values (2, 'Mary', $ts);
select * from persons at (timestamp => $ts);
select * from persons before (timestamp => current_timestamp());

insert into persons values (3, 'George', current_timestamp());
set qid = (select last_query_id());

-- Mike, Mary, George
select * from persons;
-- Mike, Mary
select * from persons before (statement => $qid);
-- Mike
select * from persons before (timestamp => $ts);
-- negative, relative, in seconds
select * from persons at (offset => -60);

select * from persons at (offset => -1000); --error 
-- =============================================================
-- data recovery with time travel
drop table persons;
undrop table persons;

-- case2
truncate persons; -- truncate all data first 
create table persons2 clone persons before (statement => last_query_id()); -- create new table 
select * from persons2;

drop table persons;
alter table persons2 rename to persons;

show tables history;
