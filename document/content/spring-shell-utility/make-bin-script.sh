#!/bin/bash

usage() {
  err_msg "Usage: $(basename "$0") -h <java_home_path> -j <jar path> -m <main class full path>"
  exit 1
}

usage() {
  cat <<EOM
Usage: $(basename "$0") -h <java_home_path> -j <jar path> [-m <main class full path>]
Options:
 -h (required) : <java_home_path> Specify Java Home Path
 -j (required) : <jar path> Executable Jar Path
 -m (required) : <main class full path> indicate specific Main Class
EOM
  exit 1
}

err_msg() { echo "$@"; } >&2
err_msg_h() { err_msg "-h option <java_home_path> required"; }
err_msg_j() { err_msg "-j option <jar path> required"; }
err_msg_m() { err_msg "-m option <main class full path> required"; }

while getopts ":h:j:m:" opt; do
  case $opt in
  h)
    JAVA_HOME=$OPTARG
    CURRENT_DIR=$(pwd)
    cd $JAVA_HOME
    JAVA_HOME=$(pwd)
    cd $CURRENT_DIR
    [ ! -d "$JAVA_HOME" ] && {
      err_msg_h
      usage
    }
    ;;
  j)
    JAR_FILE_NAME=$OPTARG
    [ -z "$JAR_FILE_NAME" ] && {
      err_msg_j
      usage
    }
    ;;
  m)
    MAIN_CLASS_FULL_PATH=$OPTARG
    [ -z "$MAIN_CLASS_FULL_PATH" ] || [[ $MAIN_CLASS_FULL_PATH =~ ^-h ]] || [[ $MAIN_CLASS_FULL_PATH =~ ^-j ]] && {
      err_msg_m
      usage
    }
    ;;
  :)
    case $OPTARG in
    h) err_msg_h ;;
    j) err_msg_j ;;
    m) err_msg_m ;;
    esac
    usage
    ;;
  \?)
    err_msg "Invalid option: -$OPTARG"
    usage
    ;;
  esac
done

if [ -z "$JAVA_HOME" ] || [ -z "$JAR_FILE_NAME" ] || [ -z "$MAIN_CLASS_FULL_PATH" ]; then
  usage
fi

JAR_FILE_NAME=$(basename $JAR_FILE_NAME)
echo "-h(JAVA_HOME): $JAVA_HOME"
echo "-j(JAR_FILE_NAME): $JAR_FILE_NAME"
echo "-m(MAIN_CLASS_FULL_PATH): $MAIN_CLASS_FULL_PATH"

RELATIVE_DIR=$(dirname "$0")
START_SHELL_FILE=$RELATIVE_DIR/start.sh
STOP_SHELL_FILE=$RELATIVE_DIR/stop.sh

echo ""
echo "make start.sh"
echo "."
sleep 1
echo ".."
sleep 1

__START_SHELL_FILE="#!/bin/sh

IP_ADDRESS=\$(hostname -I | awk '{print \$2}')
JAVA_HOME=${JAVA_HOME}

RELATIVE_DIR=\$(dirname '\$0')
APP_HOME=\$(readlink -f \$RELATIVE_DIR/..)
APP_NAME=$(echo ${JAR_FILE_NAME} | sed -e 's/\.jar//g')

if [[ \$# -eq 1 ]]; then
  JAVA_PARAMATER=\${JAVA_PARAMATER}\" -Dspring.profiles.active=\$1\"
fi

JAVA_OPTS=\"-server -Xms2048m -Xmx2048m\"
JAVA_PARAMATER=\${JAVA_PARAMATER}\" -DSERVER_IP=\${IP_ADDRESS}\"

APP_PID=\$(ps -ef | grep \"\${APP_NAME}.jar\" | grep -v grep | awk '{print \$2}')

if [ -z \$APP_PID ]; then
  echo \"start app ... app name : \${APP_NAME}\"
  cd \$APP_HOME
  mkdir -p out
  mv ./\${APP_NAME}.out ./out/\${APP_NAME}.out.\$(date +%y%m%d_%H%M%S)
  #nohup \${JAVA_HOME}/bin/java \${JAVA_OPTS} \${JAVA_PARAMATER} -cp \"\${APP_NAME}.jar:./lib/*:./conf\" ${MAIN_CLASS_FULL_PATH} > \${APP_NAME}.out &
  nohup \${JAVA_HOME}/bin/java \${JAVA_OPTS} \${JAVA_PARAMATER} -cp \"\${APP_NAME}.jar:./lib/*:./conf\" ${MAIN_CLASS_FULL_PATH} >/dev/null 2>&1 &
else
  echo \"already running app... pid : \${APP_PID}\"
fi
"

echo "$__START_SHELL_FILE" >${START_SHELL_FILE}

echo ""
echo "make stop.sh"
echo "."
sleep 1
echo ".."
sleep 1

__STOP_SHELL_FILE="#!/bin/sh
JAR_FILE_NAME=${JAR_FILE_NAME}

APP_PID=\$(ps -ef | grep \"\$JAR_FILE_NAME\" | grep -v grep | awk '{print \$2}')

if [[ -z \$APP_PID ]]; then
	echo 'no running app'
else
	echo \"kill signal to app... pid : \${APP_PID}\"
	kill \${APP_PID}
fi
"

echo "$__STOP_SHELL_FILE" >${STOP_SHELL_FILE}
