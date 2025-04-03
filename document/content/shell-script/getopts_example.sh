#!/bin/bash

usage() {
    err_msg "Usage: $0 -a <string> -b --long <string> --posix --warning[=level]"
    exit 1
}

err_msg() { echo "$@" ;} >&2
err_msg_a() { err_msg "-a option argument required" ;}
err_msg_l() { err_msg "--long option argument required" ;}

########################## long 옵션 처리 부분 #############################
A=""
while true; do
    [ $# -eq 0 ] && break
    case $1 in
        --long)
            shift    # 옵션인수를 위한 shift
            # --long 은 옵션인수를 갖는데 옵션인수가 오지 않고 다른 옵션명(-*) 이 오거나
            # 명령의 끝에 위치하여 옵션인수가 설정되지 않았을 경우 ("")
            case $1 in (-*|"") err_msg_l; usage; esac
            err_msg "--long was triggered!, OPTARG: $1"
            shift; continue
            ;;
        --warning*)
            # '=' 로 분리된 level 값을 처리하는 과정입니다.
            case $1 in (*=*) level=${1#*=}; esac
            err_msg "--warning was triggered!, level: $level"
            shift; continue
            ;;
        --posix)
            err_msg "--posix was triggered!"
            shift; continue
            ;;
        --)
            # '--' 는 옵션의 끝을 나타내므로 나머지 값 '$*' 을 A 에 append 하고 break 합니다.
            # 이때 IFS 값을 '\a' 로 변경해야 $* 내의 인수 구분자가 '\a' 로 됩니다.
            IFS=$(echo -e "\a")
            A=$A$([ -n "$A" ] && echo -e "\a")$*
            break
            ;;
        --*)
            err_msg "Invalid option: $1"
            usage;
            ;;
    esac

    A=$A$([ -n "$A" ] && echo -e "\a")$1
    shift
done

# 이후부터는 '$@' 값에 short 옵션만 남게 됩니다.
# -a aaa -b -- hello world
IFS=$(echo -e "\a"); set -f; set -- $A; set +f; IFS=$(echo -e " \n\t")

########################## short 옵션 처리 부분 #############################

# 이전과 동일하게 short 옵션을 처리하면 됩니다.
while getopts ":a:b" opt; do
    case $opt in
        a)
            case $OPTARG in (-*) err_msg_a; usage; esac
            err_msg "-a was triggered!, OPTARG: $OPTARG"
            ;;
        b)
            err_msg "-b was triggered!"
            ;;
        :)
            case $OPTARG in
                a) err_msg_a ;;
            esac
            usage
            ;;
        \?)
            err_msg "Invalid option: -$OPTARG"
            usage
            ;;
    esac
done

shift $(( OPTIND - 1 ))
echo ------------------------------------
echo "$@"
