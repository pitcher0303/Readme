#!/bin/bash

# getopts 가 아니라 getopt를 사용함.
#gnu-getopt 사용됨.
#아래와 같은 출력이 나와야함.
#$ getopt -h
#
#Usage:
# getopt <optstring> <parameters>
# getopt [options] [--] <optstring> <parameters>
# getopt [options] -o|--options <optstring> [options] [--] <parameters>
#
#Parse command options.
#
#Options:
# -a, --alternative             allow long options starting with single -
# -l, --longoptions <longopts>  the long options to be recognized
# -n, --name <progname>         the name under which errors are reported
# -o, --options <optstring>     the short options to be recognized
# -q, --quiet                   disable error reporting by getopt(3)
# -Q, --quiet-output            no normal output
# -s, --shell <shell>           set quoting conventions to those of <shell>

function usage()
{
    cat <<EOM
Usage: $0 [options] <url>
Options:
 -X, --request COMMAND   Specify request command to use
 -v, --verbose           Make the operation more talkative
EOM

    exit 1
}

function set_options()
{
    # --options에는 short option을 지정한다
    # --longoptions에는 말그대로 long option을 지정한다
    # --name은 도움말에 출력할 프로그램 이름이다
    # -- 이후에는 사용자가 입력한 문자열이 입력된다
    arguments=$(getopt --options X:v \
                       --longoptions request:,verbose \
                       --name $(basename $0) \
                       -- "$@")

    eval set -- "$arguments"

    while true
    do
        case "$1" in
            -X | --request)
                request_method=$2
                shift 2
                ;;
            -v | --verbose)
                verbose_mode="true"
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                usage
                ;;
        esac
    done

    # 남아있는 인자 얻기, 남아있는 인자는 url이다
    shift $((OPTIND-1))
    url=$@
}

set_options "$@"

echo "request_method='${request_method}'"
echo "verbose_mode='${verbose_mode}'"
echo "url='${url}'"