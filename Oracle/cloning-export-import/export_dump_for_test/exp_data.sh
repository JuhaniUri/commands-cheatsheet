#!/bin/bash
######################################################################################
#prep
#variables
SID="DB1 DB2 DB3"
DUMPDIR=/orabackup
c_date=$(date +"%G-%m-%d")
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'
source /home/oracle/.bash_profile

######################################################################################

# Check is process is already running.
# If lock file already exists exit.
LOCK_FILE=/tmp/oraexpdp.lock
if [ -e $LOCK_FILE ]
then
  echo "export already running"
  exit 0;
fi
# Create a lock file containing the current
# process id to prevent other tests from running.
echo $$ > $LOCK_FILE

######################################################################################

for i in $SID
do
echo "STARTING: EXPORT for $i"
export ORACLE_SID=$i

echo "CREATE OR REPLACE DIRECTORY dumpdir AS '$DUMPDIR';"| sqlplus -S "/ as sysdba" && expdp userid=\'/ as sysdba\' full=y parfile=exp_small.par DUMPFILE="${i}-${c_date}".dmp LOGFILE="${i}-${c_date}".log
done
######################################################################################
echo "Remove LOCKFILE"
rm -f $LOCK_FILE
######################################################################################
