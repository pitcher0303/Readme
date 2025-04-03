if [ $# -ne 1 ]; then
  echo "usage: $0 <cp -r full path>"
  echo "example: $0 /app/APP_DIR"
  exit 1
fi

echo "$0 execute..."
echo ""

#APP_DIR 없을때 mkdir??

BASEDIR=$(dirname $0)
TARGET_DIR=$BASEDIR/..
cd $TARGET_DIR || exit 1
echo "move files: [$(ls -I "*.sh" -I "*.zip" .)] -> [$1]"
if cp -r $(ls -I "*.sh" -I "*.zip" .) $1; then
  echo ""
  echo "done"
  exit 0
else
  echo "deploy failed"
  exit 1
fi
