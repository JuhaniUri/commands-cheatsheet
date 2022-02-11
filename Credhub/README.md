# Credhub examples

https://github.com/cloudfoundry/credhub-cli/blob/main/EXAMPLES.md

## General


## Setting values
```
credhub set -t value -n /concourse/tkgi/s3_access_key_id -v 'tlab-minio-user'
credhub set -t value -n /concourse/tkgi/s3_endpoint -v 'http://11.8.0.72:9000'
```

## Setting a user with password
```
credhub set -t user -n '/concourse/tkgi/labtest/bastion_user' -w '********' -z 'admin'
```
