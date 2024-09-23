create or replace database transactions;
create or replace table log(msg string not null);

-- ###### BLOCK 
begin 
 -- 
 -- 
end; 
 --its a block not the transactin becoz begin doesnt end with semicolon 


-- use case 1
-- committed transaction (paste transaction ID)
begin transaction; -- ends with semicolon
show transactions;
describe transaction 1701770368254000000; -- change this with yours
insert into log values ('must see');
commit;
select * from log;
truncate log;

-- rollbacked transaction(transaction keyword is optional)
begin transaction;
insert into log values ('wrong');
rollback;
select * from log;

-- case 2 => aborted transaction
begin transaction name t1;
insert into log values ('aborted');
show locks in account;
set tid = (select current_transaction());
select system$abort_transaction($tid);
select * from log;
commit;
select * from log;
select current_transaction(), last_transaction();

show parameters like 'TRANSACTION_ABORT_ON_ERROR';
show parameters like 'TRANSACTION_DEFAULT_ISOLATION_LEVEL';

-- CASE 3
-- not scoped transactions: second begin ignored --> show nothing
begin transaction;
insert into log values ('outer');
begin transaction;
insert into log values ('inner');
rollback;
--show transaction -- everything is rollbacked
commit;
select * from log;
truncate log;

-- scoped transactions: rolled-back inner --> show only outer
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log values ('inner');
  rollback;
end;
commit;
select * from log;
truncate log;

-- scoped transactions: auto-rolled-back inner --> show only outer
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log values ('inner');
  -- rollback;
end;
commit;
select * from log;
truncate log;

-- scoped transactions: committed inner --> show only inner
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log values ('inner');
  commit;
end;
rollback;
select * from log;
truncate log;

-- different scopes --> not allowed
begin transaction;
insert into log values ('outer');
begin
  insert into log values ('inner');
  rollback; -- fails
end;
select * from log;
truncate log;

-- ==============================================================
-- auto-commit

show parameters like 'AUTOCOMMIT';

alter session set autocommit = true;
begin
  -- begin transaction
  insert into log values ('ok');
  -- commit
end;
select * from log;
truncate log;

-- auto-rolled back
alter session set autocommit = false;
begin
  -- begin transaction
  insert into log values ('wrong');
  -- rollback
end;
select * from log;
truncate log;

-- ==============================================================
-- see data before previous commit --> one outer only
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log select * from log;
  commit;
end;
commit;
select * from log;
truncate log;

-- DDL statement auto-commits existing transaction
begin transaction;
insert into log values ('outer');
create or replace temp table log2 (msg string);
rollback;
select * from log;
truncate log;
select * from log2;
drop table log2;

-- commits w/ try insert invalid --> skip that
begin transaction;
insert into log values ('one');
insert into log values (null);
insert into log values ('two');
commit;
select * from log;
truncate log;
