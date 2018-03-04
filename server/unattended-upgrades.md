# install

```
sudo apt install unattended-upgrades update-notifier-common
sudo dpkg-reconfigure unattended-upgrades
```

# /etc/apt/apt.conf.d/50unattended-upgrades

```
// update everything from all sources (DANGEROUS)
Unattended-Upgrade::Allowed-Origins { "*:*"; }

// leave modified  configs alone, replace unmodified config
Dpkg::Options { "--force-confdef"; "--force-confold"; }
// also update on dev releases
Unattended-Upgrade::DevRelease "true";
```
