# Clean Code 2장
: 의미 있는 이름

> 아래에 나오는 코드들은 Swift로 의역하여 작성하였습니다.

소프트웨어에서 이름은 어디나 쓰인다. 이름을 잘 지으면 여러모로 편하다.   
이 장에서는 이름을 잘 짓는 간단한 규칙을 몇 가지 소개한다.

</br>
</br>

-----

## 의도를 분명히 밝혀라
좋은 이름을 짓는데는 시간이 좀 걸리지만, 좋은 이름으로 절약하는 시간이 훨씬 많다.  
더 나은 이름이 떠오르면 개선하기 바란다. 그러면 코드를 읽는 사람이 좀 더 행복해질 것이다.
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
의도가 드러나는 이름을 사용하면 코드 이해와 변경이 쉬워진다.

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
복잡하거나 어려운 로직이 아님에도 코드가 하는 일을 짐작하기 어렵다.
문제는 `코드의 단순성`이 아니라 `코드의 함축성`이다.
- 코드의 맥락이 코드 자체에 명시적으로 드러나지 않는다.

암암리에 독자가 다음과 같은 정보를 안다고 가정하자.
1. theList에 무엇이 들어있는가?
2. theList에서 0번째 값이 어째서 중요한가?
3. 값 4는 무슨 의미인가?
4. 함수가 반환하는 리스트 'list'는 어떻게 사용하는가?

```
이와 같은 정보는 위의 코드에서 드러나지 않지만, 정보 제공은 "충분히" 가능했다.
```

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

코드의 단순성을 변하지 않았다. 그런데도 코드는 더욱 명확해졌다.
한 걸음 더 나아가, 
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

-----


## 그릇된 정보를 피하라

> 프로그래머는 코드에 그릇된 단서를 남겨서는 안된다. 이는 코드의 의미를 흐린다.

여러 계정을 그룹으로 묶을 때 실제 `List`가 아니라면 `accountList라` 명명하지 않는다.
- 계정을 담는 컨테이너가 실제 List가 아니면 프로그래머에게 그릇된 정보를 제공하는 셈이다.
- `accountGroup`, `bunchOfAccounts`, `Accounts` 와 같이 명명하자.
```
실제 컨테이너가 List 인 경우라도 컨테이너 유형을 이름에 넣지 않는편이 바람직하다.
```

</br>

> 서로 흡사한 이름은 사용하지 않도록 주의한다.

한 모듈에서   
    `XYZControllerFOrEfficientHandlingOfStrings`, `XYZControllerForEfficientStorageOfStrings` 라는 이름을 사용한다면?
- 유사한 개념은 유사한 표기법을 사용한다.
- 일관성이 떨어지는 표기법은 `그릇된 정보`이다.

이름으로 그릇된 정보를 제공하는 가장 끔찍한 예는 소문자 `L`이나 대문자 `O`변수이다.
- 소문자`L`은 숫자`1`처럼 보이고 대문자 `O`는 숫자 `0`처럼 보인다.
- 어떤 경우는 코드 작성자가 글꼴을 바꿔 차이를 드러내는 해결책을 제안했다.
- 이름만 바꾸면 문제가 깨끗이 풀린다. 괜스레 일거리를 만들 필요가 없다.

-----

## 의미있게 구분하라
컴파일러나 인터프리터만 통과하려는 생각으로 코드를 구현하는 프로그래머는 스스로 문제를 일으킨다.
- ex. 동일한 범위 안에서는 다른 두 개념을 같은 이름으로 사용하지 못한다.
- 그래서 프로그래머가 한쪽 이름을 마음대로 바꾸고픈 유혹에 빠진다.
```
진짜로 황당한 예는 klass 이다. class는 이미 사용했다고 klass를 사용한다.
```
컴파일러를 통과할지라도 연속된 숫자를 덧붙이거나 noise word를 추가하는 방식은 적절하지 못하다.
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
함수 인수 이름으로 `source`와 `destination`을 사용한다면 코드 읽기가 훨씬 더 쉬워진다.  
noise word를 추가한 이름 역시 아무런 정보도 제공하지 못한다.
- `Product`라는 클래스가 있다고 가정하자.
- 다른 클래스를 `ProductInfo`, `ProductData` 라 부른다면 개념을 구분하지 않은 채 이름만 달리한 경우다. `Info`나 `Data`는 `a, an, the` 와 다를바 없다.

`a, the` 같은 접두사를 사용하지 말라는 소리가 아니다.  
의미가 분명히 다르다면 사용해도 무방하다.
- ex. 모든 지역 변수는 `a`를 사용하고, 함수 인수는 `the`를 사옹해도 좋다.

</br>

불용어는 중복이다.
- `Customer`, `CustomerObject` 라는 클래스를 발견했다면, '고객 급여 이력'을 찾으려면 어느 클래스를 뒤져야 빠를까?

```swift
getActiveAccount()
getActiveAccounts()
getActiveAccountInfo()
```
이 프로젝트에 참여한 프로그래머는 어느 함수를 호출할지 어떻게 알까?  
명확한 관례가 없다면 아래의 것들은 구분이 안된다.
- ex. `moneyAmount <-> money`, `customerInfo <-> customer`, `accountData <-> account`

```
읽는 사람이 차이를 알도록 이름을 지어라.
```

-----

## 발음하기 쉬운 이름을 사용하라
> 발음하기 어려운 이름은 토론하기도 어렵다.

내가 아는 회사 하나는 `genymdhms` 라는 단어를 사용했다.
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
2번 코드는 지적인 대화가 가능해진다.
- "마이키, 이 레코드 좀 보세요. 'Generation Timestamp' 값이 내일 날짜입니다. 어떻게 이렇죠?"

-----

## 검색하기 쉬운 이름을 사용하라
문자 하나를 사용하는 이름과 상수는 쉽게 눈에 띄지 않는다는 문제점이 있다.
- `grep`으로 `7`을 찾게 되면, `7`이 들어가는 모든 파일 이름이나 수식이 검색되기 때문이다.
변수나 상수를 코드 여러 곳에서 사용한다면 검색하기 쉬운 이름이 바람직하다.
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
위의 코드에서 `sum`이 별로 유용하진 않으나 최소한 검색이 가능하다.
이름을 의미있게 지으면 함수가 길어진다.
- 하지만 `workDaysPerWeek` 을 찾기가 얼마나 쉬운지 생각해보라. 
- 그냥 `5`를 사용하면 `5`가 들어간 이름을 모두 찾고, 의미를 분석해 원하는 상수를 가려내야 한다.

-----

## 인코딩을 피하라
유형이나 범위 정보까지 인코딩에 넣으면 그만큼 이름을 해독하기 어려워진다.
- 문제 해결에 집중하는 개발자에게 인코딩은 불필요한 정신적 부담이다.
- 대게 발음하기 어렵고, 오타가 생기기 쉽다.

이름 길이가 제한된 언어를 사용하던 옛날에는 안타까워하면서도 이 규칙을 위반했다.
- 헝가리식 표기법은 기존 표기법을 완전히 새로운 단계로 끌어올렸었다.
- 당시는 컴파일러가 타입을 점검하지 않았으므로 프로그래머에게 타입을 기억할 단서가 필요했다.
요즘 언어는 훨씬 많은 타입을 지원하고, 컴파일러가 이를 기억하고 강제한다.
- 게다가 클래스와 함수가 점차 작아지는 추세로, 변수를 선언한 위치와 사용하는 위치가 멀지 않다.

변수 이름에 타입을 인코딩할 필요가 없고, 객체는 strong 타입이며, IDE는 컴파일을 하지 않고도 탕비 오류를 감지할 정도로 발전했다. 

```swift
var phoneString: PhoneNumber // 타입을 바꿔도 이름은 바뀌지 않는다.
```
```
따라서 인코딩 방식(헝가리 표기법 등)은 오히려 방해가 될 뿐이다.
```

-----

## 자신의 기억력을 자랑하지 마라
독자가 코드를 읽으면서 자신이 아는 이름으로 변환해야 한다면
- 이는 일반적으로 문제 영역이나 해법 영역에서 사용하지 않는 이름을 선택했기 때문에 생기는 문제다.

반복문에서 반복 횟수를 세는 변수 `i, j, k`는 괜찮다. (l은 안된다)
- 그 외에 `a, b`를 사용했으므로 `c`를 선택하는 경우는 적절하지 못하다. 독자가 실제 개념으로 변환해야하므로

똑똑한 프로그래머와 전문가 프로그래머 사이의 차이점은 전문가 프로그래머는 
- `명료함이 최고`라는 사실을 이해한다.
- 자신의 능력을 좋은 방향으로 사용해 남들이 이해하는 코드를 내놓는다.


-----

## 클래스 이름
> 클래스, 객체명은 명사나 명사구가 적합하다. 동사는 사용하지 않는다.

- O : `Customer`, `WikiPage`, `Account`, `AddressParser`
- X : `Manager`, `Processor`, `Data`, `Info`


-----

## 메서드 이름
> 메서드명은 동사나 동사구가 적합하다.

 접근자, 변경자, 조건자는 값 앞에 get, set, is를 붙인다.  
 (* 첨언: 이부분은 swift에 적용이 될지 모르겠다. get, set을 메서드 앞에 붙이는 것이 안좋다고 배웠으나 정확한 이유는 모르겠다.)
 ```swift
 var name: String = employee.getName()
 customer.setName("mike")

if paycheck.isPosted() { ... }
 ```

</br>

생성자를 overload할 때는 정적 팩토리 메서드를 사용한다.
- 메서드는 인수를 설명하는 이름을 사용한다.
- 2번과 같이 선언하는 것이 더 좋다.
```swift
// 1
var fulcrmPoint: Complex = Complex.FromRealNumber(23.0)

// 2
class Complex {
    private init() { }
    
    public static func initMethod(_ number: Float) -> Complex {
        return Complex(number)
    }
}

var fulcrmPoint: Complex = Complex.initMethod(23.0)
```
- 생성자 사용을 제한하려면 해당 생성자를 private으로 선언한다.

-----

## 기발한 이름은 피하라
`HolyHandGranade` 라는 함수가 무엇을 하는지 알겠는가?
- 기발한 이름이지만 `DeleteItems`가 더 좋다. 
- '몬티 파이썬'에 나오는 가상의 무기(수류탄)이다.

```
기발한 이름 보다는 명료한 이름을 선택해라.
```

-----

## 한 개념에 한 단어를 사용하라
> 추상적인 개념 하나에 단어 하나를 선택해 이를 고수한다.

예를 들어,  
똑같은 메서드를 클래스마다 `fetch`, `retrieve`, `get`으로 제각기 부르면 혼란스럽다.

메서드 이름은 독자적이고 일관적이어야 한다.
그래야 주석을 뒤져보지 않고도 프로그래머가 올바른 메서드를 선택한다.

마찬가지로 동일 코드 기반에서 `controller`, `manager`, `driver`를 섞어쓰면 혼란스럽다.
- `DeviceManager`와 `ProtocolController`는 근본적으로 어떻게 다른가? 왜 하나는 `Manager`고 하나는 `Controller`인가?
- 이름이 다르면 독자는 당연히 클래스도 다르고 타입도 다르리라 생각한다.

```
일관성 있는 어휘는 코드를 사용할 프로그래머가 반갑게 여길 선물이다.
```

-----

## 말장난을 하지마라
> 한 단어를 두 가지 목적으로 사용하지 마라.

다른 개념에 같은 단어를 사용한다면 그것은 말장난에 불과하다.

예를 들어,  
여러 클래스에 `add`라는 메서드가 생겼고, 모든 `add` 메서드의 매개변수와 반환값이 의미적으로 똑같다면 문제가 없다.  
하지만 때로는 프로그래머가 같은 맥락이 아닌데도 일관성을 고려해 `add`라는 단어를 선택한다.
- 기존에는 기존 값 두개를 더하거나 이어서 새로운 값을 만든다고 가정하자.
- 새로 작성하는 메서드는 집합에 하나를 추가한다.

새로운 메서드는 기존 `add` 메서드와 "맥락"이 다르다. 
- 그러므로 `insert`, `append` 같은 이름이 적당하다.

```
의미를 해독할 책임이 독자에게 있는 논문 모델이 아니라 의도를 밝힐 책임이 저자에게 있는 잡지 모델이 바람직하다.
```

-----

## 해법 영역에서 가져온 이름을 사용하라
> 코드를 읽을 사람도 프로그래머라는 사실을 명심한다.

그러므로 전산용어, 알고리즘 이름, 패턴 이름, 수학 용어 등은 사용해도 괜찮다.
모든 이름은 domain 영역에서 가져오는 정책은 현명하지 못하다.

예를 들어,
- `VISITOR` 패턴에 친숙한 프로그래머는 `AccountVisitor`라는 이름을 금방 이해한다.
- `JobQueue`를 모르는 프로그래머가 있을까?

```
프로그래머에게 익숙한 기술 개념은 아주 많다. 기술 개념에는 기술 이름이 가장 적합한 선택이다.
```

-----

## 문제 영역에서 가져온 이름을 사용하라
> 적절한 '프로그래머 용어'가 없다면 domain 영역에서 이름을 가져온다.

그러면 코드를 보수하는 프로그래머가 분야 전문가에게 의미를 물어 파악할 수 있다.
```
우수한 프로그래머와 설계자라면 해법 영역과 domain 영역을 구분할 줄 알아야 한다.
domain에 더 관련이 깊은 코드라면 거기서 이름을 가져오는 것이 옳다.
```

-----

## 의미 있는 맥락을 추가하라

> 클래스, 함수, 이름 공간에 넣어 맥락을 부여한다. 모든 방법이 실패하면 마지막 수단으로 접두어를 붙인다.

ex. `firstName, lastName, street, houseNumber, city, state, zipcode` 라는 변수가 있다.  

- 변수를 훑어보면 주소라는 사실을 금방 알아챈다.  
- 하지만 어느 메서드가 `state`라는 변수 하나만 사용한다면? 변수 `state`가 주소 일부라는 사실을 금방 알아챌까?  

</br>

`addr` 라는 접두어를 추가해
- `addrFirstName, addrLastName, addrState` 라 쓰면 맥락이 좀 더 분명해진다.  
- 물론 Address 라는 클래스를 생성하면 더 좋다.  

```
그러면 변수가 좀 더 큰 개념에 속한다는 사실이 컴파일러에게도 분명해진다.  
```

> 변수에 좀 더 의미 있는 맥락이 필요할까? 

함수 이름은 맥락 일부만 제공하며, 알고리즘이 나머지 맥락을 제공한다.  
함수를 끝까지 읽어보고 나서야 `number, verb, pluralModifier` 라는 변수 세 개가 "통계 추측 메세지"에 사용된다는 사실이 드러난다.  

- 불행히도 독자는 맥락을 유추해야만 한다.  
- 그냥 메서드만 훑어서는 세 변수의 의미가 불분명하다.  

위의 내용을 바탕으로 아래의 예제 코드를 보자.
```swift
func printGuessStatistics(candidate: Character, count: Int) {
    var number: String
    var verb: String
    var pluralModifier: String

    if count == 0 {
        number = "no"
        verb = "are"
        pluralModifier = "s"
    } else if count == 1 {
        number = "1"
        verb = "is"
        pluralModifier = ""
    } else {
        number = String(count)
        verb = "are"
        pluralModifier = "s"
    }

    let guessMessage = "There \(verb) \(number) \(candidate) \(pluralModifier)"
    print(guessMessage)
}
```

</br>

> 의미있는 맥락을 추가해보자.

일단 함수가 좀 길다.  
그리고 세 변수를 함수 전반에서 사용한다.  
- 함수를 작은 조각으로 쪼개고자 `GuessStatisticsMessage라는` 클래스를 만든 후 세 변수를 클래스에 넣었다.  

그러면 세 변수의 맥락이 분명해진다.  
- 즉, 세 변수는 확실하게 `GuessStatisticsMessage`에 속한다.  

```
이렇게 맥락을 개선하면 함수를 쪼개기가 쉬어지므로 알고리즘도 좀 더 명확해진다.  
```

```swift
// 클래스를 만들어 세 변수들의 연관성을 만들고 의미를 더한다.
class GuessStatisticsMessage {
    var number: String
    var verb: String
    var pluralModifier: String
    
    // 클래스 내부에 메서드를 잘게 쪼개어 
    func make(candidate: Character, count: Int) {
        createPluralDependentMessageParts(count)
        return "There \(verb) \(number) \(candidate) \(pluralModifier)"
    }

    func createPluralDependentMessageParts(count: Int) {
        if count == 0 {
            thereAreNoLetters()
        } else if count == 1 {
            thereIsOneLetter()
        } else {
            thereAreMantLetters(count: count)
        }
    }

    func thereAreMantLetters(count: Int) {
        number = String(count)
        verb = "are"
        pluralModifier = "s"
    }

    func thereIsOneLetter() {
        number = "1"
        verb = "is"
        pluralModifier = ""
    }

    func thereAreNoLetters() {
        number = "no"
        verb = "are"
        pluralModifier = "s"
    }
}
```



-----

## 불필요한 맥락을 없애라
