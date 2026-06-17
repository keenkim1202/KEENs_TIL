# Funtional Programming (함수형 프로그래밍)

> Swift는   
> FP이면서 동시에 OOP의 상속, 은닉, 캡슐화, 추상화 등을 제공하며 POP 적인 특징도 가지고 있는 멀티 패러다임 언어이다.


## 함수형 프로그래밍이란?
- `순수 함수`를 기반으로 하는 프로그래밍 패러다임이다.
    - 함수형 프로그래밍은 자료 처리를 수학적 함수의 계산을 취급하고, 상태와 가변데이터를 멀리하는 프로그래밍 패러다임이다.
    - 일반적인 명령형 프로그래밍은 상태 값을 변경할 수 있어 예측하지 못한 에러(side-effect)를 발생시킬 가능성이 있다.
- 함수형 프로그래밍에서는 함수가 `일급 객체`가 될 수 있다.

```
그러므로 함수형 프로그래밍을 이해하려면 `순수 함수`와 `일급객체`가 무엇인지에 대한 이해가 선행되어야 한다!
```

## 순수 함수란?
> : Pure Fuction

- 어떠한 입력에 대해 항상 같은 출력을 만드는 함수를 의미한다.
- 즉, 외부의 영향을 받거나 주지 않는 것, `side-effect`(부수 효과)가 없는 것을 말한다.
- 이하 순수 함수에 대한 자세한 내용은 [순수 함수 & 일급 객체](pure_function_and_first_class_citizen.md)를 참고하자.

## side-effect 란?
- 함수를 통해 함수 외부 값의 상태(`state`)가 변하는 것을 의미한다.

## 일급객체란?
> : First-class Citizen

- 함수의 인자로 넘길 수 있고, 변수에 저장이 가능하며, 리턴값으로 반환이 가능한 객체를 의미한다.
- 더 자세히 말하면 아래의 조건을 충족하면 1급 객체라고 본다.
    - 런타임에도 생성이 가능하다.
    - 인자 값으로 전달할 수 있어야 한다.
    - 반환값으로 사용할 수 있어야 한다.
    - 데이터 구조 안에 저장할 수 있어야 한다.
- 일급객체의 대표적인 예는 클로저(closure) 이다.
- 자세한 내용은 [순수 함수 & 일급 객체](pure_function_and_first_class_citizen.md)를 참고하자.

## 함수형으로 디자인 하기 위한 조건
- 모듈 방식
    - 각각의 프로그램을 반복하여 작은 단위로 쪼개야 한다.
    - 모든 기능 조각을 조림하여 완성된 프로그램을 정의할 수 있어야 한다.
    - 거대한 프로그램을 작은 조각으로 분해했을 때, 각각의 조각들이 상태를 공유하는 것을 피해야 한다.
- 상태 오염
    - 가변 상태를 피하도록 값을 통해 프로그래밍한다.
    - side-effect가 발생하지 않도록 데이터의 의존성이 생기지 않도록 한다.
- 타입
    - 다입의 사용을 신중하게 한다.
    - 데이터 타입의 신중한 선택은 코드를 견고, 안전, 강력하게 작성하도록 도와준다.


## Swift 관점에서의 함수형 프로그래밍

iOS 개발자라면 Swift가 제공하는 함수형 도구들을 일상적으로 쓴다.

### 고차 함수 (Higher-Order Function)

함수를 인자로 받거나 함수를 반환하는 함수. Swift 표준 라이브러리의 대표적인 함수형 API다.

- `map` — 각 원소를 변환
- `filter` — 조건에 맞는 원소만 남김
- `reduce` — 원소들을 하나의 값으로 누적
- `compactMap` — 변환 후 `nil`을 제거
- `flatMap` — 중첩 컬렉션을 평탄화

```swift
let numbers = [1, 2, 3, 4, 5]
let result = numbers
    .filter { $0 % 2 == 1 }   // [1, 3, 5]
    .map { $0 * $0 }          // [1, 9, 25]
    .reduce(0, +)             // 35
```

자세히: [Map vs compactMap vs flatMap 비교](../../Swift/map_compactMap_flatMap.md)

### 일급 함수와 클로저

- Swift에서 함수와 클로저는 1급 객체다. 변수에 담고, 인자로 넘기고, 반환할 수 있다.
- 이 덕분에 콜백, 의존성 주입, 고차 함수 같은 함수형 패턴이 가능하다.

### 불변성과 값 타입

- `let`으로 불변 바인딩을 만들고, struct/enum 같은 값 타입으로 공유 가변 상태를 피한다.
- 값 타입은 복사되어 side-effect가 적고 동시성에 안전하므로, FP가 강조하는 "상태를 멀리하기"와 잘 맞는다.
- 관련: [Class & Struct](../../Swift/Class_vs_Struct.md)

### Optional도 함수형으로 다룬다

- `Optional`은 값이 있을 수도/없을 수도 있는 컨테이너로, `map`/`flatMap`을 통해 박스를 깨지 않고 변환을 이어갈 수 있다.

```swift
let input: String? = "42"
let doubled = input.flatMap { Int($0) }.map { $0 * 2 }   // Optional(84)
```

## 명령형 → 함수형으로 바꿔보기

같은 로직(짝수만 골라 제곱해서 합산)을 두 스타일로 작성한 예시.

```swift
// 명령형: 외부 변수(state)를 두고 루프로 직접 변경
var sum = 0
for n in numbers {
    if n % 2 == 0 {
        sum += n * n
    }
}

// 함수형: 상태 변경 없이 변환의 연결로 표현
let sum = numbers
    .filter { $0 % 2 == 0 }
    .map { $0 * $0 }
    .reduce(0, +)
```

함수형 버전은 가변 상태(`var sum`)가 없어 side-effect가 없고, 각 단계가 무엇을 하는지 선언적으로 드러난다.

## 참고하면 좋은 링크
- [Swift와 함수형 프로그래밍의 역사 - realm](https://academy.realm.io/kr/posts/tryswift-rob-napier-swift-legacy-functional-programming/)
- [Functional Swift](https://www.objc.io/books/functional-swift/)
- [Beginenrs guide to functional Swift](https://theswiftdev.com/beginners-guide-to-functional-swift/)
- [Swift Functional Programming - PacktPublishing Github](https://github.com/PacktPublishing/Swift-Functional-Programming)
- [An Introduction to Functional Programming in Swift - Raywenderich](https://www.raywenderlich.com/9222-an-introduction-to-functional-programming-in-swift)

## 관련 문서
- [OOP와 FP 비교](OOP_vs_FP.md)
- [OOP: 객체 지향 프로그래밍](OOP.md)
- [POP: 프로토콜 지향 프로그래밍](POP.md)
- [순수 함수 & 1급 객체](pure_function_and_first_class_citizen.md)
- [Map vs compactMap vs flatMap 비교](../../Swift/map_compactMap_flatMap.md)
