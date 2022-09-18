# Iterator
- 컬렉션(Collection)에 저장되어 있는 요소(element)들을 순회하는 인터페이스이다.
- `Sequence` 프로토콜을 준수하는 collection들은 iterator로 만들 수 있다.

</br>

Iterator는 for 를 사용할 수 있게 해준다.
- filter, map, reduce, sorted와 같은 메서드들을 제한없이 사용할 수 있다.

프로그래밍을 하다보면 데이터들을 looping(iterating)할 일이 많다.
- ex) array 안의 원소들을 하나하나 가져올 때, 문자열 안의 개별적인 문자를 가져올 때, 특정 범위의 숫자를 가져올 때…

</br>

swift에서 iteration이 어떻게 작동하는지 알아보자.

</br>

## IteratorProtocol
- 매번 for 루프를 사용하 때, 당신은 이미 iterator를 사용하고 있다.
- 예를 들어 배열에 `for-in`문을 통해 loop를 돈다.
- `for-in`은 [syntatic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar)이다. (사용자가 사용하기 쉽게 한단계 포장한 것을 의미)
    - 그 아레에서는 `makeIterator()`를 통해 iterator가 만들어지는 일이 벌어지고 있다.
    - Swift는 while문을 통해 원소들을 훑는다. 마찬가지다.

- `makeIterator()` 메서드는 `IteratorProtocol` 과 매우 연관되어있는 `Sequence` 프로토콜 안에 정의 되어있다. 





## makeIterator()
> makeiterator() `Instance Method`  
> : Retuens an iterator over the elements of the collection.

```swift
func makeIterator() -> IndexingIterator<Self>
```

- collection을 이 메서드를 통해 iterator로 만들 수 있다.

```swift
let str: String = "hello"
var iterator = str.makeIterator()
```

## next()
> next() `Instance Method`  
> : Advances to the next element and returns it, or nil if no next element exists.


- next()를 부를 때마다 iterator값은 다음 element를 가리키게 된다.
- 값이 바뀌므로 mutate될 수 있도록 변수로 선언해주어야 한다. (let으로 선언 불가)
- next()를 불렀는데 다음 element가 존재하지 않는다면(마지막 element라면) `nil` 을 리턴한다.
    - 계속 next()를 부르면 계속 nil이 나온다.
```swift
iterator.next() // "h"
iterator.next() // "e"
iterator.next() // "l"
iterator.next() // "l"
iterator.next() // "o"
iterator.next() // nil
iterator.next() // nil
iterator.next() // nil
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
