# User and role setups for Oracle 
- [User and role setups for Oracle](#user-and-role-setups-for-oracle)
  - [Profiles](#profiles)
    - [Starting point for profiles](#starting-point-for-profiles)
  - [Roles](#roles)
    - [Password-protected role](#password-protected-role)
    - [Oracle database role-related MOS notes:](#oracle-database-role-related-mos-notes)
    - [Examples](#examples)
      - [Readonly role example in with daily update job](#readonly-role-example-in-with-daily-update-job)
        - [Create role](#create-role)
        - [Create daily job](#create-daily-job)
        - [Grant access to role](#grant-access-to-role)
      - [Create a readonly role](#create-a-readonly-role)
        - [Create role](#create-role-1)
        - [Grant select and debug](#grant-select-and-debug)
      - [Oracle profile and change the password lifetime limit](#oracle-profile-and-change-the-password-lifetime-limit)
        - [1. List users](#1-list-users)
        - [2. For showing the specific profiles property](#2-for-showing-the-specific-profiles-property)
        - [3. Allow users to keep their password forever](#3-allow-users-to-keep-their-password-forever)
        - [4. Verify](#4-verify)


## Profiles
### Starting point for profiles

|                           | User account                  | Service account               |
|---------------------------|-------------------------------|-------------------------------|
| SESSIONS_PER_USER         | 2                             | Depends on use case           |
| CONNECT_TIME              | 480 (minutes)                 | unlimited                     |
| IDLE_TIME                 | 30 (minutes)                  | unlimited                     |
|                           |                               |                               |
| CPU_PER_SESSION           | unlimited                     | unlimited                     |
| CPU_PER_CALL              | unlimited                     | unlimited                     |
| LOGICAL_READS_PER_SESSION | unlimited                     | unlimited                     |
| LOGICAL_READS_PER_CALL    | unlimited                     | unlimited                     |
| PRIVATE_SGA               | unlimited                     | unlimited                     |
| COMPOSITE_LIMIT           | unlimited                     | unlimited                     |
|                           |                               |                               |
| FAILED_LOGIN_ATTEMPTS     | 5                             | 3                             |
| PASSWORD_LIFE_TIME        | 90 (days)                     | unlimited                     |
| PASSWORD_REUSE_TIME       | unlimited                     | unlimited                     |
| PASSWORD_REUSE_MAX        | 20                            | 20                            |
| PASSWORD_LOCK_TIME        | 1 hour (60/1440)              | 1 day                         |
| PASSWORD_GRACE_TIME       | unlimited                     | unlimited                     |
| INACTIVE_ACCOUNT_TIME     | 30 (days)                     | 30 (days)                     |
| PASSWORD_VERIFY_FUNCTION  | ORA12C_STRONG_VERIFY_FUNCTION | ORA12C_STRONG_VERIFY_FUNCTION |
| PASSWORD_ROLLOVER_TIME    | -1                            | 3 (days)                      |

## Roles


### Password-protected role

### Oracle database role-related MOS notes:
- Primary Note For Privileges And Roles (Doc ID 1347470.1)
- Enabling, Disabling, and Granting Default Roles (Doc ID 1079975.6)
- All About Security: User, Privilege, Role, SYSDBA, O/S Authentication, Audit, Encryption, OLS, Database Vault, Audit Vault (Doc ID 207959.1)
- PUBLIC : Is it a User, a Role, a User Group, a Privilege ? (Doc ID 234551.1)
- Invokers Rights Procedure Executed by Definers Rights Procedures (Doc ID 162489.1)
- Be Cautious When Revoking Privileges Granted to PUBLIC (Doc ID 247093.1)


### Examples

#### Readonly role example in with daily update job 

##### Create role
```
CREATE ROLE DEVELOPER_READ_ONLY;
GRANT CREATE SESSION TO DEVELOPER_READ_ONLY;
```
##### Create daily job
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
##### Grant access to role
```
GRANT DEVELOPER_READ_ONLY TO USER;
```

#### Create a readonly role 

##### Create role
```
CREATE ROLE READ_ONLY;
```
##### Grant select and debug
```
BEGIN
  FOR t IN (SELECT object_name, object_type, owner FROM all_objects WHERE OWNER in ('SCHEMA1', 'SCHEMA2', 'SCHEMA3')  AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE', 'PACKAGE BODY')) LOOP
    IF t.object_type IN ('TABLE', 'VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT ON '||t.owner||'.'||t.object_name||' TO READ_ONLY';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY') THEN
      EXECUTE IMMEDIATE 'GRANT DEBUG ON '||t.owner||'.'||t.object_name||' TO READ_ONLY';
    END IF;
  END LOOP;
END;
```


#### Oracle profile and change the password lifetime limit

##### 1. List users
```
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
```

##### 2. For showing the specific profiles property
```
select * from dba_profiles where profile='DEFAULT';
```

##### 3. Allow users to keep their password forever
```
alter profile "DEFAULT" limit password_life_time unlimited;
```

##### 4. Verify 
```
select * from dba_profiles where profile='DEFAULT';
```



