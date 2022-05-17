select output
from v$rman_output
where session_recid in (select session_recid from v$rman_status
where start_time > sysdate-1)
order by recid ;
