# Random 


### os-collect-config 

Fix for:
```
os-collect-config: /usr/lib/python2.7/site-packages/requests/packages/urllib3/connectionpool.py:852: 
InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.io/en/latest/advanced-usage.html#ssl-warnings
```

```
sed -i "s/ExecStart=.*/ExecStart=\/usr\/bin\/python -W \"ignore:Unverified HTTPS request\" \/usr\/bin\/os-collect-config/g" /usr/lib/systemd/system/os-collect-config.service
systemctl daemon-reload
systemctl restart os-collect-config
```
