- [Generic stuff](#generic-stuff)
    - [List all tables](#list-all-tables)
- [Database size](#database-size)
    - [All database listed](#all-database-listed)
    - [One database](#one-database)
- [Export/Import](#exportimport)
    - [Export to CSV](#export-to-csv)
    - [Import from CSV](#import-from-csv)
- [Create tables from](#create-tables-from)
    - [Generate create table statement](#generate-create-table-statement)
    - [Create table like](#create-table-like)
- [User/Role privileges](#userrole-privileges)

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



# Create tables from 

### Generate create table statement
```

```

### Create table like
```
CREATE TABLE schema1.t_random13 (LIKE schema1.t_random12 INCLUDING ALL);
```



# User/Role privileges

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
