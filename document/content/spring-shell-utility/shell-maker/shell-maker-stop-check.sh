APP_PID=$(ps -ef | grep "$JAR_FILE_NAME" | grep "$MAIN_CLASS_FULL_PATH" | grep -v grep | awk '{print $2}')

if [[ -z $APP_PID ]]; then
  echo 'no running app'
  exit 0
else
  echo "kill signal to app... pid : ${APP_PID}"
  kill ${APP_PID}
  echo "wait until app shutdown..."
  if sh check.sh; then
    echo "application is not shutdown correctly"
    exit 1
  else
    echo "application shutdown complete"
    exit 0
  fi
fi
