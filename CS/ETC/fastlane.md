# Fastlane 이란?

```
The easiest way to build and release mobile apps.

fastlane is an open source platform aimed at simplifying Android and iOS deployment.
fastlane lets you automate every aspect of your development and release workflow.
```

- 위에 적혀있다시피, 모바일 앱의 배포 과정 자동화를 시켜주는 툴이다.
- 기존 iOS 배포 과정은 매우 오래걸린다. Archive 하는 도중에 Xcode가 튕기는 경우도 다수 있고, Archive한 후 Apple developer 사이트에 들어가 TestFlight를 배포하고, 심사를 작성하여 애플에 제출하고 심사를 통과 하면 앱스토어에 출시된다.
- 이 과정을 fastlane은 단축시켜준다.

</br>
</br>

## Fastlane 설치
컴퓨터에 `HomeBrew`가 설치되어있지 않다면 아래의 명령어를 통해 먼저 설치하자.
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```

</br>

`HomeBrew`가 설치되어있다면 아래의 명령어를 실행하면 된다.
```
brew install fastlane
```
(명령어 실행시 권한이 없다는 에러가 뜬다면 앞에 `sudo` 키워드를 붙일 것)

</br>

컴퓨터에 `gem`이 설치되어있지 않다면 `gem`을 설치한 후,
```
# rbenv 설치
brew install rbenv ruby-build

# rbenv를 bash에 추가
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile

# ruby 설치
rbenv install 2.4.4
rbenv global 2.4.4
```

</br>

fastlane을 업데이트할 떄 사용되는 `bundler` 도 설치해주자.
```
gem install bundler
```

</br>

이후 fastlane을 업데이트 하고자 할 때는 아래의 명령어를 입력하면 된다.
```
bundle update
```

</br>
</br>

## 기본 설정
Fastlane을 사용하고자하는 플젝트의 디렉토리로 이동하여 아래의 명령어를 실행하자.
```
fastlane init
```
- fastlane 초기화를 통해 이 디텍토리에서 fastlane을 설정할 수 있다. (pod init 처럼)

init을 하면 다음과 같은 문구가 출력된다.
```
What would you like to user fastlane for?
1. Automate screenshots
2. Automate beta distribution to TestFlight
3. Automate App Store distribution
4. Manual setup - manually setup your project to automate your tasks
```
- fastlane을 통해 하고 싶은 작업의 번호들을 입력하면 된다. (나중에 추가 가능하다. 이때 선택한 것을 미리 세팅해줄 뿐임)

2,3번의 경우에는 
`Apple ID`와 `application specific password`에 대한 정보를 입력해 주어야 한다.

> application specific password란?  [appleid.apple.com](https://appleid.apple.com/account/manage) > 로그인 > 맨밑의 '앱 암호' > 암호 생성   
시 발급되는 비밀번호이다.


- 애플 서버에 매번 로그인하는 과정을 fastlane이 알아서 앱 암호를 통해 로그인해준다.

위의 과정을 완료하면 아래의 파일이 생겨있을 것이다.
```
Gemfile
Gemfile.lock
fastlane/Appfile
fastlane/Fastfile
```
- Gemfile, Gemfile.lock
    - fastlane 의 버전 등을 관리하는 파일
- fastlane/
    - 해당 프로젝트, 애플 계정, fastlane 설정사항 등이 들어있는 디렉토리

</br>
</br>

## AppStore Connect 인증 방법
- 두가지 방법이 있다.
    - Cert, Sign
    - Match

나는 여기서 첫번째 방법을 사용할 것이다.
나의 애플 계정을 입력하고 인증서를 내 로컬 Keychain에 넣어두면 알아서 인증해주는 방식이다.
(로컬에 인증서가 없어도 알아서 다운받아 진행해준다.)

</br>
</br>

## 환경변수 설정
Appfile에 아래와 같은 내용이 들어있을 것
```
app_identifier("자신의 앱 identifier") # The bundle identifier of your app
apple_id("자신의 애플 아이디") # Your Apple email address
# For more information about the Appfile, see:
#     https://docs.fastlane.tools/advanced/#appfile
```
- 혼자 사용할 때는 문제가 발생하지 않지만, 여러명에서 git을 통해 사용하다보면 `apple_id` 에서 conflict이 일어날 것이다.
- 각자의 애플 아이디로 환경 변수를 설정하여 사용하는 것이 좋다.
    - 아래와 같이 환경변수를 설정해보자.

```
app_identifier("자신의 앱 identifier") # The bundle identifier of your app
apple_id(ENV["APPLE_ID"]) # Your Apple email address -> Please Set Env Variable in /fastlane/.env!!
# For more information about the Appfile, see:
#     https://docs.fastlane.tools/advanced/#appfile
```
- 아래의 명령어를 통해 `fastlane/` 폴더 안에 `.env` 파일을 만들고 에디터를 열어서
```
vi fastlane/.env
```

거기에 아래와 같은 형식으로 자신의 이메일을  작성하고 저장한다.
```
APPLE_ID="자신의 애플 아이디"
```
- vi를 닫고 저장하는 방법은 `esc`를 누른 후 `:wq` 를 입력하고 엔터 치면된다.

그리고 이 파일(`/fastlane/.env`)을 `.gitignore`에 추가하면 끝이다.

</br>
</br>

## TestFlight 설정
fastlane/Fastfile 에 Ruby 언어로 작성한다.
Fastlane 에서 제공하는 명령어들만 사용해도 괜찮다. 
(추가적인 세팅을 원하다면 알아서 찾아볼 것.)
예시 파일 내부 코드는 아래와 같다.
```
  desc "build app and upload to testflight"
  lane :beta do
    get_certificates
    get_provisioning_profile
    increment_build_number(
        build_number: latest_testflight_build_number + 1
    )
    build_app(
      configuration: "Debug"
    )
    upload_to_testflight
    slack(
      message: "Testflight 배포 성공!",
      slack_url: "https://hooks.slack.com/자신의 채널 훅스 링크"
    )
  end
```
- `lane`
    - lane 명을 설정할 수 있다.
    - 예시로 `beta`라고 설정하였다.
    - 앞으로 이 lane으로 사용할 것이라면 `fastlane beta` 라고 작성하면 된다.
- `get_certificates`, `get_provisioning_profile`
    - Cert, Sigh 방식에서 인증할 떄 사용되는 함수이다.
    - 각각 인증서, 프로필을 가져온다.
    - 여기서 에러가 난다면, 애플 계정 혹은 인증서에 문제가 있을 수 있으니 체크해보자.
- `increment_build_number`
    - 내 프로젝트 빌드엄버를 올려준다.
- `build_app`
    - configuration을 설정해주는 부분으로 Debug와 Release 중에 Debug로 설정해주었다. (사용할 버전으로 설정하면 된다.)
- `upload_to_testflight`
    - TestFlight에 업로드해준다.
    - AppStore Connect의 빌드 목록에 뜨는 것을 기다리는 과정을 생략하고 싶다면 `skip_waiting_for_build_processing: true` 를 추가하면 된다.

- `slack`
    - slack과 연동하여 배포 성공여부에 대한 메세지를 보내도록 설정할 수 있다.


</br>

실패한 경우에 대한 error handler도 추가할 수 있다.
```
platform :ios do

  ...

  error do |lane, exception, options|
    slack(
      message: "에러 발생 : #{exception}",
      success: false,
      slack_url: "https://hooks.slack.com/자신의 채널 훅 링크",
    )
  end

  ...

end
```
- iOS의 어떤 lane에서든 에러가 발생하면 slack에 메세지를 보내도록 설정하는 코드이다.

</br>
</br>

## AppStore 심사 제출
```
  desc "build app and release to App Store."
  lane :release do |options|
    if options[:v]
      get_certificates
      get_provisioning_profile
      increment_build_number(
        build_number: latest_testflight_build_number + 1
      )
      build_app(
        configuration: "Release"
      )
      upload_to_app_store(
        app_version: options[:v],
        submit_for_review: true,
        force: true,
        automatic_release: true,
        skip_screenshots: true,
        skip_metadata: false
      )
      slack(
        message: "AppStore 배포에 성공했습니다!",
        slack_url: "https://hooks.slack.com/자신의 채널 훅스 링크"
      )
    end
  end
```
-  `lane`
    - 버전 넘버작성 시 `v`를 적어주지 않으면 작동하지 않도록 설정해두었다.
- `build_app`
    - Release로 배포되도록 설정하두었다.
    - 실수로 Debug로 배포되지 않도록 하자.
- `upload_to_app_store`
    - 빌드를 업로드한 후 심사 제출하는 코드이다.
    - 옵션들은 원하는대로 bool값을 커스텀해주면 된다.

- 추가
    - `fastlane/metadata/ko` 디렉토리 안의 `release_notes.txt` 파일을 열어 변경 사항 문구를 작성한 후 `release` lane에서 실행하면 `metadata` 업로드 시 해당 정보를 포함해서 올려준다.

## 확장가능 CI/CD

> CI: Continuous Integration  
> 코드의 새로운 변경사항을 지속적으로 프로덕트에 통합

> CD: Continuous Deployment  
> 짧은 주기로 사용자에게 서비스를 제공할 수 있돌고 지속적으로 프로덕트를 배포하는 방법


TestFlight와 AppStore 배포에 편리성을 보고 fastlane을 접하였다.

CI/CD 파이프라인을 구축하여 개발자가 배포의 과정보다는 본래의 업무에 더 집중할 수 있다.

fastlane을 통해 빌드, 테스트, 배포를 모두 자동화할 수 있다.
 (ex. Jenkins와의 연계)

</br>
</br>
</br>

### 참고링크
[fastlane 공식문서](https://docs.fastlane.tools/)