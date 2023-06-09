# Useful Linux commands

- [Useful Linux commands](#useful-linux-commands)
- [](#)
  - [Partitions, LVM, LUKS, FS etc](#partitions-lvm-luks-fs-etc)
    - [Create file that will utilize space from storage](#create-file-that-will-utilize-space-from-storage)
    - [LUKS: Format the filesystem with LUKS and add extra password to slot1](#luks-format-the-filesystem-with-luks-and-add-extra-password-to-slot1)
    - [LUKS: Resize VG/LV with LUKS](#luks-resize-vglv-with-luks)
    - [Create part/VG/LV/FS](#create-partvglvfs)
    - [Add disk to VG and grow](#add-disk-to-vg-and-grow)
    - [Growpart if disk was increased](#growpart-if-disk-was-increased)
    - [Deactive/Active LV](#deactiveactive-lv)
    - [LVM reduce](#lvm-reduce)
    - [Mounting a Windows fileshare (tested with RHEL6)](#mounting-a-windows-fileshare-tested-with-rhel6)
    - [Find dublicates in fstab](#find-dublicates-in-fstab)
  - [](#-1)
  - [Permissions](#permissions)
    - [Test permissions of file/folder for user, works even when user has "nologin"](#test-permissions-of-filefolder-for-user-works-even-when-user-has-nologin)
  - [](#-2)
  - [Text manipulation with SED, AWK](#text-manipulation-with-sed-awk)
    - [SED: Replace in file (Mac)](#sed-replace-in-file-mac)
    - [SED: Insert line at very end](#sed-insert-line-at-very-end)
    - [SED: Insert line before match found](#sed-insert-line-before-match-found)
    - [SED: replace IP in file](#sed-replace-ip-in-file)
    - [SED with find: Replacing values in multiple files inside directory (Mac)](#sed-with-find-replacing-values-in-multiple-files-inside-directory-mac)
    - [SED with find: Replacing values in multiple files inside directory (Linux)](#sed-with-find-replacing-values-in-multiple-files-inside-directory-linux)
    - [SED with find: Replacing multiple values in multiple files in subdirectories (Mac)](#sed-with-find-replacing-multiple-values-in-multiple-files-in-subdirectories-mac)
    - [GREP: Print line before, don't print match](#grep-print-line-before-dont-print-match)
    - [AWK: List of all locked accounts (accounts with passwords) :](#awk-list-of-all-locked-accounts-accounts-with-passwords-)
    - [AWK: List of all unlocked accounts (accounts with passwords) :](#awk-list-of-all-unlocked-accounts-accounts-with-passwords-)
    - [Tail: Show file content with file names](#tail-show-file-content-with-file-names)
  - [Perfomance](#perfomance)
    - [vmstat](#vmstat)
    - [top](#top)
    - [htop](#htop)
  - [SSH keys](#ssh-keys)
    - [ssh-keygen: generate private and public key to file](#ssh-keygen-generate-private-and-public-key-to-file)
    - [Convert MIIE key content](#convert-miie-key-content)
  - [VIM magic](#vim-magic)
    - [vim: How to insert a block of white spaces starting at the cursor position in VI](#vim-how-to-insert-a-block-of-white-spaces-starting-at-the-cursor-position-in-vi)
    - [vim: Delete the first X spaces for multiple lines](#vim-delete-the-first-x-spaces-for-multiple-lines)
    - [vim: Delete multiple lines](#vim-delete-multiple-lines)
  - [SElinux](#selinux)
    - [ausearch: audit daemon logs for date](#ausearch-audit-daemon-logs-for-date)
    - [restorecon: restore file(s) default SELinux security contexts.](#restorecon-restore-files-default-selinux-security-contexts)
  - [YAML](#yaml)
    - [YAML validator -\> yamllint](#yaml-validator---yamllint)
  - [Find](#find)
    - [Find with file name](#find-with-file-name)
  - [Network](#network)
    - [Route (RHEL6)](#route-rhel6)
    - [Poor man port forwarding](#poor-man-port-forwarding)
  - [Cron and stuff](#cron-and-stuff)
    - [Flock usage](#flock-usage)
    - [Bring colors to shell](#bring-colors-to-shell)
    - [FTP script](#ftp-script)
    - [Split logs](#split-logs)
    - [sync logs to nfs](#sync-logs-to-nfs)
  - [Concatenate multiple files and include filename as section headers](#concatenate-multiple-files-and-include-filename-as-section-headers)
  - [Disk speed quick and easy](#disk-speed-quick-and-easy)
  - [Curl](#curl)
    - [Download Mozilla CA certificate store in PEM format](#download-mozilla-ca-certificate-store-in-pem-format)
  - [Snmpwalk examples](#snmpwalk-examples)
    - [SNMP v2c](#snmp-v2c)
    - [SNMP v3](#snmp-v3)
- [Export password](#export-password)
#
## Partitions, LVM, LUKS, FS etc
Something to look into:
SSM https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ssm-common-tasks

### Create file that will utilize space from storage
```
xfs_mkfile 10240m 10Gigfile
```


### LUKS: Format the filesystem with LUKS and add extra password to slot1
```
cryptsetup luksFormat --cipher aes-xts-plain64 /dev/mapper/lvm_pool_data1-lvol001
cryptsetup luksOpen /dev/mapper/lvm_pool_data1-lvol001 es_data
cryptsetup luksAddKey --key-slot 1 /dev/mapper/lvm_pool_data1-lvol001
mkfs.xfs /dev/mapper/es_data
```

### LUKS: Resize VG/LV with LUKS
```
parted /dev/sdc mklabel msdos mkpart primary 1M 100% set 1 lvm on
pvcreate /dev/sdc1
vgextend vg_crypt /dev/sdc1
lvextend -L +10G  /dev/mapper/vg_crypt-lv_crypt
  Size of logical volume vg_crypt/lv_crypt changed from 11.00 GiB (2816 extents) to 21.00 GiB (5376 extents).
  Logical volume lv_crypt successfully resized.

cryptsetup resize /dev/mapper/vg_crypt-lv_crypt
xfs_growfs /dev/mapper/crypted_lvm
```

### Create part/VG/LV/FS
```
parted /dev/sdb mklabel msdos mkpart primary 1M 100% set 1 lvm on
pvcreate /dev/sdb1
vgcreate vg_pgsql /dev/sdb1
  lvcreate -L 20G -n lv_pgsql vg_pgsql
  or
  lvcreate -l 100%FREE -n lv_pgsql vg_pgsql
mkfs.xfs /dev/mapper/vg_pgsql-lv_pgsql
```

### Add disk to VG and grow
```
parted /dev/xvdr mklabel msdos mkpart primary 1M 100% set 1 lvm on
pvcreate /dev/xvdr1
vgextend vg_new_docs /dev/xvdr1
lvextend -l +100%FREE /dev/vg_new_docs/lv_doku
xfs_growfs /dev/vg_new_docs/lv_doku
```

### Growpart if disk was increased
```
growpart /dev/sda 1
pvscan
lvscan
lvextend -l +100%FREE /dev/mapper/lvm_pool_data1-lvol001
xfs_growfs /dev/mapper/lvm_pool_data1-lvol001
```

### Deactive/Active LV
```
lvchange -an /dev/lvm_pool_data1/lvol001
lvchange -ay /dev/lvm_pool_data1/lvol001
```

### LVM reduce

```
e2fsck -f /dev/mapper/VolGroup00-orabackup
resize2fs /dev/mapper/VolGroup00-orabackup 60G
lvreduce -L 60G /dev/mapper/VolGroup00-orabackup
```

```
[root@TEST ~]# pvs -o+pv_used
  PV         VG         Fmt  Attr PSize  PFree  Used
  /dev/xvda2 VolGroup00 lvm2 a--  29.88G     0  29.88G
  /dev/xvdb1 VolGroup00 lvm2 a--  63.47G 33.47G 30.00G
  /dev/xvdc1 VolGroup00 lvm2 a--  68.34G 63.34G  5.00G
```
```
[root@TEST ~]# pvmove /dev/xvdc1
  /dev/xvdc1: Moved: 0.0%
  /dev/xvdc1: Moved: 5.0%
  /dev/xvdc1: Moved: 10.0%
  /dev/xvdc1: Moved: 15.0%
  /dev/xvdc1: Moved: 20.6%
  /dev/xvdc1: Moved: 25.6%
  /dev/xvdc1: Moved: 30.6%
  /dev/xvdc1: Moved: 36.2%
  /dev/xvdc1: Moved: 41.2%
  /dev/xvdc1: Moved: 46.2%
  /dev/xvdc1: Moved: 51.9%
  /dev/xvdc1: Moved: 56.9%
  /dev/xvdc1: Moved: 62.5%
  /dev/xvdc1: Moved: 67.5%
  /dev/xvdc1: Moved: 72.5%
  /dev/xvdc1: Moved: 78.1%
  /dev/xvdc1: Moved: 83.1%
  /dev/xvdc1: Moved: 88.1%
  /dev/xvdc1: Moved: 93.8%
  /dev/xvdc1: Moved: 98.8%
  /dev/xvdc1: Moved: 100.0%
```
```
[root@TEST ~]# pvs -o+pv_used
  PV         VG         Fmt  Attr PSize  PFree  Used
  /dev/xvda2 VolGroup00 lvm2 a--  29.88G     0  29.88G
  /dev/xvdb1 VolGroup00 lvm2 a--  63.47G 28.47G 35.00G
  /dev/xvdc1 VolGroup00 lvm2 a--  68.34G 68.34G     0
```
9.	vgreduce VolGroup00 /dev/xvdc1
```
[root@TEST ~]# vgreduce VolGroup00 /dev/xvdc1
  Removed "/dev/xvdc1" from volume group "VolGroup00"
```
10.	pvremove
```
[root@TEST ~]# pvs
  PV         VG         Fmt  Attr PSize  PFree
  /dev/xvda2 VolGroup00 lvm2 a--  29.88G     0
  /dev/xvdb1 VolGroup00 lvm2 a--  63.47G 28.47G
  /dev/xvdc1            lvm2 a--  68.35G 68.35G
[root@STEST ~]# pvremove /dev/xvdc1
  Labels on physical volume "/dev/xvdc1" successfully wiped
```


### Mounting a Windows fileshare (tested with RHEL6)
```
Manually:
mount -t cifs -o username=domain/user //ms-hostname/winfolder$ /mnt/

Fstab entry:
//ms-hostname/winfolder$ /mnt/  cifs  username=domain/user,password=SomePasswords,iocharset=utf8  0  0
```

### Find dublicates in fstab
```
grep -vE "^#"  /etc/fstab  | awk  '{print $2}' |  uniq -d
```

##
## Permissions

### Test permissions of file/folder for user, works even when user has "nologin"
```
# su -s /bin/bash td-agent
$ ls -la /var/log/
```

##
## Text manipulation with SED, AWK

### SED: Replace in file (Mac)
```
sed -i '' 's/ARENDUS_FULL/DEV_FULL/g' developer_role.txt
```

### SED: Insert line at very end
```
# Add tmp as in-memory entry to fstab
sed -i -e '$atmpfs /tmp tmpfs strictatime,noexec,nodev,nosuid 0 0' /etc/fstab```
```

### SED: Insert line before match found
```
sed -i 's/.*plugins=ifcfg-rh,ibft.*/dns=none\n&/' /etc/NetworkManager/NetworkManager.conf
```

### SED: replace IP in file
```
sed -i -e 's/11\.4\.0\.27/11\.4\.0\.10/g' terraform-outputs.yml
```

### SED with find: Replacing values in multiple files inside directory (Mac)
```
find foldername -type f -exec grep -H 'hostname' {} \;
find foldername -type f -name "*.yaml" -exec sed -i '' 's/hostname.local/new-hostname.local/g' {} \;
```

### SED with find: Replacing values in multiple files inside directory (Linux)
```
find foldername/*/some-other/ -type f -name "*.yaml" -exec grep -H 'hostname' {} \;
find foldername/*/some-other/ -type f -name "*.yaml" -exec sed -i 's/hostname.local/new-hostname.local/g' {} \;
```

### SED with find: Replacing multiple values in multiple files in subdirectories (Mac)
```
find foldername/*/openstack  -type f -name "*.yaml" -exec sed -i '' '/firewall:/d;/l7policy:/d;/listener:/d;/member:/d;/healthmonitor:/d;/loadbalancer:/d' {} \
```

### GREP: Print line before, don't print match
```
grep -B 1 Dead alert.log | grep -vE 'Dead|^--$'
```

### AWK: List of all locked accounts (accounts with passwords) :
```
awk -F: '{ system("passwd -S " $1)}' /etc/passwd | grep " LK "
```
### AWK: List of all unlocked accounts (accounts with passwords) :
```
awk -F: '{ system("passwd -S " $1)}' /etc/passwd | grep " PS "
```

### Tail: Show file content with file names
```
tail -v -n +1 /u02/app/oracle/product/*/*/network/admin/sqlnet.ora
```
Example output
```
==> /u02/app/oracle/product/18.0.0.0/dbhome_6/network/admin/sqlnet.ora <==
SQLNET.ENCRYPTION_SERVER = required
SQLNET.CRYPTO_CHECKSUM_SERVER = required

==> /u02/app/oracle/product/19.0.0.0/dbhome_2/network/admin/sqlnet.ora <==
SQLNET.ENCRYPTION_SERVER = required
SQLNET.CRYPTO_CHECKSUM_SERVER = required
```

## Perfomance

### vmstat

Detecting a server with CPU resource problems is simple. When the value of the runqueue "r" column exceeds the number of CPUs on the server, tasks are forced to wait for execution.
```
[oracle@vm01 ~]$ vmstat 5 5
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
40  1      0 33275964 750340 30270020    0    0    22   104    1    3 65 16  1  0 18
15  0      0 33310408 750340 30270336    0    0     7   326 28836 30509 70 19  0  0 10
42  0      0 33285596 750340 30270972    0    0     6   249 28673 31171 72 16  0  0 12
24  0      0 33317896 750340 30271336    0    0     6   196 17484 20959 54 14  0  0 32
44  0      0 33308640 750344 30271788    0    0    14  1677 22492 25631 61 16  0  0 22
```

### top
...
### htop
...


## SSH keys

### ssh-keygen: generate private and public key to file
```
ssh-keygen -t rsa -b 4096 -out filename
```

### Convert MIIE key content

Copy the value of the private_key_pem field.
Reformat the copied value and save it in the current directory to a file named PRIVATE-KEY-FILE. Run:

printf -- "YOUR-PRIVATE-KEY" > PRIVATE-KEY-FILE
Where:

YOUR-PRIVATE-KEY is the text of your private key.
PRIVATE-KEY-FILE is the path to the private key file you are creating.
For example:
```
$ printf --  "-----BEGIN RSA PRIVATE KEY----- MIIEkeycontents ----END RSA PRIVATE KEY-----" > bbr_key.pem
```

## VIM magic

### vim: How to insert a block of white spaces starting at the cursor position in VI
```
1. Go in block visual mode ctrl-v
2. Select the lines you want to modify
3. Press shift+i (capital i)
4. Apply any changes for the first line.
5. Leaving visual mode esc will apply all changes on the first line to all lines.
```

### vim: Delete the first X spaces for multiple lines
```
1. Go in block visual mode ctrl-v
2. Select the area to delete with the arrows;
3. Then press d to delete the selected area.
4. Press Esc
```

### vim: Delete multiple lines
```
1. Press the Esc key to go to normal mode.
2. Place the cursor on the first line you want to delete.
3. Type 5dd and hit Enter to delete the next five lines.
```

## SElinux
### ausearch: audit daemon logs for date
```
ausearch -m avc -ts 10/22/2021
```
### restorecon: restore file(s) default SELinux security contexts.
```
restorecon /etc/shadow
```

## YAML

### YAML validator -> yamllint


## Find
### Find with file name
```
find / -name logstash.yml
```

## Network
### Route (RHEL6)
```
cat /etc/sysconfig/network-scripts/route-eth0
10.00.4.0/24 via 10.00.6.33 dev eth0
10.00.2.0/24 via 10.00.6.33 dev eth0
```

### Poor man port forwarding
```
ncat -l –k 844 --sh-exec "ncat 192.168.12.7 84" &
```


## Cron and stuff
### Flock usage
```
53 3 * * * root  /usr/bin/flock -n /var/lock/rman.lock /bin/bash /root/rman-ln.sh full
*/10 0,1,2,3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * * root  /usr/bin/flock -n /var/lock/rman.lock /bin/bash /root/rman-ln.sh arch
```


### Bring colors to shell
```
[<LIVE> user@bastion ~]$ cat /etc/profile.d/label.sh
shortname=$(/bin/hostname | /bin/cut -c 9-14)
export PS1='\[\e[1;31m\][<LIVE> \u@$shortname \W]\[\e[0m\]$ '
```

### FTP script
```
#!/bin/sh
HOST='193.3.4.5'
USER='user'
PASSWD='********'
ftp -n -v $HOST << EOT
binary
user $USER $PASSWD
prompt
cd DUMP/20161231
mput 20161231_0*.dmp
bye
EOT
```


### Split logs
```
split -b 141m B8465job2.log
```


### sync logs to nfs
```
 /bin/df -t nfs | /bin/grep /2ndarchlog && touch /2ndarchlog/test && time -p (rsync -rvu --progress --exclude-from=/root/rsync-excludes --delete /backup/rman/ /2ndarchlog && echo 'Sync archivelog done in:')
```


## Concatenate multiple files and include filename as section headers
```
more *.sh | cat
```



## Disk speed quick and easy
```
[root@DB11-01 bin]# hdparm -tT /dev/xvdb1

/dev/xvdb1:
Timing cached reads:   6044 MB in  1.99 seconds = 3032.71 MB/sec
Timing buffered disk reads:  222 MB in  3.01 seconds =  73.67 MB/sec

[root@DB11-01 bin]# hdparm -tT /dev/xvdc1
/dev/xvdc1:
Timing cached reads:   6132 MB in  1.99 seconds = 3076.04 MB/sec
Timing buffered disk reads:  302 MB in  3.01 seconds = 100.46 MB/sec
```

## Curl
### Download Mozilla CA certificate store in PEM format

```
[ -f cacert.pem ] || curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
```


## Snmpwalk examples

### SNMP v2c

```
$ snmpwalk -v2c -c <community-string>  192.168.0.1
```

### SNMP v3
# Export password
```
$ export SNMPPASS=‘***’*******
$ snmpwalk -v3 -l authPriv -u USERNAME -a SHA1 -A $SNMPPASS -x AES128 -X $SNMPPASS 192.168.0.1
```