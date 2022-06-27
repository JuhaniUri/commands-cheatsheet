
- [Restore](#restore)
  - [Restore datafile](#restore-datafile)
    - [Take datafile offline](#take-datafile-offline)
    - [View datafile status](#view-datafile-status)
    - [View restore and recovery](#view-restore-and-recovery)
    - [Example](#example)

# Restore 

## Restore datafile
Ref. 286355.1
Recovery of datafile

### Take datafile offline
```
alter database datafile '/u02/oradata/ORCL/ORCLtbs03.dbf' offline;
alter database datafile '/u02/oradata/ORCL/ORCLtbs03.dbf' online;

```

or

```
alter database datafile 43 offline;
alter database datafile 43 online;
```


### View datafile status
```
select file#,status from v$datafile where file#=43;
select file#,status from v$datafile_header where file#=43;
```


### View restore and recovery
```
restore datafile 43 preview;
recover datafile 43;
```

### Example
```
RMAN> recover datafile 43;

Starting recover at 18-MAY-16
using channel ORA_DISK_1
using channel ORA_DISK_2

starting media recovery

channel ORA_DISK_1: starting archive log restore to default destination
channel ORA_DISK_2: starting archive log restore to default destination
channel ORA_DISK_2: restoring archive log
archive log thread=1 sequence=101442
channel ORA_DISK_2: restoring archive log
archive log thread=1 sequence=101443
channel ORA_DISK_2: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr4qpn9_.bkp
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101444
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101445
channel ORA_DISK_1: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr4qpnz_.bkp
channel ORA_DISK_1: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr4qpnz_.bkp tag=ARCH
channel ORA_DISK_1: restore complete, elapsed time: 00:00:04
channel ORA_DISK_1: starting archive log restore to default destination
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101447
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101448
channel ORA_DISK_1: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5bfc7_.bkp
channel ORA_DISK_1: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5bfc7_.bkp tag=ARCH
channel ORA_DISK_1: restore complete, elapsed time: 00:00:03
channel ORA_DISK_1: starting archive log restore to default destination
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101446
channel ORA_DISK_1: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5bfbn_.bkp
channel ORA_DISK_2: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr4qpn9_.bkp tag=ARCH
channel ORA_DISK_2: restore complete, elapsed time: 00:00:10
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101442_cmrkb5tm_.arc thread=1 sequence=101442
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101442_cmrkb5tm_.arc recid=195796 stamp=912173693
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101443_cmrkb630_.arc thread=1 sequence=101443
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101443_cmrkb630_.arc recid=195795 stamp=912173693
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101444_cmrkb5t4_.arc thread=1 sequence=101444
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101444_cmrkb5t4_.arc recid=195792 stamp=912173686
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101445_cmrkb60m_.arc thread=1 sequence=101445
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101445_cmrkb60m_.arc recid=195791 stamp=912173686
channel ORA_DISK_2: starting archive log restore to default destination
channel ORA_DISK_2: restoring archive log
archive log thread=1 sequence=101450
channel ORA_DISK_2: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5x5j2_.bkp
channel ORA_DISK_1: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5bfbn_.bkp tag=ARCH
channel ORA_DISK_1: restore complete, elapsed time: 00:00:05
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101446_cmrkbcsp_.arc thread=1 sequence=101446
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101446_cmrkbcsp_.arc recid=195797 stamp=912173695
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101447_cmrkb8s6_.arc recid=195794 stamp=912173690
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101448_cmrkb9yy_.arc recid=195793 stamp=912173690
media recovery complete, elapsed time: 00:00:02
channel ORA_DISK_2: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5x5j2_.bkp tag=ARCH
channel ORA_DISK_2: restore complete, elapsed time: 00:00:03
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101450_cmrkbht4_.arc recid=195798 stamp=912173696
channel ORA_DISK_1: starting archive log restore to default destination
channel ORA_DISK_2: starting archive log restore to default destination
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101449
channel ORA_DISK_1: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5x5hc_.bkp
channel ORA_DISK_2: restoring archive log
archive log thread=1 sequence=101452
channel ORA_DISK_2: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrgpq3m_.bkp
channel ORA_DISK_1: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmr5x5hc_.bkp tag=ARCH
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101449_cmrkbl8c_.arc recid=195800 stamp=912173698
channel ORA_DISK_2: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrgpq3m_.bkp tag=ARCH
channel ORA_DISK_2: restore complete, elapsed time: 00:00:01
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101452_cmrkbl7v_.arc recid=195799 stamp=912173698
channel ORA_DISK_2: starting archive log restore to default destination
channel ORA_DISK_1: starting archive log restore to default destination
channel ORA_DISK_1: restoring archive log
archive log thread=1 sequence=101451
channel ORA_DISK_1: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrgpq36_.bkp
channel ORA_DISK_2: restoring archive log
archive log thread=1 sequence=101454
channel ORA_DISK_2: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrjgzb3_.bkp
channel ORA_DISK_2: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrjgzb3_.bkp tag=ARCH
channel ORA_DISK_2: restore complete, elapsed time: 00:00:01
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101454_cmrkbmn2_.arc recid=195801 stamp=912173699
channel ORA_DISK_2: starting archive log restore to default destination
channel ORA_DISK_2: restoring archive log
archive log thread=1 sequence=101453
channel ORA_DISK_2: reading from backup piece /orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrjgzbh_.bkp
channel ORA_DISK_1: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrgpq36_.bkp tag=ARCH
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1_mf_1_101451_cmrkbmo3_.arc recid=195802 stamp=912173700
channel ORA_DISK_2: restored backup piece 1
piece handle=/orabackup/flash_recovery_area/ORCL/backupset/2016_05_18/o1_mf_annnn_ARCH_cmrjgzbh_.bkp tag=ARCH
channel ORA_DISK_2: restore complete, elapsed time: 00:00:04
channel default: deleting archive log(s)
archive log filename=/orabackup/flash_recovery_area/ORCL/archivelog/2016_05_18/o1
Finished recover at 18-MAY-16

RMAN> exit

Recovery Manager complete.
[<LIVE> oracle@ORCLdb ~]$ sqlplus / as sysdba

SQL*Plus: Release 10.2.0.3.0 - Production on Wed May 18 13:35:14 2016

Copyright (c) 1982, 2006, Oracle.  All Rights Reserved.


Connected to:
Oracle Database 10g Enterprise Edition Release 10.2.0.3.0 - 64bit Production
With the Partitioning, OLAP and Data Mining options

SQL> alter database datafile '/u02/oradata/ORCL/ORCLtbs03.dbf' online;

Database altered.

SQL> exit


Recovery Manager complete.
[<LIVE> oracle@ORCLdb ~]$ dbv file='/u02/oradata/ORCL/ORCLtbs03.dbf' feedback=100                                                                                                                               00 blocksize=8192

DBVERIFY: Release 10.2.0.3.0 - Production on Wed May 18 13:50:25 2016

Copyright (c) 1982, 2005, Oracle.  All rights reserved.

DBVERIFY - Verification starting : FILE = /u02/oradata/ORCL/ORCLtbs03.dbf
................................................................................
.........................

DBVERIFY - Verification complete

Total Pages Examined         : 1048576
Total Pages Processed (Data) : 166812
Total Pages Failing   (Data) : 0
Total Pages Processed (Index): 113683
Total Pages Failing   (Index): 0
Total Pages Processed (Other): 768081
Total Pages Processed (Seg)  : 0
Total Pages Failing   (Seg)  : 0
Total Pages Empty            : 0
Total Pages Marked Corrupt   : 0
Total Pages Influx           : 0
Highest block SCN            : 2794067228 (0.2794067228)

```




