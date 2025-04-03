IP_ADDRESS=$(hostname -I | awk '{print $2}')
JAVA_HOME=${JAVA_HOME}
RELATIVE_DIR=$(dirname '$0')
APP_HOME=$(readlink -f $RELATIVE_DIR/..)
APP_NAME=$(echo ${JAR_FILE_NAME} | sed -e 's/\.jar//g')

if [[ $# -eq 1 ]]; then
  JAVA_PARAMATER=${JAVA_PARAMATER}" -Dprofiles.active=$1"
fi

JAVA_OPTS="-server -Xms2048m -Xmx2048m"
JAVA_PARAMATER=${JAVA_PARAMATER}" -DSERVER_IP=${IP_ADDRESS}"

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
  #nohup ${JAVA_HOME}/bin/java ${JAVA_OPTS} ${JAVA_PARAMATER} -cp "${APP_NAME}.jar:./lib/*:./conf" ${MAIN_CLASS_FULL_PATH} > ${APP_NAME}.out &
  nohup ${JAVA_HOME}/bin/java ${JAVA_OPTS} ${JAVA_PARAMATER} -cp "${APP_NAME}.jar:./lib/*:./conf" ${MAIN_CLASS_FULL_PATH} >/dev/null 2>&1 &
  exit 0
else
  echo "already running app... pid : ${APP_PID}"
  exit 1
fi
