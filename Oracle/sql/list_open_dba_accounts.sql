--LIST open DBA accounts
SELECT d.username, r.granted_role, d.account_status
FROM dba_users d, dba_role_privs r
WHERE d.username = r.grantee 
and r.granted_role = 'DBA'
and  d.account_status = 'OPEN'
ORDER BY d.username, r.granted_role;
