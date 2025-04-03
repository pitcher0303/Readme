usage() {
  cat <<EOM
Usage:
 $(basename "$0") <optstring> <parameters>
 $(basename "$0") [options] [--] <optstring> <parameters>
 $(basename "$0") [options] -o|--options <optstring> [options] [--] <parameters

Options:
 -h, --help               (optional) : display this help
 -p, --profile            (required) : Spring profiles active ex.)dev or dev,oauth
 -t, --trustStore         (required) : TrustStore that holds ssl certificate
 -T, --trustStorePassword (optional) : Password used to access the trust store
EOM
  exit 1
}

err_msg() { echo "$@"; } >&2
err_msg_p() { err_msg "-p, --profile option [Spring profiles active] required"; }
err_msg_t() { err_msg "-t, --trustStore option [TrustStore that holds ssl certificate] required"; }
err_msg_T() { err_msg "-T, --trustStorePassword option [Password used to access the trust store] optional"; }

if [[ $# -eq 0 ]]; then
  err_msg "설정된 옵션이 없습니다."
  usage
fi

PROFILE=
TRUST_STORE=
TRUST_STORE_PASSWORD=

arguments=$(getopt --options p:t:T:h \
  --longoptions profile:,trustStore:,trustStorePassword:,help \
  --name $(basename $0) \
  -- "$@")

eval set -- "$arguments"

while true; do
  case "$1" in
  -p | --profile)
    PROFILE=$2
    shift 2
    ;;
  -t | --trustStore)
    TRUST_STORE=$2
    shift 2
    ;;
  -T | --trustStorePassword)
    TRUST_STORE_PASSWORD=$2
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

# 남아있는 인자 얻기, 남아있는 인자는 url이다
shift $((OPTIND - 1))
echo "$@"

if [ -z "$PROFILE" ]; then
  err_msg_p
  exit 1
fi

if [ -z "$TRUST_STORE" ]; then
  err_msg_t
  exit 1
fi

IP_ADDRESS=$(hostname -I | awk '{print $2}')
JAVA_HOME=${JAVA_HOME}
RELATIVE_DIR=$(dirname '$0')
APP_HOME=$(readlink -f $RELATIVE_DIR/..)
APP_NAME=$(echo ${JAR_FILE_NAME} | sed -e 's/\.jar//g')
JAVA_PARAMETER=

if [ -n "$PROFILE" ]; then
  JAVA_PARAMETER=${JAVA_PARAMETER}" -Dprofiles.active=$PROFILE"
fi

if [ -n "$TRUST_STORE" ]; then
  JAVA_PARAMETER=${JAVA_PARAMETER}" -Djavax.net.ssl.trustStore=${TRUST_STORE}"
fi

if [ -n "$TRUST_STORE_PASSWORD" ]; then
  JAVA_PARAMETER=${JAVA_PARAMETER}" -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD}"
fi

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
