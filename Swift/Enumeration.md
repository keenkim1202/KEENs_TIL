# Enumeration (열거형)

## 열거형이란
> An enumeration defines a common type for a group of related values   
> and enables you to work with those values in a type-safe way within your code.

: 관련된 값으로 이루어진 그룹을 공통 타입으로 선언하여 `type-safety`를 보장하여 코드를 작성할 수 있게 해준다.

```swift
// enum 예시
enum CompassPoint {
    case north
    case south
    case east
    case west
}

// 콤마(,)를 사용해 한줄에 적을 수도 있다.
enum Planet {
    case mercury, venus, earch, mars, jupiter, saturn
}

// dot(.)을 통해 값에 접근할 수 있다.
let direction: CompassPoint = .south
```

- C나 Objective-C는 int값들로 열거형을 선언하는 반면 swift에서는 case값이 string, character integer, floating값들을 사용할 수 있다.
- 열거형은 1급 클래스형(first-class types)여서 연산프로퍼티 사용, 초기화 지정, 초기선언 확장이 가능하다.

## 열거형을 왜 쓰는가?
좋은 코드의 기준이 보기 쉬운 깔끔한 코드, 효율적인 코드 라고 한다.
```
열거형을 사용하면...
- 코드를 보다 깔끔하게 작성할 수 있다.
- 코드 작성 시 실수도 줄여준다.
```
## 열거형의 특징
### 1) `switch` 문과의 연계
- switch문과 연계하여 사용하면 좋다.
    - 반드시 열거형의 모든 case를 완전히 포함해야 한다.
```swift
switch direction {
    case .north:
        print("현재 북쪽으로 향하고 있습니다.")
    case .south:
        print("현재 남쪽으로 향하고 있습니다.")
    case .west:
        print("현재 서쪽으로 향하고 있습니다.")
    case .east:
        print("현재 동쪽으로 향하고 있습니다.")
}

// 만약 모든 케이스 처리를 기술하는게 적당하지 않다면 default를 작성할 수 있다.
let myPlanet: Planet = .earth

switch myPlanet {
    case .earth:
        print("나의 행성은 지구입니다.")
    default:
        print("외계 행성입니다. 왹왹")
}
```

### 2) 연관 값 (Associated Values)
- 각 `case`에 `custom type`의 추가적인 정보를 저장할 수 있다.
- Alamofire를 사용할 때 `let value`, `let error` 부분이 연관값의 예시
```swift
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
```

### 3) 원시값 (RawValue)
- case에 raw값을 지정할 수 있다.
- raw값은 `String`, `Character`, `Integer`, `Float` 을 사용할 수 있다.
    단, 각 원시값은 열거형 선언에서 유일해야 한다. (중복X)
- 암시적 할당이 가능하다.
// RawValue로 초기화가 가능하다. -> 존재하지 않는 값으로 초기화하면 `nil`이 된다.
```swift
enum Number: Int {
    case one = 1 // 명시적으로 1 선언
    case two // 암시적으로 2 할당
    case three // 암시적으로 3 할당
}

// RawValue로 초기화
let myNumber = Number(rawValue: 2) // two
```

### 4) `RawValue`와 `Associated Value`의 차이는?
- `rawValue`는 개별 `case`와 대응대는 값으로 다른 `case`와의 구분되는 유일한 값이다.
- `associated value`는 특정한 `case`와 연결되는 타입이다.
```
즉,   
rawValue의 경우 값이 다르면 다른 case에 해당하지만, 
associated value는 동일한 case 내에서 다른 값을 가질 수 있다.
```