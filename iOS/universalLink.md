# universal link
> Seamlessly link to content in your app or on your website.   
> With universal links, you can always give users the most integrated mobile experience,  
>  even when your app isn’t installed on their device.



- iOS에서만 작동하는 딥링크의 한 종류로 웹에서 앱을 호출하는 기능이 필요할 때 사용한다.
- 사용자가 유니버설 링크를 사용하면 링크 접근 시, 
  - 앱이 설치되어있는 경우 앱으로 이동
  - 설치되어 있지 않으면 앱을 설치하도록 앱스토어로 이동

(*deep link : 어플리케이션 내 특정 페이지에 도달할 수 있도록 하는 링크)


## 특징
- url 형태로 동작(IP 및 HTTP에선 동작하지 않음)
- iOS9 이상에서만 지원

## 사전작업
- 웹 서버 작업
	- 웹서버 : `AASA(Apple-App-Site-Association)` 파일 추가
	- 앱 : `Associated Domains` 추가

## 사용방법
- 소유한 도메인이 있어야 한다.
- 도메인 정보가 포함된 JSON 파일인 `AASA` 파일을 웹서버에 업로드 한다.
- 사용자가 앱 설치 시, 이 파일에 등록된 도메인으로 `AASA` 파일에 대한 요청을 보낸다.
- 사용자가 이미 앱을 설치했다면, 앱을 바로 실행시켜주는 링크의 도메인에서 호스팅이 된다.

### 주의사항
- redirection 이 없어야 함
- HTTPS를 지원해야 함
- 128KB 보다 작아야 함

----

## 웹서버 설정
### AASA 파일
- 파일 이름: `apple-app-site-association` (확장자 없음)
- 위치 : `well-known` 또는 `root` 에 추가

> iOS 13 이후
```swift
{
    applinks: {
        details: [
            {
                appIDs: ["<TEAM_DEVELOPER_ID>.<BUNDLE_IDENTIFIER>"],
                components: [
               		{
                	/: “*”
                    }
                ] 
            }
        ]
    }
}
```

> iOS 12 이전
```swift
{
    "applinks": {
        "apps": [],
        "details": [{
            "appID": "<TEAM_DEVELOPER_ID>.<BUNDLE_IDENTIFIER>",
            "paths": ["*"]
            },
            {
            "appID": "<TEAM_DEVELOPER_ID>.<BUNDLE_IDENTIFIER>",
            "paths": ["/files"]
        }]
    }
}
```

### 구성 요소
- `apps` : 유니버설 링크에서는 사용하지 않지만 빈 배열이라도 꼭 명시되어 있어야 한다.
- `details` : 웹사이트에서 핸들링되는 앱 목록 (한 웹사이트에서 유니버셜 링크를 사용하는 여러 앱 연동 가능)
- `appId` : 앱 식별값. 팀 아이디와 번들 아이디 사용
(형식 : `<TEAM_DEVELOPER_ID>.<BUNDLE_IDENTIFIER>`)

### 팀아이디 확인 방법
```
Apple Developer 사이트(https://developer.apple.com/) > Account > Certificates, IDs & Profiles > Identifiers
```

### 번들 아이디 확인 방법
```
연결할 앱 Xcode Project > Target > General > Identity
```

- paths : 앱에서 지원하는 웹 사이트 경로

----

## 앱 설정

- 앱에서 유니버셜 링크를 허용할 도메인을 추가해야 한다.

- 아래의 위치에 추가
```
Project > Target > Signing&Capabilities> Associated Domains에 Domains 추가
```

- ex) applinks 형식
```
//applinks:your_dynamic_links_domain
applinks:example.com
applinks:*.example.com
```

## 사용자가 앱 설치 시
등록된 도메인의 해당 URL의 `.well-known/apple-app-site-association` 경로에서 AASA 포맷을 확인하라고 파일에 대한 요청을 보냄

(`entitlements`로 등록이 잘 되었는지 확인 가능) 

- 여기까지 설정하면 앱과 웹이 연결되어 서로의 정보를 알고 있는 상태이다.
- 메모앱에서 설정한 도메인주소를 입력 후 클릭 시 연결한 앱이 실행되는지를 통해 테스트해볼 수 있다.

---

## 동적링크 URL handle 하기
유니버셜 링크로 들어오는 요청은
SceneDelegate의 `scene(scene: continue userActivity:)` 메서드에서 전달받은 `NSUserActivity` 객체를 통해 처리할 수 있다.

> iOS 13 이상
```swift
func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
	guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
    	let incomingURL = userActivity.webpageURL,
        let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
        let path = components.path else {
                return
        }
        
    //도메인 주소의 쿼리값을 받음
 	let params = components.queryItems ?? [URLQueryItem]()
	print("path = \(incomingURL)")
	print("params = \(params)")
}

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for urlContext in URLContexts {
        let urlToOpen = urlContext.url
        // ...
    }
}
```

> iOS 9 이하
```swift
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    NSURL *url = userActivity.webpageURL;
    // ...
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    // ...
}
```




참고 자료
- [Apple Developer - Universal Link](https://developer.apple.com/ios/universal-links/)
- [유니버설링크와 딥링크 차이점](https://www.adjust.com/ko/blog/universal-links-vs-deep-links/)
