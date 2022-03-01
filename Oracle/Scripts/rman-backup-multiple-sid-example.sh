#!/bin/bash
######################################################################################
#Prep
#CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
#CONFIGURE CHANNEL DEVICE TYPE DISK MAXPIECESIZE 5 G;
#CONFIGURE CONTROLFILE AUTOBACKUP OFF;
#Variables
SID="E1 L1 L2"
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'


. /home/oracle/.bash_profile
# Check is process is already running.
# If lock file already exists exit.
LOCK_FILE=/tmp/orabackup.lock
if [ -e $LOCK_FILE ]
then
  echo "backup already running"
  exit 0;
fi
# Create a lock file containing the current
# process id to prevent other tests from running.
echo $$ > $LOCK_FILE

######################################################################################

case "$1" in

arch)
for i in $SID
do
echo "STARTING: Redolog switch  $i"
export ORACLE_SID=$i


rman target=/ << EOF
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL TAG = 'ARCH' DELETE INPUT;
EXIT;
EOF
done
;;


############################################################################

full)
for i in $SID
do
echo "STARTING: Full backup for database $i"
export ORACLE_SID=$i

rman target=/ << EOF
CROSSCHECK BACKUP;
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
BACKUP INCREMENTAL LEVEL 0 TAG = 'rman_L0_full' DATABASE;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE INPUT;
BACKUP AS COMPRESSED BACKUPSET SPFILE;
BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE;
CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
EXIT;
EOF
done
;;


############################################################################
incr)
for i in $SID
do
echo "STARTING: Incremental backup for database $i"
export ORACLE_SID=$i

rman target=/ << EOF
CROSSCHECK BACKUP;
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 TAG = 'rman_L1_incr' DATABASE;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE INPUT;
BACKUP AS COMPRESSED BACKUPSET SPFILE;
BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE;
CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
EXIT;
EOF
done
;;
############################################################################
*)
     echo "usage: $0 (arch|full|incr)"
;;
############################################################################
esac
rm -f $LOCK_FILE