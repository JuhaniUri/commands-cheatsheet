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
```
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
```

## Adhoc
### Adhoc examples
```
ansible all -s -m shell -a 'hostname' -i hosts --become-method=sudo
ansible all -s -m shell -a 'yum update -y' -i hosts --become-method=sudo
ansible all -m shell -a "cat /etc/rsyslog.d/*|grep 514" -i inventory --limit "live-rp-k8s"
```

#### Query running services
```
$ ansible all -m shell -a "systemctl | grep running | grep -E 'zabbix*|qualys-cloud*|salt-minion*'" -i inventory --limit "test"
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
live01 | CHANGED | rc=0 >>
  qualys-cloud-agent.service                                                          loaded active running   Qualys cloud agent daemon
  zabbix-agent2.service                                                               loaded active running   Zabbix Agent 2
test01 | CHANGED | rc=0 >>
  qualys-cloud-agent.service                                                          loaded active running   Qualys cloud agent daemon
  zabbix-agent2.service                                                               loaded active running   Zabbix Agent 2
test02 | CHANGED | rc=0 >>
  qualys-cloud-agent.service                                                          loaded active running   Qualys cloud agent daemon
  salt-minion.service                                                                 loaded active running   The Salt Minion
  zabbix-agent2.service                                                               loaded active running   Zabbix Agent 2
```

#### Ansible with passphrase protected private key

```
$ ssh-agent bash
$ ssh-add ~/.ssh/id_rsa
Enter passphrase for /home/juhani.uri/.ssh/id_rsa:
Identity added: /home/juhani.uri/.ssh/id_rsa (juhani.uri@mkm-pilv-keskhaldus)
$ ssh-add -l
3072 SHA256:****************** juhani.uri@mkm-pilv-keskhaldus (RSA)
```


#### Prep a ansible-playbook for offline install

#### Create folder under ansible playbook
```bash
 mkdir collections
```

#### Download collections and commit
 ```bash
 ansible-galaxy collection download ansible.posix -p collections
 ansible-galaxy collection download ansible.netcommon -p collections
 ansible-galaxy collection download community.general -p collections
 ```


