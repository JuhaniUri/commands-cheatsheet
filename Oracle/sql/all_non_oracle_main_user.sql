select * from dba_tables where owner in 
 (select username from all_users where oracle_maintained = 'N')

