#!/bin/sh
#crontab script
#---------------------------------------------------#
# log rotate script                                 #
#---------------------------------------------------#

CALL_OPTIONS=$*

usage() {
  cat <<EOM
#crontab script
#------------------------------------------------#
# Redis log rotate script                        #
#------------------------------------------------#
Usage1: $(basename "$0") -c "<cron schedule>" -f <file1> -f <file2> -f <file3> ...
Usage2: $(basename "$0") -c "<cron schedule>" -f <file1 file2 file3 ...>

Options:
 -c, --cron            (required) : cron schedule(surround with double quotes)
                                    "*         *          *       *         *"
                                    "분(0-59)　시간(0-23) 일(1-31)　월(1-12)　요일(0-7)"
 -f, --files           (required) : file for rotate(with full path)
                                    ex.) /root/redis/redis.log /root/redis/sentinel.log
 -h, --help            (optional) : display this help
EOM
  exit 1
}

err_msg() { echo "$@"; } >&2
err_msg_c() { err_msg "-c, --cron  option [cron schedule]   required"; }
err_msg_f() { err_msg "-f, --files option [file for rotate] required"; }

if [[ $# -eq 0 ]]; then
  err_msg "필수 옵션을 설정해 주세요."
  usage
fi

CRON_SCHEDULE=
LOG_FILES=()

set -eou pipefail

arguments=$(getopt --options hc:f: \
  --longoptions help,cron:,files: \
  --name $(basename $0) \
  -- "$@")

eval set -- "$arguments"
while true; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  -c | --cron)
    CRON_SCHEDULE=$2
    shift 2
    ;;
  -f | --files)
    LOG_FILES+=($2)
    shift 2
    ;;
  --)
    shift
    break
    ;;
  *)
    echo >&2 Unsupported option: $1
    usage
    ;;
  esac
done

# 남아있는 인자 얻기 남은것은 rotate 등록할 파라미터 목록.
shift $((OPTIND - 1))
LOG_FILES=(${LOG_FILES[@]} $@)

set +eou pipefail

if [ -z "$CRON_SCHEDULE" ]; then
  err_msg_c
  exit 1
fi

if [ -z "$LOG_FILES" ]; then
  err_msg_f
  exit 1
fi

LOG_FILES_PATH=

# FILES 목록 순회
for FILE in "${LOG_FILES[@]}"; do
  if [ ! -f $FILE ]; then
    echo "File does not exist"
    usage
  fi
  LOG_FILES_PATH=(${LOG_FILES_PATH[@]} $(readlink -f "$FILE"))
done


ROTATE_LOG=rotate-log.sh
CURRENT_DIR=$(pwd)
CRON_DESC="# Redis log rotate Cron"
CRON_CMD="sh $CURRENT_DIR/$ROTATE_LOG ${LOG_FILES_PATH[@]} > $CURRENT_DIR/$ROTATE_LOG.log 2>&1"
CRON_JOB="$CRON_SCHEDULE $CRON_CMD"

echo "Previous Crontab List(crontab -l)"

(crontab -l)

sleep 1
echo "..."
sleep 1

echo ""
echo "backup on current Path"
BACK_UP_DIR=.backup
mkdir -p $BACK_UP_DIR
(crontab -l > ./$BACK_UP_DIR/before_crontab.txt)

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

CURRENT_APP_CRON=$(cat ./$BACK_UP_DIR/current_app_cron.txt)
echo ""
echo "#####Cron Register Or Update######"
if [ -z "$CURRENT_APP_CRON" ]; then
  (crontab -l | grep -v -F -e "$CRON_DESC" -e "$CRON_CMD";echo "$CRON_DESC"; echo "$CRON_JOB"; echo "";) | crontab -
else
  (crontab -l | grep -v -F -e "$CURRENT_APP_CRON";echo "$CRON_DESC"; echo "$CRON_JOB"; echo "";) | crontab -
fi
(echo "$CRON_DESC"; echo "$CRON_JOB"; echo "";) > ./$BACK_UP_DIR/current_app_cron.txt

sleep 1
echo "..."
sleep 1
echo "...."
sleep 1

echo ""
echo "After Crontab List(crontab -l)"
(crontab -l)

echo sh "$0" "$CALL_OPTIONS" > ./$BACK_UP_DIR/.register-history