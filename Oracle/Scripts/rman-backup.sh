#!/bin/bash
######################################################################################
#Variables
SID=TEST
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'


######################################################################################
case "$1" in

arch)
echo "STARTING: Redolog switch  $i"
export ORACLE_SID=$SID


rman target=/ << EOF
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
EXIT;
EOF
;;


############################################################################
full)
echo "STARTING: Full backup for database $i"
export ORACLE_SID=$SID


rman target=/ << EOF
#configure retention policy to redundancy 2;
delete noprompt backup COMPLETED BEFORE 'SYSDATE-13' DEVICE TYPE DISK;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 14 DAYS;
configure controlfile autobackup on;
CROSSCHECK BACKUP;
BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 0 TAG = 'rman_L0_full' DATABASE;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup archivelog all not backed up delete input;
CROSSCHECK BACKUP;
delete noprompt obsolete device type disk;
EXIT;
EOF
;;

############################################################################
incr)

echo "STARTING: Incremental backup for database $i"
export ORACLE_SID=$SID

rman target=/ << EOF
#configure retention policy to redundancy 2;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 14 DAYS;
delete noprompt backup COMPLETED BEFORE 'SYSDATE-14' DEVICE TYPE DISK;
configure controlfile autobackup on;
CROSSCHECK BACKUP;
BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 TAG = 'rman_L1_incr' DATABASE;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup archivelog all not backed up delete input;
CROSSCHECK BACKUP;
delete noprompt obsolete device type disk;
EXIT;
EOF
;;
############################################################################
*)
     echo "usage: $0 (arch|full|incr)"
;;
############################################################################
esac
