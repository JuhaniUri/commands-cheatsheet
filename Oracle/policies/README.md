# Policies  


## Naming policy for database.

ORALCE DB_NAME restrictions (Doc ID 239888.1): 
 The maximum permissible length of DB_NAME is 8 characters for both single instance and 
 OPS / RAC environments, consisting of valid characters like
 -  alphabetic characters, 
 -  numbers, 
 -  underscore (_),  
 -  sharp (#) or dollar ($).

Usually the DB_NAME and SID are same but they need not be same


So I generally have kept thing simple and used this pattern.


### LIVE:
Some 4 letter synonym for application.

- APP

### TEST and DEV: [ENV]+[SID]

Example 1: 
- TESTAPP
- DEVAPP

Example 2:
- TAPP
- DAPP

## Listener and ports

### Listener

Naming is rule is simple: LISTENER_[SID]

As example: LISTENER_APP, LISTENER_TESTAPP or LISTENER_TAPP etc.

### Ports
1521 is reserved for LIVE
1522 - 1529 is for TEST/DEV environment's.



