# User and role setups for Oracle 


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

