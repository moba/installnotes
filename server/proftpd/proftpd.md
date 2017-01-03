# proftpd
    
# directory listings cronjob

    0 */4 * * * cd /ftpdir && nice find . -type f -printf '%s %p\n' | sort -f -k 2 > INDEX.txt && nice tar cfJ /ftpdir/INDEX.txt.tar.xz -C /ftpdir/ INDEX.txt
