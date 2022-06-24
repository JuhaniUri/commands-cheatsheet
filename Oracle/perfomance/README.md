# Perfomance related topics

## Trace
```
EXEC DBMS_MONITOR.client_id_trace_enable(client_id=>'TEST', waits=>TRUE, binds=>TRUE);
EXEC DBMS_MONITOR.client_id_trace_disable(client_id=>'TEST');
```

```
EXEC DBMS_MONITOR.session_trace_enable(session_id => 191, serial_num=>37401, waits=>TRUE, binds=>TRUE);
EXEC DBMS_MONITOR.session_trace_disable(session_id =>191, serial_num=>37401);
```



### Trace whole database and get explain plan


```
SQL> ALTER SYSTEM SET sql_trace = true SCOPE=MEMORY;
SQL> ALTER SYSTEM SET sql_trace = false SCOPE=MEMORY;
$ tkprof eeuat_ora_11894.trc eeuat_ora_11894.prf EXPLAIN=user/***@eeuat SYS=NO
```


## Shared pool


### Flush the whole shared_pool
```
SQL>alter system flush shared_pool;
```

### Flush for one statement

```
SQL> select ADDRESS, HASH_VALUE from V$SQLAREA where SQL_ID like '7yc%';

ADDRESS 	 HASH_VALUE
---------------- ----------
000000085FD77CF0  808321886

SQL> exec DBMS_SHARED_POOL.PURGE ('000000085FD77CF0, 808321886', 'C');

PL/SQL procedure successfully completed.

SQL> select ADDRESS, HASH_VALUE from V$SQLAREA where SQL_ID like '7yc%';

no rows selected

```
Note to Oracle 10g R2 Customers
The enhanced DBMS_SHARED_POOL package with the PURGE procedure is included in the 10.2.0.4 patchset release.
10.2.0.2 and 10.2.0.3 customers can download and install RDBMS patch 5614566 to get access to these enhancements in DBMS_SHARED_POOL package.

## Logs

### 
