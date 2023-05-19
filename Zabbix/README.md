# Zabbix
## General

## SNMP traps in zabbix
Link to source: https://blog.zabbix.com/snmp-traps-in-zabbix/

Firewall setup
1. Add the following line in /etc/sysconfig/iptables:
```
-A INPUT -p udp -m udp --dport 162 -j ACCEPT
```

And restart the firewall:
```
systemctl restart iptables
```


Trap receiver setup
```
yum install -y net-snmp-utils net-snmp-perl net-snmp
wget https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.17.tar.gz
tar -xvf zabbix-6.0.17.tar.gz
```

2. Copy the script from the misc folder:
```
$ cp /root/zabbix-6.0.17/misc/snmptrap/zabbix_trap_receiver.pl /var/lib/zabbix/
```

3. Add execution permission:
```
$ chmod +x /var/lib/zabbix/zabbix_trap_receiver.pl
```

4. Set up the trap receiver and community name:

```
$ vi /etc/snmp/snmptrapd.conf
authCommunity execute public
perl do "/var/lib/zabbix/zabbix_trap_receiver.pl";
```
```
vi /etc/zabbix/zabbix_proxy.conf
SNMPTrapperFile=/tmp/zabbix_traps.tmp
StartSNMPTrapper=1
systemctl restart zabbix-proxy
```

5. Check that service is up
```
$ ps -ax | grep snmp
3387421 ?        S      0:00 /usr/sbin/zabbix_proxy: snmp trapper [processed data in 0.000071 sec, idle 1 sec]
3387514 pts/0    S+     0:00 grep --color=auto snmp
```


### Get list of cluster names
```
```


