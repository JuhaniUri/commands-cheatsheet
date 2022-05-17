# TKGI & BOSH

## General

### Vitals and columns
```
bosh -d service-instance_c2f6cdd6-8b8c-4ba6-8faa-37deba1d4572 vms --vitals --column="Load (1m, 5m, 15m)" --column=Instance --column="Memory usage"  --column=IPs
```

### Shell command in all VMs
```
bosh -d d5413e ssh -c 'date'
```

### Tasks debug

```
bosh task --debug 263
```

### Logs
```
bosh -d d392343 logs
```

## Certificates
### Get current certificates
```
$ bosh env --details
```

