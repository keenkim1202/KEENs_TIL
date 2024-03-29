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

</br>

`Comparable` 프로토콜은 숫자나 문자열과 같이 고유한 순서를 가진 타입에 사용된다.  
표준 라이브러리의 많은 타입이 이미 `Comparable` 프로토콜을 준수한다.  
관계 연산자(relational operators)를 사용하여 인스턴스를 비교하거나 비교 가능한 유형을 위해 설계된 표준 라이브러리 메서드를 사용하려면 사용자 정의 타입에 `Comparable` 을 준수하도록 추가해주어야 한다.  

</br>

관계 연산자의 가장 익숙한 사용법은 숫자를 비교하는 것이다. 예를 들면:
```swift
let currentTemp = 73

if currentTemp ?= 90 {
    print("It's a scorcher!")
} else if currentTemp < 65 {
    print("Might need a sweater today.")
} else {
    print("Seems like picnic weather!")
}

// Prints "Seems like picnic weather!"
```

</br>

`Comparable` 타입으로 작업할 때 일부 sequence, collection의 특수한 버전을 사용할 수 있다.  
예를 들어, 배열의 요소가 `Comparable`을 준수할 경우 인자를 사용하지 않고 `sort()` 메서드를 호출하여 배열의 요소를 오름차순으로 정렬할 수 있다.
```swift
var measurements = [1.1, 1.5, 2.9, 1.2, 1.5, 1.3, 1.2]
measurements.sort()
print(measurements)

// Prints "[1.1, 1.2, 1.2, 1.3, 1.5, 1.5, 2.9]"
```

</br>

## Comparable 프로토콜을 준수하는 방법
`Comparable` 을 준수하는 타입은 less-than 연산자(`<`), equal-to 연산자(`==`) 를 적용할 수 있다.  
이 두 연산은 타입의 값에 엄격한 전체적인 순서를 부여하고, `a`와 `b` 두 값에 대해 다음 중 하나가 `true` 여야 한다.
- a == b
- a < b
- a > b

</br>

또한 아래의 조건이 충족되어야 한다:
- `a < a` 는 항상 false 다. (= Irrefelxivity)
- `a < b` 는 `!(b < a)` 를 암시한다. (= Asymmetry)
- `a < b` 그리고 `b > c` 는 `a < c` 를 암시한다. (= Transitivity)

</br>

사용자 정의 타입에 `Comparable`을 추가하려면 `<` 및 `==` 연산자를 `static` 메서드로 정의해야 한다.  
`==` 연산자는 `Comparable`이 준수하는 `Equatable` 프로토콜의 요구사항이다.  
- (Swift의 동등성에 대한 자세한 내용은 위의 `Equatable` 내용을 참고.)  

</br>

나머지 관계 연산자의 기본 구현은 표준 라이브러리에 의해 제공되므로,   
추가 코드 없이 사용자 타입의 인스턴스와 함께 `!=`, `>`, `<=`, `>=`를 사용할 수 있다.  

</br>

아래의 예를 보자.
여기의 Date 구조체는 날짜의 year, month, day 정보를 담고 있다:
```swift
struct Date {
    let year: Int
    let month: Int
    let day: Int
}
```

</br>

`Comparable`을 `Date` 타입에 준수시키려면, 일단 `Comparable`을 준수하도록 선언하고 `<` 연산자 함수를 작성해야 한다:
```swift
extension Date: Comparable { // 프로토콜 준수
    static func < (lhs: Date, rhs: Date) -> Bool { // 연산자 함수 추가
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
```

</br>

이 함수는 날짜의 최소 특정 비일치 속성(least specific nonmatching property)를 사용하여 비교 결과를 결정한다.
- 비교를 할 때, 여러개의 다른 속성이 존재한다면 크고 작음을 나타내는 기준이 모호하다.
- 최소한의 특정 속성을 활용하여 크고 작음을 비교할 수 있도록 나만의 비교 연산자를 정의하는 것이다.
    - 여러 속성을 활용해야하는 경우, 속성 간의 우선순위를 정한다.

예를 들어, 두 인스턴스의 `year` 속성은 같아도 `month` 속성이 동일하지 않은 경우 월 값이 작은 날짜는 두 날짜 중 작은 날짜가 된다.
```swift
Date(year: 2022, month: 12, day: 20) // a
Date(year: 2022, month: 11, day: 30) // b

// a와 b를 비교하면 year는 2022로 같고, month는 다르다.
// a의 month가 더 큰 수 이므로 두 인스턴스를 비교시 a > b 이다.
```

</br>

다음은 `==` 연산자 함수를 적용하는 것이다.  
이는 `Equatable` 프로토콜을 준수하기 위한 필수 요구조건이다.
```swift
    ...

    static func == (lhs: Date, rhs: Date) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month
            && lhs.day == rhs.day
    }
}
```

두 `Date` 인스턴스는 각각의 속성이 같으면 동일하다고 정의하였다.

</br>

이제 `Date`가 `Comparable`을 준수하므로, 이 타입의 인스턴스는 어떠한 관계 연산자로도 비교가 가능하다.
비교 예시를 하나 들어보겠다:
```swift
let myBirthday = Date(year: 1996, month: 12, day: 13) // Dec 13, 1996
let today = Date(year: 2022, month: 12, day: 28) // Dec 28, 2022

if myBirthday > today {
    print("당신은 아직 생일이 아닙니다.")
} else {
    print("올해 당신의 생일은 지났습니다! 한 살 더 먹은 것을 축하합니다 ^^")
}
// Prints "올해 당신의 생일은 지났습니다! 한 살 더 먹은 것을 축하합니다 ^^"
```

</br>

이 예시에서 사용된 표준 라이브러리에 의해 제공되는 `>` 연산자는 위에서 정의하고 적용한 `<` 연산자가 아니라는 점 참고하자.
```
Comparable을 준수하는 타입은 예외로 취급하는 값의 하위 집합,
즉 Comparable 프로토콜의 목적을 위해 의미 있는 인자의 영역 밖에 있는 값을 포함할 수도 있다.

예를 들어,
부동 소수 타입 (Floating Point nan)에 대한 특수값인 'not a number' 값은 정규 부동 소수점 값보다 작거나 크지 않다.
예외 값이 엄격한 전체적인 순서에 포함될 필요는 없다. (즉, 크고 작음을 비교할 수 없다.)
```