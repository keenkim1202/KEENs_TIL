# Swift에서의 Big O에 대하여

`Big O 표기법(Big O Notation)`에 대해 다들 들어본 적이 있을 것이다. 하지만 제대로 이해하고 무엇인지 아는 사람은 많지 않다.

이 글을 다 읽은 후에 `Big O 표기법`을 사용하여 알고리즘을 추론할 수 있기를 바란다.  
혹은 적어도 `Big O 표기법`이 무엇인지, 무엇을 표현하는지, 어떻게 하는지는 이해할 수 있기를 바란다.

...

---

## Big O 가 무엇인지 이해하기
`Big O 표기법`은 함수(function)이나 알고리즘(algorithm)의 성능을 설명하는데 사용되며 아래와 같이 표기한다.
```
O(1)
```

데이터의 크기가 증가함에 따라 실행 시간이 어떻게 되는지를 통해 성능을 측정한다.  
(*데이터의 모음을 `collection`이라고 앞으로 지칭하겠다.)

---

## O(1)
> constant time algorithm

<img width="600" src="https://user-images.githubusercontent.com/59866819/208836647-e9fb8f42-2c75-47a2-b5e2-796607309e7f.png">

가장 최고의 성능을 낼때 `O(1)`이라고 한다.  collection의 사이즈와 관계없이 항상 실행시간이 같은 경우를 의미한다.  
(즉, 데이터의 갯수가 1개여도 1억개여도 항상 같은 실행시간이 걸리는 것을 말한다.)  
`O(1)`을 시각화하면 아래의 그래프와 같다.

// 그래프 이미지 첨부 예정

### Swift에서 O(1) 에 해당하는 예시
```swift
let numberArray = [0, 1, 2, 3, 4, 5]
numberArray[2]
```

- 위와 같이 subscript를 사용하여 `Array`의 어느 한 원소에 접근할 때를 들 수 있다.

이 말은 즉, `Array`의 크기가 얼마나 크던간에 특정 위치(index)에 있는 값에 접근하여 읽어오는것은 항상 같은 성능을 갖음을 의미한다.

### 여기서 주의해야할 점은
- 항상 빠를 것이다
- 항상 성능이 좋을 것이다

라고 생각하는 것이다.

`O(1)`은 때로 매우 느리고 성능이 형편없을 수 있다.
```
O(1)이라 표기할 때 말하고자 하는 것은 해당 알고리즘의 성능이 적용되는 "데이터의 크기에 의존하지 않는다"는 점이다.
```

`O(1)`의 시간복잡도를 갖는 알고리즘은 상수(constant)로 간주된다.  
즉, 적용되는 데이터가 증가해도 성능이 저하되지 않는다.

---

## O(n)
> linear time algorithm
<img width="600" src="https://user-images.githubusercontent.com/59866819/208836770-3df2871e-c927-459e-b620-42bb3bc3f136.png">

`O(n)`은 collection의 크기가 증가함에 따라 시간복잡도도 증가하는 것을 말한다.  
그래프로 시각화해보면 선형적인 증가를 보여준다.  
알고리즘 실행 시간 혹은 성장 정도가 collection의 크기와 비례하여 선형적으로 증가한다.  

// 그래프 이미지 첨부 예정

## Swift에서의 예시
`map`을 예로 들 수 있다.  
`map`은 배열의 모든 아이템을 순회하기 떄문에 `O(n)`의 시간복잡도를 갖는 알고리즘이라 여길 수 있다.

Swift에서 기본적으로 제공하는 함수들 중 다수가 유사한 성능을 갖는다.  
- `filter`, `compactMap`, `first(where:)`

만약 당신이 `first(where:)`가 친숙하다면 이것이 O(n)의 시간복잡도를 갖는다는 것에 의아할 것이다.
(나는 O(1)인줄 알고 있었다.)  

왜냐면 위에서 O(n)은 collection의 모든 항목을 단순히 순회하고 방문 것으로 설명했기 떄문이다.
- `first(where:)`는 그렇지 않는데 말이지..

이 경우, `where`인자를 사용하여 일치하는 항목을 예측하고 찾는 순간 리턴할 수 있다.  
아래의 예시 코드를 보자.

```swift
let wordArray = ["Hi", "My", "name", "is", "keen"]
var numberOfChecked = 0

let fourLetterWord = wordArray.first(where: { word in
    numberOfChecked += 1
    return word.count == 4
})

print(fourLetterWord) // name
print(numberOfChecked) // 3
```

코드를 보면 내가 원하는 조건과 일치하는 단어를 찾는데 3번이면 된다.
위에서 말한 두루뭉실한 정의를 바탕으로 보면, 당신은 명확하게 모든 경우에 대해 `O(n)` 은 아니라고 주장할 수도 있다.
- `map` 처럼 `Array`의 모든 원소를 순회하지 않았기 때문에

### 그 주장은 맞다! 
`Big O 표기법`은 어떤 특정한 `use case`를 고려하지 않는다.  
이 알고리즘은 최악의 경우 일치하는 원소를 마지막까지 찾지 못하고 `nil`을 리턴할 수도 있다.

`Big O 표기법`은 평균(most common)과 최악(worst case)의 경우를 다룬다.  
`first(where:)`의 경우, 최악의 경우를 가정하는게 가장 합리적이다.
- 일치하는 원소를 찾을 거라는 보장이 없고,
- 만약 보장한다고 해도, 가장 처음 혹은 마지막에 발견할지 모르기에 모든 경우가 동등하지 않기 때문이다.

처음에 Array의 데이터를 읽어오는 경우는 O(1) 이라고 말한 이유는  
Array가 얼마나 많은 아이템들을 가지고 있던 성능은 항상 같기 떄문이다.  
Swift 공식문서를 보면 Array에 원소를 삽입(insert)하는 경우에 대해서 아래와 같이 기술했다.
```
Complexity: Reading an element from an array is O(1). 
Writing is O(1) unless the array's storage is shared with another array or uses a bridged NSArray instance as its storage, 
in which case writing is O(n), where n is the length of the array.
```
```
(해석)
복잡도: 배열에서 하나의 원소를 읽는 것은 O(1) 이다.
쓰는 것은 배열의 저장공간이 다른 배열과 공유되고 있거나 저장NSArray 인스턴스와 연결되어 사용하는 경우가 아니라면 O(1) 이다.
그 경우에는 배열의 길이가 n이라면 쓰는데 O(n)이 걸린다. 
```

## Swift에서 Array가 메모리 공간을 할당하는 방식
배열은 그들 안에 아이템을 삽입할 때 특별한 일이 발생한다.  
하나의 배열은 대게 자기자신을 위해 특정 크기의 메모리 공간을 아껴두고 있다.  
그 공간이 가득차고 나면, 아껴둔 메모리 공간이 충분하지 않게 될 수 있고, 그러면 그 배열은 자기 자신을 위한 더 많은 메모리 공간을 필요로 하게 된다.

이 메모리 재할당은 Swift문서에 언급되지 않은 성능 문제(performance hit)를 야기한다.  
이러한 문제가 발생하는 이유를 추측하보면 Swift 핵심 개발 팀이 `배열의 쓰기` 행위를 할 때 최악의 경우가 아닌 평균 성능을 사용하기로 결정한 것으로 보인다.  
```
위의 이유로 새로운 항목을 삽입(insert)할 때 배열 크기가 조정되지 않을 가능성이 높다.
```

----

## O(n^2)
> quadratic time algorithm

<img width="600" src="https://user-images.githubusercontent.com/59866819/208836801-97b6a2f2-3023-4f9f-aefb-1022d917d9ba.png">

O(n^2) 의 성능은 bubble sort와 같은 간단한 정렬 알고리즘에서 흔하게 볼 수 있다.  
쉬운 예제를 들면 아래와 같다:
```swift
let intergers = (0..<5)
let squareCoords = integers.flatMap { i in
    return intergers.map { j in
        return (i, j)
    }
}

print(squareCoords) // [(0,0), (0,1), (0,2) ... (4,2), (4,3), (4,4)]
```

`squareCoords`를 생성하기 위해서 `flapMap`을 사용하여 interger들을 순회하였다.  
그 `flapMap` 안에는, 다시 `map`을 사용하여 순회를 하였다.  
이것은 `return (i, j)` 라인은 `5^2` 즉, `25`번 실행됨을 말한다.
각각의 원소들을 배열에 추가하고, 생성되는 `squareCoords`는 기하급수적으로 증가한다.  
6x6 의 사각형은 36번, 7x7은 49, 8x8은 64번 순회할 것이다.  
이를 보면 `O(n^2)` 은 최선의 성능은 갖는다고 볼 수 없음을 알 수 있다.

----

## O(logn)
> logarithmic time algorithm
<img width="600" src="https://user-images.githubusercontent.com/59866819/208836902-a69aea50-7706-4d20-b44f-f78922535997.png">


