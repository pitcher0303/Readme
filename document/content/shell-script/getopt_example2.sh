#!/usr/bin/env bash
#
# Adapted from https://www.shellscript.sh/examples/getopt/
#
set -euo pipefail

alpha=
beta=
gamma=
delta=

usage(){
cat << EOF
Usage: $0
   [ -a | --alpha ]
   [ -b | --beta ]
   [ -g | --gamma input ] 
   [ -d | --delta input ]
   <infile> [infiles]
EOF
exit 1
}

args=$(getopt -a -o abhc:d: --long alpha,beta,help,gamma:,delta: -- "$@")
if [[ $? -gt 0 ]]; then
  usage
fi

eval set -- ${args}
while :
do
  case $1 in
    -a | --alpha)   alpha=1    ; shift   ;;
    -b | --beta)    beta=1     ; shift   ;;
    -h | --help)    usage      ; shift   ;;
    -c | --gamma)   gamma=$2   ; shift 2 ;;
    -d | --delta)   delta=$2   ; shift 2 ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

if [[ $# -eq 0 ]]; then
  usage
fi

echo "alpha   : ${alpha}"
echo "beta    : ${beta} "
echo "gamma   : ${gamma}"
echo "delta   : ${delta}"
echo "Parameters remaining are: $@"
exit 0