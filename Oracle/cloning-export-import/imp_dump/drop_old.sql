connect / as sysdba
select name from v$database;
--todo check that name matches database
shutdown immediate;
startup restrict;
DROP USER USER1 CASCADE;
DROP USER USER2 CASCADE;
shutdown immediate;
startup;
CREATE or REPLACE DIRECTORY impdir AS '/u02/dump/';
-- setting the pga to higher, hoping that it will improve index import
alter system set PGA_AGGREGATE_TARGET=2000M scope=spfile;
exit;