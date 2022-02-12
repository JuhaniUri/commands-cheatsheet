connect / as sysdba
grant execute on dbms_crypto to USER1;
grant execute on dbms_crypto to USER1;
@$ORACLE_HOME/rdbms/admin/utlrp.sql
SELECT count(*) FROM dba_objects WHERE  status = 'INVALID' ORDER BY owner, object_type, object_name;
alter system set PGA_AGGREGATE_TARGET=700M scope=spfile;