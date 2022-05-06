-- Update all sequences
DECLARE
  v_increase_by                     NUMBER;
v_bkp_increment_by            NUMBER;
  v_str                         VARCHAR2 (1000);
  v_count                       NUMBER;
BEGIN
  v_increase_by                  := 2000;

  FOR rec IN (SELECT *
              FROM   user_sequences) LOOP
    -- Backup current incrementation number
    v_bkp_increment_by         := rec.increment_by;
    -- Alter the sequence to increase by a defined amount
    v_str                      := 'alter sequence ' || rec.sequence_name || ' increment by ' || v_increase_by;

    EXECUTE IMMEDIATE v_str;

    -- Increase by that amount
    v_str                      := 'select ' || rec.sequence_name || '.nextval from dual';

    EXECUTE IMMEDIATE v_str
    INTO              v_count;

    -- Reset the increment factor
    v_str                      := 'alter sequence ' || rec.sequence_name || ' increment by ' || v_bkp_increment_by;

  EXECUTE IMMEDIATE v_str;
  END LOOP;
END;
/
