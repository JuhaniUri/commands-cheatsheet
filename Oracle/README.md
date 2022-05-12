# General & Daily tasks

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
## Tablespaces and datafiles
### Add datafile to TABLESPACE
```
ALTER TABLESPACE DAT1 ADD datafile '/u02/TEST/DAT1_05.dbf' size 1G autoextend on next 1G MAXSIZE 20G;
ALTER TABLESPACE DAT1 ADD datafile '/u02/TEST/DAT1_06.dbf' size 1G autoextend on next 1G MAXSIZE 20G;
```
### Resize datafile
```
ALTER DATABASE datafile '/u02/TEST/DAT1_01.dbf' AUTOEXTEND ON next 512m  maxsize 10G;
```