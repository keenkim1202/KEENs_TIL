# 순수 함수 & 일급 객체 (Pure Function & First-Class Citizen)

> 함수형 프로그래밍을 이해하려면 `순수 함수`와 `일급 객체`가 무엇인지에 대한 이해가 선행되어야 한다.
> 두 개념을 한 문서에 정리한다.

---

# 순수 함수 (Pure Function)

## 순수 함수란?
- 어떠한 입력에 대해 항상 같은 출력을 만드는 함수를 의미한다.
- 즉, 외부의 영향을 받거나 주지 않는 것, `side-effect`(부수 효과)가 없는 것을 말한다.

## 순수 함수의 특징
- 동일한 입력에 대해 동일한 출력을 가진다.
- `side-effect` 가 없다.
- 두 개의 순수한 표현식 사이에 데이터 의존성이 없는 경우,
    - 순서를 반대로 하거나 병렬로 수행이 가능하다.
    - 서로 간섭을 할 수 없다.
    - 그렇기 때문에 `thread-safe` 하다.

## 순수함수가 아닌 예시
### ex1) 전역(혹은 지역) 프로퍼티에 의존하는 경우
```swift
// side-effect (O)
var counter: Int = 0

func increment(num: Int) -> Int {
    counter += 1
    return counter
}
```
- `increment(num:)` 함수는 함수 바깥에 있는 전역 프로퍼티 `counter` 값을 변경 시킨다.
- 다른 함수가 `counter` 프로퍼티에 접근할 지도 모른다.
- 그렇기에 이러한 로직은 프로퍼티의 값이 바뀜으로써(`mutating the property`) 예상치 못한 부수효과(`side-effect`)를 발생시킬 여지가 있으므로 순수함수가 아니다.

### ex2) 랜덤 요소에 의존하는 경우
```swift
// side-effect (O)
func getRandomNumber(maxNum: Int) -> Int {
    return Int.random(in: 0...maxNum)
}
```
- 함수에 랜덤적 요소가 포함되어있다면 테스트하기 힘들다.
- 순수함수는 나의 코드를 테스트하기 쉽게 한다.
- `getRandomNumber(maxNum:)` 함수는 `0`부터 `maxNum` 사이의 숫자를 랜덤하게 리턴해준다.
- 위와 같이 랜덤 요소를 리턴하는 함수로 테스트(= 충분한 unit test)를 할 수 있을까?
    - 여러 `input`을 통해 함수의 `output`을 테스트해볼 수는 있을 것이다.
    - `output`은 `getRandomNumber(maxNum:)` 에 주어진 `input`에 의존하게 된다.
    - 그 말은, 여러 `input` 경우의 수에 따른 테스트를 실행함으로써 테스트가 가능하고, 그 당시 다른 테스트들을 방해하는 테스트는 없을 것이다.
    - 그래서 순수함수라고 착각할 수 있다.
- 이 함수는 함수를 실행할 때마다 같은 결과를 낸다는 보장이 없다.
    - `XCTest`를 통해 테스트를 작성할 수 없듯 이 함수는 테스트가 불가능하다는 뜻이다. (= `untestable`)
    - XCTest 관련 참고 링크 : [How to Test Asynchronous Functions Using Expectation in Swift](https://betterprogramming.pub/how-to-test-asynchronous-functions-using-expectation-2c9183fd99c9)

## 순수함수의 예시
```
[ 순수함수의 조건 ]
1. 항상 같은 결과를 리턴한다.
2. 전역으로 선언된 것의 상태를 변경 시키지 않고 그대로 둔다.
```

```swift
// side-effect (X)
func hello(name: String) -> String {
    return "안녕! \(name)아!"
}
```
- `hello(name:)` 함수는 위의 두 조건을 만족하므로 순수함수라고 볼 수 있다.
    - 1번 조건 만족: 항상 같은 `input`에 같은 `output`을 리턴한다.
    - 2번 조건 만족: 전역 변수 즉, 전역적으로 선언된 상태값(`global state`)을 변경시키지 않는다.

## 순수함수의 장점
- 읽기 쉽고, `side-effect`가 없다.
    - 그러므로 문제가 발생시 그 이유에 대해 쉽게 추론이 가능하다.
    - 명확히 정의된 함수의 파라미터를 가지고 있다. 그러므로 도출된 `output`은 온전히 `input` 파라미터에 의해 결정된다.

- 함수는 오직 `input` 파라미터에 의해 결정되므로, 해당 코드는 이식이 가능하다. (= `portable`)
    - 이 말은, 함수는 앱 전체 어느 곳에서든 사용이 가능하다는 뜻이다.

- 테스트 코드 작성에 용이하다.
    - 주어진 다양한 `input`에 대한 예측가능한 결과를 코드를 통해 유추할 수 있다면, 우리는 테스트할 수 있다.
    - 여기저기 공유되고 있는 가변상태(`mutable state`)는 모든 경우의 수를 빼놓지 않고 테스트 하기 어렵다.
    - 이것은 `독립적`이고 `반복 가능한` 테스트에 반하는 아이디어이다.

- 정의상으로 순수함수는 참조 투명성(referential transparency)을 갖는다.
    - 이는 프로그램의 결과를 변경하지 않고 표현식을 값으로 대체할 수 있음을 의미한다.
```
(1) : f(x) = x + 1
(2) : y = f(x) + 1
(3) : y = x + 1 + 1

위의 3 가지 수식이 있다고 할 때, (2)와 (3)은 다른가? 둘은 같다.
식이 원래 가지는 의미가 변하지 않고 대체가 가능하다.
```

- 메모리의 관점에서는
    - 한번 값이 할당된 메모리 위치에는 새로운 값을 다시 할당하지 않는다는 것이 참조 투명성의 필수 조건이다.
    - 이 조건이 만족된다면, 어떤 함수를 많이 호출(callback) 하더라도, 항상 동일한 결과를 얻게 된다.
    - (프로그램이 사용하는 컴퓨터 메모리의 값은 프로그램이 실행되는 동안에는 절대 변하지 않는다.)

- 구조체, 열거형과 같은 값 타입(value type)은 우리가 상태를 변경하고자할 때 명확히 명시한다.
- 즉, 함수가 상태를 변경하고자 할 때는 `mutating` 키워드를 꼭 필요로 한다는 뜻이다.
- 이 키워드를 통해 참조 투명성을 가질 수 있다.
    - 순수함수들은 작성하기 좋고, 테스트가 가능한 코드에 중요하다는 것을 나타내기 때문에 유용하다.

```
[ 참조 투명성(referential transparency) ]
- 일반적으로 응용프로그램의 동작에 영향을 미치지 않고 항상 함수를 반환값으로 대체할 수 있음을 의미한다.
- 코드의 재사용성을 보장합니다.
- 데이터가 가변상태인 것을 거부한다. (데이터의 상태 변경 불가)
- 가변이 가능하다면, 동일한 함수의 두 호출은 잠재적으로 두 개의 서로 다른 결과를 만들어낼 가능성이 있고, 테스트와 유지보수가 어렵다.

- 표현식을 결과값으로 대체했을 때 아무 문제가 발생하지 않는다면, 해당 표현식은 "참조 투명성"을 갖는다고 한다.
```

---

# 일급 객체 (First-Class Citizen)

## 일급 객체란?
- 함수의 인자로 넘길 수 있고, 변수에 저장이 가능하며, 리턴값으로 반환이 가능한 객체를 의미한다.
- 더 자세히 말하면 아래의 조건을 충족하면 일급 객체라고 본다.
    - 런타임에도 생성이 가능하다.
    - 인자 값으로 전달할 수 있어야 한다.
    - 반환값으로 사용할 수 있어야 한다.
    - 데이터 구조 안에 저장할 수 있어야 한다.
- 일급 객체의 대표적인 예는 클로저(closure) 이다.
- Swift에서는 **함수와 클로저가 일급 객체**이며, 이것이 `map`/`filter`/`reduce` 같은 고차 함수와 함수형 패턴을 가능하게 하는 기반이다.

### 상수/변수에 함수 대입
```swift
func lotto(range: Int) -> Int {
    return Int.random(in: 1...range)
}

let firstNumber: Int = lotto(range: 10)         // 함수 호출 결과값을 상수에 할당
let randomFunc = lotto                           // 함수 자체를 할당 (타입 추론: (Int) -> Int)
let anotherRandomFunc: (Int) -> Int = lotto      // 함수의 타입을 명시하여 할당
```

### 함수를 리턴값으로 사용
```swift
func plus(lhs: Int, rhs: Int) -> Int {
    print(#function)
    return lhs + rhs
}

func plusAgain(a: Int, b: Int) -> (Int, Int) -> Int {
    print(#function)
    return plus
}

let doPlus = plusAgain(a: 1, b: 2)   // (Int, Int) -> Int

doPlus(7, 8) // 15
// doPlus에는 plusAgain()의 리턴값인 plus()가 들어있다.
// 그러므로 doPlus를 선언할 때 a, b에 넣어준 값과 상관없이 doPlus를 호출할 때 인자로 넣어준 7, 8을 연산한 15가 결과값으로 나온다.

plusAgain(a: 1, b: 2)(7, 8) // 15
// doPlus라는 상수에 담는 과정을 제외하고 바로 호출해도 결과는 같다.
```

### 인자로 함수를 전달
```swift
func increment(a: Int) -> Int {
    print(1)
    return a + 1 // 4
}

func square(value: Int, fn: (Int) -> Int) -> Int {
    print(2)
    return fn(value) * fn(value) // 16
}

print(3)
square(value: 3, fn: increment(a:)) // 16
print(4)

// 출력 : 3 2 1 1 4
```

---

관련: [FP: 함수형 프로그래밍](FP.md), [OOP와 FP 비교](OOP_vs_FP.md), [Map vs compactMap vs flatMap 비교](../../Swift/map_compactMap_flatMap.md)
