create database if not exists data_pipelines;
create or replace schema data_pipelines.streams_and_tasks;

-- source (table) --> mystream (stream) --> target (table)
create table source(id int, name string);
create table target(id int, name string);

-- CREATE A STREAM
create stream mystream on table source;

-- CREATE A TASK 
-- CAN Create as Warehouse Task & Can Create a Serverless Task BOTH
-- task on mystream data stream, w/ MERGE statement
create or replace task mytask
  warehouse = compute_wh
  schedule = '1 minute'
  when system$stream_has_data('mystream')
as
  merge into target t using mystream s on t.id = s.id
  when matched
    and metadata$action = 'DELETE'
    and metadata$isupdate = 'FALSE'
    then delete
  when matched
    and metadata$action = 'INSERT'
    and metadata$isupdate = 'TRUE'
    then update set t.name = s.name
  when not matched -- means new records 
    and metadata$action = 'INSERT'
    then insert (id, name) values (s.id, s.name);

-- WHEN MATCHED -- Either update or delete
-- WHEN NOT MATCHED - THEN ITS INSERT 



-- insert 3 rows in the source table
select system$stream_has_data('mystream');
insert into source values (1, 'John'), (2, 'Mary'), (3, 'George');
select system$stream_has_data('mystream');

-- could manually execute the task and look at its execution
alter task mytask resume;
execute task mytask; -- foricbly run like this or it will run every 1 minute
select *
  from table(information_schema.task_history(task_name => 'mytask'))
  order by run_id desc;

-- CHECK the Data 
select * from target;

-- update+delete existing source rows --> target should make in-place changes
update source set name = 'Mark' where id = 1;
delete from source where id = 2;
select system$stream_has_data('mystream');
select * from target;


-- ALTER THE TASK 
alter task mytask suspend;
-- DELETE THE TASK 