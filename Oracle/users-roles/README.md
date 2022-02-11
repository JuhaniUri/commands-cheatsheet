# User and role setups for Oracle 
- [User and role setups for Oracle](#user-and-role-setups-for-oracle)
  - [Developer role](#developer-role)
    - [Create role](#create-role)
    - [Create daily job](#create-daily-job)
    - [Grant access to role](#grant-access-to-role)
  - [Oracle profile and change the password lifetime limit](#oracle-profile-and-change-the-password-lifetime-limit)
    - [1. Check view users:](#1-check-view-users)
    - [2. For showing the specific profiles property](#2-for-showing-the-specific-profiles-property)
    - [3. Allow users to keep their password forever:](#3-allow-users-to-keep-their-password-forever)
    - [4. Verify](#4-verify)

## Developer role
### Create role
```
CREATE ROLE DEVELOPER_READ_ONLY;
GRANT CREATE SESSION TO DEVELOPER_READ_ONLY;
```

### Create daily job
```
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"SYSTEM"."REFRESH_ACCESS_TO_DEVELOPER_READ_ONLY"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
  FOR t IN (SELECT object_name, object_type, owner FROM all_objects WHERE OWNER in (''SC1'', ''SC2'')  AND object_type IN (''TABLE'',''VIEW'',''PROCEDURE'',''FUNCTION'',''PACKAGE'',''SEQUENCE'')) LOOP
    IF t.object_type IN (''TABLE'',''VIEW'',''SEQUENCE'') THEN
      EXECUTE IMMEDIATE ''GRANT SELECT ON ''||t.owner||''.''||t.object_name||'' TO DEVELOPER_READ_ONLY'';
    ELSIF t.object_type IN (''PROCEDURE'',''FUNCTION'',''PACKAGE'') THEN
      EXECUTE IMMEDIATE ''GRANT DEBUG ON ''||t.owner||''.''||t.object_name||'' TO DEVELOPER_READ_ONLY'';
    END IF;
  END LOOP;
END;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=DAILY',
            end_date => NULL,
            enabled => TRUE,
            auto_drop => FALSE,
            comments => 'Access for developers');
         
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"SYSTEM"."REFRESH_ACCESS_TO_DEVELOPER_READ_ONLY"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"SYSTEM"."REFRESH_ACCESS_TO_DEVELOPER_READ_ONLY"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
  
    
END;
```
### Grant access to role
```
GRANT DEVELOPER_READ_ONLY TO USER;
```


## Oracle profile and change the password lifetime limit

### 1. List users
```
SET LINESIZE 200 VERIFY OFF

COLUMN username FORMAT A20
COLUMN account_status FORMAT A16
COLUMN default_tablespace FORMAT A15
COLUMN temporary_tablespace FORMAT A15
COLUMN profile FORMAT A15

SELECT username,
       account_status,
       TO_CHAR(lock_date, 'DD-MON-YYYY') AS lock_date,
       TO_CHAR(expiry_date, 'DD-MON-YYYY') AS expiry_date,
       default_tablespace,
       temporary_tablespace,
       TO_CHAR(created, 'DD-MON-YYYY') AS created,
       profile,
       authentication_type
FROM   dba_users
WHERE  username LIKE UPPER('%&1%')
ORDER BY username;

SET VERIFY ON
```

### 2. For showing the specific profiles property
```
select * from dba_profiles where profile='DEFAULT';
```

### 3. Allow users to keep their password forever
```
alter profile "DEFAULT" limit password_life_time unlimited;
```

### 4. Verify 
```
select * from dba_profiles where profile='DEFAULT';
```