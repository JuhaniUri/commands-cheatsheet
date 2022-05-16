#!/bin/sh
ARH_PATH=/orabackup/export
dateofexp=`date +%Y%m%d`
 
#Backup database
 
ORACLE_SID=hbeeprod
echo "create or replace directory BACKUP_DIR as  '/orabackup/export';" | sqlplus / as sysdba
echo "create or replace directory BACKUP_LOG_DIR as  '/orabackup/export';" | sqlplus / as sysdba
expdp userid=\'/ as sysdba\' FULL=Y directory=BACKUP_DIR DUMPFILE=$dateofexp-hbeeprod.dmp logfile=$dateofexp-hbeeprod.log
 
ORACLE_SID=hblvprod
echo "create or replace directory BACKUP_DIR as  '/orabackup/export';" | sqlplus / as sysdba
echo "create or replace directory BACKUP_LOG_DIR as  '/orabackup/export';" | sqlplus / as sysdba
expdp userid=\'/ as sysdba\' FULL=Y directory=BACKUP_DIR DUMPFILE=$dateofexp-hblvprod.dmp logfile=$dateofexp-hblvprod.log
 
ORACLE_SID=hbltprod
echo "create or replace directory BACKUP_DIR as  '/orabackup/export';" | sqlplus / as sysdba
echo "create or replace directory BACKUP_LOG_DIR as  '/orabackup/export';" | sqlplus / as sysdba
expdp userid=\'/ as sysdba\' FULL=Y directory=BACKUP_DIR DUMPFILE=$dateofexp-hbltprod.dmp logfile=$dateofexp-hbltprod.log
 
# delete old databases
/usr/bin/find $ARH_PATH -type f -name '*.dmp' -o -name '*.log' -mtime +30 -exec rm {} \;
 
