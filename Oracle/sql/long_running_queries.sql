SELECT count(sid) \
  FROM gv$session \
WHERE username      IS NOT NULL \
AND NVL(osuser,'x') <> 'SYSTEM' \
AND type            <> 'BACKGROUND' \
AND status           = 'ACTIVE' \
AND last_call_et > 3600
