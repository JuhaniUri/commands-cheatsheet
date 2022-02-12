--
show errors;
set timi on;
set echo on;
--set serveroutput on;

-- in case of re-run.
drop table user1.insurance_quotes_temp;
drop table user1.ark_owner_temp;


--abort scrambling when there's an error
whenever sqlerror exit sql.sqlcode;

-- disable all triggers
begin
    for trig in (select * from all_triggers
                 where owner = 'USER1')
    loop
        execute immediate 'alter trigger '||trig.owner||'.'|| trig.trigger_name||' disable';
    end loop;
end;
/

--- truncate, delete, update etc


-- enable triggers

begin
    for trig in (select * from all_triggers
                 where owner = 'USER1')
    loop
        execute immediate 'alter trigger '||trig.owner||'.'|| trig.trigger_name||'  enable';
    end loop;
end;
/

-- end?
commit;
exit;