# Aliases for DBAs


```
#*******************************
# Linix / UNIX aliases for Oracle DBAs
#*******************************
alias alert='tail -100 $DBA/$ORACLE_SID/bdump/alert_$ORACLE_SID.log|more'
alias errors='tail -100 $DBA/$ORACLE_SID/bdump/alert_$ORACLE_SID.log|more'
alias arch='cd $DBA/$ORACLE_SID/arch'
alias bdump='cd $DBA/$ORACLE_SID/bdump'
alias cdump='cd $DBA/$ORACLE_SID/cdump'
alias pfile='cd $DBA/$ORACLE_SID/pfile'
alias rm='rm -i'
alias sid='env|grep ORACLE_SID'
alias admin='cd $DBA/admin'
```