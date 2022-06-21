## Some examples how desing your scripts

### SQLplus and master script

masterscript.sql
```
set serveroutput on
set define off

spool install.log
prompt Start

@\test1.tables.sql;
@\test1.functions.sql;
@\test1.procedures.sql;
@\test1.package.pck;
@\test1.views.sql;

prompt db compile
@\compile.sql;

prompt End
spool off
```


### Individual files with numbering for execution

Script namiming (number, type, name)

- 1_PKG_MANAGE.sql
- 2_PKG_MANAGE_BODY.sql
- 3_classes.sql
- 4_update_test_view.sql


### Lot of changes DML in one file 
Use "sqlerror exit"

Example
```
whenever sqlerror exit failure;
insert into test1.name ...
update test1.name ...
commit;
insert into test1.name ...
commit;
```

### Extentsions for files

- .pks - Package Spec
- .pkb - Package Body
- .pck - Package with Spec and Body
- .sql - Everyrhing else



