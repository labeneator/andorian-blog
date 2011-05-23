#!/bin/bash - 
#===============================================================================
#
#          FILE:  heartbeat.sh
# 
#         USAGE:  ./heartbeat.sh 
# 
#   DESCRIPTION:  Runs mk-heartbeat. Can be cron'd

# 
#
#       OPTIONS:  ---
#  REQUIREMENTS:  maatkit in your path
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Laban Mwangi (lmwangi), lmwangi@gmail.com
#       COMPANY: 
#       CREATED: 13/05/11 11:46:27 MUT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

DBUSER=maatkit
DBPASS="xxxxxxx"
DB="maatkit"
TABLE="heartbeat"
# Seconds
INTERVAL=15

#Daemon check
IS_ALIVE=$(ps aux|grep mk-heart|grep daemon|wc -l)

# Start it if it's dead
if [ $IS_ALIVE -eq 0 ]; 
then
	perl mk-heartbeat -u $DBUSER -p${DBPASS} --database $DB --table $TABLE --update --host 127.0.0.1 --create-table --daemonize --interval $INTERVAL;
fi
