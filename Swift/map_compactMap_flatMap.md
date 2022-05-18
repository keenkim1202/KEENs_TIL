# map, compactMap, flatMap

## map
- 각 요소에 대한 값을 컨테이너 내부에서 원하는 형태로 변경 후 배열의 형태로 반환한다.

```swift
func map<T>(_ transform: (String) throws -> T) rethrows -> [T]
```

```swift
let numbers: [Int] = [1, 2, 3, 4, 5]
numbers.map{ String($0) } // ["1", "2", "3", "4", "5"]
```

## compactMap
- 1 차원 배열에서 nil을 제거하고 옵셔널바인딩을 해주고 싶을 때 사용한다.
```swift
 func compactMap<ElementOfResult>(_ transform: (Int?) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
```
  
```swift
let optionalNumbers: [Int?] = [1, nil, 2, nil, 3, nil, 4, nil, 5]
optionalNumbers.compactMap { $0 } // [1, 2, 3, 4, 5]
optionalNumbers.flatMap { $0 } // flatMap을 사용해도 동일한 기능을 하나, deprecated 되고 대신 compactMap이 생겼다.
```
  
## flatMap
- 2차원 배열을 1차원으로 평평하게 만들어준다.
```swift
 func flatMap<SegmentOfResult>(_ transform: ([Int]) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
```
  
```swift
let twoDimentionNumbers: [[Int?]] = [[1, nil, 2, nil], [3, nil, 4, nil, 5]]
twoDimentionNumbers.flatMap { $0 } // [Optional(1), nil, Optional(2), nil, Optional(3), nil, Optional(4), nil, Optional(5)]
```
