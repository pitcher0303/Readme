## NPM > YARN 변경 방법

 1. npm 프로젝트로 이동한다.
 2. node_modules 폴더를 지운다.
 3. cmd 창에 해당 명령어들을 차례로 입력한다.

    1.  
    ```shell 
        npm uninstall -g yarn

        npm install -g yarn@berry
    ```

    2. 가장 안전한 최신 버전 yarn 다운을 위해
    ```shell
        set NODE_TLS_REJECT_UNAUTHORIZED=0

        yarn config set enableStrictSsl false

        yarn set version berry
    ```

    3. 

    ```shell
        yarn install
    ```

4. install 까지 다 마쳤으면, 프로젝트 경로에 .yarn폴더가 생선된다.

5. vsCode에서 Ctrl + , 후, "npm package manage" 검색 후 yarn으로 변경한다.

5. 
```shell
    Set NODE_EXTRA_CA_CERTS=C:\workbench-web\LGUPLUS_CERT.crt 

    Get-ChildItem Env:NODE_EXTRA_CA_CERTS 

    Echo %NODE_EXTRA_CA_CERTS% > 확인 
```

* * *
## OFFLINE 에서 사용할 corepack 압축 방법
1. 사내망 등 ssl 오류가 발생 할때 아래 설정

```shell
    set NODE_EXTRA_CA_CERTS=[사내망 ssl 인증서 절대경로]

    set NODE_TLS_REJECT_UNAUTHORIZED=0 

    set COREPACK_ENABLE_NETWORK=0

    corepack prepare yarn@4.7.0 --activate
```

2.
```shell
    corepack install
```

3. corepack.tgz를 받을 경로를 지정후 ,
 
    - 참고 url : https://github.com/nodejs/corepack?tab=readme-ov-file#corepack-binary-nameversion--args
```shell
    corepack pack --output ./corepack/corepack.tgz
```

