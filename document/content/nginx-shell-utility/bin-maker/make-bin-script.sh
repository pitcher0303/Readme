if [ $# -ne 1 ]; then
  echo "usage: $0 [nginx root path]"
  echo "example: $0 /home/pitcher0303/nginx"
  exit 1
fi

NGINX_ROOT_PATH=$(readlink -f $1)
CHECK_SHELL_FILE=$NGINX_ROOT_PATH/bin/check.sh
RELOAD_SHELL_FILE=$NGINX_ROOT_PATH/bin/reload.sh
START_SHELL_FILE=$NGINX_ROOT_PATH/bin/start.sh
STOP_SHELL_FILE=$NGINX_ROOT_PATH/bin/stop.sh

echo "NGINX_ROOT_PATH: [$NGINX_ROOT_PATH]"
echo "make check.sh"
echo "."
sleep 1
echo ".."
sleep 1
CHECK_SHELL_01="$NGINX_ROOT_PATH/sbin/nginx -t"
(echo "$CHECK_SHELL_01") >${CHECK_SHELL_FILE}

echo ""
echo "make reload.sh"
echo "."
sleep 1
echo ".."
sleep 1

echo "APP_PID=\$(ps -ef | grep $NGINX_ROOT_PATH | grep nginx: | grep -v grep | awk '{print \$2}')" >${RELOAD_SHELL_FILE}
echo "if [[ -z \$APP_PID ]]; then " >>${RELOAD_SHELL_FILE}
echo "  echo Nginx Is Not Working..." >>${RELOAD_SHELL_FILE}
echo "  exit 1" >>${RELOAD_SHELL_FILE}
echo "else " >>${RELOAD_SHELL_FILE}
echo "  if $NGINX_ROOT_PATH/sbin/nginx -s reload; then" >>${RELOAD_SHELL_FILE}
echo "    echo Nginx Reload Complete PID:\${APP_PID}" >>${RELOAD_SHELL_FILE}
echo "    exit 0" >>${RELOAD_SHELL_FILE}
echo "  else" >>${RELOAD_SHELL_FILE}
echo "    echo Nginx Reload Failed" >>${RELOAD_SHELL_FILE}
echo "    exit 1" >>${RELOAD_SHELL_FILE}
echo "  fi" >>${RELOAD_SHELL_FILE}
echo "fi" >>${RELOAD_SHELL_FILE}

echo ""
echo "make start.sh"
echo "."
sleep 1
echo ".."
sleep 1

echo "APP_PID=\$(ps -ef | grep $NGINX_ROOT_PATH | grep nginx: | grep -v grep | awk '{print \$2}')" >${START_SHELL_FILE}
echo "if [[ -z \$APP_PID ]]; then" >>${START_SHELL_FILE}
echo "  if $NGINX_ROOT_PATH/sbin/nginx; then" >>${START_SHELL_FILE}
echo "    echo Start Running NGINX" >>${START_SHELL_FILE}
echo "    exit 0" >>${START_SHELL_FILE}
echo "  else" >>${START_SHELL_FILE}
echo "    echo All Nginx Server Port is using..." >>${START_SHELL_FILE}
echo "    exit 1" >>${START_SHELL_FILE}
echo "  fi" >>${START_SHELL_FILE}
echo "else" >>${START_SHELL_FILE}
echo "  echo NGINX is already running! PID:\${APP_PID}" >>${START_SHELL_FILE}
echo "  exit 1" >>${START_SHELL_FILE}
echo "fi" >>${START_SHELL_FILE}

echo ""
echo "make stop.sh"
echo "."
sleep 1
echo ".."
sleep 1

echo "APP_PID=\$(ps -ef | grep $NGINX_ROOT_PATH | grep nginx: | grep -v grep | awk '{print \$2}')" >${STOP_SHELL_FILE}
echo "if [[ -z \$APP_PID ]]; then" >>${STOP_SHELL_FILE}
echo "  echo Not Found Working NGINX" >>${STOP_SHELL_FILE}
echo "  exit 1" >>${STOP_SHELL_FILE}
echo "else" >>${STOP_SHELL_FILE}
echo "  if $NGINX_ROOT_PATH/sbin/nginx -s stop; then" >>${STOP_SHELL_FILE}
echo "    echo NGINX Stopped working. kill PID:\${APP_PID}" >>${STOP_SHELL_FILE}
echo "    exit 0" >>${STOP_SHELL_FILE}
echo "  else" >>${STOP_SHELL_FILE}
echo "    echo NGINX Stop Failed" >>${STOP_SHELL_FILE}
echo "    exit 1" >>${STOP_SHELL_FILE}
echo "  fi" >>${STOP_SHELL_FILE}
echo "fi" >>${STOP_SHELL_FILE}
