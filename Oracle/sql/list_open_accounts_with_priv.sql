--LIST open accounts by privilege "CREATE ANY DIRECTORY" 
SELECT d.username, p.privilege, d.account_status
FROM dba_users d, dba_sys_privs p
WHERE d.username = p.grantee 
and p.privilege = 'CREATE ANY DIRECTORY'
and  d.account_status = 'OPEN'
ORDER BY d.username, p.privilege;