# Backups


## Backup checklist

### Business requirements 
* RTO: Recovery Time Objective is the amount of downtime a business can tolerate.
* RPO: Recovery Point Objective the amount of data that can be lost within a period.

 RTO and RPO picture: https://medium.com/@asfinachdian/rpo-vs-rto-difference-71b09dc96f78


### Types
* Full (If size and backup time is acceptable, then go for daily Full backups)
* Differential
* Incremental

### Strategy 
* Backup 3-2-1 (3 copies of data, 2 different media, 1 being off site)
* Custom (2-2-1, 2-2-0, ...)
NB! Should not be on the same physical storage with your Production system.

### Rotation
* Grandfather-father-son
* Custom (3 months, 3 0days)

### Data at rest
* Encryption

### Recovery testing and documentation
* Yearly or Quarterly. 
* Documentation should be easy to read (command by command with explations/recovery time) as when disater will you be in hurry. 

### Monitoring
* Status (OK or failed)
* Backup time 


## Example setup for databases

| Backup settings           |                |
| ------------------------- | -------------- |
| Scope                     | LIVE           |
| Full                      | Sunday         |
| Incremental               | Immediately    |
| Differential              | -              |
| Strategy                  | 2-1-1          |
| Rotation*                 | 90d, 30d       |
| Compression               | No             |
| Encryption                | Yes            |
| Testing                   | Yearly         |
| Monitoring                | Yes            |

* We'll keep 30days backups (full+incremental), so it's possible to restore at any point within 30days
* We'll keep one full backup from each month and from last 3 months.


## Backups vs Archiving 
There is lot of confusion around this topic. Quite common case is that Backups are used as Archive, in a sense that is OK and of course simplifies the setup.
But, you should consider keep the Archives separately

|                | BACKUPS                                                | ARCHIVING                                        |
|----------------|--------------------------------------------------------|--------------------------------------------------|
| Purpose        | Fast recovery operations                               | Data retention                                   |
| Usage          | Event of failure                                       | As required                                      |
| Speed          | Speed is very important                                | Not concerned                                    |
| Storage        | Short to mid-term storage (costly)                     | Long-term storage (cheaper)                      |
| Retention      | Typically short-term (weeks or months)                 | Typically long-term (months, years or decades)  |
| Cyclic process | Overwriting itself after retention time is reached     | Might be forever growing                        |
| Data Type      | Replicated data of active data, hot data and warm data | Cold data                                        |
| Format         | Not important                                          | For decades something standard                   |
|                |                                                        |                                                  |
