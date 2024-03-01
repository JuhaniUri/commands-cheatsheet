# Purge ADR contents (adr-purge.sh)
# 00 05 * * 0 adr-purge.sh
# Add the above line with `crontab -e` to the oracle user's cron
# Link to author: https://tuxrootsite.wordpress.com/2018/02/02/oracle-adrci-cleanup-script/

ALERT_RET="129600" # 90 Days
INCIDENT_RET="43200" # 30 Days
TRACE_RET="43200" # 30 Days
CDUMP_RET="43200" # 30 Days
HM_RET="43200" # 30 Days

echo "INFO: adrci purge started at `date`"
adrci exec="show homes"|grep -v : | while read file_line
do
echo "INFO: adrci purging diagnostic destination " $file_line
echo "INFO: purging ALERT older than 90 days"
adrci exec="set homepath $file_line;purge -age $ALERT_RET -type ALERT"
echo "INFO: purging INCIDENT older than 30 days"
adrci exec="set homepath $file_line;purge -age $INCIDENT_RET -type INCIDENT"
echo "INFO: purging TRACE older than 30 days"
adrci exec="set homepath $file_line;purge -age $TRACE_RET -type TRACE"
echo "INFO: purging CDUMP older than 30 days"
adrci exec="set homepath $file_line;purge -age $CDUMP_RET -type CDUMP"
echo "INFO: purging HM older than 30 days"
adrci exec="set homepath $file_line;purge -age $HM_RET -type HM"
echo ""
echo ""
done
echo
echo "INFO: adrci purge finished at `date`"