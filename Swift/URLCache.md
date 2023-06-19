
# URLCache
" 캐시된 응답 객체를 URL request와 매핑하는 객체

```swift
class URLCache : NSObject
```

- `URLCache` 클래스는 NSURLRequest 객체를 `CachedURLResponse` 객체에 매핑하여 `URL` 로드 요청에 대한 응답 캐싱을 구현한다.
- `compositive in-memory`와 `on-disk cache`를 제공하며, 둘의 비율과 크긱를 조작활 수 있다.
- 캐시 데이터가 지속적으로 저장되는 경로를 제어할 수도 있다.

## 캐시가 제거될 수 있는가?
- iOS에서 `on-disk cache`는 시스템의 디스크 공간이 부족할 때 제거될 수 있지만, 앱이 실행되고 있지 않을 때만 제거된다.

## Thread Safety
- `iOS 8`, `macOS 10.10` 이후 버전부터는 thread safe 하다.
- 동시에 다수의 context에서 실행되어도 안전하지만, [cachedResponse(for:)](https://developer.apple.com/documentation/foundation/urlcache/1411817-cachedresponse), [storeCachedResponse(_:for:)](https://developer.apple.com/documentation/foundation/urlcache/1410340-storecachedresponse)
   와 같은 메서드는 조심하는게 좋다.
  - 같은 request에 대한 response를 read/write 시도할 경우 race condition을 피할 수 없다.
- `URLCahce의` 하위 클래스는 이런 thread-safe한 방식으로 재정의된 메서드를 구현해야 한다.

# Subclassing
- URLCache는 있는 그대로 사용하는게 가장 좋지만, 특정한 요구사항을 위해 subclass를 할 수 있다.
  - ex. 캐시된 응답을 선별, 보안 등의 이유로 저장 메커니즘을 다시 구현해야할 때
- 이 클래스를 제정의(override)할 때는 `task` 파라미터를 가지고 있는 메서드를 시스템에서는 선호한다.
- 따라서 subclassing을 할 때 다음과 같이 `task 기반 메서드`를 재정의 해야 한다.
  - "`response를 cache에 저장할 때`"는 [2번](https://developer.apple.com/documentation/foundation/urlcache/1410340-storecachedresponse) 대신에 [1번](https://developer.apple.com/documentation/foundation/urlcache/1414434-storecachedresponse)의 메서드를 재정의 하는 것이 좋다. (혹은 2번에 추가적으로 1번까지 재정의해라.)
    ```swift
    // 1
    func storeCachedResponse(
        _ cachedResponse: CachedURLResponse,
        for dataTask: URLSessionDataTask
    )
    
    // 2
    func storeCachedResponse(
        _ cachedResponse: CachedURLResponse,
        for request: URLRequest
    )
    ```
  - "`cache로 부터 response를 가져올 때`"는 [2번](https://developer.apple.com/documentation/foundation/urlcache/1411817-cachedresponse) 대신에 [1번](https://developer.apple.com/documentation/foundation/urlcache/1409184-getcachedresponse)의 메서드를 재정의 하는 것이 좋다. (혹은 2번에 추가적으로 1번까지 재정의해라.)
    ```swift
    // 1
    func getCachedResponse(
      for dataTask: URLSessionDataTask,
      completionHandler: @escaping @Sendable (CachedURLResponse?) -> Void
    )
    
    // 2
    func cachedResponse(for request: URLRequest) -> CachedURLResponse?
    ```
  - "`cache된 response를 제거할 때`"는 [2번](https://developer.apple.com/documentation/foundation/urlcache/1415377-removecachedresponse) 대신에 [1번](https://developer.apple.com/documentation/foundation/urlcache/1412258-removecachedresponse)의 메서드를 재정의 하는 것이 좋다. (혹은 2번에 추가적으로 1번까지 재정의해라.)
    ```swift
    // 1 
    func removeCachedResponse(for dataTask: URLSessionDataTask)
    
    // 2
    func removeCachedResponse(for request: URLRequest)
    ```
