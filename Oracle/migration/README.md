# Migration from one database server to another


### Pre-checks

- [ ] **Know your source database**
  - [ ] OS
  - [ ] Edian
  - [ ] Size
  - [ ] Version
  - [ ] Enabled extras 


```
select * from v$database;
select * from dba_data_files;
select * from NLS_DATABASE_PARAMETERS;
select * from V$PARAMETER;
select * from v$option;
select * from dba_registry;
```


- [ ] **Choose your strategy**
  - [ ] RMAN
  - [ ] Datapump 

- [ ] **Always use md5sum take hash transfering files** 



<br/>
<br/>


### Check that you are in right db


### Check invalid objects before (can be skipped in case of only DML).

### Do your changes 



### Check invalid count

### Compile if needed
```
EXEC DBMS_UTILITY.COMPILE_SCHEMA( schema => 'USER', compile_all => FALSE);
```