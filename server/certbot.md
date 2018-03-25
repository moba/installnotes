    echo "deb http://ftp.debian.org/debian jessie-backports main" >  /etc/apt/sources.list.d/jessie-backports.list
    apt-get update
    apt-get install certbot

# webroot way

```
certbot certonly --webroot -w /var/www/example -d example.com -d www.example.com -w /var/www/thing -d thing.is -d m.thing.is
```

# crontab

```
0 5 * * 0 certbot -q renew --renew-hook "/usr/sbin/service nginx reload; /usr/sbin/service postfix reload"
```

# /usr/local/bin/certbot-nosudo:

```
#!/bin/sh
#
# file: certbot-nosudo
if [ -z $LETSENCRYPT_NOSUDO_DIR ]; then
   LETSENCRYPT_NOSUDO_DIR=~/.certbot
fi
certbot \
  --config-dir ${LETSENCRYPT_NOSUDO_DIR}/config \
  --logs-dir ${LETSENCRYPT_NOSUDO_DIR}/logs \
  --work-dir ${LETSENCRYPT_NOSUDO_DIR} \
  $*
exit $?

mkdir /var/www/letsencrypt/
chown certbot:certbot /var/www/letsencrypt/

adduser certbot
su certbot
```

$ /home/certbot/certbot-nosudo certonly --webroot -w /var/www/letsencrypt/ -d example.org -d www.example.org

$ crontab -e

0 4 * * 0,4 /usr/local/bin/certbot-nosudo renew --quiet --noninteractive --no-self-upgrade


## postfix

```
smtpd_tls_cert_file=/home/certbot/.certbot/config/live/mail.example.org/fullchain.pem
smtpd_tls_key_file=/home/certbot/.certbot/config/live/mail.example.org/privkey.pem
smtpd_use_tls=yes
smtpd_tls_loglevel = 1
smtpd_tls_protocols = !SSLv2, !SSLv3
smtpd_tls_ciphers = high
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtp_tls_security_level = encrypt
```

## nginx

```
        ssl_certificate /home/certbot/.certbot/config/live/lists.techcultivation.org/fullchain.pem;
        ssl_certificate_key /home/certbot/.certbot/config/live/lists.techcultivation.org/privkey.pem;
```
