# 1급 객체 (First Class Citizen)

## 일급객체란?
> : First-class Citizen

- 함수의 인자로 넘길 수 있고, 변수에 저장이 가능하며, 리턴값으로 반환이 가능한 객체를 의미한다.
- 더 자세히 말하면 아래의 조건을 충족하면 1급 객체라고 본다.
    - 런타임에도 생성이 가능하다.
    - 인자 값으로 전달할 수 있어야 한다.
    - 반환값으로 사용할 수 있어야 한다.
    - 데이터 구조 안에 저장할 수 있어야 한다.
- 일급객체의 대표적인 예는 클로저(closure) 이다.

```swift
// ex. 상수/변수에 함수 대입
func lotto(range: Int) -> Int {
    return Int.random(in: 1...range)
}

let firstNumber: Int = lotto(range: 10) // 함수 호출 결과값을 상수에 할당
let randomNumber = lotto(range: ) // 함수 자체를 할당
let anotherRandomNumber: (Int) -> Int = lotto // 함수의 타입을 지정하여 할당
```

```swift
// ex. 함수를 리턴값으로 사용 가능
func plus(lhs: Int, rhs: Int) -> Int {
    print(#function)
    return lhs + rhs
}

func plusAgain(a: Int, b: Int) -> (Int, Int) -> Int {
    print(#function)
    return plus
}

let doPlus = plusAgain(a: 1, b: 2) // (Int, Int) -> Int

doPlus(7, 8) // 15
// doPlus에는 plusAgain()의 리턴값인 plus()가 들어있다.
// 그러므로 doPlus를 선언할 때 a, b에 넣어준 값과 상관없이 doPlus를 호출할 때 인자로 넣어준 7, 8을 연산한 15가 결과값으로 나온다.

plusAgain(a: 1, b: 2) // (Int, Int) -> Int
plusAgain(a: 1, b: 2)(7, 8) // 15
// 마찬가지로 doPlus라는 상수에 담는 과정을 제외하고 바로 plusAgain을 대입하여 작성해도 결과는 같다.
```

```swift
// ex. 인자로 함수를 전달 가능
func increament(a: Int) -> Int {
    print(1)
    return a + 1 // 4
}

func sqaure(value: Int, fn: (Int) -> Int) -> Int { 
    print(2)
    return fn(value) * fn(value) // 16
}

print(3)

sqaure(value: 3, fn: increament(a:)) // 16
print(4)

// 출력 : 3 2 1 1 4
```