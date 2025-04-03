# redis-utility

Redis 설치 방법, Redis 설정 방법, Sentiel 에 대해 다루는 문서

## Redis 설치.

경로만 잡아주면 됨.

```Shell
make PREFIX=/app/pitcher0303-redis install
```

## rotate-log-maker

### getopt-sample.sh

> getopt 사용하는 샘플 파일

> **getopts 가 아니라 getopt를 사용함.**  
> gnu-getopt 사용됨.  
> 아래와 같은 출력이 나와야함.
>
{style="warning"}

```Bash
$ getopt -h
Usage:
 getopt <optstring> <parameters>
 getopt [options] [--] <optstring> <parameters>
 getopt [options] -o|--options <optstring> [options] [--] <parameters>
Parse command options.
Options:
 -a, --alternative             allow long options starting with single -
 -l, --longoptions <longopts>  the long options to be recognized
 -n, --name <progname>         the name under which errors are reported
 -o, --options <optstring>     the short options to be recognized
 -q, --quiet                   disable error reporting by getopt(3)
 -Q, --quiet-output            no normal output
 -s, --shell <shell>           set quoting conventions to those of <shell>
```

{collapsible="true" collapsed-title-line-number="1"}