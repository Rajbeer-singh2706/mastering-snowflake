-- select test database and schema
use schema employees.public;

create table abc(v variant);

set json = $$
{
  myobj: {
    PROP1: {
      prop2: {
        name2: { array1: ['a', 'b', 'c'] }
      }
    }
  }
}
$$;

insert into abc values ($json);             --invalid
insert into abc values (parse_json($json)); --invalid expression
insert into abc select parse_json($json);
select * from abc;

select v:myobj.prop1.prop2['name2'].array1[2] from abc;   -- "c"
select v:myobj.prop1.prop2['name2'].array1[2]::string from abc;  -- cast to string 
select v:myobj.PROP1.prop2['name2'].array1[2]::string from abc;

drop table abc;