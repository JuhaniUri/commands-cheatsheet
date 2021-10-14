#!/bin/bash
# Author: Juhani Uri
# This will output all pods, nodes and etcd status
# Note you need to be authenticated against TKGI before you can run this
# Example: pks login -a hostname -u admin -k
# Read Password
echo -n PKS_USER_PASSWORD:
read -s PKS_USER_PASSWORD
export PKS_USER_PASSWORD
echo

clusters=$(/usr/local/bin/pks clusters --json |  jq '.[]' | jq -r '.name')
for val in $clusters; do
    echo $val
    pks get-credentials $val
    kubectl get pods -A -o wide
    kubectl get nodes -o wide
    # Lets make sure etcd entries are synchronized
    kubectl get cs
done
