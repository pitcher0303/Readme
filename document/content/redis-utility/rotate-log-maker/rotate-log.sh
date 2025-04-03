#!/bin/sh

#crontab script
#---------------------------------------------------------#
# Redis log rotate script                                 #
# register-cron-rotate-log.sh로 등록하세요.                 #
#---------------------------------------------------------#
usage() {
  echo "Usage: $(basename "$0") <log_file1> <log_file2> ..."
  exit 1
}

if [[ $# -eq 0 ]]; then
  echo "least one file needed"
  usage
fi

msg() {
  prefix=$(date "+%Y-%m-%d %H:%M:%S")
  echo "$prefix $*"
}
date=$(date -Id)

YESTERDAY=$(date -d 'yesterday' '+%Y-%m-%d')
LOG_FILES=($@)

#파라미터가 파일인지 검증.
for LOG_FILE in "${LOG_FILES[@]}"; do
  if [ ! -f $LOG_FILE ]; then
    msg "[$LOG_FILE] is not a FILE."
    exit 1
  fi
done

#로그파일 로테이션
for LOG_FILE in "${LOG_FILES[@]}"; do
  #파일의 Full Path 얻기
  FILE_FULL_PATH=$(readlink -f "$LOG_FILE")
  #[파일명].어제날짜 파일명 생성
  YESTERDAY_FILE_FULL_PATH="$FILE_FULL_PATH.$YESTERDAY"
  msg find "$YESTERDAY_FILE_FULL_PATH"
  #어제 날짜 파일 없으므로 생성
  if [ ! -f "$YESTERDAY_FILE_FULL_PATH" ]; then
    msg "not found $YESTERDAY_FILE_FULL_PATH"
    msg "make  $YESTERDAY_FILE_FULL_PATH"
    cat $FILE_FULL_PATH >$YESTERDAY_FILE_FULL_PATH
  #어제 날짜 파일이 있으므로 append
  else
    msg "detected $YESTERDAY_FILE_FULL_PATH"
    msg "append $FILE_FULL_PATH to $YESTERDAY_FILE_FULL_PATH"
    cat "$FILE_FULL_PATH" >>"$YESTERDAY_FILE_FULL_PATH"
  fi
  msg "clear $FILE_FULL_PATH file..."
  #현재 파일 clear
  cat /dev/null >"$FILE_FULL_PATH"
  #현재 파일 디렉토리 얻기
  BASE_DIR=$(dirname "$FILE_FULL_PATH")
  #현재 파일의 Path를 제외한 파일명 얻기
  LOG_FILE_NAME=$(basename "$LOG_FILE")
  #7일전 파일 삭제
  DELET_BEFORE_FILES=$(find $BASE_DIR -name "$LOG_FILE_NAME.*" -mtime +6)
  msg "find delete files... cmd: find $BASE_DIR -name $LOG_FILE_NAME.* -mtime +6"
  if [[ -z "${DELET_BEFORE_FILES[*]}" ]]; then
    msg "There ara no files to delete"
  else
    for f in "${DELET_BEFORE_FILES[@]}"; do
      msg "delete file: $f"
      #rm -f "$f"
    done
  fi
done
