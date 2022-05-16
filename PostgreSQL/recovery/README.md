# Recovery 

### Recovery to latest 
The recovery.conf file must be placed on /var/vcap/store/postgresqlXX/recovery.conf with the following content:

```
pg:/var/vcap/store/postgresql-restore# vi /var/vcap/store/postgresql11/recovery.conf
recovery_target_timeline = 'latest'
restore_command = 'cp /var/vcap/store/postgresql-restore/%f %p'
recovery_target_action = 'promote' # If using PostgreSQL 10 or 11
```

### Point-in-time recovery (PITR) option
You need to set recovery_target_time like this in  /var/vcap/store/postgresqlXX/recovery.conf 

```
recovery_target_time = '2022-01-24 11:46:00 UTC'
restore_command = 'cp /var/vcap/store/postgresql-restore/%f %p'
recovery_target_action = 'promote' # If using PostgreSQL 10 or 11
```

