# TKGI & BOSH

## General

### Get list of cluster names
```
$ tkgi clusters --json | jq -r ' .[] | .name'
```


