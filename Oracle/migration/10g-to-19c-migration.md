# Oracle 10g to 19c migration

## Know your source database**
  - [ ] OS
  - [ ] Edian
  - [ ] Size
  - [ ] Version
  - [ ] Enabled extras


## Install Oracle 19c
Follow automatic installation: https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8


## Create database
- [ ] Create empty with dbca
- [ ] Add tablespaces and datafiles
- [ ] Register listener
- [ ] Check startup setting (oratab)


## Migration

### Enable restricted mode and kick active users out.
```
alter system enable restricted session;
```

### Check the estimate size
```
expdp userid=\'/ as sysdba\' FULL=Y  DIRECTORY=DUMPDIR estimate_only=y
```

### Export from source (10g)
```
expdp userid=\'/ as sysdba\' FULL=Y  DIRECTORY=DUMPDIR DUMPFILE=full_2024_02%U FILESIZE=5G
```

### Copy to new server
```
scp /u03/full_2024_02* oracle@10.20.30.40:/u03/
```

### All next steps are done new server Oracle 19

### Create import dir
```
create directory IMPDIR as '/u03';
```

### Create par file
[Check here](exclude.par)

### Import
```
$ impdp system@dbname DIRECTORY=IMPDIR PARFILE=exclude.par DUMPFILE=full_2024_02%U logfile=full_import.log
```

### Compile
```
SQL> @?/rdbms/admin/utlrp.sql
```

### Review
```
SELECT owner, object_type, object_name, status
FROM dba_objects
WHERE status = 'INVALID'
ORDER BY owner, object_type, object_name;
```

### Enable archivelog mode
```
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
ARCHIVE LOG LIST;
```

### Check FRA settings
```
show parameter db_recovery_file
```

### Change FRA size
```
alter system set db_recovery_file_dest_size=200g scope=both;
```

### Set location
```
alter system set db_recovery_file_dest='/u03/flash_recovery_area/' scope=both;
```

### Set Force logging
```
ALTER DATABASE FORCE LOGGING;
```

### Unlock application for users account


### Run full backup after success testing