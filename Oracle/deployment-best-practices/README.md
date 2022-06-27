# Deployment best practices

If possible use some version control software for database like Liquibase
https://www.liquibase.org/


## Deployment best practices

### Manual deployment pre-checks

1\. Check free space on tablespaces and storage

2\. What user should be used for deploying? Are schemas prefix in place?

3\. In case of lot of DML use this in header, this will stop script in case of statment error
https://docs.oracle.com/en/database/oracle/oracle-database/19/sqpug/WHENEVER-SQLERROR.html#GUID-66C1C12C-5E95-4440-A37B-7CCE7E33491C
```
WHENEVER SQLERROR EXIT SQL.SQLCODE
```
4\. Make additional backups for recovery
    
    4.1\. Datapump (expdp) 
    ```
    expdp system/** TABLES=schema1.table1, schema1.table2 DIRECTORY=dumpdir DUMPFILE=pre-deploy-export-date.dmp
    ```

    4.2\. CTAS
    ```
    SQL> CREATE TABLE emp_backup AS SELECT * FROM emp;
    Table created.
    ```

Note check the table size beforehand!
Remeber to cleanup once you are done.


5\. Check that you are in right db
```
SELECT sys_context('userenv', 'instance_name') FROM dual;
```

6\. Check invalid objects before (can be skipped in case of only DML).

```
SELECT owner, object_type, object_name, status
FROM dba_objects
WHERE status = 'INVALID'
ORDER BY owner, object_type, object_name;
```

7\. Do changes/deployment
Note when deploying PL/SQL with SQLdeveloper do this:
set define off;


8\. Check invalid count

9\. Compile if needed
```
EXEC DBMS_UTILITY.COMPILE_SCHEMA( schema => 'USER', compile_all => FALSE);
```
