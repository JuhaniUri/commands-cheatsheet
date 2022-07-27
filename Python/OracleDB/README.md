# Getting started with python-oracledb

## Quick start
https://github.com/oracle/python-oracledb
https://python-oracledb.readthedocs.io/en/latest/user_guide/installation.html

### Install
```
$ python -m pip install oracledb --upgrade
```


### Create test.py
```
# test.py

import oracledb
import os

un = os.environ.get('PYTHON_USERNAME')
pw = os.environ.get('PYTHON_PASSWORD')
cs = os.environ.get('PYTHON_CONNECTSTRING')

with oracledb.connect(user=un, password=pw, dsn=cs) as connection:
    with connection.cursor() as cursor:
        sql = """select sysdate from dual"""
        for r in cursor.execute(sql):
            print(r)
			
```		
			
### Export connection details 

```
export PYTHON_USERNAME=testuser
export PYTHON_PASSWORD=somepassword
export PYTHON_CONNECTSTRING=localhost:1521/ORCLCDB
```

### Run the python 
```
$ python test.py
(datetime.datetime(2022, 7, 27, 11, 28, 53),)
```