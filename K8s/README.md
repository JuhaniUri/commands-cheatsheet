# K8s

## Bastion settings




### Getting a shell to a container 

```
$ kubectl exec -i -t -n dev app-dev-5d9fdb847f-8bjnr -- /bin/sh
```

## Logs

### Fetch logs from POD that has two containers

```
$ kubectl -n dev logs app-dev-5d9fdb847f-8bjnr -c container-2 > container-2.logs
```

### Tail logs from POD

```
$ kubectl -n dev logs -f --tail=100 app-dev-5d9fdb847f-8bjnr
```

### Show all logs from pod nginx written in the last hour

```
kubectl logs --since=1h nginx
```

## Copy files

### Copy file from pod to local
```
kubectl cp test/-test-549d85696-cj4qn:/etc/ssl/certs/java/cacerts /Users/juhaniuri/Downloads/cacerts
```


## Hacks and tricks

### k8s Trick to Scale down daemonset to zero
```
kubectl -n cattle-logging patch daemonset rancher-logging-fluentd-linux -p '{"spec": {"template": {"spec": {"nodeSelector": {"non-existing": "true"}}}}}'
```

### k8s Trick to Scale daemonset to up

```
kubectl -n cattle-logging patch daemonset rancher-logging-fluentd-linux  --type json -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector/non-existing"}]'
```
