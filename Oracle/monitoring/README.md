# Monitoring

## Alertlog
### Errors (Oracle 11)

| Category                              | Errors Returned in this Category | Default Critical Threshold |
| ------------------------------------- | -------------------------------- | -------------------------- |
| Archiver Hung Alert Log Error         | ORA-00257, ORA-16038             | High                       |
| Data Block Corruption Alert Log Error | ORA-01578, ORA-00353, ORA-00227  | Disaster                   |
| Session Terminated Alert Log Error    | ORA 00603                        | High                       |
| Media Failure Alert Log Error         | ORA 01242, ORA-01243             | Disaster                   |
| Extension Alert Log Error             | ORA-01652, ORA-01653, ORA-01654  | High                       |
| Out of MemoryAlert Log Error          | ORA-4030, ORA-4031               | High                       |
| Generic Alert Log Error               | All other alert log errors       | Average                    |