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
- 그러면 `theList`가 게임판이라는 것을 을 알 수 있으므로 `gameBoard`로 바꿔보자.
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
    - init 배열을 사용하는 대신 칸을 간단한 클래스로 만들어도 되겠다.
    - `isFlagged` 라는 좀 더 명시적인 함수를 사용해 `flagged` 라는 상수를 감춰도 좋겠다.

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

> 프로그래머는 코드에 그릇된 단서를 남겨서는 안된다. 이는 코드의 의미를 흐린다.

- 여러 계정을 그룹으로 묶을 때 실제 `List`가 아니라면 `accountList라` 명명하지 않는다.
    - 계정을 담는 컨테이너가 실제 List가 아니면 프로그래머에게 그릇된 정보를 제공하는 셈이다.
    - `accountGroup`, `bunchOfAccounts`, `Accounts` 와 같이 명명하자.
```
실제 컨테이너가 List 인 경우라도 컨테이너 유형을 이름에 넣지 않는편이 바람직하다.
```

</br>

> 서로 흡사한 이름은 사용하지 않도록 주의한다.

- 한 모듈에서   
    `XYZControllerFOrEfficientHandlingOfStrings`, `XYZControllerForEfficientStorageOfStrings`   
     라는 이름을 사용한다면?
    - 유사한 개념은 유사한 표기법을 사용한다.
    - 일관성이 떨어지는 표기법은 `그릇된 정보`이다.

- 이름으로 그릇된 정보를 제공하는 가장 끔찍한 예는 소문자 `L`이나 대문자 `O`변수이다.
    - 소문자`L`은 숫자`1`처럼 보이고 대문자 `O`는 숫자 `0`처럼 보인다.
    - 어떤 경우는 코드 작성자가 글꼴을 바꿔 차이를 드러내는 해결책을 제안했다.
    - 이름만 바꾸면 문제가 깨끗이 풀린다. 괜스레 일거리를 만들 필요가 없다.


## 의미있게 구분하라
- 컴파일러나 인터프리터만 통과하려는 생각으로 코드를 구현하는 프로그래머는 스스로 문제를 일으킨다.
    - ex. 동일한 범위 안에서는 다른 두 개념을 같은 이름으로 사용하지 못한다.
    - 그래서 프로그래머가 한쪽 이름을 마음대로 바꾸고픈 유혹에 빠진다.
```
진짜로 황당한 예는 klass 이다. class는 이미 사용했다고 klass를 사용한다.
```
- 컴파일러를 통과할지라도 연속된 숫자를 덧붙이거나 noise word를 추가하는 방식은 적절하지 못하다.
    - 이름이 달라야 한다면 의미도 달라야 한다.
    - 위의 예시와 같은 이름은 그릇된 정보를 제공하는 이름도 아니며, 아무런 정보를 제공하지 못하는 이름일 뿐이다.

</br>

```swift
func copyChars(a1: [Character], a2: [Character]) -> [Character] {
    let newA2 = a2

    for i in 0..<a1.count {
        newA2[i] = a1[i]
    }
}
```
- 함수 인수 이름으로 `source`와 `destination`을 사용한다면 코드 읽기가 훨씬 더 쉬워진다.
- noise word를 추가한 이름 역시 아무런 정보도 제공하지 못한다.
    - `Product`라는 클래스가 있다고 가정하자.
    - 다른 클래스를 `ProductInfo`, `ProductData` 라 부른다면 개념을 구분하지 않은 채 이름만 달리한 경우다. `Info`나 `Data`는 `a, an, the` 와 다를바 없다.

- `a, the` 같은 접두사를 사용하지 말라는 소리가 아니다.
- 의미가 분명히 다르다면 사용해도 무방하다.
    - ex. 모든 지역 변수는 `a`를 사용하고, 함수 인수는 `the`를 사옹해도 좋다.

</br>

- 불용어는 중복이다.
    - `Customer`, `CustomerObject` 라는 클래스를 발견했다면, '고객 급여 이력'을 찾으려면 어느 클래스를 뒤져야 빠를까?

```swift
getActiveAccount()
getActiveAccounts()
getActiveAccountInfo()
```
- 이 프로젝트에 참여한 프로그래머는 어느 함수를 호출할지 어떻게 알까?
- 명확한 관례가 없다면 아래의 것들은 구분이 안된다.
    - ex. `moneyAmount <-> money`, `customerInfo <-> customer`, `accountData <-> account`

```
읽는 사람이 차이를 알도록 이름을 지어라.
```


## 발음하기 쉬운 이름을 사용하라
> 발음하기 어려운 이름은 토론하기도 어렵다.

- 내가 아는 회사 하나는 `genymdhms` 라는 단어를 사용했다.
    - 직원들은 "젠 와이 엠 디 에이치 엠 에스" 라고 발음했고, 나느 쓰이는 대로 발음하는 습관이 있어 "젠 야 무다 힘즈"라고 읽었다. 나중에 몇몇은 나처럼 발음하기 시작했다.
    - 새로운 개발자가 들어오면 변수를 설명해준 다음 우리가 만들어낸 발음을 알려줬다. (올바른 영단어가 아니라)

</br>

> 다음 두 예제를 비교해보자
```swift
// 1
class DtaRcrd102 {
    private var genymdhms: Date
    private var modymdhms: Date
    private var pszqint: String = "102"
}

// 2
class Customer {
    private var generationTimestamp: Date
    private var modificationTimestamp: Date
    private var recordId: String = "102"
}
```
- 2번 코드는 지적인 대화가 가능해진다.
    - "마이키, 이 레코드 좀 보세요. 'Generation Timestamp' 값이 내일 날짜입니다. 어떻게 이렇죠?"

## 검색하기 쉬운 이름을 사용하라
- 문자 하나를 사용하는 이름과 상수는 쉽게 눈에 띄지 않는다는 문제점이 있다.
    - `grep`으로 `7`을 찾게 되면, `7`이 들어가는 모든 파일 이름이나 수식이 검색되기 때문이다.
- 변수나 상수를 코드 여러 곳에서 사용한다면 검색하기 쉬운 이름이 바람직하다.
```swift
// 1
for j in 0..<34 {
    s += (t[j] * 4) / 5
}

// 2 
var realDaysPerIdealDay: Int = 4
let workDaysPerWeek: Int = 5
var sum: Int = 0

for j in 0..<numberOfTasks.count {
    let realTaskDays = taskEstimate[j] * realDaysPerIdealDay
    let realTaskWeeks = realTaskDays / workDaysPerWeek
    sum += realTaskWeeks
}
```
- 위의 코드에서 `sum`이 별로 유용하진 않으나 최소한 검색이 가능하다.
- 이름을 의미있게 지으면 함수가 길어진다.
    - 하지만 `workDaysPerWeek` 을 찾기가 얼마나 쉬운지 생각해보라. 
    - 그냥 5를 사용하면 5가 들어간 임름을 모두 찾고, 의미를 분석해 원하는 상수를 가려내야 한다.


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
