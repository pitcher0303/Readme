echo "check application startup.."

RETRY_COUNT=0
APP_PID=""
APP_PORT=""
APP_RUN=false
while [ $RETRY_COUNT -lt 4 ]; do
  APP_PID=$(ps -ef | grep "$JAR_FILE_NAME" | grep "$MAIN_CLASS_FULL_PATH" | grep -v grep | awk '{print $2}')
  if [ ! -z $APP_PID ]; then
    echo "found app: $JAR_FILE_NAME, pid: ${APP_PID}"
    APP_RUN=true
    break
  else
    echo "Not Found PID"
    echo "Re(${RETRY_COUNT}) find [PID] on JAR_FILE_NAME=[$JAR_FILE_NAME]..."
    sleep 1
  fi
  ((RETRY_COUNT++))
done

echo ""
sleep 1

RETRY_COUNT=0
if $APP_RUN; then
  APP_RUN=false
  while [ $RETRY_COUNT -lt 6 ]; do
    echo "find [TCP LISTEN PORT]..."
    APP_PID=$(ps -ef | grep "$JAR_FILE_NAME" | grep "$MAIN_CLASS_FULL_PATH" | grep -v grep | awk '{print $2}')
    if [ -z $APP_PID ]; then
      echo "APP is Shutdown..."
      break
    fi
    APP_PORT=$(netstat -tlpn 2>/dev/null | grep ${APP_PID} | awk '{print $4}' | awk '{ split($0, temp, ":"); if(length(temp) > 0) print temp[length(temp)]}')
    if [ ! -z $APP_PORT ]; then
      echo "found app: ${JAR_FILE_NAME}, pid: ${APP_PID}, port: ${APP_PORT}"
      APP_RUN=true
      break
    else
      echo "Re($RETRY_COUNT) find [TCP PORT] on pid: ${APP_PID}..."
      sleep 3
    fi
    ((RETRY_COUNT++))
  done
fi

echo ""
HOST_NAME=$(hostname)

if $APP_RUN; then
  echo "app is running"
  echo "###################################################################################################"
  echo "#  █████╗ ██████╗ ██████╗     ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗██╗███╗   ██╗ ██████╗          #"
  echo "# ██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██║   ██║████╗  ██║████╗  ██║██║████╗  ██║██╔════╝          #"
  echo "# ███████║██████╔╝██████╔╝    ██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗         #"
  echo "# ██╔══██║██╔═══╝ ██╔═══╝     ██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██║██║╚██╗██║██║   ██║         #"
  echo "# ██║  ██║██║     ██║         ██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║██║██║ ╚████║╚██████╔╝██╗██╗██╗#"
  echo "# ╚═╝  ╚═╝╚═╝     ╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝╚═╝#"
  echo "###################################################################################################"
  echo "# HOST_NAME: ${HOST_NAME}, pid: ${APP_PID}, APP_PORT: ${APP_PORT}, jar-file: ${JAR_FILE_NAME}     #"
  echo "###################################################################################################"
  exit 0 # Running
else
  echo "app is not running"
  echo "#########################################################################################################################"
  echo "# █████╗ ██████╗ ██████╗     ███╗   ██╗ ██████╗ ████████╗    ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗██╗███╗   ██╗ ██████╗ #"
  echo "#██╔══██╗██╔══██╗██╔══██╗    ████╗  ██║██╔═══██╗╚══██╔══╝    ██╔══██╗██║   ██║████╗  ██║████╗  ██║██║████╗  ██║██╔════╝ #"
  echo "#███████║██████╔╝██████╔╝    ██╔██╗ ██║██║   ██║   ██║       ██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗#"
  echo "#██╔══██║██╔═══╝ ██╔═══╝     ██║╚██╗██║██║   ██║   ██║       ██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██║██║╚██╗██║██║   ██║#"
  echo "#██║  ██║██║     ██║         ██║ ╚████║╚██████╔╝   ██║       ██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║██║██║ ╚████║╚██████╔╝#"
  echo "#╚═╝  ╚═╝╚═╝     ╚═╝         ╚═╝  ╚═══╝ ╚═════╝    ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ #"
  echo "#########################################################################################################################"
  echo "# HOST_NAME: ${HOST_NAME}, pid: ${APP_PID}, APP_PORT: ${APP_PORT}, jar-file: ${JAR_FILE_NAME}                           #"
  echo "#########################################################################################################################"
  exit 1 # Not Running
fi
