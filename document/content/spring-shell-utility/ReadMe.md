# ReadMe

# 1. 구성
---

### 1.shell-maker

* check.sh, start.sh, stop.sh 등 실행용 shell 파일을 생성하는 script 모음 폴더

#### 1-01.shell-maker.bat

* shell을 생성하는 master maker shell factory 생성 스크립트(Window 용)

#### 1-02.shell-maker.sh

* shell을 생성하는 master maker shell factory 생성 스크립트(linux, bash shell 용)

#### 1-03.shell-maker-check.sh

* application 실행 여부를 체크하는 check.sh 생성 스크립트

#### 1-04.shell-maker-deploy.sh

* CI/CD(Jenkins, TeamCity 등) 에서 사용하는 배포용 deploy.sh 생성 스크립트

#### 1-05.shell-maker-script.sh

* shell을 생성하는 bin-script-generator.sh 생성 스크립트

#### 1-06.shell-maker-start.sh

* application을 실행 하는 start.sh 생성 스크립트

#### 1-07.shell-maker-start-opt.sh

* application을 옵션과 함께 실행 하는 start-opt.sh 생성 스크립트

#### 1-08.~~shell-maker-start-opt2~~.sh

* ~~이전 버전 shell 생성 스크립트~~(사용하지 않음)

#### 1-09.shell-maker-stop.sh

* application을 중단 하는 stop.sh 생성 스크립트

#### 1-10.shell-maker-check.sh

* application 실행 여부를 체크하는 check.sh 생성 스크립트

### 2.ant.xml

* 프로젝트 빌드시 사용하는 ant.xml

### 3.ant-cicd.xml

* CI/CD(Jenkins, TeamCity 등) 에서 사용하는 ant 설정파일

### 4.auto-deploy.sh

* CI/CD(Jenkins, TeamCity 등) 에서 사용하는 Deploy용 shell 파일

### 5.~~make-bin-script.sh~~

* ~~이전 버전 shell 생성 스크립트~~(사용하지 않음)

***

# 2. 사용전 준비 사항
--------------------------
> * 프로젝트가 특정 구조로 만들어 져야 한다.
> * 아래와 같은 구조가 아닐시 스크립트를 직접 변경 해야함.

프로젝트 구조:

* [로컬]
    * [**Application Home**] - Directory
        * **[bin]** - (필수)Directory, shell 파일 모음
        * **[mvnlib]** - (필수)Directory, library 파일 모음
        * **[src]** - (필수)Directory, source 파일 모음
        * **[ant.xml]** - (필수)File, ant 설정 파일(로컬용)
        * **[ant-cicd.xml]** - (필수)File, ant 설정 파일(CI/CD용)
        * **[pom.xml]** - File, pom file 또는 Gradle 등
* [서버]
    * [**Application Home**] - Directory
        * **[bin]** - (필수)Directory, shell 파일 모음
        * **[conf]** - (필수)Directory, confing 파일 모음, yaml, properties, xml 등
        * **[lib]** - (필수)Directory, library 파일 모음
        * **[Application.jar]** - (필수)File, 실행 Jar 파일.

> 로컬에서 폴더이름은 다를수 있으나 서버 배포시에는 위와 같게 해야함.  
> 서버에 ant.xml, ant-cicd.xml, pom.xml 은 배포되지 않음.  
> 로컬에서 폴더이름 다를 경우 - ant.xml **<&#33;--프로젝트에 맞게 바꿀것-->** 부분을 수정하면 된다.

[//]: # (로컬에서 폴더이름 다를 경우 - ant.xml <!--프로젝트에 맞게 바꿀것--> 부분을 수정하면 된다.)
***

# 3. 과정
--------------------------
[로컬]

1. 개발 완료
2. ant.xml 설정후 ant build
3. ant.xml에 설정한 위치에 아래와 같이 build 파일 생성됨.

* [서버]
    * [**Application Home**] - Directory
        * **[bin]** - (필수)Directory, shell 파일 모음
        * **[conf]** - (필수)Directory, confing 파일 모음, yaml, properties, xml 등
        * **[lib]** - (필수)Directory, library 파일 모음
        * **[Application.jar]** - (필수)File, 실행 Jar 파일.

4. 서버로 배포.
5. [Application Home]/[bin] 에서 bin-script-generator.sh 실행
6. 서버 시작 or 중지.

[CI/CD - TeamCity]
> 추가 필요...