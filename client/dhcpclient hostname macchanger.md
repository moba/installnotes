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
    /usr/bin/macchanger -e wlan0
    /usr/bin/macchanger -e eth0

This generates a random MAC from the same vendor every time you (re)start the network interface. Some people prefer "-a" (any vendor of similar device), "-A" (random vendor, random device), or "-r" (fully random).

Don't forget to make that script executable.
