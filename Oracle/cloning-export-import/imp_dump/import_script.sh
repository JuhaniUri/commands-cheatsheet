#!/bin/bash
######################################################################################
#prep
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'
#variables
IMPDIR=/u02/dump/
PARFILE=/home/oracle/imp_dump/imp.par
c_date=$(date +"%G-%m-%d")
IMPLOG=$IMPDIR/$1$c_date.log
source /home/oracle/.bash_profile
######################################################################################

ORACLE_SID=$1
DUMPFILE=$2


function usage(){
  echo "USAGE:
	    Parameter 1 is the SID of the database where you want to import
	    Parameter 2 is the DUMPFILE NAME"
	   }

if [ $# -lt 2 ]; then
	usage
	exit 1
fi

######################################################################################
START_TIME=`date`
export ORACLE_SID=$1

#sqlplus /nolog @test.sql

sqlplus /nolog @drop_old.sql

impdp userid=\'/ as sysdba\' FULL=Y PARFILE=$PARFILE DIRECTORY=IMPDIR DUMPFILE=$DUMPFILE LOGFILE=import.log

sqlplus /nolog @run_scramble_and_compile.sql


######################################################################################

echo "#########################################################################################"
echo $END_MESSAGE
echo "# Start time : $START_TIME "
echo "# End time   : `date`"
echo "#########################################################################################"