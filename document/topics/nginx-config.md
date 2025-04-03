# nginx-config

> 이 문서의 **Nginx 로그 로테이트를 위한 crontab 설정.**  
> 내용중에 crontab shell 스크립트를 **redis crontab shell 스크립트** 로  
> 바꾸는게 좋을듯함. **언제 바꿀지는 미정... 시간이 있다면...**
>
> **아래 내용 그대로 사용해도 무방함.**
>
{style="warning"}

Nginx 설정에 관해 다루는 문서.

* Nginx 컨트롤을 위한 도우미 Shell 생성.
* Nginx 로그 로테이트를 위한 crontab 설정.
* Nginx.conf 예시 설명.

## 1. 시작전 Nginx 디렉토리 구성

아래와 같이 구성해야 한다.

* bin: Nginx 컨트롤을 위한 Shell 생성.
* rotate-log 로그 로테이트를 위한 crontab 설정.

<img src="nginx-config-1.png" alt=""/>

1. bin 디렉토리를 만들고, 아래 make-bin-script.sh 파일을 위치 시킨다.

[//]: # (```shell)

[//]: # (```)

[//]: # ()
[//]: # ({collapsed-title="make-bin-script.sh" src="nginx-shell-utility/bin-maker/make-bin-script.sh" collapsible="true"})

```shell

```

{collapsed-title="make-bin-script.sh" src="../content/nginx-shell-utility/bin-maker/make-bin-script.sh" collapsible="true"}

2. rotate-log 디렉토리를 만들고, 아래 crontab-register.sh, rotate-log.sh 파일을 위치 시킨다.

> 내용중에 rotate-log.sh 스크립트를 **redis crontab shell 스크립트** 로  
> 바꾸는게 좋을듯함. **언제 바꿀지는 미정... 시간이 있다면...**  
> 당장 사용하는 데에는 문제 없음.
>
{style="warning"}

[//]: # (```shell)

[//]: # (```)

[//]: # ()
[//]: # ({collapsed-title="crontab-register.sh" src="nginx-shell-utility/rotate-log-maker/crontab-register.sh" collapsible="true"})

```shell
```

{collapsed-title="crontab-register.sh" src="../content/nginx-shell-utility/rotate-log-maker/crontab-register.sh" collapsible="true"}

[//]: # (```shell)

[//]: # (```)

[//]: # ()
[//]: # ({collapsed-title="rotate-log.sh" src="nginx-shell-utility/rotate-log-maker/rotate-log.sh" collapsible="true"})

```shell
```

{collapsed-title="rotate-log.sh" src="../content/nginx-shell-utility/rotate-log-maker/rotate-log.sh" collapsible="true"}

## 2. Nginx 컨트롤을 위한 도우미 Shell 생성.

**make-bin-script.sh**: nginx 실행, 중지, 재실행, config check 를 위한 shell 생성파일

<img src="nginx-config-2.png" alt=""/>

위와 같이 그냥 실행 시키면 'nginx root path' 를 입력하라고 표시된다., nginx 가 설치된 root path 를 입력하고 실행하자.

* **root path는 절대 경로로 입력하자..**

```shell
usage: make-bin-script.sh [nginx root path]
example: make-bin-script.sh /apps/pitcher0303-nginx
```

<img src="nginx-config-3.png" alt=""/>

실행후 확인하면 위 그림과 같이 sh이 생성 된다.

* check.sh: nginx.conf 파일, config 의 유효성을 검증해 준다.
* reload.sh: nginx 를 reload 한다.
* start.sh: nginx 를 실행한다.
* stop.sh: nginx 를 중지한다.

## 3. Nginx 로그 로테이트를 위한 crontab 설정.

> 1. nginx 는 log 를 rotate 하지 않고 기본적으로 계속 해서 append 함으로
> 2. 일 별로 cron 으로 log rotate 를 시켜 운영상의 용의성을 확보하기 위함.
> 아래 과정에서 일별로 log 를 rotate 하는 cron 을 설정함.
>
{style="tip"}

* **crontab-register.sh**: log rotate 를 실행하는 'rotate-log.sh' 을 crontab 에 등록하는 shell 파일
* **rotate-log.sh**: nginx log rotate 를 하는 파일
* **crontab-register.sh** 을 바로 실행 해도 된다. (디폴트로 '매일 0시 1분'에 로테이트가 돌도록 설정되어 있다.)
* **로테이트 크론 값을 바꾸고 싶다면 아래 그림에서 CRON_JOB 을 바꿔주면된다.**

<img src="nginx-config-4.png" alt=""/>

**crontab-register.sh** 실행 결과

<img src="nginx-config-5.png" alt=""/>

shell 실행 과정은 아래와 같다.

1. 이미 등록 되어 있는 **크론 탭 리스트**(crontab -l 실행 결과)를 before_crontab.txt 에 백업 한다.
    * 되돌리고 싶다면 before_crontab.txt 내용을 (crontab -e, 크론탭 편집) 을 실행 해서 바꿔주자.
2. 이미 등록 되어 있는 크론탭 밑으로 **'Nginx 로그 rotate 크론탭'** 을 등록 시킨다.
    * 특이사항으로 **crontab-register.sh** 을 최초가 아니라 다시 한번 실행 할 경우 이전 **crontab-register.sh** 결과를 update 해준다.
    * 따라서 **'실행 주기'** 를 변경 하고자 하면 rotate-log.sh 을 변경하고, 다시 실행 하면 된다.
    * **!주!의!**: rotate-log.sh 파일 명이 바뀌면 업데이트 되지 않고, 최초 추가가 된다.

> **매우 주의 할것.**: **crontab-register.sh** 을 실행 하고 난 뒤에는
> 꼭! 이전 크론탭(before_crontab.txt)과 현재 크론탭(crontab -l) 을 확인하고
> 정상적으로 등록 되었는지 확인하자!  
> ```Shell crontab -l``` 을 하면 crontab 확인가능.
>
{style="warning"}

___

## 4. 기본-NGINX구조(실제-배포된-nginx-기준)

위 과정을 완료하면 아래와 같은 구조가 될 것이다.

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
    * [rotate-log.sh]: log-rotate 를 하는 shell
    * [before_crontab.txt]: crontab 자동 등록전 이전 crontab 백업
    * [rotate-log.sh.log]: rotate-log.sh 실행 로그
* [conf]
    * [nginx.conf]: nginx 설정파일
* [sbin]
    * [nginx]: nginx 실행파일
* [logs]
    * [nginx.pid]: nginx pid
    * [error.log.2025-03-01]: rotate 된 log
    * [access.log.2023-03-02]: rotate 된 log
    * [error.log]
    * [access.log]
```

{collapsible="false"}

## 5. Nginx.conf 예시 설명.

nginx.conf 설정 내용 설명은 아래 **Nginx Conf** 스크립트로 마무리함.

```text
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid 파일 생성 하고 싶을때 사용
#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    #upstream 설정 하나 이상 설정 가능
    #localhost: 서버 자신
    #이러면 was 는 현재 서버 20000 포트에 떠 있는것.
	upstream was {
		server localhost:20000;
	}

    #web 5173 으로 띄움
    #server_name: 도메인으로 접근 가능하도록함.
    #특이 하게 location 을 보면 root 는 nginx 내부가 아니라 다른 디렉토리임.
	server {
		listen 5173;
 		server_name  dev.sample.co.kr;

		location / {
			root /apps/sample/web;
			index index.html index.htm;
			try_files $uri $uri/ /index.html;
		}
	}

    #WAS reverse proxy 설정, Nginx 파일 다운로드 설정
    #proxy_pass http://was; <- upstream 으로 들어감, upstream에 2가지 이상이면 기본적으로 round robin으로 분배해줌.
    server {
        listen       8080;
        server_name  dev.sample.co.kr;

        #위에 web 을 5173으로 띄워 놓아서 아래처럼 설정했는데
        #web 이 8080 포트 보게 바꿔야함.
        location / {
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
			proxy_set_header Host $host;
			proxy_set_header X-Forwarded-Host  $host;
			proxy_set_header X-Forwarded-Port  $server_port;
			proxy_cookie_domain ~^ $host;
			proxy_pass http://was;
        }

        #api,oauth2 때문에 따로 빼둠.
		location ~ ^/(api|oauth2|login/oauth2) {
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
			proxy_set_header Host $host;
			proxy_set_header X-Forwarded-Host  $host;
			proxy_set_header X-Forwarded-Port  $server_port;
			proxy_cookie_domain ~^ $host;
			proxy_pass http://was;
		}
        
        #static 파일 다운로드를 위해 설정해 놓음.
		location ~ /static/(?<download_filename>[^/]+)$ {
			#root /app/nginx;
			alias /sdata1;
			#add_header Content-Disposition 'attachment; filename="$download_filename"';
			try_files $uri =404;
		}

        #static 파일 리스트 보여줌.
		location /static {
			alias /sdata1/static;
			try_files $uri $uri/  =404;
			autoindex on;
		}

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```