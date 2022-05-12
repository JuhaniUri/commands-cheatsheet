# Useful Linux commands

- [Useful Linux commands](#useful-linux-commands)
  - [Partitions, LVM, LUKS, FS etc](#partitions-lvm-luks-fs-etc)
    - [Create file that will utilize space from storage](#create-file-that-will-utilize-space-from-storage)
    - [LUKS: Format the filesystem with LUKS and add extra password to slot1](#luks-format-the-filesystem-with-luks-and-add-extra-password-to-slot1)
    - [LUKS: Resize VG/LV with LUKS](#luks-resize-vglv-with-luks)
    - [Create part/VG/LV/FS](#create-partvglvfs)
    - [Add disk to VG and grwo](#add-disk-to-vg-and-grwo)
    - [Growpart if disk was increased](#growpart-if-disk-was-increased)
    - [Deactive/Active LV](#deactiveactive-lv)
    - [Mounting a Windows fileshare (tested with RHEL6)](#mounting-a-windows-fileshare-tested-with-rhel6)
    - [Find dublicates in fstab](#find-dublicates-in-fstab)
  - [Permissions](#permissions)
    - [Test permissions of file/folder for user, works even when user has "nologin"](#test-permissions-of-filefolder-for-user-works-even-when-user-has-nologin)
  - [Text manipulation with SED, AWK](#text-manipulation-with-sed-awk)
    - [SED: Replace in file (Mac)](#sed-replace-in-file-mac)
    - [SED: Insert line at very end](#sed-insert-line-at-very-end)
    - [SED: Insert line before match found](#sed-insert-line-before-match-found)
    - [SED: replace IP in file](#sed-replace-ip-in-file)
    - [SED with find: Replacing values in multiple files inside directory (Mac)](#sed-with-find-replacing-values-in-multiple-files-inside-directory-mac)
    - [SED with find: Replacing values in multiple files inside directory (Linux)](#sed-with-find-replacing-values-in-multiple-files-inside-directory-linux)
    - [SED with find: Replacing multiple values in multiple files in subdirectories (Mac)](#sed-with-find-replacing-multiple-values-in-multiple-files-in-subdirectories-mac)
    - [AWK: List of all locked accounts (accounts with passwords) :](#awk-list-of-all-locked-accounts-accounts-with-passwords-)
    - [AWK: List of all unlocked accounts (accounts with passwords) :](#awk-list-of-all-unlocked-accounts-accounts-with-passwords-)
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
    - [YAML validator -> yamllint](#yaml-validator---yamllint)
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

### Add disk to VG and grwo
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
lvextend -l 100%FREE /dev/mapper/lvm_pool_data1-lvol001
xfs_growfs /dev/mapper/lvm_pool_data1-lvol001
```

### Deactive/Active LV
```
lvchange -an /dev/lvm_pool_data1/lvol001
lvchange -ay /dev/lvm_pool_data1/lvol001
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


### AWK: List of all locked accounts (accounts with passwords) :
```
awk -F: '{ system("passwd -S " $1)}' /etc/passwd | grep " LK "
```
### AWK: List of all unlocked accounts (accounts with passwords) :
```
awk -F: '{ system("passwd -S " $1)}' /etc/passwd | grep " PS "
```


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
