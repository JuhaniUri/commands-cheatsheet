# SQLplus 


## Formating
```
SET pagesize 2000
SET LONG 10000
SET linesize 1000
COLUMN last_name format a20
COLUMN total format 999,999,999
SET feedback ON
```

## Connect with SQLplus (tested with Oracle client 12.2)

### Connect core or pdb db with password manually (preferred):
```
sqlplus system@\"localhost:1521/ORCLCDB\"
```

### Connect core or pdb db with password in command:
```
sqlplus system/*******@localhost:1521/ORCLCDB
```
