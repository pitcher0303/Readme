# nginx-setup

Nginx 설치 방법에 관한 문서.

1. 적당한 곳에 아래와 같이 디렉토리 생성 및 nginx 압축을 풀고 필수 라이브러리 압출을 풀어서 위치 시킨다.

<img src="nginx-setup-1.png" alt=""/>

2. nginx 설치 설정 커맨드를 실행 하고, '컴파일, 설치' 커맨드를 실행한다.

* **prefix**: nginx 를 설치할 위치 경로 값, 적절히 입력.
* **user**: nginx 실행 파일 권한을 가질 user, 주로 서버 계정 사용.
* **group**: nginx 실행 파일 권한을 가질 group, 주로 서버 계정 사용.

```shell
```

{src="../content/nginx-shell-utility/configure_sample.txt" collapsible="false"}

* 아래 이미지와 같이 configure.sh 파일로 만들어서 사용하면 추후 확인하기 편함

<img src="nginx-setup-2.png" alt=""/>

> * 설치하다 보면 linux 자체에 패키지가 없어서 생기는 문제는 net 상에 많이 올라와 있으니 참고.
> * 1. ./configure: error: C compiler cc is not found
>   * ```shell sudo apt-get install gcc``` gcc 설치
> * 2. configure.sh: 16: make: not found
>   * ``shell sudo apt-get install build-essential`` make 설치
>
{style="note"}

3. 설치가 완료 되었는지 확인. (위에서 prefix 값 경로에 설치될 것임.)

* 아래 이미지와 같이 'conf', 'html', 'logs', 'sbin' 이 디폴트로 생성 됨.

<img src="nginx-setup-3.png" alt=""/>

* 여기까지 만 해도 nginx 구동에 문제는 없으나, 좀더 쉽게 사용하기 위해 설정을 다음에서 진행함.

> * 위 에서 사용한 nginx-setup 디렉토리는 그대로 두는 것이 좋을 수 있음.
> * 일부 모듈 추가, 설정 변경시에 사용 할 수 있기 때문.
> * 같은 prefix 에 다시 make & make install 하더라도 conf 폴더 값은 바뀌지 않음.
>
{style="note"}