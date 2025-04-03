usage() {
  err_msg "Usage: $(basename "$0") -h <java_home_path> -j <jar path> [-m <main class full path>]"
  exit 1
}

usage() {
  cat <<EOM
Usage: $(basename "$0") -h <java_home_path> -j <jar path> [-m <main class full path>]
Options:
 -h (required) : <java_home_path> Specify Java Home Path
 -j (required) : <jar path> Executable Jar Path
 -m (optional) : <main class full path> indicate specific Main Class [default: ${DEFAULT_MAIN_CLASS_FULL_PATH}]
EOM
  exit 1
}

err_msg() { echo "$@"; } >&2
err_msg_h() { err_msg "-h option <java_home_path> required"; }
err_msg_j() { err_msg "-j option <jar path> required"; }
err_msg_m() { err_msg "-m option <main class full path> optional"; }

while getopts ":h:j:m:" opt; do
  case $opt in
  h)
    JAVA_HOME=$OPTARG
    CURRENT_DIR=$(pwd)
    cd $JAVA_HOME || exit 1;
    JAVA_HOME=$(pwd)
    cd $CURRENT_DIR || exit 1;
    [ ! -d "$JAVA_HOME" ] && {
      err_msg_h
      usage
    }
    ;;
  j)
    JAR_FILE_PATH=$OPTARG
    [ -z "$JAR_FILE_PATH" ] && {
      err_msg_j
      usage
    }
    ;;
  m)
    MAIN_CLASS_FULL_PATH=$OPTARG
    [[ $MAIN_CLASS_FULL_PATH =~ ^-h ]] || [[ $MAIN_CLASS_FULL_PATH =~ ^-j ]] && {
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

if [ -z "$MAIN_CLASS_FULL_PATH" ]; then
  MAIN_CLASS_FULL_PATH=$DEFAULT_MAIN_CLASS_FULL_PATH
fi

if [ -z "$JAVA_HOME" ] || [ -z "$JAR_FILE_PATH" ]; then
  usage
fi

echo "-h(JAVA_HOME): $JAVA_HOME"
echo "-j(JAR_FILE_PATH): $JAR_FILE_PATH"
echo "-m(MAIN_CLASS_FULL_PATH): $MAIN_CLASS_FULL_PATH"

JAR_FILE_NAME=$(basename $JAR_FILE_PATH)
#START_SHELL=$(cat ./shell-maker/shell-maker-start.sh)
#START_SHELL_NAME=start.sh
START_OPT_SHELL=$(cat ./shell-maker/shell-maker-start-opt.sh)
START_OPT_SHELL_NAME=start-opt.sh
#START_OPT_SHELL2=$(cat ./shell-maker/shell-maker-start-opt2.sh)
#START_OPT_SHELL_NAME2=start-opt2.sh
STOP_SHELL=$(cat ./shell-maker/shell-maker-stop.sh)
STOP_SHELL_NAME=stop.sh
DEPLOY_SHELL=$(cat ./shell-maker/shell-maker-deploy.sh)
DEPLOY_SHELL_NAME=deploy.sh
CHECK_SHELL=$(cat ./shell-maker/shell-maker-check.sh)
CHECK_SHELL_NAME=check.sh
STOP_CHECK_SHELL=$(cat ./shell-maker/shell-maker-stop-check.sh)
STOP_CHECK_SHELL_NAME=stop-check.sh

#echo ""
#echo "make ${START_SHELL_NAME}"
#echo "."
#echo "#!/bin/bash" >${START_SHELL_NAME}
#echo "" >> ${START_SHELL_NAME}
#echo "MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >>${START_SHELL_NAME}
#echo "JAVA_HOME=${JAVA_HOME}" >>${START_SHELL_NAME}
#echo "JAR_FILE_NAME=${JAR_FILE_NAME}" >>${START_SHELL_NAME}
#echo "$START_SHELL" >>${START_SHELL_NAME}

echo ""
echo "make ${START_OPT_SHELL_NAME}"
echo "."
echo "#!/bin/bash" >${START_OPT_SHELL_NAME}
echo "" >> ${START_OPT_SHELL_NAME}
echo "MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >>${START_OPT_SHELL_NAME}
echo "JAVA_HOME=${JAVA_HOME}" >>${START_OPT_SHELL_NAME}
echo "JAR_FILE_NAME=${JAR_FILE_NAME}" >>${START_OPT_SHELL_NAME}
echo "$START_OPT_SHELL" >>${START_OPT_SHELL_NAME}

#echo ""
#echo "make ${START_OPT_SHELL_NAME2}"
#echo "."
#echo "#!/bin/bash" >${START_OPT_SHELL_NAME2}
#echo "" >> ${START_OPT_SHELL_NAME2}
#echo "MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >>${START_OPT_SHELL_NAME2}
#echo "JAVA_HOME=${JAVA_HOME}" >>${START_OPT_SHELL_NAME2}
#echo "JAR_FILE_NAME=${JAR_FILE_NAME}" >>${START_OPT_SHELL_NAME2}
#echo "$START_OPT_SHELL2" >>${START_OPT_SHELL_NAME2}

echo ""
echo "make ${STOP_SHELL_NAME}"
echo "."
echo "#!/bin/bash" >${STOP_SHELL_NAME}
echo "" >> ${STOP_SHELL_NAME}
echo "MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >>${STOP_SHELL_NAME}
echo "JAVA_HOME=${JAVA_HOME}" >>${STOP_SHELL_NAME}
echo "JAR_FILE_NAME=${JAR_FILE_NAME}" >>${STOP_SHELL_NAME}
echo "$STOP_SHELL" >>${STOP_SHELL_NAME}

echo ""
echo "make ${DEPLOY_SHELL_NAME}"
echo "."
echo "#!/bin/bash" >${DEPLOY_SHELL_NAME}
echo "" >> ${DEPLOY_SHELL_NAME}
echo "$DEPLOY_SHELL" >>${DEPLOY_SHELL_NAME}

echo ""
echo "make ${CHECK_SHELL_NAME}"
echo "."
echo "#!/bin/bash" >${CHECK_SHELL_NAME}
echo "" >> ${CHECK_SHELL_NAME}
echo "MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >>${CHECK_SHELL_NAME}
echo "JAVA_HOME=${JAVA_HOME}" >>${CHECK_SHELL_NAME}
echo "JAR_FILE_NAME=${JAR_FILE_NAME}" >>${CHECK_SHELL_NAME}
echo "$CHECK_SHELL" >>${CHECK_SHELL_NAME}

echo ""
echo "make ${STOP_CHECK_SHELL_NAME}"
echo "."
echo "#!/bin/bash" >${STOP_CHECK_SHELL_NAME}
echo "" >> ${STOP_CHECK_SHELL_NAME}
echo "MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >>${STOP_CHECK_SHELL_NAME}
echo "JAVA_HOME=${JAVA_HOME}" >>${STOP_CHECK_SHELL_NAME}
echo "JAR_FILE_NAME=${JAR_FILE_NAME}" >>${STOP_CHECK_SHELL_NAME}
echo "$STOP_CHECK_SHELL" >>${STOP_CHECK_SHELL_NAME}

echo "done."