# DHCP: Hide hostname, random MAC address 

## Change Hostname

### /etc/dhcp/dhclient.conf 

By default, dhcpclient sends your local hostname to the DHCP:

    send host-name = gethostname();

I did not try yet, but maybe you could point it to a different source for the name, and have a list of popular hostnames. I'm not so much a fan of randomly generating a hostname every time.

For now, I've disabled sending a hostname completely, as DHCP does not require it. Just comment out that line.

## Change MAC Address

    sudo apt-get install macchanger

### /etc/network/if-pre-up.d/macchanger 

    #!/bin/sh
    /usr/bin/macchanger -a wlan0
    /usr/bin/macchanger -a eth0

This should generate a random MAC from the same vendor every time you (re)start the network interface. For some reason, for me, it generates a new MAC from a random vendor instead (the argument for that should be -A).

Don't forget to make that script executable.
