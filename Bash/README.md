# Bash script examples

Here I'll collect some examples that can be re-used


### Lock file usage inside script
```
# Check is process is already running.
# If lock file already exists exit.
LOCK_FILE=/tmp/orabackup.lock
if [ -e $LOCK_FILE ]
then
  exit 0;
fi

# Create a lock file containing the current
# process id to prevent other tests from running.
echo $$ > $LOCK_FILE

# Add your processing here.
#
#

# Clear down lock file ready for the next run.
rm -f $LOCK_FILE
```


### Bash script month/week/daily
https://nicaw.wordpress.com/2013/04/18/bash-backup-rotation-script/
```
# It is logical to run this script daily. We take files from source folder and move them to
# appropriate destination folder
# On first month day do
if [ "$month_day" -eq 1 ] ; then
  destination=backup.monthly/$date_daily
else
  # On saturdays do
  if [ "$week_day" -eq 6 ] ; then
    destination=backup.weekly/$date_daily
  else
    # On any regular day do
    destination=backup.daily/$date_daily
  fi
fi
```
