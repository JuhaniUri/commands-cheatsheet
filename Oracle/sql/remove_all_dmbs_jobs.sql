BEGIN
  FOR x IN (SELECT * FROM user_jobs)
  LOOP
    dbms_job.remove(x.job);
  END LOOP;
END;
/
