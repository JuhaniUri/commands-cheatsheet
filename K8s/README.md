# K8s

## Bastion settings


### Getting a shell to a container 

```
$ kubectl exec -i -t -n dev app-dev-5d9fdb847f-8bjnr -- /bin/sh
```

### Fetch logs from POD that has two containers

```
$ kubectl -n dev logs app-dev-5d9fdb847f-8bjnr -c container-2 > container-2.logs
```
