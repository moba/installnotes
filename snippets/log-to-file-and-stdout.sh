# write stdout and stderr to logfile 

LOG_FILE=$(date +%Y%m%d%H%M%S).log
exec 1> >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

