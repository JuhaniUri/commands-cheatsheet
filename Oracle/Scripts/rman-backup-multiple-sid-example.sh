#!/bin/bash
######################################################################################
#Cariables
export NLS_DATE_FORMAT="dd-mm-yyyy hh:mm:ss"
rmanzabbix=/tmp/ORAbackupstatus
SID="EE LV LT"

#Colors to script
ok=$(printf "\e[1;31;32m%-10s\e[00m" "[OK]")
fail=$(printf "\e[1;31;31m%-10s\e[00m" "[FAIL]")


#Variables for 2nd backup
ctfile=/orabackup/flash_recovery_area/$dbname/autobackup/$date/
backupfile=/orabackup/flash_recovery_area/$dbname/backupset/$date/
destctfolder=/2ndbackup/LIVE/orabackup/flash_recovery_area/$dbname/autobackup/
destbackupfolder=/2ndbackup/LIVE/orabackup/flash_recovery_area/$dbname/backupset/
archlog=/orabackup/flash_recovery_area/$dbname/archivelog/$date/
destarchlog=/2ndbackup/LIVE/orabackup/flash_recovery_area/$dbname/archivelog/

################################# Full or Incremental backup #################################
case "$1" in
  FULL | INCR)
    type=$1
  ;;
  bacula)
    if [ $(date \+\%u) = 7 ];
      then type="FULL"
    else
      type="INCR"
    fi
  ;;
  *)
    echo "usage: $0 (INCR|FULL)"
  ;;
esac
######################################################################################

case "$type" in

INCR)

for i in $SID
do
echo $date $time "STARTING: Incremental backup for database $i"
export ORACLE_SID=$i

rman target /' <<!
run {
ALLOCATE CHANNEL RMAN_BACK_CH01 TYPE DISK;
CROSSCHECK BACKUP;
BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 TAG = 'rman_L1_incr_${date}' DATBASE;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL FORMAT 'rman_arch_%d_%u_%s_%T' DELETE INPUT;
BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE FORMAT 'rman_ctrl_%d_%u_%s_%T';
BACKUP AS COMPRESSED BACKUPSET SPFILE FORMAT 'rman_spfile_%d_%u_%s_%T';
CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
RELEASE CHANNEL RMAN_BACK_CH01;
}
!
echo "FINISHED: INCREMENTAL backup for database $i"
done
;;

######################################################################################

FULL)

for i in $SID
do
echo $date $time "STARTING: Full backup for database $i"
export ORACLE_SID=$i

rman target /' <<!
run {
ALLOCATE CHANNEL RMAN_BACK_CH01 TYPE DISK;
CROSSCHECK BACKUP;
BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 0 TAG = 'rman_L0_full_${date}' DATBASE;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL FORMAT 'rman_arch_%d_%u_%s_%T' DELETE INPUT;
BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE FORMAT 'rman_ctrl_%d_%u_%s_%T';
BACKUP AS COMPRESSED BACKUPSET current SPFILE FORMAT 'rman_spfile_%d_%u_%s_%T';
CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
RELEASE CHANNEL RMAN_BACK_CH01;
}
!
echo "FINISHED: Full backup for database $i"
done
;;

################## Copy backups to another disk  ################
# Note. This quite old example. One could do this with rsync or smth else

#    if
#        cp -ra $ctfile $destctfolder && cp -ra $backupfile $destbackupfolder && chmod -R 755 /2ndbackup/LIVE/orabackup/flash_recovery_area/$ORACLE_SID
#    then
#        echo $date $time "arhiveerimine:" $ok
#    else
#        echo $date $time "arhiveerimine:" $fail
#    fi
#;;

############################################################################
############################################################################
*)
     echo "usage: $0 (INCR|FULL)"
;;
############################################################################
esac
