# URLSession

# 개요

앱을 만들다보면 웹서버와 통신이 필요한 경우가 많다.

웹 서버 통신은 크게 2가지로 나눌 수 있는데,

- HTTP 통신: URL 기반으로 클라이언트에게 요청을 보내고, 서버로부터 응답을 받는 형태
- 웹소켓 통신: 클라이언트와 서버가 특정 port를 통해 연결되어 있는 양방향 형태. 실시간 통신에 주로 사용.

→ 이 중에서 HTTP/HTTPS 통신 방법을 URLSession으로 알아볼 것이다.

# Declaration

[공식문서](https://developer.apple.com/documentation/foundation/urlsession)

> `Class`  
> An object that coordinates a group of related, network data transfer tasks.


- URLSession은 네트워크 데이터를 전송하는 일을 한다.
- URLSession은 URL의 endpoint로부터 `데이터를 다운로드/업로드하는 API`를 제공하는 '클래스'다.
- 앱이 `not running`, `suspend` 상태에서 background download를 수행할 수 있도록 하기 위해 이 API를 사용할 수도 있다.

[URLSessionDelagate](https://developer.apple.com/documentation/foundation/urlsessiondelegate)와 [URLSessionTaskDelegate](https://developer.apple.com/documentation/foundation/urlsessiontaskdelegate)와 관련된 것을 사용하여 `authentication`을 지원하거나 `redirection`이나 `task completion` 같은 이벤트를 받을 수 있다.

# Thread Safety

[Thread-Safe에 대하여](https://www.notion.so/Thread-Safe-7e98b9ffcfac40309f48a2cd3fdff828)

- URL session API 는 `thread-safe` 하다.
- session과 task들을 어느 thread context에서든 자유롭게 생성할 수 있다.

→ 자체적으로 비동기적으로 작동하게 구현되어있으므로, 따로 비동기 처리를 할 필요가 없다.

대신 `completionHandler`를 작성할 때, UI관련 작업을 수행한다면 반드시 `Main thread`에서 작업해주어야 한다.

```
ex.
하나의 탭 또는 ㅊ아마다 하나의 세션을 만들어 볼 수 있고,
한 세션은 상호작용하는 데 사용, 다른 하나는 백그라운드에서 다운로드하는데 사용할 수 있다.
다운로드가 완료된 후, UI를 업데이트 하고 싶다면 main  thread에서 작업한다.
```

# URLSession Configuratoin

> URLSession은 configuration이라는 객체를 가지고 있다.

(업로드를 할 지, 다운로드를 할 지 등의 행동과 규칙을 정의하는 객체.)

- URLSession 객체를 초기화 하기 전에 가장 먼저 작업해야할 첫 단계이며,  
  타임아웃값, 캐싱 정책, HTTP header와 같은 값들로 구성된다.

### 종류

- `.default`
- `.epemeral`
- `.background`

configuration의 복사본으로 session을 세팅한다.

따라서 session이 생성되고 난 이후에 configuration 객체가 변동되어도 session은 변하지 않는다.

→ configuration을 수정하고 싶으면, 새로운 configuration으로 새로운 session을 만들어야 함!

# URLSession 종류

URLSession의 종류는 configuration 객체에 의해 결저된다.

### 공유 세션(singleton)

```swift
let sharedSession = URLSesssion.shared()
```

- 기본 요청을 위한 세션
- configuration 객체 없음
- 사용자 정의 불가

### 기본 세션

```swift
let defaultSession = URLSession(configuration: .default)
```

- disk에 기록함( 캐시, 쿠키, authentication)
- delegate 지정 가능 (순차적 데이터 처리)

### 임의 세션

```swift
let ephemeralSession = URLSession(configuration: .ephemeral)
```

- disk에 데이터를 쓰지 않음
- 메모리에 올려서 세션을 연결
- 세션 만료 시 데이터가 사라진다. → 비공개 세션

### 백그라운드 세션

```swift
let brackgroundSession = URLSession(configuration: .background)
```

- 백그라운드에서 업로드, 다운로드 가능
- 별도의 프로세스가 모든 데이터 전송을  처리 → suspend, not running 상태에서도 수행
- [참고 링크 - raywenderlich urlsession tutorial]((https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started))
    

# URLSession Task

각 세션 내에는 task를 추가할 수 있다.

각 task는 특정 URL에 대한 요청을 의미하며, HTTP redirection이 될 수 있다.

URL 주소만으로 요청할 때는 URL 객체를 이용하고,

주소와 HTTP 메소드, Body 까지 설정해야 할 때는 URLRequest 객체를 이용하면 된다.

```swift
// URL 객체
let url = URL(string: "https://api.address.com")

// URRequest 객체
let request: URLRequest = URLReuest(url: url)
request.httpMethod = "GET"
request.addValue("application/json", forHTTPHeaderField: "Accept")
```

→ URLRequest는 캐싱 정책, HTTP method, HTTP body 등을 설정할 수 있다.

## 종류

<img width="550" src="https://user-images.githubusercontent.com/59866819/167378634-7925cec2-b1e4-4863-b130-cbfb693e5bb4.png">

`URLSessionDataTask (HTTP GET)`

- reponse data를 받아서 Data 형태의 객체를 받아오는 작업
- JSON, XML, HTML

`URLSessionUploadTask (HTTP POST/PUT)`

- Data 객체 또는 파일 형태의 데이터를 서버로 업로드 하는 작업 (백그라운드 ok)

`URLSessionDownloadTask`

- 파일 형태의 데이터를 다운로드 하는 작업 (백그라운드 Ok)
- 일시정지, 재개, 취소 가능

```
+ 웹소켓 작업은 URLSession이 아니라 WebSocket 프로토콜을 사용
```

# Task 추가
```swift
session.dataTasks(with:)
```

## 사용 예시
```swift
extension URLSession {
  func request<T: Decodable>(_ request: URLRequest, completion: @escaping(T?, APIError?) -> Void) {
    URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        guard error == nil else {
          completion(nil, .failed)
          return
        }
        
        guard let data = data else {
          completion(nil, .noData)
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          completion(nil, .invalidResponse)
          return
        }
        
        guard response.statusCode == 200 else {
          completion(nil, .failed)
          return
        }
        
        do {
          let decoder = JSONDecoder()
          let userData = try decoder.decode(T.self, from: data)
          completion(userData, nil)
        } catch {
          completion(nil, .invalideData)
        }
      }

    }.resume()
  }
}
```
→ [코드 전문 보러기기](https://github.com/keenkim1202/SproutFARM/blob/main/SproutFARM/Sources/Extension/URLSession%2B%2BExtension.swift)
