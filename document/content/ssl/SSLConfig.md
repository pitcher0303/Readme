# ReadMe

## 알아두기-용어정리 {collapsible="true"}

___
__.csr__

    Certificate Signing Request(인증서 서명 요청)
    인증서 발급을 위해 필요한 정보를 담고있는 인증서 신청 형식 데이터

__.cst__

    보안 인증서 파일
    CRT는 Base64 ASCII 인코딩 파일인 인증서의 PEM 형식에 속합니다.

__.pem__

    PEM (Privacy Enhanced Mail)은 Base64 인코딩된 ASCII 텍스트 이다. 파일 구분 확장자로 .pem 을 주로 사용한다.
    개인키, 서버인증서, 루트인증서, 체인인증서 및  SSL 발급 요청시 생성하는 CSR 등에 사용되는 포맷이며, 
    가장 광범위하고 거의 99% 대부분의 시스템에 호환되는 산업 표준 포맷이다. 
    (대부분 Base64 Text 파일)

__.pfx / .p12__

    PKCS#12 바이너리 포맷이며, Personal Information Exchange Format 를 의미한다. 
    주요 장점으로는 개인키,서버인증서,루트인증서,체인인증서를 모두 담을수 있어서 SSL 인증서 적용이나 또는이전시 상당히 유용하고 편리하다. 
    Tomcat 등 요즘에는 pfx 설정을 지원하는 서버가 많아지고 있다.  (바이너리 이진 파일)

__.key__

    주로 openssl 및 java 에서 개인키 파일임을 구분하기 위해서 사용되는 확장자이다. 
    PEM 포맷일수도 있고 DER 바이너리 포맷일수도 있으며, 파일을 열어봐야 어떤 포맷인지 알수가 있다. 
    저장할때 어떤 포맷으로 했는지에 따라 다르며, 확장자는 이름 붙이기 나름이다.

__.jks__

    Java Key Store 의 약자이며, Java 기반의 독자 인증서 바이너리 포맷이다. 
    pfx 와 마찮가지로 개인키+서버인증서+루트인증서+체인인증서를 모두 담을수 있어서 SSL 인증서 파일 관리시 유용하다. 
    Java 기반의 Tomcat 서버에서 SSL 적용시 가장 많이 사용되는 포맷이다. (바이너리 이진 파일)

__keystore__

    keyStore에는 개인 정보와 민감한 정보가 포함되어 있습니다.
    keyStore는 자격 증명을 저장합니다.
    KeyStore는 애플리케이션의 인증서를 보유합니다.

__trustsotre__

    TrustStore에는 개인 정보와 민감한 정보가 포함되어 있지 않습니다.
    TrustStore는 다른 사람의 자격 증명을 저장합니다.
    TrustStore는 신뢰하는 외부 시스템의 인증서를 보유합니다.

__인증서(Leaf Certificate)__

    HTTPS 서비스를 위하여 발급 받은 인증서서로 서비스가 올라간 서버에 적용, 중간 인증서에 인증서 정보가 Hash된 값을 전달하여 서명(중간 인증서 서버 비공개키로 암호화) 요청
    인증서가 포함하는 정보.
    * 인증서가 발급된 대상 도메인 이름
    * 발급받은 사람, 조직, 장치
    * 발급한 인증 기관
    * 인증 기관의 디지털 서명
    * 관련 하위 도메인
    * 인증서 발급 날짜
    * 인증서 만료 날짜
    * 공개 키(개인 키는 비밀로 유지됨)

__중간 인증서(Intermediate Certificate)__

    인증서를 서명해줌, Root 인증서에 의해 서명 된 상태

__Root 인증서(Root Certificate)__

    중간 인증서를 서명해줌, 본인의 서버 공개키로 Self 서명 된 상태, 브라우저들은 신뢰하는 Root 인증서 리스트를 가지고 있음(인증서에 따라 Self 서명이 아닌 다른 Root 인증서와 교차 서명하기도 함)

__인증 기관(Certificate Authoirty)__

    서명을 해주는 기관

___

# SSL-인증과정

___

1. TLS Handshaking - Certificate 과정에서 Client는 Server로부터 인증서 체인(인증서/중간 인증서/Root 인증서)을 전달 받음
2. 브라우저의 신뢰하는 Root 인증서 리스트와 ①에서 전달 받은 Root 인증서를 비교하여 신뢰된 Root 인증서인지 확인
3. Root 인증서 : 본인 서버 공개키로 Self 서명을 복호화하여 Self 서명 확인과 무결성 검증
4. 중간 인증서 : Root 인증서 서버 공개키로 서명을 복호화하여 서명 확인과 무결성 검증
5. 인증서 : 중간 인증서 서버 공개키로 서명을 복호화하여 서명 확인과 무결성 검증
6. 신뢰된 인정서임을 확인하고 TLS Handshaking 계속 진행...

___

## 인증서 구조

___

## #기본 구조(Chain 인증서 구조)

| Sign 인증서       | 인증서 종류      | 인증서 종류      | 비고                     |
|:---------------|-------------|-------------|------------------------|
| 루트CA 인증서(Self) | 루트CA 인증서    |             | 자신의 Private으로 Sign     |
| 루트CA 인증서       | 중개 인증서      |             | Root CA Private으로 Sign |
| 중개 인증서         | Server1 인증서 | Server2 인증서 | 중개 인증서 Private으로 Sign  |

## #일반적인 구조

#### 일반구조로 하려면 아래 단계에서 1. Root CA 인증서생성 -> 2. Server 인증서 생성을 하면 된다.

#### 2. Server 인증서 생서시에 아래 단계에서 Intermediate로 Sign 하는 부분을 Root CA로 Sign 하도록 바꾸면 된다.

| Sign 인증서       | 인증서 종류      | 인증서 종류      | 비고                    |
|:---------------|-------------|-------------|-----------------------|
| 루트CA 인증서(Self) | 루트CA 인증서    |             | 자신의 Private으로 Sign    |
| 루트CA 인증서       | Server1 인증서 | Server2 인증서 | CA 인증서 Private으로 Sign |

___


#3. ROOT CA 인증성 생성
------------------------

* **A. PRIVATE KEY 생성(root ca 개인키)**

```Bash
openssl genrsa -aes256 -out rootca.key.pem 4096
```

`* openssl 1.1.1 기준 PKCS#1 표준으로 키를 생성하고 PEM 형식 인코딩을 사용함.`

* **A-1. pkcs1 -> pkcs8 변환**

```Bash
openssl pkcs8 -topk8 -inform PEM -outform PEM -in rootca.key.pkcs1.pem -out rootca.key.pkcs8.pem
```

`* pkcs1은 'BEGIN RSA PRIVATE KEY' 으로 시작 pkcs8은 'BEGIN ENCRYPTED PRIVATE KEY' 으로 시작.`

* **B. 인증서 발급.**

```Bash
openssl req -new -x509 -days 3650 -sha256 \
-extensions v3_ca \
-config rootca.conf \
-key rootca.key.pem \
-out rootca.crt.pem 
```

[rootca.conf](#root-ca-opensslconfrootcaconf) 파일은 하단 참조

* **C. 발급된 인증서 보기**

```Bash
openssl x509 -text -in rootca.crt.pem
```

* **D. Key File Password 제거**

```Bash
openssl rsa -in rootca.key.pem -out rootca.key.pem
```

* **E. Key File 보기**

```Bash
openssl rsa -in rootca.key.pem -text -noout
```

#4. Intermediate(중개인증서) 생성
------------------------

* **A. PRIVATE KEY 생성(Intermediate 개인키)**

```Bash
openssl genrsa -aes256 -out intermediateca.key.pem 2048
```

* **A-1. pkcs1 -> pkcs8 변환**

```Bash
openssl pkcs8 -topk8 -inform PEM -outform PEM -in intermediateca.key.pkcs1.pem -out intermediateca.key.pkcs8.pem
```

`* pkcs1은 'BEGIN RSA PRIVATE KEY' 으로 시작 pkcs8은 'BEGIN ENCRYPTED PRIVATE KEY' 으로 시작.`

* **B. CSR(인증서 발급요청)**

```Bash
openssl req -new -key intermediateca.key.pem -out intermediateca.csr.pem -config intermediateca.conf
```

[intermediateca.conf](#intermediate-opensslconfintermediatecaconf) 파일은 하단 참조

* **C. Intermediate CRT(인증서 발급)**

```Bash
openssl x509 -req -days 3650 -extensions v3_ca -in intermediateca.csr.pem \
-CA ../root/rootca.crt.pem \
-CAcreateserial  \
-CAkey ../root/rootca.key.pem  \
-out intermediateca.crt.pem \
-extfile intermediateca.conf
```

`CAcreateserial: 시리얼 자동 지정 및 시리얼 파일 생성 (.srl)`    
`CAserial rootca.srl: CAcreateserial 로 한번 발급한 이후(server-n crt 발급시)에는 이 옵션으로 시리얼 생성 파일 추가`  
[intermediateca.conf](#intermediate-opensslconfintermediatecaconf) 파일은 하단 참조

* **D. 발급된 인증서 보기**

```Bash
openssl x509 -in intermediateca.crt.pem -text -noout
```

* **D. Key File Password 제거**

```Bash
openssl rsa -in intermediateca.key.pem -out intermediateca.key.pem
```

* **E. Key File 보기**

```Bash
openssl rsa -in intermediateca.key.pem -text -noout
```

## server 인증서 생성

___

* **A. PRIVATE KEY 생성(Server 개인키)**

```Bash
openssl genrsa -aes256 -out server.key.pem 2048
```

* **A-1. pkcs1 -> pkcs8 변환**

```Bash
openssl pkcs8 -topk8 -inform PEM -outform PEM -in server.key.pkcs1.pem -out server.key.pkcs8.pem
```

`* pkcs1은 'BEGIN RSA PRIVATE KEY' 으로 시작 pkcs8은 'BEGIN ENCRYPTED PRIVATE KEY' 으로 시작.`

* **B. CSR(인증서 발급요청)**

```Bash
openssl req -new -key server.key.pem -out server.csr.pem -config server.conf
```

[server.conf](#server-opensslconfleafconf) 파일은 하단 참조

* **C. server CRT(인증서 발급 - ROOT CA)**

```Bash
openssl x509 -req -days 1825 -extensions v3_user -in server.csr.pem \  
-CA ../rootca/rootca.crt.pem \
-CAcreateserial \  
-CAkey ../rootca/rootca.key.pem \  
-out server.crt.pem \  
-extfile server.conf
```

[server.conf](#server-opensslconfleafconf) 파일은 하단 참조

* **C. server CRT(인증서 발급 - Intermediate CA)**

```Bash
openssl x509 -req -days 3650 -extensions v3_user -in server.csr.pem \
-CA ../intermediate/intermediateca.crt.pem \
-CAcreateserial \
-CAkey ../intermediate/intermediateca.key.pem \
-out server.crt.pem \
-extfile server.conf
```

`CAcreateserial: 시리얼 자동 지정 및 시리얼 파일 생성 (.srl)`  
`CAserial rootca.srl: CAcreateserial 로 한번 발급한 이후(server-n crt 발급시)에는 이 옵션으로 시리얼 생성 파일 추가`  
[server.conf](#server-opensslconfleafconf) 파일은 하단 참조

* **D. 발급된 인증서 보기**

```Bash
openssl x509 -in server.crt.pem -text -noout
```

* **E. Key File Password 제거**

```Bash
openssl rsa -in intermediateca.key.pem -out intermediateca.key.pem
```

* **F. Key File 보기**

```Bash
openssl rsa -in intermediateca.key.pem -text -noout
```

* **G. CRT to PKCS12 Keystore 변환**

```Bash
openssl pkcs12 -export -in devServer.crt.pem -inkey devServer/server.key.pkcs8.pem -name "QMPC-DEV" -aes256 -out qmpc.keystore.p12
openssl pkcs12 -export -in prism-app02.crt -inkey prism-app02.key -aes256 -out prism-app02.keystore.p12 -name prism-app02 -CAfile rootca.crt -caname rootca -chain
```

* **H. Keystore VIEW(Key store list 보기)**

```Bash
/app/jdk-17.0.9/bin/keytool -list -keystore qmpc.keystore.p12 -storepass root -v
```

* **I. PKCS12 -> JKS**

```Bash
/app/jdk-17.0.7/bin/keytool -importkeystore -deststoretype JKS -destkeystore prism-app02.keystore.jks -deststorepass nms1234 -srckeystore prism-app02.keystore.p12 -srcstoretype PKCS12 -srcstorepass nms1234
```

* **J. JKS -> PKCS12**

```Bash
/app/jdk-17.0.7/bin/keytool -importkeystore -deststoretype PKCS12 -destkeystore prism-app02.keystore.p12 -deststorepass nms1234 -srckeystore prism-app02.keystore.jks -srcstoretype JKS -srcstorepass nms1234
/app/jdk-17.0.7/bin/keytool -importkeystore -deststoretype PKCS12 -destkeystore prism-app02.truststore.p12 -deststorepass nms1234 -srckeystore prism-app02.truststore.jks -srcstoretype JKS -srcstorepass nms1234
```

* **K. CRT IMPORT Keystore**

```Bash
/app/jdk-17.0.7/bin/keytool -keystore prism-app02.keystore.p12 -alias rootca -import -file rootca.crt -storepass nms1234
/app/jdk-17.0.7/bin/keytool -keystore prism-app02.truststore.p12 -alias rootca -import -file rootca.crt -storepass nms1234
/app/jdk-17.0.7/bin/keytool -keystore prism-app02.keystore.jks -alias rootca -import -file rootca.crt -storepass nms1234
/app/jdk-17.0.7/bin/keytool -keystore prism-app02.truststore.jks -alias rootca -import -file rootca.crt -storepass nms1234
```

## ROOT-CA-openssl.conf(rootca.conf)

___
rootca.conf 파일:

```text
[ req ]
default_bits                 = 4096
default_md                   = sha256
default_keyfile              = rootca.key.pem
distinguished_name           = req_distinguished_name
extensions                   = v3_ca

[ v3_ca ]
basicConstraints             = critical, CA:TRUE
keyUsage                     = critical, digitalSignature, cRLSign, keyCertSign
extendedKeyUsage             = clientAuth, serverAuth
subjectKeyIdentifier         = hash
authorityKeyIdentifier       = keyid:always,issuer

[req_distinguished_name ]
countryName                  = Country Name (2 letter code)
countryName_default          = KR
countryName_min              = 2
countryName_max              = 2

# 회사명 입력
organizationName             = Pitcher0303
organizationName_default     = Pitcher0303 Inc.

# SSL 서비스할 domain 명 입력
#commonName                  = Common Name
#commonName_default          = Common Name
#commonName_max              = 64
#ROOT CA openssl.conf****


#openssl req -config rootca.cnf -key rootca.key.pem -new -x509 -days 3650 -sha256 -extensions v3_ca -out rootca.crt.pem
```

___

## Intermediate-openssl.conf(intermediateca.conf)

___
intermediateca.conf 파일:

```text
[ req ]
default_bits                 = 2048
default_md                   = sha256
default_keyfile              = intermediateca.key.pem
distinguished_name           = req_distinguished_name
extensions                   = v3_ca

[ v3_ca ]
basicConstraints             = critical, CA:TRUE, pathlen:0
keyUsage                     = critical, digitalSignature, cRLSign, keyCertSign
extendedKeyUsage             = clientAuth, serverAuth
subjectKeyIdentifier         = hash
authorityKeyIdentifier       = keyid:always,issuer

[req_distinguished_name ]
countryName                  = Country Name (2 letter code)
countryName_default          = KR
countryName_min              = 2
countryName_max              = 2

# 회사명 입력
organizationName             = Pitcher0303
organizationName_default     = Pitcher0303 Inc.

# SSL 서비스할 domain 명 입력
commonName                  = Common Name
commonName_default          = intermediateca
commonName_max              = 64
#INTERMEDIATE CA openssl.conf****

#openssl req -new -key intermediateca.key.pem -config intermediateca.cnf -out intermediateca.csr.pem
#openssl x509 -req -days 3650 -extensions v3_ca -in intermediateca.csr.pem -CA ../root/rootca.crt.pem -CAcreateserial -CAkey ../root/rootca.key.pem -out intermediateca.crt.pem -extfile intermediateca.cnf

##검증
#openssl verify -CAfile ../root/rootca.crt.pem intermediateca.crt.pem
#openssl verify -CAfile RootCert.pem -untrusted Intermediate.pem UserCert.pem

```

___

## Server-openssl.conf(leaf.conf)

___
leaf.conf(server.conf) 파일:

```text
[ req ]
default_bits                = 2048
default_md                  = sha256
default_keyfile             = leaf.key.pem
distinguished_name          = req_distinguished_name
extensions                  = v3_user

[ v3_user ]
basicConstraints            = CA:FALSE
nsCertType                  = client, server, email
authorityKeyIdentifier      = keyid,issuer:always
subjectKeyIdentifier        = hash
keyUsage                    = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage            = clientAuth, serverAuth
subjectAltName              = @alt_names

[ alt_names]
IP.1 = 172.30.184.61
IP.2 = 172.30.184.62
IP.3 = 172.30.184.63

[req_distinguished_name ]
countryName                 = Country Name (2 letter code)
countryName_default         = KR
countryName_min             = 2
countryName_max             = 2

# 회사명 입력
organizationName            = Pitcher0303
organizationName_default    = Pitcher0303 Inc.

# SSL 서비스할 domain 명 입력
commonName                  = Common Name
commonName_default          = 
commonName_max              = 64

#openssl req -new -key leaf.key.pem -out leaf.csr.pem -config leaf.cnf
#openssl x509 -req -days 3650 -extensions v3_user -in leaf.csr.pem -CA ../intermediate/intermediateca.crt.pem -CAcreateserial -CAkey ../intermediate/intermediateca.key.pem -out leaf.crt.pem -extfile leaf.cnf

##검증
#openssl verify -partial_chain -CAfile ../intermediate/intermediateca.crt.pem leaf.crt.pem
#openssl verify -CAfile ../root/rootca.crt.pem -untrusted ../intermediate/intermediateca.crt.pem leaf.crt.pem

```

___

## openssl merge

___

    1. root ca chain인증서와 domain인증서를 합친다.
        그냥 간단하게 cat으로 두개의 파일을 merge한다.
        파일 순서는 domain -> root ca chain 순서이다.
        cat domain.crt root_ca.crt >> my.crt
        주의 : 인증서 파일은 기본적으로 마지막 파일끝에 뉴라인이 없는 경우가 많으므로, 위의 명령어를 그대로 실행하면 root ca파일이 정상적으로 입력되지 못하고 중간에 '-----END CERTIFICATE----------BEGIN CERTIFICATE-----' 와 같이 인증서 파일 내용이 겹치게 된다. 이때는 오류 발생
    위 명령어로 합쳐진 인증서가 정상적으로 동작하는지 아래의 명령어로 확인한다.
    openssl verify -verbose -purpose sslserver -CAfile root_ca.crt my.crt
    
    2. keystore에 새로운 인증서 추가 및 인증서 다시 생성.

---

## 인증서 검증

___

    #Intermediate 검증(단건)
    #openssl verify -CAfile ../root/rootca.crt.pem intermediateca.crt.pem
    #openssl verify -CAfile RootCert.pem -untrusted Intermediate.pem UserCert.pem
    #Server 검증(Chain)
    #openssl verify -partial_chain -CAfile ../intermediate/intermediateca.crt.pem leaf.crt.pem
    #openssl verify -CAfile ../root/rootca.crt.pem -untrusted ../intermediate/intermediateca.crt.pem leaf.crt.pem

___