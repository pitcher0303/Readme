#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage: $0 <main class full path>"
  echo "example: $0 com.example.demo.DemoApplication"
  exit 1
fi

SHELL_NAME=bin-script-generator.sh
MAIN_CLASS_FULL_PATH=$1
CONDITION_SHELL=$(cat ./shell-maker-script.sh)

echo "#!/bin/bash" > ${SHELL_NAME};
echo "DEFAULT_MAIN_CLASS_FULL_PATH=${MAIN_CLASS_FULL_PATH}" >> ${SHELL_NAME};
echo "" >> ${SHELL_NAME};
echo "$CONDITION_SHELL" >> ${SHELL_NAME};

cp ${SHELL_NAME} ../