#!/bin/sh

#crontab script
#------------------------------------------------#
# Redis log rotate script                        #
#                                                #
# This file will locate on under redis-utility root path #
# ex.) redis-utility/rotatelogs/rotate-log.sh            #
#------------------------------------------------#
#*　　　　　*　　　　　　*　　　　　*　　　　　*
#분(0-59)　시간(0-23)　일(1-31)　월(1-12)　요일(0-7)
#1 0 * * * sh redis-utility/rotatelogs/rotate-log.sh > redis-utility/rotatelogs/rotate-log.sh.log 2>&1

ROTATE_LOG=rotate-log.sh
CURRENT_DIR=$(pwd)
CRON_DESC="# Redis log rotate Cron (every 1 day 00h 01m executed)"
CRON_CMD="sh $CURRENT_DIR/$ROTATE_LOG > $CURRENT_DIR/$ROTATE_LOG.log 2>&1"
CRON_JOB="1 0 * * * $CRON_CMD"

echo "Previoud Crontab List(crontab -l)"

(crontab -l)

sleep 1
echo "..."
sleep 1

echo ""
echo "backup on current Path"
(crontab -l > before_crontab.txt)

sleep 1
echo "..."
sleep 1
echo "...."
sleep 1

echo ""
echo "Attempt Register Cron='$CRON_JOB'"

sleep 1
echo "..."
sleep 1
echo "...."
sleep 1

echo ""
echo "#####Cron Register Or Update######"
(crontab -l | grep -v -F -e "$CRON_DESC" -e "$CRON_CMD";echo "$CRON_DESC"; echo "$CRON_JOB"; echo "";) | crontab -

sleep 1
echo "..."
sleep 1
echo "...."
sleep 1

echo ""
echo "After Crontab List(crontab -l)"
(crontab -l)
