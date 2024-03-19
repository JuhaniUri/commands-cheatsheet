#!/bin/bash
######################################################################################
#Variables
SID="eeprod1 lvprod1 ltprod1"
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'

# Oracle Env
. /home/oracle/scripts/setEnv.sh

# Check is process is already running. If lock file already exists exit.
LOCK_FILE=/tmp/orabackup.lock
if [ -e $LOCK_FILE ]
then
  echo "backup already running"
  exit 0
fi
# Create a lock file containing the current
# process id to prevent other tests from running.
echo $$ > $LOCK_FILE

######################################################################################
# Create root container backup
rman target=/ << EOF
CONFIGURE RETENTION POLICY TO REDUNDANCY 1;
CROSSCHECK BACKUP;
BACKUP DATABASE;
BACKUP SPFILE;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
EXIT;
EOF

for i in $SID
do
echo "STARTING: Full backup for database $i"
export ORACLE_PDB_SID=$i

rman target=/ << EOF
BACKUP AS COMPRESSED BACKUPSET DATABASE format '/u03/backups/full_bkp_%n%d%U';
BACKUP CURRENT CONTROLFILE format '/u03/backups/ctl_bkp_%n%d%U';
EXIT;
EOF
done



############################################################################

rm -f $LOCK_FILE