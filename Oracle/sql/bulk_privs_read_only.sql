BEGIN
  FOR t IN (SELECT object_name, object_type, owner FROM all_objects WHERE OWNER in ('EP_ANDMED', 'EP_ADMIN', 'EP_STAT')  AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE', 'PACKAGE BODY')) LOOP
    IF t.object_type IN ('TABLE', 'VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT ON '||t.owner||'.'||t.object_name||' TO READ_ONLY';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY') THEN
      EXECUTE IMMEDIATE 'GRANT DEBUG ON '||t.owner||'.'||t.object_name||' TO READ_ONLY';
    END IF;
  END LOOP;
END;
