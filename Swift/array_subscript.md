# Array 에서 subscript를 사용하여 Index Out of Range 방지하기

```swift
extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

var someArr: [Int] = [1,2,3,4,5,6]

someArr[safe: -1] // nil
someArr[safe: 10] // nil
someArr[safe: 4] // 5
```

- subscript를 사용하면 nil 이 반환되므로 `Index Out of Range` 가 발생하지 않는다.
