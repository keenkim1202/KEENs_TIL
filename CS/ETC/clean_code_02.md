# Clean Code 2장
: 의미 있는 이름

> 아래에 나오는 코드들은 Swift로 의역하여 작성하였습니다.

소프트웨어에서 이름은 어디나 쓰인다. 이름을 잘 지으면 여러모로 편하다.   
이 장에서는 이름을 잘 짓는 간단한 규칙을 몇 가지 소개한다.
.
.
.

## 의도를 분명히 밝혀라
- 좋은 이름을 짓는데는 시간이 좀 걸리지만, 좋은 이름으로 절약하는 시간이 훨씬 많다.
- 더 나은 이름이 떠오르면 개선하기 바란다. 그러면 코드를 읽는 사람이 좀 더 행복해질 것이다.
```swift
var d: Int // 경과시간(단위: 날짜)
```
- `d`는 아무 의미도 드러나지 않는다.
- 측정하려는 값과 단위를 표현하는 이름이 필요하다.

</br>

```swift
var elapsedTimeInDays: Int
var daysSinceCreation: Int
var daysSinceModification: Int
var fileAgeInDays: Int
```
- 의도가 드러나는 이름을 사용하면 코드 이해와 변경이 쉬워진다.

</br>

> 다음 코드는 무엇을 할까?

```swift
func getThem() -> [Int] {
    var list: [Int] = []

    for i in 0..<theList.count {
        if theList[i] == 4 {
            list.append(i)
        }
    }

    return list
}
```
- 복잡하거나 어려운 로직이 아님에도 코드가 하는 일을 짐작하기 어렵다.
- 문제는 `코드의 단순성`이 아니라 `코드의 함축성`이다.
    - 코드의 맥락이 코드 자체에 명시적으로 드러나지 않는다.

암암리에 독자가 다음과 같은 정보를 안다고 가정하자.
1. theList에 무엇이 들어있는가?
2. theList에서 0번째 값이 어째서 중요한가?
3. 값 4는 무슨 의미인가?
4. 함수가 반환하는 리스트 'list'는 어떻게 사용하는가?

- 이와 같은 정보는 위의 코드에서 드러나지 않지만, 정보 제공은 "충분히" 가능했다.

</br>

지뢰찾기 게임을 만든다고 가정하자.
- 그러면 theList가 게임판이라는 것을 을 알 수 있으므로 gameBoard로 바꿔보자.
- 게임판에서 각 칸은 단순 배열로 표현한다. 배열에서 0번째 값은 칸 상태를 뜻한다.
- 값 4는 깃발이 꽂힌 상태를 가리킨다. 
위의 내용을 바탕으로 각 개념에 이름만 붙여도 코드가 상당히 나아진다.

```swift
let flagged: Int = 4

func getFlaggedCells() -> [Int] {
    var flaggedCells: [Int] = []

    for status in 0..<gameBoard.count {
        if gameBoard[status] == flagged {
            flaggedCells.append(status)
        }
    }

    return flaggedCells
}
```
- 코드의 단순성을 변하지 않았다. 그런데도 코드는 더욱 명확해졌다.
- 한 걸음 더 나아가, 
    - init 배열을 사용하는 대신 칸을 간단한ㄴ 클래스로 만들어도 되겠다.
    - isFlagged 라는 좀 더 명ㅇ시적인 함수를 사용해 flagged 라는 상수를 감춰도 좋겠다.

```swift
func isFlagged() -> Bool {
    if self == 4 {
        return true
    } 

    return false
}

func getFlaggedCells() -> [Int] {
    var flaggedCells: [Int] = []

    for cell in gameBoard {
        if cell.isFlagged() {
            flaggedCells.append(status)
        }
    }

    return flaggedCells
}
```

```
단순히 이름만 고쳤는데도 함수가 하는 일을 이해하기 쉬워졌다. 이것이 좋은 이름이 주는 위력이다.
```


## 그릇된 정보를 피하라

## 의미있게 구분하라

## 발음하기 쉬운 이름을 사용하라

## 검색하기 쉬운 이름을 사용하라

## 인코딩을 피하라

## 자신의 기억력을 자랑하지 마라

## 클래스 이름

## 메서드 이름

## 기발한 이름은 피하라

## 한 개념에 한 단어를 사용하라

## 말장난을 하지마라

## 해법 영역에서 가져온 이름을 사용하라

## 문제 영역에서 가져온 이름을 사용하라

## 의미 있는 맥락을 추가하라

## 불필요한 맥락을 없애라
