usage() {
  cat <<EOM
Usage:
 $(basename "$0") <optstring> <parameters>
 $(basename "$0") [options] [--] <optstring> <parameters>
 $(basename "$0") [options] -o|--options <optstring> [options] [--] <parameters

Options:
 -h, --help            (optional) : display this help
 -j, --java-parameters (optional) : java parameter ex.)  -Dprofiles.active=[PROFILE] -Djavax.net.ssl.trustStore=[TRUST_STORE] -Djavax.net.ssl.trustStorePassword=[TRUST_STORE_PASSWORD]
EOM
  exit 1
}

err_msg() { echo "$@"; } >&2
err_msg_j() { err_msg "-j, --java-parameters option [java-parameter when start up] optional"; }

#if [[ $# -eq 0 ]]; then
#  err_msg "설정된 옵션이 없습니다."
#  usage
#fi

JAVA_PARAMETER=

arguments=$(getopt --options j:h \
  --longoptions java-parameters:,help \
  --name $(basename $0) \
  -- "$@")

eval set -- "$arguments"

while true; do
  case "$1" in
  -j | --java-parameters)
    JAVA_PARAMETER=$2
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
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

# 남아있는 인자 얻기
shift $((OPTIND - 1))
echo "$@"

IP_ADDRESS=$(hostname -I | awk '{print $2}')
JAVA_HOME=${JAVA_HOME}
RELATIVE_DIR=$(dirname '$0')
APP_HOME=$(readlink -f $RELATIVE_DIR/..)
APP_NAME=$(echo ${JAR_FILE_NAME} | sed -e 's/\.jar//g')

JAVA_OPTS="-server -Xms2048m -Xmx2048m"
JAVA_PARAMETER=${JAVA_PARAMETER}" -DSERVER_IP=${IP_ADDRESS}"

APP_PID=$(ps -ef | grep "$JAR_FILE_NAME" | grep "$MAIN_CLASS_FULL_PATH" | grep -v grep | awk '{print $2}')

if [ -z $APP_PID ]; then
  echo "started app ... app name : ${APP_NAME}"
  cd $APP_HOME || exit 1
  mkdir -p out
  if [ -f ${APP_NAME}.out ]; then
    mv ./${APP_NAME}.out ./out/${APP_NAME}.out.$(date +%y%m%d_%H%M%S)
  else
    echo ""
  fi
  #nohup ${JAVA_HOME}/bin/java ${JAVA_OPTS} ${JAVA_PARAMETER} -cp "${APP_NAME}.jar:./lib/*:./conf" ${MAIN_CLASS_FULL_PATH} > ${APP_NAME}.out &
  nohup ${JAVA_HOME}/bin/java ${JAVA_OPTS} ${JAVA_PARAMETER} -cp "${APP_NAME}.jar:./lib/*:./conf" ${MAIN_CLASS_FULL_PATH} >/dev/null 2>&1 &
  exit 0
else
  echo "already running app... pid : ${APP_PID}"
  exit 1
fi
