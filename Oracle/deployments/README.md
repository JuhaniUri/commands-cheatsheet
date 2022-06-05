# Deployment and scripts best practices

If possible use some version control software your database like Liquibase
https://www.liquibase.org/

In case that is not possible, try to follow these steps:

## Structure your scripts

### SQLplus and master script

masterscript.sql
```
set serveroutput on
set define off

spool install.log
prompt Start

@\test1.tables.sql;
@\test1.functions.sql;
@\test1.procedures.sql;
@\test1.package.pck;
@\test1.views.sql;

prompt db compile
@\compile.sql;

prompt End
spool off
```


### Individual files changes by numbers for execution

Script namiming (number, type, name)

1_PKG_MANAGE.sql
2_PKG_MANAGE_BODY.sql
3_classes.sql
4_update_test_view.sql


### Lot of changes DML in one file 
User sqlerror exit

Example
```
whenever sqlerror exit failure;
insert into test1.name ...
update test1.name ...
commit;
insert into test1.name ...
commit;
```

### Extentsions for files

.pks - Package Spec
.pkb - Package Body
.pck - Package with Spec and Body
.sql - Everyrhing else




## Deployment  best practices

### Manual deployment pre-checks

- [ ] **Check the space on tablespaces and storage (in case large updates)** 

- [ ] **In case of lot of DML use this in header, this will stop script in case of statment error.** 
https://docs.oracle.com/en/database/oracle/oracle-database/19/sqpug/WHENEVER-SQLERROR.html#GUID-66C1C12C-5E95-4440-A37B-7CCE7E33491C
```
WHENEVER SQLERROR EXIT SQL.SQLCODE
```

- [ ] **Make backups for faster recovery** 

    a) go with expdp 
    ```
    expdp system/** TABLES=schema1.table1, schema1.table2 DIRECTORY=dumpdir DUMPFILE=pre-deploy-export-date.dmp
    ```

    b) go with CTAS
    ```
    SQL> CREATE TABLE emp_backup AS SELECT * FROM emp;
    Table created.
    ```

Note check the table size beforehand!
Remeber to cleanup once you are done.

- [ ] **What user should be used for deploying? Are schemas prefix in place?** 


<br/>
<br/>


### Check that you are in right db
```
SELECT sys_context('userenv', 'instance_name') FROM dual;
```


### Check invalid objects before (can be skipped in case of only DML).

```
SELECT owner, object_type, object_name, status
FROM dba_objects
WHERE status = 'INVALID'
ORDER BY owner, object_type, object_name;
```

### Do your changes 


### Check invalid count

### Compile if needed
```
EXEC DBMS_UTILITY.COMPILE_SCHEMA( schema => 'USER', compile_all => FALSE);
```