# Oracle Database migration with RMAN and NFS share


### Migration test run with RMAN:

```
mkdir /nfs
mount <IP>:/nfs /nfs
mkdir –p /nfs/<SID>/DB
chown oracle:dba /nfs/<SID>/DB
mkdir –o /nfs/<SID>/ARCH
chown oracle:dba /nfs/<SID>/ARCH
```

### Test run initial transfer stage:
ALTER SYSTEM ARCHIVE LOG CURRENT;
rman target / << EOF
backup incremental level 0 as copy format '/nfs/eeprd/db/%U' database;
EOF


### Test run refresh transfer stage:  
rman target / <<EOF
backup  incremental level 1 for recover of copy database;
recover copy of database;
backup as copy current controlfile format ‘/nfs/eeprd/db/%U’;
EOF
(Assuming there is sufficient space in fast recovery area for incremental backup).
Test run post test run stage:
As oracle user:
sqlplus / as sysdba << EOF
ALTER SYSTEM ARCHIVE LOG CURRENT
EOF

Transfer all archivelog’s of incremental backup execution period (+1 at beginning and end).
As root user:
unmount /nfs
As Oracle user
Clear information about test run related image copies.
Migration real run:
 Real run preparation stage:
  As root:
mount <TEOHOST>:/nfs /nfs
mkdir –p /nfs/<SID>/DB
chown oracle:dba /nfs/<SID>/DB
mkdir –o /nfs/<SID>/ARCH
chown oracle:dba /nfs/<SID>/ARCH

 Real run initial transfer stage:
  As oracle user:
rman target / << EOF
backup incremental level 0 as copy format ‘/nfs /<SID>/DB/%U’ database;
EOF
(Assuming default device type is disk)

Real run refresh transfer stage (by request, possibly optional):  
As oracle user:
rman target / <<EOF
backup  incremental level 1 for recover of copy database;
recover copy of database;
EOF
(Assuming there is sufficient space in fast recovery area for incremental backup).
Real run final refresh stage:
As oracle user:
sqlplus / as sysdba << EOF
shutdown immediate;
startup mount;
EOF
rman target / <<EOF
backup  incremental level 1 for recover of copy database;
recover copy of database;
backup as copy current controlfile format ‘/nfs/<SID>/DB/%U’;
EOF
As root user:
unmount /nfs


