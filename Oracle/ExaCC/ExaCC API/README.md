# ExaCC API


## Getting started ExaCC API
ExaCC Gen1 does not support OAuth, this will come in Gen2.

https://docs.oracle.com/en/cloud/cloud-at-customer/exadata-cloud-at-customer/eccrs/url-structure.html
https://docs.oracle.com/en/cloud/cloud-at-customer/exadata-cloud-at-customer/eccrs/security-authentication-authorization.html

### What you need:
- Exadata Cloud at Customer REST endpoints:
https://rest-server/endpoint-path
- Identity Service Id: idcs-****** (can be found in cloud-ui)
- a user account (read only)

### Headers
1) The X-ID-TENANT-NAME Header <-  Identity Service Id
2) Authorization
Curl will generate this header for us if we use the --user option


### Fetching data

View All Database Deployments

https://docs.oracle.com/en/cloud/cloud-at-customer/exadata-cloud-at-customer/eccrs/op-paas-service-dbcs-api-v1.1-instances-identitydomainid-get.html
/paas/service/dbcs/api/v1.1/instances/{identityDomainId}
```
export ORA_API_username='readonly'
export ORA_API_pass='****'
```

#### All database deployments:
```
curl -X GET --user $ORA_API_username:$ORA_API_pass -H "X-ID-TENANT-NAME:idcs-******" https://example.com/paas/service/dbcs/api/v1.1
/instances/idcs-******
```

#### All database deployments, save result to file:
```
curl -X GET --user $ORA_API_username:$ORA_API_pass -H "X-ID-TENANT-NAME:idcs-******" https://example.com/paas/service/dbcs/api/v1.1/instances/idcs-****** -o data.json
```

#### jq usage example, print servicename and oracle version
```
curl -X GET --user $ORA_API_username:$ORA_API_pass -H "X-ID-TENANT-NAME:idcs-******" https://example.com/paas/service/dbcs/api/v1.1/instances/idcs-****** | jq -r '.services[] | "\(.service_name) \(.version)"'
```

# Get details from service eg. database
View a Database Deployment

https://docs.oracle.com/en/cloud/cloud-at-customer/exadata-cloud-at-customer/eccrs/op-paas-service-dbcs-api-v1.1-instances-identitydomainid-serviceidget.html

/paas/service/dbcs/api/v1.1/instances/{identityDomainId}/{serviceId}

```
curl -X GET --user $ORA_API_username:$ORA_API_pass -H "X-ID-TENANT-NAME:idcs-******" https://example.com/paas/service/dbcs/api/v1.1/instances/idcs-******/DATABASENAME
```