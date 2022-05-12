# Deployment best practice

```
SELECT
    sys_context('userenv', 'instance_name')
FROM
    dual;
```


### Check invalid objects before (can be skipped in case of only DML).

```
SELECT
    owner,
    object_type,
    object_name,
    status
FROM
    dba_objects
WHERE
    status = 'INVALID'
ORDER BY
    owner,
    object_type,
    object_name;
```

### Do changes 



### Check invalid count

### Compile if needed
```
EXEC DBMS_UTILITY.COMPILE_SCHEMA( schema => 'USER', compile_all => FALSE);
```