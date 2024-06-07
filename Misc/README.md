# Random
- [Random](#random)
    - [os-collect-config](#os-collect-config)
    - [Image modification with qemu](#image-modification-with-qemu)
    - [Image modification with virt-customize](#image-modification-with-virt-customize)
    - [Image modification with virt-customize and questmount](#image-modification-with-virt-customize-and-questmount)
    - [Basic image setup and layout](#basic-image-setup-and-layout)
    - [Socks proxy usage](#socks-proxy-usage)
    - [Send email from command line](#send-email-from-command-line)
  - [s3cmd usage](#s3cmd-usage)
    - [Configure](#configure)
    - [Delete recursive](#delete-recursive)
    - [Delete multiple folders](#delete-multiple-folders)
    - [Bucket settings](#bucket-settings)
    - [Bucket lifecycle](#bucket-lifecycle)
    - [Set expire for files](#set-expire-for-files)
  - [PHP](#php)
    - [Change the upload max value](#change-the-upload-max-value)


### os-collect-config

Fix for:
```
os-collect-config: /usr/lib/python2.7/site-packages/requests/packages/urllib3/connectionpool.py:852:
InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.io/en/latest/advanced-usage.html#ssl-warnings
```

```
sed -i "s/ExecStart=.*/ExecStart=\/usr\/bin\/python -W \"ignore:Unverified HTTPS request\" \/usr\/bin\/os-collect-config/g" /usr/lib/systemd/system/os-collect-config.service
systemctl daemon-reload
systemctl restart os-collect-config
```



### Image modification with qemu

Requirements:
- user with sudo rights
- complex password
- Allow password logins

Download ubuntu 18.04 cloud image and resize disk to 20G

```
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img

qemu-img info bionic-server-cloudimg-amd64.img
qemu-img resize bionic-server-cloudimg-amd64.img 20G
```


Modifications script:

```
cat changes.sh
useradd -m -p "test123" commonuser ; usermod -aG sudo commonuser
sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
ssh-keygen -A
apt-get remove cloud-init -y
```

Do changes:

```
sudo virt-customize -a bionic-server-cloudimg-amd64.img --run changes.sh
```

Review changes by coping image to /tmp and mounting it:
```
cp bionic-server-cloudimg-amd64.img /tmp/
sudo guestmount -a /tmp/bionic-server-cloudimg-amd64.img -i --rw /mnt
```
 Verify that user is created:
```
sudo cat /mnt/etc/passwd
```
If everything looks OK, then umount mnt.
Convert the img to vmdk:
```
qemu-img convert -f qcow2 bionic-server-cloudimg-amd64.img -O vmdk bionic-server-cloudimg-amd64.vmdk
```



### Image modification with virt-customize

```
virt-customize -a xenial-server-cloudimg-amd64-disk1.img --root-password password:passw1rd
virt-customize -a xenial-server-cloudimg-amd64-disk1.img --uninstall cloud-init
```

### Image modification with virt-customize and questmount


Mount image to /mnt
```
guestmount -a /tmp/CentOS-6-x86_64-GenericCloud-1809.qcow2 -i --rw /mnt
```

Change the cloud-init username to cloud-user:
```
sed -i 's/name: centos/name: cloud-user/g' /mnt/etc/cloud/cloud.cfg
```

Unmount and convert to vmdk
```
guestunmount /mnt/
qemu-img convert -p -f qcow2 -O vmdk -o adapter_type=lsilogic,subformat=streamOptimized,compat6 /tmp/CentOS-6-x86_64-GenericCloud-1809.qcow2 /tmp/mvp/CentOS-6-x86_64-GenericCloud-1809.vmdk
```

### Basic image setup and layout

- Set the proper Timezone
- Install basic packages:  zip unzip wget open-vm-tools
- Make release number /etc/my-image-release
- Default Filesystem layout as bellow.
```
NAME	SIZE	TYPE	MOUNTPOINT
sda	20G	disk
├─sda1	512M	part
└─sda2	18.1G	part
├─vg_root-lv_root	3G	lvm	/
├─vg_root-lv_tmp	128M	lvm	/tmp
├─vg_root-lv_vartmp	512M	lvm	/var/tmp
├─vg_root-lv_opt	1G	lvm	/opt
├─vg_root-lv_var	4G	lvm	/var
├─vg_root-lv_varlog	1G	lvm	/var/log
├─vg_root-lv_varlogaudit	128M	lvm	/var/log/audit
├─vg_root-lv_home	512M	lvm	/home
```

### Socks proxy usage

- Open an SSH connection to a remote server
```
ssh -q -D 1999 username@11.11.11.29
```

### Send email from command line
```
echo "Hello there" | mail -s "testing" -r sender@company.com someone@gmail.com
```


## s3cmd usage
Grab the tool https://github.com/s3tools/s3cmd

### Configure
```
s3cmd --configure
```

Result:
```
New settings:
  Access Key: ********
  Secret Key: ********
  Default Region: US
  S3 Endpoint: s3.host.com:8080
  DNS-style bucket+hostname:port template for accessing a bucket:  %(bucket)s.s3.host.com:8080
  Encryption password:
  Path to GPG program: None
  Use HTTPS protocol: True
  HTTP Proxy server name:
  HTTP Proxy server port: 0

```

### Delete recursive
```
s3cmd del --recursive s3://postgres-backup/main-repo/backup/main/20230813-023002F/
```

### Delete multiple folders
```
s3cmd ls s3://postgres-backups/main-repo/backup/main/ | grep '202309' | awk '{print $2}' | while read file; do s3cmd del --recursive $file; done
```

### Bucket settings
```
s3cmd info  s3://pgsql-test01-db-backups/
```

### Bucket lifecycle
```
s3cmd getlifecycle s3://pgsql-test01-db-backups/
```

### Set expire for files
```
s3cmd expire --expiry-days=15 s3://pgsql-test01-db-backups/
```


## PHP

### Change the upload max value

upload_max_filesize
The maximum size of an uploaded file.
post_max_size must be larger than this value.
https://www.php.net/manual/en/ini.core.php#ini.upload-max-filesize
```
sed -i '/upload_max_filesize/s/= *2M/=100M/' /etc/php/8.0/cli/php.ini
sed -i '/post_max_size/s/= *8M/=108M/' /etc/php/8.0/cli/php.ini
```

Validate the change
```
# php -i | grep upload
```
