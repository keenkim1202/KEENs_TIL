# count == 0 vs isEmpty 무엇을 사용하는게 더 효율적일까?

문자열이 비어있는지 확인하는 방법은 두 가지가 있다.
```swift
let string: String = "hello"

string.count == 0 // 1
string.isEmpty // 2
```

- count의 시간복잡도는 O(n)  
- isEmpty의 시간복잡도는 O(1)

</br>

swift에서 문자열을 indexing할 때  
일반적으로 String.Index로 접근 시 시간복잡도는 O(1) 이 아닌 O(n) 이 된다.  
(String.Index를 자세히 알고싶다면 about_string.md 참고.)  

문자열을 index를 통해 접근하고 싶다면 아래와 같은 subscript()를 만들어줄 수 있다.
```swift
extension Stirng {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

string[1] // e
```

</br>

위에서 언급한 것처럼 문자열을 indexing할 때는 선형의 시간을 갖게 된다.  
문자열의 갯수가 n개라면 n의 시간이 소요된다.  
만약 특정 index의 문자를 출력하고자 한다면 `print(string[n])` 을 사용할 것이다.  
이것은 이미 문자열을 순회하면서 필요로하는 index위치의 문자를 출력하므로 O(n) 의 시간복잡도를 갖는다.  
그리고 `for`문을 돌면서 또 O(n) 의 시간복잡도를 갖으므로 총 O(n^2) 의 시간복잡도를 갖게 된다.  
```swift
for index in stride(from: 0, to: stirng.count, by: 2) { // O(n)
    print(string[index]) // O(n)
}

// 총 O(n^2)
```

</br>

## 1번
count의 경우 시간복잡도는 O(n) 이다.  
문자열의 문자 하나하에 대해 `String.Index`에 접근하면서 count해 나가기 때문이다.  
(참고: swift에서 문자는 눈으로 보기에 1글자여도 메모리상 각기 다른 크기를 차지하기 때문에 일정한 메모리 크기에 따라 index를 나누는 C언어와 달리 index를 통해서 특정 위치의 문자열에 대한 정보를 알 수 없다.)

## 2번
`isEmpty`는 문자열의 첫번째 index와 마지막 index가 같은지 비교하여 한번의 체크로 문자열이 비어있는지 판단하고 true, false로 리턴해준다.  
한번의 연산으로 끝나므로 시간복잡도는 O(1) 이다.

## 결론
1번과 2번의 시간복잡도를 비교해보았을 때,   
문자열의 길이가 얼마나 길지는 알 수 없겠지만 무조건 2번의 경우가 시간복잡도가 작거나 같다.  
작은 차이일 수도 있지만, 효율을 고려하면 O(1)인 2번 즉, `isEmpty` 를 사용하는 것이 좋다.</br>