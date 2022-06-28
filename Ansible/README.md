# Generic ansible 

## Best practices 

### Overall organization

    o	Project structure
    o	Standardized role structure

### Usage of variables

    o	Keep all your variables in one place, if possible
    o	Use variables in the roles instead of hard-coding
    o	In Role use defaults instead of vars, because vars are harder to override.

### Naming

    o	Keep the names consistent between groups, plays, variables, and roles
    o	Comment every play
    o	Use tags in your play

### Staging

    o	Different environments (development, test, production) 

### Encryption of data (e.g. passwords, certificates)

    o	Use ansible-vault when you want to store sensitive information (passwords, privatekeys, certs)



## Example layout for ansible 
### Monorepo
Infra
 ├── environments
 │   ├── dev
 │   │   ├── group_vars       # here we assign variables to particular groups
 │   │   └── host_vars        # if systems need specific variables, put them here
 │   ├── test
 │   │   ├── group_vars
 │   │   └── host_vars
 │   └── prod                 
 │    
 ├── filter_plugins            # if any custom modules, put them here (optional)
 ├── group_vars
 ├── library                   # if any custom module_utils to support modules, put them here (optional)
 ├── module_utils              # if any custom filter plugins, put them here (optional)
 └── roles
    ├── apache
    ├── common
    │   ├── defaults
    │   ├── files
    │   ├── handlers
    │   ├── meta
    │   ├── tasks
    │   ├── templates
    │   └── vars
    ├── ntp
    ├── oracle-12-db
    ├── oracle-client
    ├── tomcat
    └── zabbix-agent


## Adhoc
### Adhoc examples
```
ansible all -s -m shell -a 'hostname' -i hosts --become-method=sudo
ansible all -s -m shell -a 'yum update -y' -i hosts --become-method=sudo
```
