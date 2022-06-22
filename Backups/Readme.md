# Backups

Backups in short.

Backups should not be on the same physical storage with your Production system.


## Business requrements 
* RTO: Recovery Time Objective is the amount of downtime a business can tolerate.
* RPO: Recovery Point Objective the amount of data that can be lost within a period.

## Types
* Full (If size and backup time is acceptable, then go for daily Full backups)
* Differential
* Incremental

## Strategy 
* Backup 3-2-1 (3 copies of data, 2 different media, 1 being off site)
* Custom (2-2-1, 2-2-0, ...)

## Rotation
* Grandfather-father-son
* Custom (90d, 30d)

## Data at rest
* Encryption

## Regular testing (Often overlooked or with low priority)
* Yearly
* Quarterly  

## Monitoring (Ofter not implemented)
* Status (OK or failed)
* How long it took


 
