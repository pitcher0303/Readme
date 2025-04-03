usage() {
  cat <<EOM
Usage: $(basename "$0") <app_name> <source_dir_path> <sink_dir_path> <java_home_path> <java_parameters>
Options:
 [app_name]:
  - 1. Application Name
  - 2. Jar File Name
 [source_dir_path]: from target, moving dir root path
 [sink_dir_path]  : to target, Application dir root path
 [java_home_path] : Jdk Home Path
 [java_parameters]: java parameters
EOM
  exit 1
}

if [ $# -ne 5 ]; then
  usage
fi

APP_NAME=$1

SOURCE_DIR_PATH=$2
CURRENT_DIR=$(pwd)
if [ ! -d "$SOURCE_DIR_PATH" ]; then
  echo: "SOURCE_DIR_PATH Invalid"
  echo ""
  usage
fi
cd $SOURCE_DIR_PATH || exit 1
SOURCE_DIR_PATH=$(pwd)
cd $CURRENT_DIR || exit 1

TARGET_DIR_PATH=$3
CURRENT_DIR=$(pwd)
if [ ! -d "$TARGET_DIR_PATH" ]; then
  echo: "TARGET_DIR_PATH Invalid"
  echo ""
  usage
fi
cd $TARGET_DIR_PATH || exit 1
TARGET_DIR_PATH=$(pwd)
cd $CURRENT_DIR || exit 1

JAVA_HOME_PATH=$4
CURRENT_DIR=$(pwd)
if [ ! -d "$JAVA_HOME_PATH" ]; then
  echo: "JDK Home Path Invalid"
  echo ""
  usage
fi
cd $JAVA_HOME_PATH || exit 1
JAVA_HOME_PATH=$(pwd)
cd $CURRENT_DIR || exit 1

JAVA_PARAMETER=$5
HOST_NAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $2}')

echo "#####################################################################################"
echo "######1. HOST_NAME: $HOST_NAME, IP_ADDRESS: $IP_ADDRESS, Deploy APP: $APP_NAME Started..."
echo "#####################################################################################"
echo "######2. Execute bin-script-generator.sh -h $JAVA_HOME_PATH -j ../$APP_NAME.jar"
echo "######cmd: cd bin || exit 1"
echo "######cmd: sh bin-script-generator.sh -h $JAVA_HOME_PATH -j ../$APP_NAME.jar"
echo "#####################################################################################"
cd bin || exit 1
sh bin-script-generator.sh -h $JAVA_HOME_PATH -j ../$APP_NAME.jar
echo "."
echo "#####################################################################################"
echo "######3. Stop app"
echo "######cmd: sh stop-check.sh"
echo "#####################################################################################"
sh stop-check.sh
echo "."
echo "#####################################################################################"
echo "######4. Deploy to Source to Target [$SOURCE_DIR_PATH/$APP_NAME -> $TARGET_DIR_PATH/$APP_NAME]"
echo "######cmd: sh deploy.sh $TARGET_DIR_PATH/$APP_NAME"
echo "#####################################################################################"
sh deploy.sh $TARGET_DIR_PATH/$APP_NAME
echo "."
echo "#####################################################################################"
echo "######5. Before Deploy Clean up bin script."
echo "######cmd: cd $TARGET_DIR_PATH/$APP_NAME || exit 1"
echo "######cmd: rm -r auto-deploy.sh bin-script-generator.sh deploy.sh shell-maker"
echo "#####################################################################################"
cd $TARGET_DIR_PATH/$APP_NAME || exit 1
cd bin || exit 1
rm -r auto-deploy.sh bin-script-generator.sh deploy.sh shell-maker
echo "."
echo "#####################################################################################"
echo "######6. Start app"
echo "######cmd: sh start.sh $PROFILES"
echo "#####################################################################################"
#sh start.sh $PROFILES
#sh start-opt.sh -p $PROFILES -t /app/ssl-certificate/common/qmpc.truststore.p12 -T trusts
#start.sh 을 덮어 쓰거나 start-opt.sh 을 없애거나.
if [ -n "$JAVA_PARAMETER" ]; then
  echo "sh start-opt.sh -j \"$JAVA_PARAMETER\"" > $TARGET_DIR_PATH/$APP_NAME/bin/start.sh
  sh start-opt.sh -j "$JAVA_PARAMETER"
else
  rm start-opt.sh
  sh start.sh
fi
echo "."
echo "#####################################################################################"
echo "######7. Check starting app..."
echo "######cmd: sh check.sh"
echo "#####################################################################################"
sh check.sh
exit $?
