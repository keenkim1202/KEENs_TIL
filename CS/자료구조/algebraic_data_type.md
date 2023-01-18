# Algebraic Data Types (ADT)
> 대수적 자료형

Functional Programming(함수형 프로그래밍)과  type theory(타입 이론)에서 `Algebraic data type`은 다른 타입의 결합으로 만들어지는 합성 타입(`Composite type`)을 가리킨다.

```
type thoery
: type의 개념을 사용하여 합법적으로 사용 가능한 논리식에 제한을 두는 논리 체계들의 총칭.
논리식이란 어떤 논리 체계의 언어 속 기호들로 구성된 유한 문자열 가운데, 합법적인 명제로 여길 수 있는 것들을 말한다.
```

대수적 자료형의 대표적으로 `Sum type`(합 타입), `Product type`(곱 타입) 이 있다.
- Sum : `Union`(공용체)
- Product : `Record`(레코드), `Tuple`(튜플)

`Algebraic data type`은 다른 자료형의 대체로 다른 자료형을 생성자로 감싸고 있다.
어떤 값도 대수적 자료형의 생성자의 인지가 될 수 있다.  

반면에 다른 자료형은 생성자를 실행하 수 없으며 `Pattern matching`(패턴 매칭) 과정을 통해 생성자를 얻을 수 있다.

가장 일반적인 `Algebraic data type`은 두 개의 생성자를 가진 `list`(목록형) 이다.  
`list`는 비어있는 `list`를 위해 `nil` 또는 `[]` 를 지원한다.

----

## Primitive and Composite types
### Primitive Types (기본 자로형)
모든 프로그래밍 언어는 `primitive type`(원시 타입)을 가지고 있다.  
그들은 주로 간단하고 `atomic` 하다.  
(더 이상 쪼갤 수 없는 가장 작은 단위 라는 의미에서 `atomic` 하다고 표현한다.)
- primitive type : Bool, Int, Float, Double, Character, ...

### Composite types (복합 자료형)
`composite type`은 다수의 primative type 혹은 composite type 으로 구성된 것을 말한다.  
`Int`들의 배열, `age`와 `name`필드를 갖고 있는 `Person` 타입과 같은 것들을 말이다.
- composite type : String(Charater들의 배열), [Int], [String: Int], Person(age: name:) , ...


----

## Product and Snum types
### Product Types (곱 타입)
`product type`은 대부분의 프로그래밍 언어에 존재한다.  
`product type`은 `primitive type`들을 `AND 결합`(AND conjunction)으로 결합시킨 것이다.  
예를 들어 person이 `age` 와(AND) `married` 두 가지 속성을 모두 가지고 있을 수도 있다.  
- Swift에서 `product type`은 `Tuple`, `Struct`, `Class`를 나타낸다.
```swift
// Example:
// Tuple
(20, true) // (UInt8, Bool)

// Struct
struct Person {
    let age: UInt8
    let isMarried: Bool
}

Person(age: 20, isMarried: true)

// Class
class Person {
    let age: UInt8
    let isMarried: Bool

    init(age: UInt8, isMarried: Bool) {
        self.age = age
        self.isMarried = isMarried
    }
}

Person(age: 20, isMarried: true)
```

Person 타입이 가질 있는 가능한 모든 값들을 계산해보면, `isMarried 필드의 갯수` * `age 필드의 갯수`를 알아야 한다.
- 우리는 그들의 `product`(곱)이 필요한 것이다.
    - `isMarried`에 들어갈 수 있는 값: true, false -> 2개
    - `age`에 들어갈 수 있는 값: 0, 1, ... 255 -> 256개

```
위의 경우 사람이 최대 255살까지 살 수 있다는 가정하에 
우리는 최대 `2 * 256 = 512` 가지의 경우의 수를 갖을 수 있다.
```

### Sum Types (합 타입))
`sum type`은 `primitive type`들을 `OR 결합`(OR conjunction)으로 결합시킨 것이다.  
그들은 choice(선택)을 나타낸다.
이 에시에서 우리는 Documents의 열거를 가지고 있다.

`Document`는 birth certificate(출생 증명서) OR(혹은) driving license(운전면허증) 중 하나가 될 수 있다.
- 두 가지가 동시에 될 수는 없다. 그들은 상호 배타적이다.

Swift는 `associated value`를 통해 `enum`을 지원한다.
이 예제에서 birth certificate는 age와 함께, driving license는 isExpired 라는 Bool 값과 함꼐 들어온다.

```swift
enum Document {
    case birthCertificate(age: UInt8)
    case drivingLicense(isExpired: Bool)
}

let birthCertificate = Document.birthCertificate(age: 20)
let drivingLicense = Document.drivingLicense(isExpired: false)
```

Document 타입에서 가능한 모든 값들을 계산해보면, 우리는 각각의 케이스의 모든 값들을 더하면 된다.
- driving license는 만료되거나 아니거나 두 가지 경우의 수가 있다.
- birth certificate는 `age`를 0 ~ 255 의 경우의 수가 있다.

```
위의 경우 사람이 최대 255살까지 살 수 있다는 가정하에 
우리는 최대 `2 + 256 = 258` 가지의 경우의 수를 갖을 수 있다.
```

## 실전 에제
물론 Sum 과 Product type을 결합하여 사용할 수도 있다.  
`Struct`는 안에 `Enum` 값을 가질 수 있고, `Enum` 안에 `Struct` 값을 가질 수도 있다.  
그렇기 때문에 application 상태를 모델링할 때 굉장한 유연성을 제공한다.  

예를 들어, 3가지 상호 배타적인 `ScreenState`가 있다.
만약 screen이 `loaded` 상태일 때, `Journey`의 배열에 접근할 수 있다.
- `Location`타입인 `start`와 `end`의 product에 해당한다.

만약 screen이 `loading` 상태일 때, journeys는 존재하지 않는다.
- type system에서 불가능 상태를 표현할 수 없다.
- data가 아직 로딩중일 때는 절대 실수로 journeys를 랜더링해서는 안된다. (값이 존재하지 않으니까)
```swift
// Sum type
enum ScreenState {
    case loading
    case loaded(userJourneys: [UserJourney])
    case failed(error: Error)
}

// Product Type
struct Journey {
    let start: Location
    let end: Location
}
```

[Point-Free](https://www.pointfree.co/)의 영상중 하나인 [algebraic data types](https://www.pointfree.co/episodes/ep4-algebraic-data-types) 에 또 다른 좋은 예시가 있다.
Algebraic Data Types를 사용하지 않는 Apple의 API 의 문제점에 대한 이야기이다.
이 API는 network request를 생성하고 completion handler에서 다수의 illegal 상태를 허용한다.
이것은 ADT를 지원하지 않는 Objective-C로 구현된 것이기에 어쩔 수 없다.

```swift
// URLSession dataTask(with: completionHandler:)
func dataTask(with url: URL, compeltionHandler: (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
```

`completionHandler`에 집중해보자.
Data, URLResponse, Error 모두 optional 타입을 받는다.
모두 8개의 경우의 수를 가지고 있고, 대부분이 illegal 하다.
경우의 수를 모두 작성해보면...
```swift
(Data?, URLResponse?, Error?)
-----------------------------
(Data?, URLResponse?, Error?)
```

|Data|URLResponse|Error|is illegal|
|:--:|:--:|:--:|:--:|
|data|response|nil  | |
|nil |nil     |error| |
|nil |response|error| |
|nil |response|nil  |O|
|data|response|error|O|
|data|nil     |error|O|
|data|nil     |nil  |O|
|nil |nil     |nil  |O|

illegal한 상태를 피하기 위해서 [Ole Begemann의 블로그](https://oleb.net/blog/2018/03/making-illegal-states-unrepresentable/)에 소개된 두 개의 새로운 product type를 사용하면 고칠 수 있다.
response의 `Success`와 `Failure` 값을 들고 있는 것이다.
```swift
extension URLSessionDataTask {
    struct Success {
        let data: Data
        let response: URLSResponse
    }

    struct Failure: Error {
        let error: Error
        let response: URLResponse?
    }
}
```

우리는 이 타입의 use case와 맞아 떨어지는 Swift에 내장된 Sum type인 `Result`타입과 엮어 사용할 수 있다.
```swift
Result<URLSessionDataTask.Sucess, URLSessionDataTask.Failure>
```

위의 illegal한 경우의 수를 포함하는 경우와 비교해보자.
```swift
.success(Success(data: data, response: response)) // is illegal? : NO
.failure(Failure(error: error, response: nil)) // is illegal? : NO
.failure(Failure(error: error, response: response)) // is illegal? : NO
```

이 새로운 API를 사용하면 모든 케이스를 legal하게 사용할 수 있다.