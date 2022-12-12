# CollectionType(Array, Set, Dictionary) 비교

## 간단 설명
- Array
    - 리스트 컬렉션
    - random access가 가능. index를 통해 요소에 접근할 수 있다.

```swift
let array: [Int] [1, 1, 2, 3]
array[1] // 1
```

- Set
    - 중복되지 않은 값들의 컬렉션
    - 순서가 보장하지 않는다.
    - hashable 프로토콜을 채택하는 값들을 저장한다.
    - 교집합, 차집합 등 집합 연산 메서드를 제공한다.

```swift
let set: [Int] = [1, 1, 2, 3] // [1, 2, 3]

// 중복을 허용하지 않으므로, 중복된 값을 넣어도 제거된다.
```

- Dictionary
    - key - value 형태의 데이터를 관리하는 컬렉션
    - key 타입은 hashable 프로토콜을 채택한다.
    - 중복된 key는 허용하지 않는다.
    - 순서를 보장하지 않는다.

```swift
var dictionary: [Int: String] = [001: "홍길동", 002: "이철수", 003: "김영희"]
dictionary[001] // "홍길동"
dictionary[001] = "아무개"
dictionary[001] // "아무개"

// key 값은 유일하므로 001에 "홍길동"이라는 값이 있는 상태에서 "아무개"를 할당하면, "홍길동"이 "아무개"로 대치된다.
```

## 시간복잡도
mutating method들은 COW(Copy On Write)를 고려해야 한다.

> Array
- `append(_ newElement: Element)`
    - 평균: O(1)
    - 최악: O(n) -> 최악의 상황은 메모리를 재할당 해야할 때이다.
- `append(contentsOf:)`
    - 평균: O(m) -> m = Elements의 갯수
- `insert(_ newElement: Element, at i: Int)`
    - 평균: O(n)
    - i가 마지막 index일 경우 append와 시간 복잡도가 같다.
- `subscript(_:)`
    - read는 항상 O(1)
    - write는 평균 O(1)
    - NSArray와 bridged된 경우, 다른 array와 storage를 공유하고 있을 경우: O(n) -> COW 때문

|시간복잡도|메서드|추가설명|
|:--:|:--:|:--:|
|O(1)|`count`, `randomElement()`, `last`, `isEmpty`, `popLast()`, `removeLast()`, `reseversed()`, `swapAt(_:_:)`||
|O(n)|`reserveCapacity(_:)`, `remove(at:)`, `removeFirst()`, `removeAll(keepingCapacity:)`, `contains(_:)`, `contains(where:)`, `first(where:)`, `firstIndex(where:)`, `last(where:)`, `lastIndex(where:)`, `firstIndex(of:)`, `lastIndex(of:)`, `min()`, `max()`, `enumerated()`, `reverse()`, `shuffle()`, `shuffled()`, `split()`||
|O(NlogN)|`sort()`, `sorted()`|merge sort와 insertion sort 기반으로 [tim sort](https://youtu.be/2pjUsuHTqHc)를 사용한다.|
|O(m)|`elementsEqual(_:)`, `==`||

> Set
