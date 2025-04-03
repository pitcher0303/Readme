#crontab script
#---------------------------------------------------------#
# Redis log rotate script                                 #
#                                                         #
# This file will locate on under nginx root path          #
# ex.) redis-utility/rotatelogs/rotate-log.sh                     #
# TODO: LOG_DIR을 Redis Log 파일 위치 파라미터로 받게 변경 하기 #
# Logrotate를 많이 씀                                       #
#---------------------------------------------------------#
date=`date -Id`

YESTERDAY=$(date -d 'yesterday' '+%Y-%m-%d')

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
BASE_DIR=$(cd $SCRIPT_DIR/..;pwd)
LOG_DIR=/log

echo $BASE_DIR

REDIS_LOG_FILE=$BASE_DIR$LOG_DIR/redis.log
YESTERDAY_REDIS_LOG_FILE=$BASE_DIR$LOG_DIR/redis.log.$YESTERDAY

echo find "$YESTERDAY_REDIS_LOG_FILE"
if [ ! -f "$YESTERDAY_REDIS_LOG_FILE" ]; then
  echo not found "$YESTERDAY_REDIS_LOG_FILE"
  echo make  "$YESTERDAY_REDIS_LOG_FILE"
  cat $REDIS_LOG_FILE > $YESTERDAY_REDIS_LOG_FILE
else
  echo detected "$YESTERDAY_REDIS_LOG_FILE"
  echo append $REDIS_LOG_FILE to $YESTERDAY_REDIS_LOG_FILE
  cat "$REDIS_LOG_FILE" >> "$YESTERDAY_REDIS_LOG_FILE"
fi
cat /dev/null > "$REDIS_LOG_FILE"

#echo before 7 days file deleted
for f in `find $BASE_DIR$LOG_DIR -name '*.log.*' -mtime +6 #-delete`; do
  echo delete "$f"
#  rm -f "$f"
done
