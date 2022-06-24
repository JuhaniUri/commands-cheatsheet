# Notes when migrating database server


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


