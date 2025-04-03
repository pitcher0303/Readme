# nginx-readme

Nginx 설치 방법, Nginx 설정 방법 관련 문서

직접 설치하는 방법을 다룸.

## 1. Nginx 설치 방법

Nginx 설치에 필요한 Library 를 다운로드 한다.

필수 라이브러리
1. [nginx-xxx](https://nginx.org/): nginx 설치파일
2. [pcre2-xxx](https://github.com/PCRE2Project/pcre2): pcre2 라이브러리파일, github 내에 release 찾아보면 있음
3. [zlib-xxx](https://zlib.net/): zlib 라이브러리파일

선택 라이브러리

* [openssl-xxx](https://www.openssl.org/): openssl 라이브러리파일
  * SSL 이 필요 없다면 없어도 가능.

> * 설치하다 보면 linux 자체에 패키지가 없어서 생기는 문제는 net 상에 많이 올라와 있으니 참고.
>
{style="note"}

__이후는 아래 문서 참조.__

<a href="nginx-setup.md">Nginx 설치 방법 문서 참조</a>

## 2. Nginx 설정 방법

Nginx 설치 후 설정에 관한 문서
* Nginx 디렉토리 구조
* Nginx 시작, 중지, 재시작, 설정 체크를 도와주는 Shell 파일 생성
* Nginx 로그 로테이트 방법
  * Nginx 는 기본적으로 로그를 append 하기 때문에 일별 로테이트가 필요함.

__이후는 아래 문서 참조.__

<a href="nginx-config.md">Nginx 설정 방법 문서 참조</a>
