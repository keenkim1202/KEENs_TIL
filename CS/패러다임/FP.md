# Funtional Programming (함수형 프로그래밍)

> Swift는   
> FP이면서 동시에 OOP의 상속, 은닉, 캡슐화, 추상화 등을 제공하며 POP 적인 특징도 가지고 있는 멀티 패러다임 언어이다.   
> 그러므로 FP에 대해서도 알고 넘어가자.


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
- 이하 순수 함수에 대한 자세한 내용은 [순수함수에 대하여](pure_function.md)를 참고하자.

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
- 자세한 내용은 [1급객체란](first_class_citizen.md)을 참고하자.

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


## 참고하면 좋은 링크
- [Swift와 함수형 프로그래밍의 역사 - realm](https://academy.realm.io/kr/posts/tryswift-rob-napier-swift-legacy-functional-programming/)
- [Functional Swift](https://www.objc.io/books/functional-swift/)
- [Beginenrs guide to functional Swift](https://theswiftdev.com/beginners-guide-to-functional-swift/)
- [Swift Functional Programming - PacktPublishing Github](https://github.com/PacktPublishing/Swift-Functional-Programming)
- [An Introduction to Functional Programming in Swift - Raywenderich](https://www.raywenderlich.com/9222-an-introduction-to-functional-programming-in-swift)

## 추가할 내용
- 명령형 -> 함수형으로 바꾸어보는 코드 예시
