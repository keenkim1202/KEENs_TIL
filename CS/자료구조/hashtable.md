# Hash / HashTable

## 해시(hash)란,
> index에 해시값을 사용하는 자료구조로, 정렬을 하지 않고도 빠른 검색/삽입이 가능하다.

`다양한 길이를 가진 데이터`를 `고정된 길이를 가진 데이터`로 매핑(mapping)한 값이다.
이를 이용해 특정 배열의 인덱스, 위치, 위치를 입력하고자 하는 데이터의 값을 이용해 저장하거나 찾을 수 있다.
기존에 사용했던 자료 구조들은 탐색이나 삽입에 선형 시간이 걸리기도 했던 것에 비해,
해시를 이용하면 즉시 저장하거나 찾고자 하는 위치를 참조할 수 있으므로 더욱 빠른 속도로 처리할 수 있다.
해시값이라고도 한다.

## 특징
- 무결성
    - 특정한 데이터를 이를 상징하는 더 짧은 길이의 데이터로 변환하는 행위를 의미.
    - 상징 데이터는 원본 데이터가 조금만 달라져도 크게 달라지는 특성이 있어서 무결성을 지키는데 도움이 된다.
- 보안성
    - 해시는 기본적으로 복호화가 불가능하다.
    - 당연히 입력 데이터 집합이 출력 데이터 집합을 포함하고 있으므로 특정한 출력 데이터를 토대로 입력 데이터를 찾을 수 없기 때문이다.
    - 동일한 출력 값을 만들어낼 수 있는 입력 값의 가짓수는 수학적으로 무한개라 볼 수 있다.
    - 해시는 애초에 복호화를 수행할 수 없게 설계되어있다.
- 비둘기집 원리
    - 대부분의 해시 알고리즘은 항상 고정된 길이의 결과 문자열을 반환한다는 특징을 가지고 있다.
    - 비둘기가 5마리일 때 상자가 4개밖에 존재하지 않는다면 아무리 비둘기를 균등하게 분배해도 최소 한 상자에는 2마리의 비둘기가 들어가게 된다는 원리.
    - 이 원리에 따라 해시에서는 '서로 다른 입력값의 해시 결과 값이 동일한 문제' 즉, `해시 충돌`이 발생할 여지가 있다.

## 구현방식
> 개별 체이닝(Separate Chaining) 과 오픈 어드레싱(Open Addressing)

해시 충돌이 발생하여 같은 index가 만들어질 수도 있다.  
이 경우 보통 사용하는 방법이 두 가지 정도이다.  

하나는 리스트 각각의 index를 연결리스트(Linked List)로 만들어 새로 입력이 될 때마다 같은 해시를 가진다 하더라도 색인이 연결리스트로 구현되어 있기 때문에 
```
- 원하는 데이터의 접근이 가능한 개별 체이닝
- 다음에 위치한 색인들 중 비어있는 곳에 넣는 방식인 오픈 어드레싱 
```
이 있다.

### 개별 체이닝
해시 테이블의 기본방식이기도 하다.
충돌 발생 시 연결리스트로 link하는 방식이다. 출돌이 발생한 bannana과 bus를 서로 연결리스트로 연결한다.
이처럼 기본적인 자료구조와 임의로 정한 간단한 알고리즘만 있으면 되므로, 이 방식은 인기가 높다.
원래 해시 테이블 구조의 원형이기도 하며 가장 전통적이 방식이다. 


### 오픈 어드레싱
충돌 발생 시 탐사(Probing)를 통해 빈 공간을 찾아나서는 방식이다.
사실상 무한정 저장할 수 있는 체이닝 방식과 달리, 저전체  슬롯의 개수 이상은 저장할 수 없다.
충돌이 일어나면 데이블 공간 내에서 탐사를 통해 빈 공간을 찾아 해결하낟.
이 때문에 모든 원소가 반드시 자신의 해시값과 일치하는 주소에 저장된다는 보장은 없다.
가장 간단한 방식은 선형 탐사(Lenear Probing) 방식이며 충돌이 발생할 경우 해당 위치부터 순차적으로 탐사를 진행한다.
특정 위치가 선점되어 있으면 그 바로 다음 위치를 확인하는 식이다.
탐사를 짆애하다 비어있는 공간을 발견하면 삽입하게 된다. (가장 가까운 다음 빈 위치에 새 키를 삽입한다)
선형 탐사 방식은 구현 방법이 간단하면서도 의외로 전체적인 성능이 좋은 편이기도 하다.

## Swift에서의 해시 테이블
딕셔너리를 사용하면 된다.

딕셔너리는 key - value 로 값을 저장하고 가져온다.
딕셔너리는 해시 테이블로 구현되어있다. 
(참고: 해시테이블은 또 내부적으로 배열로 구현되어있다.)
그러면 이 해시테이블 내부 배열에서 key값을 통해 value를 가져오려면 테이블의 index 정보를 알아야 한다.

이 해당 index를 찾도록 도와주는 것이 hash function 이다.
hash function은 key값으로 연산을 하여 index값 즉, 해시의 주소값을 만들어준다.

## 구현해보기
### 1) 배열 만들기
```swift
var hashTable: [String?] = .init(repeating: nil, count: 3)
// 값이 없으면 nil을 뱉도록 구성
```

### 2) 해시 함수 만듥
일반적으로는 SHA256같은 안전한 알고리즘을 사용한다.
직접 만들어보는 연습을 하기 위해 임의로 함수를 만든다.
```swift
func hash(key: Int) -> Int {
    return key % 3
}
```

### 3) 해시 테이블에 저장하는 함수 만들기
key-value 쌍을 받아 이 값을 해시 테이블에 저장한다.
```swift
func updateValue(_ value: String, forKey key: String) {
    guard let key = UnicodeScalar(key)?.value else { return } // String 타입의 key를 Unicode를 사용하여 Int타입으로 만들어줌 (key가 Int형이면 생략)
    let hashAddress = hash(key: Int(key))
    hashTable[hashAddress] = value
}
```
- 비어있으면 insert, 이미 존재한다면 update

### 4) 해시 테이블의 값을 얻는 함수 만들기
```swift
func getValue(forkey key: String) -> String? {
    guard let key = UnicodeScalar(key)?.value else { return nil }
    let hashAddress = hash(key: Int(key))
    return hashTable[hashAddress]
}
```

### 중간 결과 확인
```swift
updateValue("apple", forKey: "a")
updateValue("bus", forKey: "b")
updateValue("car", forKey: "c")

print(hashTable) // [Optional("car"), Optional("apple"), Optional("bus")]
```

## 해시가 충돌할 경우
### Saperate Chaining (Open Hashing)
- 충돌이 일어날 경우 연결리스트를 이용하여 데이터를 추가로 뒤에 연결하여 저장하는 기법

### Linear Probing (Close Hashing)
- 충돌이 일어날 경우 해당 해쉬 주소값을 순회하면 가장 처음 나오는 빈 공간에 저장하는 기법


## 시간복잡도
```
O(1)
```
- 최악의 경우(모두 충돌이 발생한 경우): `O(n)`
- 평균: `O(1)`

## 장단점
```
시간복잡도 <-> 공간복잡도
```
> 장점
- 데이터 read/write 속도가 빠르다.
- key에 대한 데이터 중복 확인이 쉽다.

> 단점
- 일반적으로 저장 공간이 많이 필요하다. (충돌 문제를 대비해 저장공간을 넓게 잡는다.)
- 충돌 발생 시 해결을 위한 별도의 자료구조가 필요하다.

> 언제 사용하면 좋은가?
- 탐색이 잦은 경우
- 캐시를 구현할 때

## Ex
### HashTable
```swift
public struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]
  private var buckets: [Bucket]

  private(set) public var count = 0
  
  public var isEmpty: Bool { return count == 0 }

  public init(capacity: Int) {
    assert(capacity > 0)
    buckets = Array<Bucket>(repeatElement([], count: capacity))
  }
```

### HashTable 객체 만들기
```swift
var hashTable = HashTable<String, String>(capacity: 5) // capacity에 원하는 크기를 지정하여 선언
```

### 주어진 key값을 통해 index 값을 구하는 메서드
```swift
  private func index(forKey key: Key) -> Int {
    return abs(key.hashValue % buckets.count)
  }
```

### 사용법 (syntex)
```swift
hashTable["a"] = "apple"   // insert
let x = hashTable["a"]     // lookup
hashTable["a"] = "airplane"     // update
hashTable["a"] = nil       // delete
```

### subscript 함수 만ㄷ르기
```swift
  public subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    }
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
```

### key값에 따른 value를 구하는 함수
```swift
  public func value(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for element in buckets[index] {
      if element.key == key {
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```

### 값 수정
```swift
  public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    
    // Do we already have this key in the bucket?
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }
    
    // This key isn't in the bucket yet; add it to the chain.
    buckets[index].append((key: key, value: value))
    count += 1
    return nil
  }
```

### 값 삭제
```swift
  public mutating func removeValue(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)

    // Find the element in the bucket's chain and remove it.
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        buckets[index].remove(at: i)
        count -= 1
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```