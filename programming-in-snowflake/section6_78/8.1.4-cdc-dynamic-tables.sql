create database if not exists data_pipelines;
create or replace schema data_pipelines.dynamic_tables;

-- source (table) --> target (dynamic table)
CREATE TABLE source(id INT, name STRING);

-- CREATE Target TABLE as a => DYNAMIC TABLE 
-- Encapsulated the STREAMS & TASK functionality together
-- NO Longer Merge is Required 
-- We can do some transformation as well , on the fly
-- AS of now its very simple select
CREATE DYNAMIC TABLE target
  WAREHOUSE = compute_wh
  TARGET_LAG = '1 minute'
AS
  SELECT id, name FROM source;

-- insert 3 rows in the source table
INSERT INTO source VALUES (1, 'John'), (2, 'Mary'), (3, 'George');
SELECT * FROM target;

-- update+delete existing source rows --> dynamic table should reflect in-place changes
UPDATE source SET name = 'Mark' WHERE id = 1;
DELETE FROM source WHERE id = 2;
SELECT * FROM target;

ALTER DYNAMIC TABLE target SUSPEND;
