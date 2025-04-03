#crontab script
#------------------------------------------------#
# Nginx log rotate script                        #
#                                                #
# This file will locate on under nginx root path #
# ex.) nginx/rotatelogs/rotate-log.sh            #
#------------------------------------------------#
date=`date -Id`

YESTERDAY=$(date -d 'yesterday' '+%Y-%m-%d')

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
BASE_DIR=$(cd $SCRIPT_DIR/..;pwd)
LOG_DIR=/logs

echo $BASE_DIR

PID_FILE=$BASE_DIR$LOG_DIR/nginx.pid

ACCESS_LOG_FILE=$BASE_DIR$LOG_DIR/access.log
ERROR_LOG_FILE=$BASE_DIR$LOG_DIR/error.log
YESTERDAY_ACCESS_LOG_FILE=$BASE_DIR$LOG_DIR/access.log.$YESTERDAY
YESTERDAY_ERROR_LOG_FILE=$BASE_DIR$LOG_DIR/error.log.$YESTERDAY

echo find "$YESTERDAY_ACCESS_LOG_FILE"
if [ ! -f "$YESTERDAY_ACCESS_LOG_FILE" ]; then
  echo not found "$YESTERDAY_ACCESS_LOG_FILE"
  echo make  "$YESTERDAY_ACCESS_LOG_FILE"
  mv $ACCESS_LOG_FILE $YESTERDAY_ACCESS_LOG_FILE
else
  echo detected "$YESTERDAY_ACCESS_LOG_FILE"
  echo append $ACCESS_LOG_FILE to $YESTERDAY_ACCESS_LOG_FILE
  cat "$ACCESS_LOG_FILE" >> "$YESTERDAY_ACCESS_LOG_FILE"
  rm -f "$ACCESS_LOG_FILE"
fi

echo find "$YESTERDAY_ERROR_LOG_FILE"
if [ ! -f "$YESTERDAY_ERROR_LOG_FILE" ]; then
  echo not found "$YESTERDAY_ERROR_LOG_FILE"
  echo make "$YESTERDAY_ERROR_LOG_FILE"
  mv $ERROR_LOG_FILE $YESTERDAY_ERROR_LOG_FILE
else
  echo detected "$YESTERDAY_ERROR_LOG_FILE"
  echo append $ERROR_LOG_FILE to $YESTERDAY_ERROR_LOG_FILE
  cat "$ERROR_LOG_FILE" >> "$YESTERDAY_ERROR_LOG_FILE"
  rm -f "$ERROR_LOG_FILE"
fi

kill -USR1 $(cat $PID_FILE)

#echo before 7 days file deleted
for f in `find $BASE_DIR$LOG_DIR -name '*.log.*' -mtime +6 #-delete`; do
  echo delete "$f"
#  rm -f "$f"
done
