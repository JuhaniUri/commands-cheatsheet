 Here is the provided content converted to Markdown (md) format:

- [Install and Configure OpenDKIM](#install-and-configure-opendkim)
  - [Generate Dedicated Keys](#generate-dedicated-keys)
  - [Change `/etc/opendkim.conf`](#change-etcopendkimconf)
  - [Create `/etc/opendkim/key.table`](#create-etcopendkimkeytable)
  - [Create `/etc/opendkim/signing.table`](#create-etcopendkimsigningtable)
  - [Create `/etc/opendkim/internalhosts`](#create-etcopendkiminternalhosts)
  - [Change Ownership](#change-ownership)
  - [Add to `/etc/postfix/main.cf`](#add-to-etcpostfixmaincf)
  - [Restart OpenDKIM and Postfix](#restart-opendkim-and-postfix)
- [Testing](#testing)
  - [Domain with DKIM](#domain-with-dkim)
    - [From logs you should see DKIM-Signature field added](#from-logs-you-should-see-dkim-signature-field-added)
  - [Domain without DKIM](#domain-without-dkim)
    - [From the logs you should see "no signing table match for '"](#from-the-logs-you-should-see-no-signing-table-match-for-)


# Install and Configure OpenDKIM

```bash
apt -y install opendkim opendkim-tools perl-Getopt-Long
```

## Generate Dedicated Keys

```bash
mkdir /etc/opendkim
opendkim-genkey -D /etc/opendkim/example.ee -d example.ee -s mydkim01
opendkim-genkey -D /etc/opendkim/example.lv -d example.lv -s mydkim01
```

## Change `/etc/opendkim.conf`

```
Socket                  inet:8891@localhost
PidFile                 /run/opendkim/opendkim.pid
UserID                  opendkim
UMask                   007
Mode                    s
Syslog                  yes
SyslogSuccess           yes
LogWhy                  yes
KeyTable                /etc/opendkim/key.table
SigningTable            /etc/opendkim/signing.table
InternalHosts           /etc/opendkim/internalhosts
Domain                  smtp.tes.ee
RequireSafeKeys         False
```

## Create `/etc/opendkim/key.table`

```
mydkim01._domainkey.examle.ee examle.ee:mydkim01:/etc/opendkim/example.ee/mydkim01.private
mydkim01._domainkey.examle.lv examle.lv:mydkim01:/etc/opendkim/example.lv/mydkim01.private
```

## Create `/etc/opendkim/signing.table`

```
example.ee mydkim01._domainkey.example.ee
example.lv mydkim01._domainkey.example.lv
```

## Create `/etc/opendkim/internalhosts`

```
your subnet
192.168.0.0/16
127.0.0.1
::1
```

## Change Ownership

```bash
chown -R opendkim:mail /etc/opendkim
```

## Add to `/etc/postfix/main.cf`

```plaintext
# For opendkim
smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = $smtpd_milters
milter_default_action = accept
```

## Restart OpenDKIM and Postfix

```bash
systemctl enable opendkim; systemctl restart opendkim
systemctl restart postfix
```

# Testing

## Domain with DKIM

```bash
echo "Hello" | mail -s "testing" -r info@example.ee myemail@gmail.com
```

### From logs you should see DKIM-Signature field added

```bash
cat /var/log/mail.log | grep opendkim
Mar 12 11:22:03 smtp opendkim[3905285]: 6F392200AC: DKIM-Signature field added (s=mydkim01, d=example.ee)
```


## Domain without DKIM

```bash
echo "Hello" | mail -s "testing" -r info@notexample.ee myexampl@gmail.com
```

### From the logs you should see "no signing table match for '"

```bash
cat /var/log/mail.log | grep opendkim
Mar 12 12:05:12 smtp opendkim[3907647]: EBB59200AE: no signing table match for 'info@notexample.ee'
```



