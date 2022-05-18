# Monitoring

## Alertlog
### Errors 

| **Category**                          | **Errors Returned in this Category** | **Comparison Operator** | **Default Warning Threshold**                              | **Default Critical Threshold** |
| ------------------------------------- | ------------------------------------ | ----------------------- | ---------------------------------------------------------- | ------------------------------ |
| Archiver Hung Alert Log Error         | ORA-00257 <br>ORA-16038              | Contains                | regexp(".\*(00257|16038).\*")})=1)                         | High                           |
| Data Block Corruption Alert Log Error | ORA-01578<br>ORA-00353 <br>ORA-00227 | Contains                | regexp(".\*(01578|00353|00227).\*")})=1)                   | Disaster                       |
| Session Terminated Alert Log Error    | ORA 00603                            | Contains                | regexp(\*00603\*)})=1)                                     | High                           |
| Media Failure Alert Log Error         | ORA 01242<br>ORA-01243               | Contains                | regexp(".\*(01242|01243).\*")})=1)                         | Disaster                       |
| Extension Alert Log Error             | ORA-01652

ORA-01653

ORA-01654      | Contains                | regexp(".\*(01652|01653|01654).\*")})=1)                   | High                           |
| Out of Memory  Alert Log Error        | ORA-4030

ORA-4031                   | Contains                | regexp(".\*(04030|04031).\*")})=1)                         | High                           |
| Generic Alert Log Error               | All other alert log errors           | Contains                | regexp(".\*0\*(600?|7445|4\[0-9\]\[0-9\]\[0-9\]).\*")})=1) | Average                        |```

