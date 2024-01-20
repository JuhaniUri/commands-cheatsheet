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

### k8s Trick to Scale down daemonset to zero
```
kubectl -n cattle-logging patch daemonset rancher-logging-fluentd-linux -p '{"spec": {"template": {"spec": {"nodeSelector": {"non-existing": "true"}}}}}'
```

### k8s Trick to Scale daemonset to up

```
kubectl -n cattle-logging patch daemonset rancher-logging-fluentd-linux  --type json -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector/non-existing"}]'
```