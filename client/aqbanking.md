# aqbanking

    apt-get install aqbanking-tools

# GLS

    aqbanking-cli dbinit
    aqhbci-tool4 adduser -N openlab -u VRK000xyz -b VRK0000xyz -s https://hbci-pintan.gad.de/cgi-bin/hbciservlet -t pintan --hbciversion=300
    aqhbci-tool4 getsysid
    aqbanking-cli request --balance

    aqbanking-cli request --transactions -c transactions.ctx
    aqbanking-cli request --transactions -c transactions.ctx --fromdate=20100101 --todate=20130101 -a $ACCOUNTNR
    aqbanking-cli listtrans -c transactions.ctx --exporter=csv --profile=full -o transactions.csv
