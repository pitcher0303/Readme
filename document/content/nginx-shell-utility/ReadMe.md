# ReadMe

### 1.nginx.conf

* upstream 설정
* path-rewrite 설정
* 등 기본 설정 smaple 참고 파일.

### 2.configure-sample.txt

* nginx 설치시 사용하는 configure sample 파일

### 3.bin-maker

* make-bin-script.sh: nginx 실행, 중지, 재실행, conf check를 위한 shell 생성파일

### 4.rotate-log-maker

* crontab-register.sh: log rotate를 실행하는 'rotate-log.sh'을 crontab에 등록하는 shell 파일
* rotate-log.sh: nginx log rotate를 하는 파일

***

#2.기본-NGINX구조(실제-배포된-nginx-기준)
---

디렉토리 구조:

```Text
* [bin]
    * [make-bin-script.sh]: start.sh, stop.sh, reload.sh, check.sh 을 만드는 shell
    * [check.sh]: conf check
    * [reload.sh]: nginx 재실행
    * [start.sh]: nginx 실행
    * [stop.sh]: nginx 종료
* [rotatelogs]
    * [crontab-register.sh]: rotate-log.sh 을 실행하는 cron을 등록하는 shell
    * [rotate-log.sh]: log-rotate를 하는 shell
    * [before_crontab.txt]: crontab 자동 등록전 이전 crontab 백업
    * [rotate-log.sh.log]: rotate-log.sh 실행 로그
* [conf]
    * [nginx.conf]: nginx 설정파일
* [sbin]
    * [nginx]: nginx 실행파일
* [logs]
    * [nginx.pid]: nginx pid
    * [error.log.2023-12-18]: rotate 된 log
    * [access.log.2023-12-18]: rotate 된 log
    * [error.log]
    * [access.log]
```

{collapsible="true"}

#3. bin/make-bin-script.sh
--------------------------
> 위 의 bin 경로에서 **make-bin-script.sh** 실행하면
> **start.sh**, **stop.sh**, **reload.sh**, **check.sh** 생성함.
***

#4. rotatelogs/crontab-register.sh.sh
--------------------------
> 위 의 rotatelogs 경로에서 **crontab-register.sh** 실행하면
> 현재 User의 Crontab에 cron 추가.
***

#5. Location 블록 우선순위
--------------------------
다수의 Location 블록이 정의되어 있을 경우 Location 블록에 정의되어 있는 패턴에 우선순위에 따라 달라지게 됩니다.

1순위 = : 정규식이 정확하게 일치
> 예시) location = /static { ... }

2순위 ^~ : 정규식 앞부분이 일치
> 예시) location ^~ /static { ... }

3순위 ~ : 정규식 대/소문자 일치
> 예시) location ~ /static/ { ... }

4순위 ~* : 대/소문자를 구분하지 않고 일치
> 예시) location ~* .(jpg|png|gif)

5순위 / : 하위 일치
> 예시) location /static { ... }
***