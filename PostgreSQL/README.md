- [Generic stuff](#generic-stuff)
    - [List all tables](#list-all-tables)
- [Database size](#database-size)
    - [All database listed](#all-database-listed)
    - [One database](#one-database)
- [Export/Import](#exportimport)
    - [Export to CSV](#export-to-csv)
    - [Import from CSV](#import-from-csv)
    - [pg\_dump](#pg_dump)
- [Create tables from](#create-tables-from)
    - [Generate create table statement](#generate-create-table-statement)
    - [Create table like](#create-table-like)
- [User/Role privileges](#userrole-privileges)
    - [Create readonly user](#create-readonly-user)
- [Sessions management](#sessions-management)
    - [show running queries](#show-running-queries)
    - [Terminate a query but keep the connection alive (kill query)](#terminate-a-query-but-keep-the-connection-alive-kill-query)
    - [Terminate a query and kill the connection (kill query + connection)](#terminate-a-query-and-kill-the-connection-kill-query--connection)
    - [Kill long-running queries + session](#kill-long-running-queries--session)
- [psql tips and tricks](#psql-tips-and-tricks)
    - [Watch](#watch)
- [Create database with random data](#create-database-with-random-data)
    - [Create database](#create-database)
    - [Create Schema](#create-schema)
    - [Create some random data](#create-some-random-data)
- [Performance testing](#performance-testing)
    - [pgbench usage with existing database](#pgbench-usage-with-existing-database)
- [pg\_extension](#pg_extension)
    - [dblink](#dblink)
- [pg\_dump and pg\_restore (binary)](#pg_dump-and-pg_restore-binary)
    - [Export](#export)
    - [Import](#import)
- [pg\_dump and psql (plain).](#pg_dump-and-psql-plain)
  - [Migrate database from db to other.](#migrate-database-from-db-to-other)
    - [Export](#export-1)
    - [pg\_restore](#pg_restore)

# Generic stuff

### List all tables
```
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog' AND
    schemaname != 'information_schema';
```

# Database size

### All database listed
```
select t1.datname AS db_name,
       pg_size_pretty(pg_database_size(t1.datname)) as db_size
from pg_database t1
order by pg_database_size(t1.datname) desc;
```

### One database
```
-- Database Size
SELECT pg_size_pretty(pg_database_size('Database Name'));
-- Table Size
SELECT pg_size_pretty(pg_relation_size('table_name'));
```

# Export/Import

### Export to CSV
```
\COPY schema1.t_random12 TO /tmp/schema1.t_random12 DELIMITER ',' CSV HEADER;
```

### Import from CSV
```
\COPY schema1.t_random13 FROM /tmp/schema1.t_random12 DELIMITER ',' CSV HEADER;
```

### pg_dump
Compressed
```
pg_dump -h 10.1.1.14 -U username -W -F t randomdemo > /tmp/randomdemo.tar
```

In plain
```
pg_dump -h 10.1.1.14 -U username -W randomdemo > /tmp/randomdemo.dump
```



# Create tables from

### Generate create table statement
```

```

### Create table like
```
CREATE TABLE schema1.t_random13 (LIKE schema1.t_random12 INCLUDING ALL);
```



# User/Role privileges

### Create readonly user

```
postgres=# CREATE ROLE APP_READONLY WITH LOGIN PASSWORD 'SomeSuperSecret';
postgres=# GRANT CONNECT ON DATABASE <DATABASE_NAME> TO APP_READONLY;
postgres=# \c <DATABASE_NAME>
your_db=# GRANT USAGE ON SCHEMA <SCHEMA_NAME> to APP_READONLY;
your_db=# GRANT SELECT ON ALL TABLES IN SCHEMA <SCHEMA_NAME> TO APP_READONLY;
your_db=# ALTER DEFAULT PRIVILEGES IN SCHEMA <SCHEMA_NAME> GRANT SELECT ON TABLES TO APP_READONLY;
```


```
SELECT grantor, grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'myuser'
```


```
SELECT grantee AS user, CONCAT(table_schema, '.', table_name) AS table,
    CASE
        WHEN COUNT(privilege_type) = 7 THEN 'ALL'
        ELSE ARRAY_TO_STRING(ARRAY_AGG(privilege_type), ', ')
    END AS grants
FROM information_schema.role_table_grants
GROUP BY table_name, table_schema, grantee;
```

# Sessions management

### show running queries
```
SELECT pid, age(clock_timestamp(), query_start), usename, query
FROM pg_stat_activity
WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%'
ORDER BY query_start desc;
```

### Terminate a query but keep the connection alive (kill query)
```
SELECT pg_cancel_backend(procpid);
```

### Terminate a query and kill the connection (kill query + connection)
```
SELECT pg_terminate_backend(procpid);
```

### Kill long-running queries + session
```
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
where usename = ‘USERNAME’ and  query ILIKE 'SELECT%'
and (now() - pg_stat_activity.query_start) > interval '120 minutes' ;
```

# psql tips and tricks

### Watch
```
postgres=# SELECT * FROM pg_replication_slots;
 slot_name | plugin | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn
-----------+--------+-----------+--------+----------+-----------+--------+------------+------+--------------+-------------+---------------------
(0 rows)

postgres=# \watch 1
                                                   Thu 10 Mar 2022 12:03:25 PM UTC (every 1s)

 slot_name | plugin | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn
-----------+--------+-----------+--------+----------+-----------+--------+------------+------+--------------+-------------+---------------------
(0 rows)

                                                   Thu 10 Mar 2022 12:03:26 PM UTC (every 1s)

 slot_name | plugin | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn
-----------+--------+-----------+--------+----------+-----------+--------+------------+------+--------------+-------------+---------------------
(0 rows)
```


# Create database with random data

### Create database
```
CREATE DATABASE randomdemo;
```

### Create Schema

```
CREATE SCHEMA schema_demo;
```

### Create some random data
It will generate ca 130MB of data, will run 4-8sec.
```
CREATE TABLE schema_demo.demo_random1 AS SELECT s, md5(random()::text) FROM generate_Series(1,2000000) s;
```

# Performance testing

### pgbench usage with existing database
It will create 4 tables under public schema
```
pgbench -h 10.180.1.14 -p 5432 -U TESTUSER -i -s 150 randomdemo
Password:
dropping old tables...
creating tables...
generating data...
100000 of 15000000 tuples (0%) done (elapsed 0.02 s, remaining 3.03 s)
200000 of 15000000 tuples (1%) done (elapsed 0.04 s, remaining 3.01 s)
300000 of 15000000 tuples (2%) done (elapsed 0.06 s, remaining 2.98 s)
400000 of 15000000 tuples (2%) done (elapsed 0.08 s, remaining 3.00 s)
500000 of 15000000 tuples (3%) done (elapsed 0.19 s, remaining 5.58 s)
...
14700000 of 15000000 tuples (98%) done (elapsed 18.21 s, remaining 0.37 s)
14800000 of 15000000 tuples (98%) done (elapsed 18.29 s, remaining 0.25 s)
14900000 of 15000000 tuples (99%) done (elapsed 18.54 s, remaining 0.12 s)
15000000 of 15000000 tuples (100%) done (elapsed 18.64 s, remaining 0.00 s)
vacuuming...
creating primary keys...
done.
```

# pg_extension

### dblink
```
$ psql postgres
psql (11.10)
Type "help" for help.

postgres=# SELECT * FROM pg_extension;
 extname | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
---------+----------+--------------+----------------+------------+-----------+--------------
 plpgsql |       10 |           11 | f              | 1.0        |           |
(1 row)

postgres=# CREATE EXTENSION dblink;
CREATE EXTENSION
postgres=# SELECT * FROM pg_extension;
 extname | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
---------+----------+--------------+----------------+------------+-----------+--------------
 plpgsql |       10 |           11 | f              | 1.0        |           |
 dblink  |       10 |         2200 | t              | 1.2        |           |
(2 rows)

postgres=# select * from dblink('dbname=test-db-1 port=5432 host=10.0.14.2
user=user password=***', 'select username from schema1.demousers') AS t1(t text);

     t
------------
 uriiijuh
 uriiijuh2
 unknown
(3 rows)
```


# pg_dump and pg_restore (binary)

### Export
```
pg_dump -U postgres -h 10.20.30.10 -p 6432 -W -F c -d DatabaseName > 240913_test.dump
```
### Import
```
pg_restore -U postgres -h 10.20.30.10 -p 6432 -d DatabaseName 240913_test.dump
```


# pg_dump and psql (plain).
## Migrate database from db to other.
### Export
```
pg_dump -U DatabaseUSER -W -h 10.20.30.10 -p 6432 DatabaseName > 240913_live.dump
```
### pg_restore
```
psql -U DatabaseUSER -W -h 30.30.30.30 -p 6432 DatabaseName < 240913_live.dump
```