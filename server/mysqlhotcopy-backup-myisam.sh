#!/bin/sh
# 
# mysqlhotcopy backup all databases
# only works for MyISAM tables! include dbs with InnoDB tables in DBFILTER
#
# http://www.debianroot.de/server/mysql-backup-mysqldump-mysqlhotcopy-1060.html

BACKUPDIR="/backups/db";
DBFILTER="(information_schema|dev|tmp)";
MYSQLHOTCOPY="$(which mysqlhotcopy) --noindices -q";
DIRNAME=`date +%Y-%m`;

MYSQL=$(which mysql);
TAR=$(which tar);
NICE=$(which nice);
EGREP=$(which egrep);

TEMPSAVEDIR=`mktemp -d -t mysqlhotcopybackup.XXXXXX` || exit 1

mkdir -p "$BACKUPDIR/$DIRNAME";

DBS=$($MYSQL -Bse "show databases");
for db in $DBS
do
	if !(echo $db | $EGREP $DBFILTER > /dev/null); 
	then
		FILENAME="$db-`date +%Y_%m_%d_%H_%M_%S`.tar.gz";
		mkdir -p "$TEMPSAVEDIR";
		$NICE -n 20 $MYSQLHOTCOPY $db "$TEMPSAVEDIR";
		$NICE -n 20 $TAR -cPzf "$BACKUPDIR/$DIRNAME/$FILENAME" "$TEMPSAVEDIR";
		rm -rf "$TEMPSAVEDIR";
	fi
done
