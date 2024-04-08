# General & Daily tasks

- [General \& Daily tasks](#general--daily-tasks)
  - [Backup settings](#backup-settings)
    - [Show Recovery are (RMAN)](#show-recovery-are-rman)
    - [Change FRA size](#change-fra-size)
    - [Set location](#set-location)
    - [Change location](#change-location)
    - [Check the RMAN status](#check-the-rman-status)
  - [Tablespaces and datafiles](#tablespaces-and-datafiles)
    - [Tablespace used/free/total](#tablespace-usedfreetotal)
    - [Add datafile to TABLESPACE](#add-datafile-to-tablespace)
    - [Resize datafile](#resize-datafile)
    - [Check if autoextend is enabled](#check-if-autoextend-is-enabled)
    - [Enable autoextend with maxsize](#enable-autoextend-with-maxsize)
    - [Swap undo tablespace](#swap-undo-tablespace)
    - [Temp tablespace switch](#temp-tablespace-switch)
    - [Move table/lob to new tablespace](#move-tablelob-to-new-tablespace)
  - [Indexes](#indexes)
    - [View unusable](#view-unusable)
    - [Rebuild unusable indexes](#rebuild-unusable-indexes)
    - [Move indexes to tablespace](#move-indexes-to-tablespace)
  - [Redologs](#redologs)
    - [Hourly/Daily Archive generation](#hourlydaily-archive-generation)
      - [Hourly Archive Log Generation](#hourly-archive-log-generation)
      - [Daily Archive Log Generation](#daily-archive-log-generation)
    - [Force logging](#force-logging)
    - [Add more redo](#add-more-redo)
  - [Random stuff](#random-stuff)
    - [Disable jobs at startup](#disable-jobs-at-startup)
    - [Startup for pdbs](#startup-for-pdbs)
    - [Shutdown Immediate Hangs / Active Processes Prevent Shutdown (Doc ID 416658.1)](#shutdown-immediate-hangs--active-processes-prevent-shutdown-doc-id-4166581)
    - [DBCA examples](#dbca-examples)
    - [Using pipes in Linux with Oracle](#using-pipes-in-linux-with-oracle)
    - [Move controlfile location](#move-controlfile-location)
    - [UTL\_FILE examples tested in 10G](#utl_file-examples-tested-in-10g)
    - [Test env delete archivelog](#test-env-delete-archivelog)



## Backup settings
### Show Recovery are (RMAN)
```
show parameter db_recovery_file
```

### Change FRA size
```
alter system set db_recovery_file_dest_size=30g scope=both;
```
### Set location
```
alter system set db_recovery_file_dest='/u03/flash_recovery_area/' scope=both;
```
### Change location
```
alter system set log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST' scope=both;
```

### Check the RMAN status
```
SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    OPNAME NOT LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;
```


## Tablespaces and datafiles


### Tablespace used/free/total
```
SELECT df.tablespace_name "Tablespace",
  totalusedspace "Used MB",
  (df.totalspace - tu.totalusedspace) "Free MB",
  df.totalspace "Total MB",
  ROUND(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace)) "% Free"
FROM
  (SELECT tablespace_name,
    ROUND(SUM(bytes) / 1048576) TotalSpace
  FROM dba_data_files
  GROUP BY tablespace_name
  ) df,
  (SELECT ROUND(SUM(bytes)/(1024*1024)) totalusedspace,
    tablespace_name
  FROM dba_segments
  GROUP BY tablespace_name
  ) tu
WHERE df.tablespace_name = tu.tablespace_name;
```


### Add datafile to TABLESPACE
```
ALTER TABLESPACE DAT1 ADD datafile '/u02/TEST/DAT1_05.dbf' size 1G autoextend on next 1G MAXSIZE 20G;
ALTER TABLESPACE DAT1 ADD datafile '/u02/TEST/DAT1_06.dbf' size 1G autoextend on next 1G MAXSIZE 20G;
```
### Resize datafile
```
ALTER DATABASE datafile '/u02/TEST/DAT1_01.dbf' AUTOEXTEND ON next 512m  maxsize 10G;
```

### Check if autoextend is enabled
```
select file_name,autoextensible  from  dba_data_files where tablespace_name='ORCLTBS';;
```

### Enable autoextend with maxsize
```
select 'alter database datafile ' || '''' || file_name || '''' || ' autoextend on maxsize 12G;' from dba_data_files where tablespace_name not like 'UNDO%';
```
or
```
select 'alter database datafile ' || '''' || file_name || '''' || ' autoextend on next 512m maxsize 20G;' from dba_data_files where tablespace_name='ORCLTBS';
```

### Swap undo tablespace
```
CREATE UNDO TABLESPACE undotbs2 DATAFILE '/u02/prelive/PREEE/undotbs02.dbf' SIZE 1G AUTOEXTEND ON NEXT 100M maxsize 3G;
ALTER SYSTEM SET UNDO_TABLESPACE=undotbs2;
DROP TABLESPACE undotbs1 INCLUDING CONTENTS AND DATAFILES;
```

### Temp tablespace switch
```
select PROPERTY_NAME,PROPERTY_VALUE from database_properties where property_name like '%TEMP%';

CREATE TEMPORARY TABLESPACE TEMP2 TEMPFILE '/u02/testbaas/temp201.dbf' SIZE 100M reuse autoextend on maxsize 2G;
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp2;
DROP TABLESPACE temp1 INCLUDING CONTENTS AND DATAFILES;
```

### Move table/lob to new tablespace

```
CREATE TABLESPACE XML_IO2
datafile '/u02/TEST/XML_IO2_01.dbf'
size 3000m;


select owner, table_name,tablespace_name
   from dba_tables
  where tablespace_name='XML_IO';

ALTER TABLE SHR.XML_IO MOVE TABLESPACE XML_IO2;
ALTER TABLE YHR.XML_IO MOVE TABLESPACE XML_IO2;



select segment_name , segment_type, tablespace_name, owner from dba_segments
where tablespace_name = 'XML_IO';


SELECT OWNER,COLUMN_NAME,SEGMENT_NAME,TABLESPACE_NAME FROM DBA_LOBS WHERE TABLE_NAME='XML_IO';
SELECT OWNER,INDEX_NAME,INDEX_TYPE,TABLESPACE_NAME FROM DBA_INDEXES WHERE TABLE_NAME='XML_IO';


ALTER TABLE YHR.XML_IO MOVE LOB(XML) STORE AS (TABLESPACE XML_IO2);
ALTER TABLE SHR.XML_IO MOVE LOB(XML) STORE AS (TABLESPACE XML_IO2);


DROP TABLESPACE XML_IO INCLUDING CONTENTS AND DATAFILES;
```


## Indexes
### View unusable
```
select owner, index_name from dba_indexes where status='UNUSABLE';
```

### Rebuild unusable indexes
```
select 'alter index '||owner||'.'||index_name||' rebuild ONLINE;' from dba_indexes where status='UNUSABLE';
```



### Move indexes to tablespace
```
select INDEX_NAME, tablespace_name
from all_indexes
where owner = 'TEST'


select 'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' REBUILD TABLESPACE ' || TABLESPACE_NAME || ';' from DBA_INDEXES WHERE OWNER='TEST';
select 'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' MOVE TABLESPACE ' || TABLESPACE_NAME || ';' from DBA_TABLES WHERE OWNER='TEST';


select segment_name , segment_type from dba_segments
where tablespace_name ='TEST';
```

## Redologs

### Hourly/Daily Archive generation


#### Hourly Archive Log Generation
```
select to_char(trunc(first_time, 'HH24'), 'DD/MM/YYYY HH24:MI:SS') date_by_hour, sum(round(blocks*block_size/1024/1024)) CHURN_IN_MB
from v$archived_log
group by trunc(first_time, 'HH24')
order by 1;
```

#### Daily Archive Log Generation
```
select trunc(COMPLETION_TIME,'DD') Day, thread#,
round(sum(BLOCKS*BLOCK_SIZE)/1024/1024/1024) GB,
count(*) Archives_Generated from v$archived_log
group by trunc(COMPLETION_TIME,'DD'),thread# order by 1;
```


### Force logging
The FORCE LOGGING option is the safest method to ensure that all the changes made in the database will be captured and available for recovery in the redo logs.

```
ALTER DATABASE FORCE LOGGING;
```
Check more: https://www.orafaq.com/wiki/Nologging_and_force_logging


### Add more redo
```
ALTER DATABASE ADD LOGFILE GROUP 7 ('/oradata/test/redo07.log') SIZE 500m;
ALTER DATABASE ADD LOGFILE GROUP 8 ('/oradata/test/redo08.log') SIZE 500m;
ALTER DATABASE ADD LOGFILE GROUP 9 ('/oradata/test/redo09.log') SIZE 500m;
ALTER DATABASE ADD LOGFILE GROUP 10 ('/oradata/test/redo10.log') SIZE 500m;
```




## Random stuff
### Disable jobs at startup

```
STARTUP MOUNT;
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER DATABASE OPEN;
alter system set job_queue_processes=0 scope=both;
ALTER SYSTEM DISABLE RESTRICTED SESSION;
```

To start again
```
alter system set job_queue_processes=1000 scope=both;
```

### Startup for pdbs
```
CREATE OR REPLACE TRIGGER open_pdbs
  AFTER STARTUP ON DATABASE
BEGIN
   EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ALL OPEN';
END open_pdbs;
/
```

###	Shutdown Immediate Hangs / Active Processes Prevent Shutdown (Doc ID 416658.1)

Symptom:
Alert.log shows:
Active call for process 22181 user 'oracle' program 'oracle@TESTDB2'
Active call for process 25813 user 'oracle' program 'oracle@TESTDB2'
SHUTDOWN: waiting for active calls to complete.

Solution:
```
shutdown abort
startup restrict
shutdown normal
```

### DBCA examples
```
dbca -silent -createDatabase \
-templateName General_Purpose.dbc \
-gdbName test \
-sid test \
-sysPassword **** \
-systemPassword **** \
-emConfiguration NONE \
-datafileDestination /u02 \
-recoveryAreaDestination /u03 \
-storageType FS \
-characterSet AL32UTF8 \
-nationalCharacterSet AL16UTF16 \
-registerWithDirService false \
-listeners LISTENER_1521;
```

### Using pipes in Linux with Oracle
```
export ORACLE_SID=test1 && echo "alter database tempfile '/oradata/test1/temp01.dbf' drop;"| sqlplus -S "/ as sysdba"
echo "ALTER TABLESPACE temp ADD TEMPFILE '/oradata/test1/temp01.dbf' SIZE 100M reuse autoextend on maxsize 2000M;"| sqlplus -S "/ as sysdba"
```


### Move controlfile location
```
show parameter control_files
shutdow immediate;
mv /mnt/test/control02.ctl /u01/test/control02.ctl
startup nomount;
alter system set control_files='/u01/test/control01.ctl','/u01/test/control02.ctl' scope=SPFILE;
shutdown immediate;


startup nomount;
show parameter control_files
alter database mount;
alter database open;
```

### UTL_FILE examples tested in 10G

```
declare
  f utl_file.file_type;
begin
  f := utl_file.fopen('ORALOAD', 'juhani_test.txt', 'w');
  utl_file.put_line(f, 'line one: some text');
  utl_file.put_line(f, 'line two: more text');
  utl_file.fclose(f);
end;
/
```

```
declare
  f utl_file.file_type;
begin
  f := utl_file.fopen('DOCUMENT_LOCATION', 'juhani_test.txt', 'w');
  utl_file.put_line(f, 'line one: some text');
  utl_file.put_line(f, 'line two: more text');
  utl_file.fclose(f);
end;
/
```

```
declare
  f utl_file.file_type;
begin
  f := utl_file.fopen('BATCH_FILES', 'juhani_test.txt', 'w');
  utl_file.put_line(f, 'line one: some text');
  utl_file.put_line(f, 'line two: more text');
  utl_file.fclose(f);
end;
/
```



```
begin
  Utl_File.Fcopy (
       src_location  => 'ORALOAD',
       src_filename  => 'test.txt',
       dest_location => 'BATCH_FILES',
       dest_filename => 'test.txt' );
end;
/
```

### Test env delete archivelog
```
echo "connect target;delete noprompt archivelog until time 'sysdate - 1';"|rman
```