
REM --------------------------------------------------------------------------
REM This script will recompile all invalid database objects in
REM the logged on users scheme.
REM --------------------------------------------------------------------------

set heading off
set linesize 2000
set pagesize 1000
set feedback off
set termout off
PROMPT Compiling logged on Users Invalid Database Objects
spool w.sql
prompt Prompt Compiling:
select 'Prompt '||object_name || ' ...'|| chr(10)|| 'alter function '|| object_name || ' compile;' from user_objects where
object_type='FUNCTION' and status='INVALID'
/
select 'Prompt '||object_name || ' ...'|| chr(10)|| 'alter procedure '|| object_name || ' compile;' from user_objects where
object_type='PROCEDURE' and status='INVALID'
/
select 'Prompt '||object_name || ' ...'|| chr(10)|| 'alter package '|| object_name || ' compile;' from user_objects where
object_type='PACKAGE' and status='INVALID'
/
select 'Prompt '||object_name || ' ...'|| chr(10)|| 'alter trigger '|| object_name || ' compile;' from user_objects where
object_type='TRIGGER' and status='INVALID' and object_name not in (select object_name from recyclebin)
/
select 'Prompt '||object_name || ' ...'|| chr(10)|| 'alter view '|| object_name || ' compile;' from user_objects where
object_type='VIEW' and status='INVALID'
/
select 'Prompt '||object_name || ' ...'|| chr(10)|| 'alter package '|| object_name || ' compile body;' from user_objects where
object_type='PACKAGE BODY' and status='INVALID'
/

spool off
set termout on
start w.sql

set heading on

prompt Invalid objects:
select object_name,object_type,status
from   all_objects
where  object_type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','TRIGGER','VIEW')
and    status = 'INVALID'
and    owner = USER
and    object_name not in (select object_name from recyclebin)
order  by 1,2;

prompt RecycleBin:
Select OBJECT_NAME,ORIGINAL_NAME, type from recyclebin;
set heading on
set linesize 80
set pagesize 14
set feedback on

PROMPT
PROMPT End of Compile.

