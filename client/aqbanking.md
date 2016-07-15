# aqbanking

    apt-get install aqbanking-tools

# GLS

    # aqbanking-cli dbinit ?
    USER=VRK000xxxxxxx
    BLZ=43060967
    aqhbci-tool4 adduser -N openlab -u $USER -b $BLZ -s https://hbci-pintan.gad.de/cgi-bin/hbciservlet -t pintan --hbciversion=300
    aqhbci-tool4 getsysid
    aqbanking-cli request --balance

    aqbanking-cli request --transactions -c transactions.ctx
    aqbanking-cli request --transactions -c transactions.ctx --fromdate=20100101 --todate=20130101 -a $ACCOUNTNR
    aqbanking-cli listtrans -c transactions.ctx --exporter=csv --profile=full -o transactions.csv
