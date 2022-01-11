# Various export/import, RMAN and etc examples for cloning migrating data 


## RMAN Clone in same server (Offline) 


###Preparation
###Check what we got:
```
--- List of all the User excluding default Users
SELECT username 
FROM all_users 
WHERE oracle_maintained = 'N';
```
```
SELECT sum(bytes)/1024/1024 size_in_mb 
FROM dba_data_files;
```
```
--- Check what's invalid
SELECT owner, object_type, object_name
FROM all_objects
WHERE status = 'INVALID';
```

### Create missing dirs
```
mkdir -p /u01/app/oracle/product/admin/NEWTEST/{adump,dpdump,pfile}
mkdir /u02/NEWTEST
```

### Create dedicated disk
```
<TEST> oracle@testdb ~]$ parted /dev/xvdf mklabel msdos mkpart primary 1M 100% set 1 lvm on
<TEST> oracle@testdb ~]$ pvcreate /dev/xvdf1
<TEST> oracle@testdb ~]$ vgcreate vg_NEWTEST /dev/xvdf1
<TEST> oracle@testdb ~]$ lvcreate -l 100%FREE -n lv_NEWTEST vg_NEWTEST
<TEST> oracle@testdb ~]$ mkfs.ext4 /dev/mapper/vg_NEWTEST-lv_NEWTEST
 
<TEST> oracle@testdb ~]$ add to  /etc/fstab
/dev/mapper/vg_NEWTEST-lv_NEWTEST /u02/NEWTEST ext4    defaults        1 2
<TEST> oracle@testdb ~]$ mount -a
 
<TEST> oracle@testdb ~]$ chmod 750 /u02/NEWTEST
<TEST> oracle@testdb ~]$ chown oracle:oinstall /u02/NEWTEST/
```
### Clone the existing database to NEWTEST
### Startup to with mount mode
```
<TEST> oracle@testdb ~]$ sqlplus / as sysdba
SQL*Plus: Release 10.2.0.3.0 - Production on Wed Oct 4 15:42:27 2017
 
Copyright (c) 1982, 2006, Oracle.  All Rights Reserved.
 
SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
 
SQL> startup mount
ORACLE instance started.
 
Total System Global Area 2097152000 bytes
Fixed Size                  2074016 bytes
Variable Size            1426066016 bytes
Database Buffers          654311424 bytes
Redo Buffers               14700544 bytes
Database mounted.
SQL> CREATE PFILE='/tmp/initNEWTEST.ora' FROM spfile;
SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS '/tmp/NEWTESTcontrol.ctl';
SQL> exit
```
### Clone with RMAN
```
RMAN> RUN {
BACKUP AS COPY DB_FILE_NAME_CONVERT ('/u02/TEST/','/u02/NEWTEST/') database;
};
 
Starting backup at 06-JAN-22
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=237 device type=DISK
channel ORA_DISK_1: starting datafile copy
input datafile file number=00009 name=/u02/TEST/ep_tabelid01.dbf
output file name=/u02/NEWTEST/ep_tabelid01.dbf tag=TAG20220106T120006 RECID=11 STAMP=1093262536
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:02:15
channel ORA_DISK_1: starting datafile copy
input datafile file number=00004 name=/u02/TEST/undotbs01.dbf
output file name=/u02/NEWTEST/undotbs01.dbf tag=TAG20220106T120006 RECID=12 STAMP=1093262589
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:55
channel ORA_DISK_1: starting datafile copy
input datafile file number=00010 name=/u02/TEST/system02.dbf
output file name=/u02/NEWTEST/system02.dbf tag=TAG20220106T120006 RECID=13 STAMP=1093262624
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:35
channel ORA_DISK_1: starting datafile copy
input datafile file number=00011 name=/u02/TEST/sysaux02.dbf
output file name=/u02/NEWTEST/sysaux02.dbf tag=TAG20220106T120006 RECID=14 STAMP=1093262681
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:55
channel ORA_DISK_1: starting datafile copy
input datafile file number=00003 name=/u02/TEST/sysaux01.dbf
output file name=/u02/NEWTEST/sysaux01.dbf tag=TAG20220106T120006 RECID=15 STAMP=1093262706
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:25
channel ORA_DISK_1: starting datafile copy
input datafile file number=00002 name=/u02/TEST/ep_indeksid01.dbf
output file name=/u02/NEWTEST/ep_indeksid01.dbf tag=TAG20220106T120006 RECID=16 STAMP=1093262728
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:25
channel ORA_DISK_1: starting datafile copy
input datafile file number=00001 name=/u02/TEST/system01.dbf
output file name=/u02/NEWTEST/system01.dbf tag=TAG20220106T120006 RECID=17 STAMP=1093262757
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:25
channel ORA_DISK_1: starting datafile copy
input datafile file number=00008 name=/u02/TEST/ep_kasutajad01.dbf
output file name=/u02/NEWTEST/ep_kasutajad01.dbf tag=TAG20220106T120006 RECID=18 STAMP=1093262767
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:07
channel ORA_DISK_1: starting datafile copy
input datafile file number=00007 name=/u02/TEST/users01.dbf
output file name=/u02/NEWTEST/users01.dbf tag=TAG20220106T120006 RECID=19 STAMP=1093262772
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:03
channel ORA_DISK_1: starting datafile copy
input datafile file number=00005 name=/u02/TEST/ep_kirjeldused01.dbf
output file name=/u02/NEWTEST/ep_kirjeldused01.dbf tag=TAG20220106T120006 RECID=20 STAMP=1093262773
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:01x
Finished backup at 06-JAN-22
 
RMAN> exit
```

### Prep pfile
```
[<TEST>oracle@testdb u02]$ sed -i 's/TEST/NEWTEST/g' /tmp/initNEWTEST.ora
[<TEST>oracle@testdb u02]$ sed -i 's/TEST/NEWTEST/g' /tmp/initNEWTEST.ora
 
[<TEST>oracle@testdb u02]$ cat /tmp/initNEWTEST.ora
NEWTEST.__data_transfer_cache_size=0
NEWTEST.__db_cache_size=1627389952
NEWTEST.__inmemory_ext_roarea=0
NEWTEST.__inmemory_ext_rwarea=0
NEWTEST.__java_pool_size=67108864
NEWTEST.__large_pool_size=33554432
NEWTEST.__oracle_base='/u01/app/oracle/product'#ORACLE_BASE set from environment
NEWTEST.__pga_aggregate_target=1677721600
NEWTEST.__sga_target=5033164800
NEWTEST.__shared_io_pool_size=251658240
NEWTEST.__shared_pool_size=3003121664
NEWTEST.__streams_pool_size=33554432
*.audit_file_dest='/u01/app/oracle/product/admin/NEWTEST/adump'
*.audit_trail='db'
*.compatible='12.2.0'
*.control_files='/u02/NEWTEST/control01.ctl','/u02/NEWTEST/control02.ctl'
*.db_block_size=8192
*.db_name='NEWTEST'
*.diagnostic_dest='/u01/app/oracle/product'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=NEWTESTXDB)'
*.local_listener='LISTENER_NEWTEST'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=1596m
*.processes=300
*.remote_login_passwordfile='EXCLUSIVE'
*.result_cache_mode='MANUAL'
*.sga_target=4788m
### Create control file, use file /tmp/NEWTESTcontrol.ctl as reference
cat /tmp/NEWTEST.ctl
STARTUP NOMOUNT
CREATE CONTROLFILE SET DATABASE "NEWTEST" RESETLOGS  NOARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 100
    MAXINSTANCES 8
    MAXLOGHISTORY 292
LOGFILE
  GROUP 1 '/u02/NEWTEST/redo01.log'  SIZE 200M BLOCKSIZE 512,
  GROUP 2 '/u02/NEWTEST/redo02.log'  SIZE 200M BLOCKSIZE 512,
  GROUP 3 '/u02/NEWTEST/redo03.log'  SIZE 200M BLOCKSIZE 512
-- STANDBY LOGFILE
DATAFILE
  '/u02/NEWTEST/system01.dbf',
  '/u02/NEWTEST/ep_indeksid01.dbf',
  '/u02/NEWTEST/sysaux01.dbf',
  '/u02/NEWTEST/undotbs01.dbf',
  '/u02/NEWTEST/ep_kirjeldused01.dbf',
  '/u02/NEWTEST/users01.dbf',
  '/u02/NEWTEST/ep_kasutajad01.dbf',
  '/u02/NEWTEST/ep_tabelid01.dbf',
  '/u02/NEWTEST/system02.dbf',
  '/u02/NEWTEST/sysaux02.dbf'
CHARACTER SET AL32UTF8
;
```

### Change the newly copied database to NEWTEST
```
export ORACLE_SID=NEWTEST
SQL> startup nomount pfile='/tmp/initNEWTEST.ora';
 
SQL> @/tmp/NEWTEST.ctl
SQL> alter database open resetlogs;
SQL> ALTER TABLESPACE TEMP ADD TEMPFILE '/u02/NEWTEST/temp01.dbf' SIZE 500M reuse autoextend on maxsize 10G;
SQL> create spfile from memory;
```

### Lets do startup test
```
SQL> shutdown immediate;
SQL> startup;
```

### Create and modify existing listener
```
[<TEST>oracle@testdb u02]$ cd /u01/app/oracle/product/12.2.0.1/db_1/network/admin
 
[<TEST>oracle@testdb admin]$ cat listener.ora
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1522))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1522))
    )
  )
 
### [<TEST>oracle@testdb admin]$ cat tnsnames.ora
# tnsnames.ora Network Configuration File: /u01/app/oracle/product/12.2.0.1/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.
 
TEST =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1522))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = TEST)
    )
  )

```

### To this:
```
[<TEST>oracle@testdb admin]$ cat *.ora
TEST =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
      (CONNECT_DATA = (SERVICE_NAME = TEST))
    )
  )
NEWTEST =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1522))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1522))
      (CONNECT_DATA = (SERVICE_NAME = NEWTEST))
    )
  )
# tnsnames.ora Network Configuration File: /u01/app/oracle/product/12.2.0.1/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.
 
TEST =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = TEST)
    )
  )
 
LISTENER_TEST =
  (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1521))
 
 
NEWTEST =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1522))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = NEWTEST)
    )
  )
 
LISTENER_NEWTEST =
  (ADDRESS = (PROTOCOL = TCP)(HOST = testdb)(PORT = 1522))
```
#### Restart and Start listener
```
[<TEST>oracle@testdb admin]$ lsnrctl stop
[<TEST>oracle@testdb admin]$ lsnrctl start
  
[<TEST>oracle@testdb admin]$ lsnrctl start NEWTEST_TEST
```

### Add to Oratab
```
NEWTESTNEWTEST:/u01/app/oracle/product/12.2.0.1/db_1:N
```
### Reset password and lock user that are unknown
```
ALTER USER SQLTEST ACCOUNT LOCK;

```

