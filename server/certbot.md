    apt-get install certbot

# webroot way

```
certbot certonly --webroot -w /var/www/example -d example.com -d www.example.com -w /var/www/thing -d thing.is -d m.thing.is
```

# deploy-hook!

/etc/letsencrypt/renewal-hooks/deploy/restart-services.sh

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
