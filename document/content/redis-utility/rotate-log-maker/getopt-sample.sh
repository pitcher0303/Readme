#!/bin/sh

#crontab script
#------------------------------------------------#
# Redis log rotate script                        #
#                                                #
# This file may locate on under redis-utility root path  #
# ex.) redis-utility/rotatelogs/rotate-log.sh            #
#------------------------------------------------#

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
FILES=

set -eou pipefail

arguments=$(getopt --options hc:f: \
  --longoptions help,cron:,files: \
  --name $(basename $0) \
  -- "$@")

echo "$arguments"
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
    FILES+=($2)
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
echo "-------------------------------"
FILES=(${FILES[@]} $@)

set +eou pipefail

if [ -z "$CRON_SCHEDULE" ]; then
  err_msg_c
  exit 1
fi

if [ -z "$FILES" ]; then
  err_msg_f
  exit 1
fi

# FILES 목록 순회
for FILE in "${FILES[@]}"; do
  echo "FILE: $FILE"
  if [ ! -f $FILE ]; then
    echo "File does not exist"
  fi
  FILE_PATH=$(readlink -f "$FILE")
  echo "$(dirname "$FILE_PATH")"
done
