APP_PID=$(ps -ef | grep "$JAR_FILE_NAME" | grep "$MAIN_CLASS_FULL_PATH" | grep -v grep | awk '{print $2}')

if [[ -z $APP_PID ]]; then
  echo 'no running app'
  exit 0;
else
  echo "kill signal to app... pid : ${APP_PID}"
  kill ${APP_PID}
  exit 0;
fi
