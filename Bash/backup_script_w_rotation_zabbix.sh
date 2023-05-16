#!/bin/bash

# Define source and destination directories
SOURCE_DIR="/path/to/source"
DESTINATION_DIR="/path/to/destination"

# Define GFS backup rotation parameters
DAILY_BACKUPS=7
WEEKLY_BACKUPS=4
MONTHLY_BACKUPS=12

# Define log file path
LOG_FILE="/path/to/backup.log"

# Define Zabbix server and port
ZABBIX_SERVER="zabbix.example.com"
ZABBIX_PORT="10051"

# Create a timestamp for the backup folder name
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create a new folder with the timestamp as the name
BACKUP_DIR="${DESTINATION_DIR}/${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

# Copy the contents of the source directory to the backup directory
cp -r "$SOURCE_DIR" "$BACKUP_DIR"

# Remove old daily backups
while [ $(ls "$DESTINATION_DIR" | grep daily | wc -l) -ge $DAILY_BACKUPS ]; do
  rm -rf "$(ls -t "$DESTINATION_DIR" | grep daily | tail -1)"
done

# Remove old weekly backups
while [ $(ls "$DESTINATION_DIR" | grep weekly | wc -l) -ge $WEEKLY_BACKUPS ]; do
  rm -rf "$(ls -t "$DESTINATION_DIR" | grep weekly | tail -1)"
done

# Remove old monthly backups
while [ $(ls "$DESTINATION_DIR" | grep monthly | wc -l) -ge $MONTHLY_BACKUPS ]; do
  rm -rf "$(ls -t "$DESTINATION_DIR" | grep monthly | tail -1)"
done

# Create daily, weekly, and monthly backups
if [ $(date +%d) -eq 01 ]; then
  # Monthly backup
  cp -al "$BACKUP_DIR" "${DESTINATION_DIR}/monthly.${TIMESTAMP}"
  echo "$(date): Monthly backup created: ${DESTINATION_DIR}/monthly.${TIMESTAMP}" >> "$LOG_FILE"
  zabbix_sender -z "$ZABBIX_SERVER" -p "$ZABBIX_PORT" -s "Backup" -k "backup.monthly" -o "1"
else
  # Daily backup
  cp -al "$BACKUP_DIR" "${DESTINATION_DIR}/daily.${TIMESTAMP}"
  echo "$(date): Daily backup created: ${DESTINATION_DIR}/daily.${TIMESTAMP}" >> "$LOG_FILE"
  zabbix_sender -z "$ZABBIX_SERVER" -p "$ZABBIX_PORT" -s "Backup" -k "backup.daily" -o "1"

  if [ $(date +%u) -eq 1 ]; then
    # Weekly backup on Monday
    cp -al "$BACKUP_DIR" "${DESTINATION_DIR}/weekly.${TIMESTAMP}"
    echo "$(date): Weekly backup created: ${DESTINATION_DIR}/weekly.${TIMESTAMP}" >> "$LOG_FILE"
    zabbix_sender -z "$ZABBIX_SERVER" -p "$ZABBIX_PORT" -s "Backup" -k "backup.weekly" -o "1"
  fi
fi

# Output confirmation message
echo "Backup created: $BACKUP_DIR"