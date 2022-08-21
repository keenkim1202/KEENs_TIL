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

## Comparable
> `Protocol` Comparable
> : A type that can be compared using the relational operators <, <=, >=, and >.

```swift
protocol Comparable: Equatable
```
