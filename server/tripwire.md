# tripwire

    apt-get install tripwire
    tripwire --init
    
# /etc/tripwire/twpol.txt

    see [tripwire-twpol.txt]

# edit twpol until no errors

    /usr/sbin/twadmin -m P /etc/tripwire/twpol.txt
    /usr/sbin/tripwire -m i

# check and update db

    tripwire --check --interactive
    
# cronjob to check

    30 4 * * * /usr/sbin/tripwire --check

