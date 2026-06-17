# Object Oriented Programming (객체 지향 프로그래밍)

## 객체 지향 프로그래밍이란?

- 프로그램을 **객체(object)들의 상호작용**으로 바라보고 설계하는 프로그래밍 패러다임이다.
- 데이터(상태)와 그 데이터를 다루는 동작(메서드)을 하나의 객체로 묶고, 객체끼리 메시지를 주고받으며 동작한다.
- 상속을 통해 공통 기능을 모듈화하고 재사용한다.

## 4가지 핵심 특징

### 추상화 (Abstraction)

- 복잡한 대상에서 **핵심적인 개념·기능만 추려내** 표현하는 것.
- 불필요한 세부 구현은 감추고, 객체가 "무엇을 하는지"에 집중한다.
- Swift에서는 프로토콜, 추상적인 인터페이스 설계 등으로 표현된다.

### 캡슐화 (Encapsulation)

- 데이터(프로퍼티)와 동작(메서드)을 하나로 묶고, 외부에서 직접 접근하면 안 되는 내부 구현을 숨기는 것.
- 접근 제어(`private`, `fileprivate` 등)로 내부 상태를 보호하고, 정해진 인터페이스로만 접근하게 한다.
- 정보 은닉(information hiding)을 통해 객체 내부 변경이 외부에 미치는 영향을 줄인다.

### 상속 (Inheritance)

- 부모 클래스의 프로퍼티와 메서드를 자식 클래스가 물려받는 것.
- 공통 기능을 상위 클래스에 두어 재사용하고, 자식은 필요한 부분만 추가·재정의(override)한다.
- Swift에서 상속은 class에서만 가능하다. (struct, enum은 불가)

### 다형성 (Polymorphism)

- 같은 인터페이스(메서드 호출)가 객체의 실제 타입에 따라 다르게 동작하는 것.
- 오버라이딩(overriding), 오버로딩(overloading)으로 구현된다.
- 런타임에 실제 타입의 구현을 찾아 호출하는 동적 디스패치와 직접 연결된다.

```swift
class Animal {
    func makeSound() { print("...") }
}

class Dog: Animal {
    override func makeSound() { print("멍멍") }   // 재정의 (다형성)
}

class Cat: Animal {
    override func makeSound() { print("야옹") }
}

let animals: [Animal] = [Dog(), Cat()]
animals.forEach { $0.makeSound() }   // "멍멍", "야옹" — 실제 타입에 따라 다르게 동작
```

관련: [override & overload 란?](../../Swift/Override&Overload.md), [Static Dispatch & Dynamic Dispatch](../../Swift/static_dynamic_dispatch.md)

## Swift 관점에서의 OOP

iOS 개발자라면 OOP의 4가지 특징이 Swift에서 어떤 문법·규칙으로 구현되는지 알아둬야 한다.

### 캡슐화 — 접근 제어자

- Swift는 5단계 접근 수준으로 캡슐화를 표현한다: `open` > `public` > `internal`(기본) > `fileprivate` > `private`.
- **`open` vs `public`**: 둘 다 모듈 외부에서 접근 가능하지만, **모듈 외부에서의 상속·오버라이드는 `open`만 허용**된다. (`public` 클래스는 외부에서 상속 불가)
- 저장 프로퍼티는 `private(set)`으로 "외부 읽기 가능 / 내부에서만 쓰기"를 만들 수 있다.

### 상속 — class 한정, 단일 상속

- 상속은 class에서만 가능하고 **단일 상속**만 지원한다. (다중 상속은 프로토콜로 보완)
- 메서드 재정의 시 `override` 키워드가 **필수**이며, `super`로 상위 구현을 호출한다.
- `final`을 붙이면 더 이상 상속·오버라이드할 수 없고, 동시에 정적 디스패치로 최적화된다.

### 다형성 — 동적 디스패치 + 타입 캐스팅

- class 메서드의 다형성은 vTable 기반 동적 디스패치로 동작한다. (위 예제)
- 업캐스팅(`as`)은 항상 안전하고, 다운캐스팅은 실패할 수 있어 `as?`(옵셔널) / `as!`(강제)를 쓴다.

### 초기화 / 소멸

- class는 **지정 이니셜라이저(designated)** 와 **편의 이니셜라이저(convenience)** 를 구분하고, 상속 시 **2단계 초기화** 규칙을 따른다.
- 하위 클래스가 반드시 구현해야 하는 이니셜라이저는 `required`로 강제한다.
- `deinit`에서 해제 시점 정리를 할 수 있으며, 인스턴스 생명주기는 ARC가 참조 카운팅으로 관리한다.

### Objective-C 상호운용

- `NSObject`를 상속하면 KVO, `#selector`, `target-action` 등 Objective-C 런타임 기능을 쓸 수 있다.
- 이때 메서드는 `@objc`로 노출하며, `dynamic`을 붙이면 메시지 디스패치로 동작한다.

## SOLID 원칙

객체 지향 설계를 유연하고 유지보수하기 좋게 만드는 5가지 원칙.

- **S — 단일 책임 원칙 (Single Responsibility Principle)**
	- 하나의 클래스는 하나의 책임만 가져야 한다. 변경 이유가 하나여야 한다.
- **O — 개방-폐쇄 원칙 (Open-Closed Principle)**
	- 확장에는 열려 있고, 변경에는 닫혀 있어야 한다. 기존 코드를 고치지 않고 기능을 추가할 수 있어야 한다.
- **L — 리스코프 치환 원칙 (Liskov Substitution Principle)**
	- 자식 타입은 언제나 부모 타입을 대체할 수 있어야 한다. (부모를 쓰는 곳에 자식을 넣어도 정상 동작)
- **I — 인터페이스 분리 원칙 (Interface Segregation Principle)**
	- 클라이언트는 자신이 사용하지 않는 인터페이스에 의존하지 않아야 한다. 큰 인터페이스보다 작고 구체적인 여러 개가 낫다.
- **D — 의존 역전 원칙 (Dependency Inversion Principle)**
	- 고수준 모듈이 저수준 모듈에 의존하면 안 되고, 둘 다 추상화에 의존해야 한다. (구체 타입이 아니라 프로토콜에 의존)

## OOP의 한계

- 클래스 상속은 **단일 상속만** 가능하다.
- 상속 계층이 깊어지면 **부모-자식 결합이 강해져** 변경의 영향 범위가 커진다.
- 상속은 **값 타입(struct, enum)에는 적용할 수 없다.**
- 이런 한계를 프로토콜 중심 설계로 극복하려는 흐름이 [Protocol Oriented Programming (POP)](POP.md)이다.

## 정리

- OOP는 추상화·캡슐화·상속·다형성을 통해 객체 단위로 코드를 구성하는 패러다임이다.
- SOLID 원칙은 OOP 설계를 유연하게 유지하는 지침이다.
- Swift는 OOP·FP·POP 특징을 모두 가진 멀티 패러다임 언어로, 상황에 맞게 조합해 사용한다.

관련: [OOP와 FP 비교](OOP_vs_FP.md), [FP: 함수형 프로그래밍](FP.md), [Protocol Oriented Programming (POP)](POP.md), [Class & Struct](../../Swift/Class_vs_Struct.md)
