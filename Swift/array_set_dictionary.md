# CollectionType(Array, Set, Dictionary) 비교

## 간단 설명
- Array
    - 리스트 컬렉션
    - random access가 가능. index를 통해 요소에 접근할 수 있다.

```swift
let array: [Int] [1, 1, 2, 3]
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