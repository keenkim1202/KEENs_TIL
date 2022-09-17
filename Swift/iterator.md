# Iterator

> makeiterator() `Instance Method`  
> : Retuens an iterator over the elements of the collection.

```swift
func makeIterator() -> IndexingIterator<Self>
```





## 문자열 자르기 문제에 활용
- 문자열을 원하는 길이로 자르는 함수를 iterator를 활용하여 구현해보기


```swift
// str: 주어진 문자열, size: 자를 크기
func splitString(str: String, size: Int) -> [String] {
    var results: [String] = [] // 자른 문자열들을 담을 배열
    var count: Int = 0 // size 길이가 될 때까지 temp에 문자를 더할 때마다 증가시킬 count (최대 size)
    var temp: String = "" // size 길이의 문자열이 완성될 때까지 임시로 담아둘 문자열 변수
    
    for char in str {
        temp.append(char)
        count += 1
        
        if count == size {
            results.append(temp)
            count = 0
            temp = ""
        }
    }

    if !temp.isEmpty {
        results.append(temp)
    }

    return results
}
```

- 생각해보니 count 변수가 굳이 필요없을 것 같아서 없앴다.
```swift
func splitString(str: String, size: Int) -> [String] {
    var results: [String] = []
    var temp: String = ""
    
    for char in str {
        temp.append(char)
        
        if temp.count == size {
            results.append(temp)
            temp = ""
        }
    }

    if !temp.isEmpty {
        results.append(temp)
    }

    return results
}
```
