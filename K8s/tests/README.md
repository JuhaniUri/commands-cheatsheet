# K8s

## Testing Longhorn

* Create
```
$ kubectl create -f longhorn-pvc-test.yaml
persistentvolumeclaim/test-pvc-on-longhorn created
pod/pv-testing-pod created
```

* Check the status from kubectl or from longhorn.
Expected behaivor pod should mount pv.


* Cleanup

```
kubectl delete  -f longhorn-pvc-test.yaml
persistentvolumeclaim "test-pvc-on-longhorn" deleted
pod "pv-testing-pod" deleted
```
In case it failed to attach, then you need to manually cleanup.
Delete volume from longhorn.
