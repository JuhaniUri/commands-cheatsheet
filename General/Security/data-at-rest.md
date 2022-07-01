## Data that needs to be encrypted:

* Credit Card Payment Data  (PCI)
* Personal Information
* Intellectual Property


## Compliance Requirement:

PCI requires encryption for data at rest and in-transit for cardholder data
In shared hosting environments, each Tenant must only have access to their own data.


## Types of Encryption, ordered by security level from high to low:

### Application Level

+ Most secure option, protects against most types of intrusion	
- Requires Application Logic Integration
- complex, usually one-off type solutions
  
### Database Level	

+ Protects sensitive data in databases
+ Establishes protection against a range of threats, including malicious insiders
- Database software that support the TDE

Transparent Data Encryption (TDE) is encryption that is native to common database vendors such as Microsoft and Oracle.

### File Level

+ Protects data by applying policies at file level	
+ File-level encryption establishes strong controls that guard against abuse by privileged users
- Requires Operating System Agent

Many commercial and enterprise solutions use this method Vormetric, SafeNet, Thales etc

### Disk level	

#### Infra: Volume 

Protects data by applying policies eg. Openstack volume level

+ Protects volume data at rest and in transit encryption
+ Transparent Encryption, no keys/password needed.
+ Works with Any Operating System
+ Works with Bootable Volumes
- Does not protect data against Operating System intrusion
- Live Migration should be carefully tested, dependency on controller

This configuration uses LUKS to encrypt the disks attached to your instances. Key management is transparent to the user. When booting the instance (or attaching an encrypted volume), nova retrieves the key from barbican and stores the secret locally as a Libvirt secret on the Compute node.	Barbican + Cinder Volumes	


#### Partition

Protects data by applying policies in VM disk/partition level	
+ Linux native solution (LUKS)
- Protects volume data at rest only
- Passphrase or key is needed on mount 

Block device encryption encrypts/decrypts the data transparently as it is written/read from block devices, the underlying block device sees only encrypted data.


### Storage Level

#### vSAN 

+ Protects date by applying polices in datastores in VMware level	
- Does not protect data against Operating System intrusion
- Protects volume data at rest only

vSAN encrypts everything in the vSAN datastore. All files are encrypted, so all virtual machines and their corresponding data are protected. Only administrators with encryption privileges can perform encryption and decryption tasks.	vSAN Encryption	Potential
SAN


