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




## Adhoc
### Adhoc examples
```
ansible all -s -m shell -a 'hostname' -i hosts --become-method=sudo
ansible all -s -m shell -a 'yum update -y' -i hosts --become-method=sudo
```
