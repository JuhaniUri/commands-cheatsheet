# OpenSSL 

## General

 **_Type of<br>certificate_** | **_Domain<br>validated?_** | **_Subject Name<br>Validated?_** | **_Address<br>Validated?_** | **_Pad Lock _**_<br>**Displayed by**<br>**Browser?**_ | **_Green address<br>bar or other<br>special treatment?_** | **_Relative price_** |
| ---------------------------- | -------------------------- | -------------------------------- | --------------------------- | ----------------------------------------------------- | --------------------------------------------------------- | -------------------- |
| _DV_                         | _X_                        |                                  |                             | _X_                                                   |                                                           | _$_                  |
| _OV_                         | _X_                        | _X_                              | _X_                         | _X_                                                   |                                                           | _$$_                 |
| _EV_                         | _X_                        | _X_                              | _X_                         | _X_                                                   | _X_                                                       | _$$$_                |


## Certificates
### Print out certificate details
```
openssl x509 -in ca.cert -text -noout -sha256 -fingerprint
```


