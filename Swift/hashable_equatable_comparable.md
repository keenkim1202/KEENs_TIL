# hashable, equatable, comparable

## 공식문서
- [Hashable](https://developer.apple.com/documentation/swift/hashable)
    - [hash(into:)](https://developer.apple.com/documentation/swift/hashable/hash(into:))
- [Equatable](https://developer.apple.com/documentation/swift/equatable)
- [Comparable](https://developer.apple.com/documentation/swift/comparable)


## Hashable
> `Protocol` Hashable
> : A type that can be hashed into a Hasher to produce an integer hash value.

```swift
protocol Hashable: Equatable
```

- 간단히 말하면 정수 hash값을 제공하는 타입이다.
- Set, Dictionary 의 key값으로 `Hashable`을 준수하는 모든 타입을 사용할 수 있다.
- Swift의 `Dictionary<KeyType, ValueType>` 의 형태로 사용된다.
- 이때 반드시 KeyType은 `Hashable` 타입이어야 한다. (= 그 자체로 유일함을 나타낼 수 있어야 한다.)

### Hashable을 준수하는 Swift의 타입
- Stirng, Integer, Float, Bool, Set
- associated value 없는 enum
    - associated value를 갖는 경우 모두 Hashable을 준수하도록 정의해야 한다.
- 구조체에서 정의한 모든 저장 프로퍼티들

### 예시
공식 문서속 예시를 보자.

- grid 버튼들 안에서 특정한 한 위치를 묘사하는 GridPoint 라는 타입이 있다.
- 아래와 같이 정의되어있다.
```swift
// x-y 좌표 시스템 안의 한 점
struct GridPoint {
    var x: Int
    var y: Int
}
```

</br>

사용자가 이미 누른(tapped) 지점들의 Set을 나타내고자 한다.
GridPoint 타입은 아직 hashable 하지 않다.

아직 Set에 사용할 수 없다.
Set 안에 담아주려면 우선 Hashable을 준수해야하는데, 
준수하도록 하려면 == 연산자 함수를 제공해야 하고 hash(into:) 메서드를 적용해야 한다.
```swift
extension GridPoint: Hashable {
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
```

</br>

hash(into:) 메서드는 gridPoint의 x,y 프로퍼티를 hasher로 제공하도록 한다.
이 프로퍼티들은 == 연산자 함수 안에서 동등함(equality)을 테스트하는 데 사용되는 것과 같다.

이제 GridPoint는 Hashable 프로토콜을 준수하고 있으므로, 이전에 사용자가 눌렀던 grid point들의 Set를 만들 수 있다.
```swift
var tappedPoints: Set = [GridPoint(x: 2, y: 3), GridPoint(x: 4, y: 1)]
let nextTap = GridPoint(x: 0, y: 1)

if tappedPoints.contains(nextTap) {
    print("Already tapped at (\(nextTap.x), \(nextTap.y)).")
} else {
    tappedPoints.insert(nextTap)
    print("New tap detected at (\(nextTap.x), \(nextTap.y)).")
}
// Prints "New tap detected at (0, 1).")
```


## Equatable
> `Protocol` Equatable
> : A type that can be compared for value equality.

```swift
protocol Equatable
```

`Equatable`을 준수하는 타입들은 동일여부를 `==` 연산자를 통해 비교할 수 있다. 
- `!=` 연산자를 통해 같지 않음을 비교할 수도 있다.

`Swift standard library` 안에 있는 대부분의 기본 타입들은 `Equatable`을 준수한다.

sequence나 collection 연산을 할 때 Equatale을 준수함으로써 원소들을 비교하기 쉬워진다.

- 예를 들어, 배열이 특정 원소를 가지 고 있는지 체크하고자할 때, 
  - 동등성을 결정하기 위해 클로저를 제공하는 대신 배열의 원소가 Equatable 을 만족한다면 contains(_:) 메섣를 통해 자기 자신의 값을 넘겨줄 수 있다.

아래의 예제를 보면 contains(_:) 메서드가 문자열 배열에 어떻게 쓰이는지 확인할 수 있다.
```swift
let student: [String] = ["Kofi", "Abena", "Efua", "Kweku", "Akosua"]
let nameToCheck = "Kofi"

if student.contains(nameToCheck) {
    print("\(nameToCheck) is signed up!")
} else {
    print("No record of \(nameToCheck).")
}

// Prints "Kofi is signed up!"
```

### Equatable을 준수하는 방법
`Equatable`을 당신의 커스텀 타입에 준수시킴으로써 당신은 collection에서 특정 instance를 찾고자할 때 더 편리한 APIs를 사용할 수 있다.
`Equatable`은  또한 `Hashable`과 `Comparable` 프로토콜을 기반으로 하고 있어서,
- 커스텀 타입에 sets를 만들거나 collection의 원소들을 정렬하는 것과 같은 사용성을 준다. 

타입의 기존 선언 안에 `Equatable` 을 만족하도록 선언하고 다음의 기준을 만족할 때 커스텀 타입에 대한 `Equatable` 프로토콜의 기능을 사용할 수 있다:
- Struct의 경우, 
  - 해당 struct안의 모든 `stored proeprty`(저장 프로퍼티)들은 `Equatable`을 준수해야만 한다.
- Enum의 경우, 
  - 모든 `associated value`(연관값)들은 `Equatable`을 준수해야 한다.
  - (`associated value`가 없는 enum은 선언 없이도 `Equatable`을 준수한다.)

`Equatable` 만족하는 타입을 커스텀 하기 위해서는, 
- 위에 언급되지 않은 타입에 `Equatable`을 적용하거나
- `Equatable`을 만족하는 기존에 존재하는 타입을 확장(extend)
  - `==`라는 동등함을 비교하는 static 메서드 만든다.
하는 방법이 있다.

standard library는 `Equatable` 타입에 `==` 함수의 반대의 결과를 내뱉는 `!=` 연산자를 제공한다.

예제를 한번 보자.
`StreetAddress` 클래스는 building number, street name, 그리고 옵셔널인 unit number 를 가지고 있다.
이 클래스 타입을 정의하는 초기화 선언부는 다음과 같다:
```swift
class StreetAddress {
    let number: String
    let street: String
    let unit: String?
    
    init(_ number: String, _ street: String, unit: String? = nil) {
        self.number = number
        self.street = street
        self.unit = unit
    }
}
```

이제 당신은 address의 배열을 가지고 있다는 가정하에, 당신은 특정 주소가 맞는기 확인하려고 한다.
`containts(_:)` 메서드를 사용하기 위해서 closure를 사용하여 각각의 원소를 부르는 방법, `StreetAddress` 타입이 `Equatable`을 준수하도록 확장해주는 방법이 있다.
```swift
extension StreetAddress: Equatable {
    static func ==(lhs: StreetAddress, rhs: StreetAddress) -> Bool {
        return lhs.number == rhs.number &&
               lhs.street == rhs.street &&
               lhs.unit == rhs.unit
    }
}
```

이제 `StreetAddress` 타입은 `Equatable`을 준수한다.
당신은 `==` 을사용하여 두 인스턴스 사이의 동등성을 확인할 수 있고,
또는 `constains(_:)` 메서드를 사용하여 해당 인스턴스를 가지고 있는지 판별할 수 있다. 

```swift
let addresses = [
    StreetAddress("1490", "Grove Street"),
    StreetAddress("2119", "Maple Avenue"),
    StreetAddress("1400", "16th Street")]
let home = StreetAddress("1400", "16th Street")

print(addresses[0] == home) // false
print(addresses.contains(home)) // true
```  

동등함(`Equality`)은 대채가능함(`Substitutability`)을 암시한다.
- 어느 동등함을 비교할 수 있는 두 인스턴스는 값에 따라 달라지는 모든 코드에서 서로 대체하여 사용이 가능하다.

대체가능함을 유지하기 위해 `==` 연산자는 `Equatable`의 모든 가시적 측면을 고려해야 한다.
`Class`타입 이외의 `Equatable` 타입의 비가치적 측면을 노출하는 것은 권장되지 않으며, 노출되는 모든 것은 문서에서 명시적으로 지적해야 한다.
```
Q. 여기서 비가치적 측면이란 무엇일까?
```

Equatable 타이브이 인스턴스 사이의 동등성은 등가관계이므로, Equatable을 준수하는 어느 커스텀 타입도 아래의 3가지 조건을 만족해야 한다:
- a, b, c 라는 어떤 값이 있다고 하자.
  - `a == a` 는 항상 참(true)이다. (= Reflexivity)
  - `a == b` 는 `b == a` 임을 암시한다 (= Symmetry)
  - `a == b && b == c` 는 `a == c` 임을 암시한다. (= Transitivity)

게다가, 비동등함(inequality)은 동등함(equality)의 반댓말 이다. 
그래서 `!=` 연산자에 대한 어느 커스텀도 반드시 `a != b` 는 `!(a == b)` 을 암시함을 보장해야 한다.

`!=` 연산자 함수가 이 조건을 만족하는 것은 기본(default) 적용이다.

 

## Comparable
> `Protocol` Comparable
> : A type that can be compared using the relational operators <, <=, >=, and >.

```swift
protocol Comparable: Equatable
```
