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

### Validate that Cert matches key:
```
openssl x509 -noout -modulus -in web.crt | openssl md5 ; openssl rsa -noout -modulus -in web.key | openssl md5
```

### Create request with respone file
#### Create csr file
```
$cat csr_details_for_web.txt
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[ dn ]
C=FI
L=Helsinki
O=TEST
CN=web.fi
[ req_ext ]
```

#### Create key and csr
```
$openssl req -new -sha256 -days 720 -newkey rsa:2048 -keyout web.key -out web.csr -config csr_details_for_web.txt
$openssl req -in web.csr -noout -text
```

### One-liner for creating a key and csr
```
openssl req -new -sha256 -newkey rsa:2048 -keyout web.key -out web.csr -subj "/C=EE/ST=Tallinn/O=Company/CN=something.ee"
```


## Private and public keys

### How can I tell how many bits my ssh key is?
```
$  ssh-keygen -l -f ~/.ssh/id_rsa.pub
3072 SHA256:4QBx/Vc5dZscdoaHFRNYJEe/ErTq2h+TgKGatYaMAEo user@work (RSA)
```

### Ubuntu 20 will create 3072 bit key by default, in case you need 2048
```
$ ssh-keygen -b 2048 -t rsa
```