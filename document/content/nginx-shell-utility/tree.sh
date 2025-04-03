#!/bin/bash

#폴더 구조를 tree 로 보여줌.

tree=$(tree -tf -L 2 --noreport -I '*~' --charset ascii $1 | sed -e 's/| \+/  /g' -e 's/[|`]-\+/ */g' -e 's:\(*\)\(\(.*/\)\([^/]\+\)\):\1[\4](\2):g')

printf "# Projecttree\n\n${tree}"
