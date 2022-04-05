# Escaping Closure

### Escaping Closure 란?
- 클로저가 함수의 인자로 전달됬을 때, 함수의 실행이 종료된 후 실행되는 클로저이다.
```swift
class ViewModel {
    var completionHandler: (() -> Void)? = nil

    func fetchData(completion: @escaping () -> Void) {
        completionHandler = completion
    }
}
```
> 실행순서
1. 클로저가 fetchData() 함수의 completion 인자로 전달된다.
2. 클로저 completion이 conpletionHandler 변수에 저장된다.
3. fetchData() 함수가 값을 반환하고 종료된다.
4. 클로저 completion은 아직 실행되지 않았다.
(completion은 함수의 실행이 종료되기 전에 실행되지 않기 때문에  
함수 밖에서 실행되는 클로저이다.)


### Non-Escaping Closure 란?
- 반대로 함수의 실행이 종료되기 전에 실행되는 클로저이다.

```swift
func runClosure(closure: () -> Void) {
    closure()
}
```
> 실행순서
1. 클로저가 `runClosure()` 함수의 `closure` 인자로 전달된다.
2. 함수 안의 `closure()` 가 실행된다.
3.  `runClosure()` 함수가 값을 반환하고 종료한다.

</br>

## 예시
escaping closure의 예로는 비동기로 실행되는 `HTTP 요청 CompletionHandler` 가 있다.
``` swift
func makeRequest(_ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
  URLSession.shared.dataTask(with: URL(string: "http://somesite.com")!) { data, response, error in
    if let error = error {
      completion(.failure(error))
    } else if let data = data, let response = response {
      completion(.success((data, response)))
    }
  }
}
```
- `makeRequest()` 함수에서 실행되는 `completion` 클로저는 함수 실행 중에 즉시 실행되지 않고, URL 요청이 끝난 후 비동기로 실행이 된다.
- 클로저로된 인자인 `completion`의 타입에 `@escaping` 을 붙여서 `escaping closure` 라는 것을 명시해주어야 한다.

</br>

## Q. `@escaping` 키워드가 붙으면 무조건 escaping으로만 사용해야 할까?
### NO!
- `@escaping` 이 붙어있어도 `non-escaping closure`를 인자로 넣을 수 있다.
```swift
func runClosure(closure: @escaping () -> Void) {
    closure() // closure는 non-escaping 이지만 @escaping 사용이 가능
}
```

</br>

- 하지만 반대로 `escaping closure` 를 `@escaping` 키워드 없이 사용은 불가
``` swift
class ViewModel {
    var completionhandler: (() -> Void)? = nil
    
    func fetchData(completion: () -> Void) { // @escaping 누락으로 컴파일 에러 발생
        completionhandler = completion
    }
}
```

## Q. `@escaping`를 사용하면 escaping과 non-escaping을 모두 사용할 수 있다면 왜 나누어 사용하는가?
- 컴파일러의 퍼포먼스와 최적화 때문이다.
- non-escaping은 
    - 컴파일러가 클로저의 실행이 언제 종료되는지 알고 있다.
    ㄷ- 따라서 클로저에서 사용하는 특정 객체에 대한 `retain, release` 등의 처리를 생략해 객체의 `life-cycle`을 효율적으로 관리 가능하다.
- escaping은
    - 함수 밖에서 실행되기 떄문에 클로저가 함수 밖에서도 적절히 실행되는 것을 보장하기 위해,  
    클로저에서 사용하는 객체에 대한 추가적인 `reference cycle`을 관리해줘야 한다.
- 이러한 이유로 Swift에서는 필요할 때만 `escaping closure`를 사용하도록 구분해두었다.