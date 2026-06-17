# Protocol Oriented Programming (POP)

## 정의

- POP는 Protocol-Oriented Programming의 약자로, Swift가 강조하는 프로그래밍 패러다임이다.
- Apple이 WWDC 2015에서 Swift의 핵심 패러다임으로 제시했다. ("Protocol-Oriented Programming in Swift" 세션)
- Swift 표준 라이브러리 대부분이 `struct`(값 타입)와 프로토콜로 구성되어 있는 것도 이 흐름을 반영한다.

## 핵심 아이디어

- 클래스 상속 대신 **프로토콜 + 프로토콜 익스텐션 + 값 타입**을 중심으로 코드를 설계한다.
- OOP와 비교하면 분류의 축이 다르다.
	- **OOP**: "무엇인가"라는 정체성 기반의 **수직적** 분류 (상속 계층)
	- **POP**: "무엇을 할 수 있는가"라는 능력 기반의 **수평적** 분류 (프로토콜 채택)

## 등장 배경: OOP 상속의 한계

클래스 상속에는 다음과 같은 한계가 있고, 프로토콜로 이를 극복할 수 있다.

- **단일 상속만 가능하다.** 클래스는 부모를 하나만 가질 수 있다.
- **부모-자식 결합이 강하다.** 상속 계층이 깊어지면 변경의 영향 범위가 커지고 관리가 어렵다.
- **값 타입에는 적용할 수 없다.** struct, enum은 상속이 없어 공통 기능을 상속으로 공유할 수 없다.

## 어떻게 구성하나

상속이 없는 값 타입 기반에서 공통 기능은 프로토콜과 익스텐션으로 구성한다.

1. **프로토콜로 추상화** — 어떤 능력을 가져야 하는지 정의한다.
2. **프로토콜 익스텐션으로 기본 구현 제공** — 채택만 해도 동작하는 메서드를 제공한다.
3. **값 타입과 결합** — struct/enum에 프로토콜을 채택해 안전한 값 타입 중심 설계를 한다.

```swift
protocol Greetable {
    var name: String { get }
}

extension Greetable {
    func greet() {
        print("안녕하세요, \(name)입니다")
    }
}

struct Person: Greetable {
    let name: String
}

Person(name: "Alice").greet()   // "안녕하세요, Alice입니다" — 자동으로 동작
```

## 장점

- **다중 채택이 가능하다.**
	- 클래스는 하나의 부모만 상속하지만, 한 타입은 여러 프로토콜을 동시에 채택할 수 있다.
	- 작은 프로토콜을 조합해 능력을 부여하므로, 새 능력이 필요하면 새 프로토콜을 추가하면 되고 기존 코드는 영향받지 않는다.
	```swift
	struct Robot: Walking, Talking, Calculating {
	    // 세 프로토콜의 능력을 모두 가짐
	}
	```
- **값 타입을 활용할 수 있다.**
	- 프로토콜은 클래스뿐 아니라 struct, enum도 채택할 수 있다.
	- 값 타입의 장점(동시성 안전성, 의도치 않은 공유 방지, ARC 오버헤드 없음)을 누리면서 추상화도 가능하다.
- **익스텐션으로 기본 구현을 제공한다.**
	- 각 타입에서 같은 메서드를 반복 구현할 필요가 없어 재사용성이 높아진다. 필요하면 특정 타입에서 오버라이드도 가능하다.
- **성능 이점이 있다.**
	- 값 타입 메서드와 프로토콜 익스텐션 메서드는 정적 디스패치되어 인라이닝 등 컴파일러 최적화가 가능하다. (class의 vTable 디스패치보다 빠를 수 있다.)
	- 다만 프로토콜 타입 변수를 쓰면 existential container 비용이 추가되므로 무조건 빠른 것은 아니다. 측정 기반으로 판단해야 한다.

## 실무 활용

- **의존성 주입 / 테스트 용이성**
	- 프로토콜로 의존하면 실제 구현체와 테스트용 mock 구현체를 쉽게 교체할 수 있다. (의존성 역전 원칙이 자연스럽게 적용된다.)
	```swift
	protocol UserRepository {
	    func fetchUser(id: String) async throws -> User
	}

	class APIUserRepository: UserRepository { /* 실제 네트워크 호출 */ }
	class MockUserRepository: UserRepository { /* 테스트용 더미 반환 */ }

	final class UserViewModel {
	    let repository: UserRepository   // 구체 타입이 아니라 프로토콜에 의존
	    init(repository: UserRepository) { self.repository = repository }
	}
	```
- **능력별 프로토콜 분리**
	- Swift 표준 라이브러리의 `Codable`, `Equatable`, `Hashable`, `Identifiable`처럼 필요한 능력만 선택적으로 채택하는 방식.

## 디스패치 관점에서 주의할 점

POP를 쓸 때 가장 헷갈리는 부분이다.

- **프로토콜 요구사항으로 선언된 메서드** → witness table을 통한 동적 디스패치
- **익스텐션에만 정의된 메서드** → 정적 디스패치
- 그래서 같은 이름의 메서드라도 **변수의 타입에 따라 다른 구현이 호출**될 수 있다. 다형성이 필요한 메서드는 반드시 프로토콜 본문에 요구사항으로 선언해야 한다.

자세히: [Static Dispatch & Dynamic Dispatch](../../Swift/static_dynamic_dispatch.md)

## Protocol 타입 vs Generic

```swift
// 프로토콜 타입 - existential container, 동적 디스패치
func process1(items: [Drawable]) {
    for item in items { item.draw() }
}

// 제네릭 - 컴파일 타임에 타입별로 특수화, 정적 디스패치
func process2<T: Drawable>(items: [T]) {
    for item in items { item.draw() }
}
```

- **프로토콜 타입**: existential container라는 박싱을 사용해 다양한 타입을 담을 수 있다. 유연하지만 약간의 런타임 비용이 있다.
- **제네릭**: 컴파일 타임에 사용 타입별로 특수화되어 정적 디스패치·인라이닝이 가능하다. 대신 한 함수에 서로 다른 타입을 섞어 담을 수는 없다.
- Swift 5.7부터 `some`/`any` 키워드로 이 차이를 명시적으로 표현한다.
	```swift
	func process(item: some Drawable) { ... }   // 제네릭, 정적
	func process(item: any Drawable)  { ... }   // existential, 동적
	```

## Associated Type 과 Self 요구사항 (PAT)

iOS 개발자가 POP를 쓰다 보면 가장 자주 부딪히는 Swift 특유의 제약이다.

- `associatedtype`은 프로토콜이 사용할 타입을 **채택 시점에 결정**하도록 한다. 제네릭과 비슷하지만 프로토콜 쪽에서 쓰는 방식이다.
- `Self` 요구사항이나 `associatedtype`을 가진 프로토콜을 **PAT (Protocol with Associated Type)** 라고 부른다. 표준 라이브러리의 `Equatable`, `Hashable`, `Collection`, `Sequence`가 대표적이다.

```swift
protocol Container {
    associatedtype Item
    var count: Int { get }
    mutating func append(_ item: Item)
    subscript(i: Int) -> Item { get }
}
```

- **제약**: PAT는 구체 타입이 정해지지 않으면 변수 타입으로 직접 쓸 수 없다. (Swift 5.6 이전에는 다음 에러가 났다.)
	- `Protocol can only be used as a generic constraint because it has Self or associated type requirements`
- **해결 방법**:
	- **제네릭 제약으로 사용** — `func use<C: Container>(_ c: C)`처럼 타입 파라미터의 제약으로 쓴다.
	- **타입 소거 (Type Erasure)** — `AnyHashable`처럼 `Any~` 래퍼로 감싸 구체 타입을 숨긴다.
	- **`some` / `any` (Swift 5.6+)** — `some`은 불투명 타입으로 정적, `any`는 existential로 동적이다. PAT도 `any`로 변수에 담을 수 있게 되었지만 런타임 비용이 따른다.

## 한계와 주의점

- **디스패치 차이로 인한 버그 가능성** — 위에서 설명한 프로토콜 본문 vs 익스텐션 전용 메서드의 동작 차이.
- **existential container의 오버헤드** — 큰 값 타입을 프로토콜 타입으로 자주 다루면 Heap 박싱이 빈번해질 수 있다.
- **진짜 참조 의미가 필요하면 class가 맞다** — `UIViewController`처럼 정체성(identity)이 중요하거나 시스템(UIKit)이 라이프사이클을 관리하는 객체는 class가 자연스럽다.
- **너무 잘게 쪼개면 오히려 추적이 어렵다** — 응집도와 결합도의 균형이 필요하다.

## 정리

- POP는 "무엇을 할 수 있는가"를 프로토콜로 정의하고, 값 타입이 그 프로토콜을 채택해 능력을 갖추도록 하는 설계다.
- OOP와 대립이 아니라 보완 관계다. 데이터 모델은 struct로, UI 레이어는 class로, 공통 동작은 프로토콜+익스텐션으로 추상화하는 식으로 상황에 맞게 조합하는 것이 바람직하다.

관련: [Class & Struct](../../Swift/Class_vs_Struct.md), [Static Dispatch & Dynamic Dispatch](../../Swift/static_dynamic_dispatch.md), [Stack & Heap (Swift 관점)](../../Swift/Stack_Heap.md), [OOP](OOP.md), [OOP와 FP 비교](OOP_vs_FP.md)

## 참고 자료

**WWDC**
- [Protocol-Oriented Programming in Swift (WWDC 2015, Session 408)](https://developer.apple.com/videos/play/wwdc2015/408/) — POP를 처음 제시한 세션
- [Protocol and Value Oriented Programming in UIKit Apps (WWDC 2016, Session 419)](https://developer.apple.com/videos/play/wwdc2016/419/) — UIKit 앱에 POP·값 타입을 적용하는 후속 세션

**Apple 공식 문서**
- [Protocols — The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)
- [Choosing Between Structures and Classes](https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes)

**Swift Evolution**
- [SE-0335: Introduce existential `any`](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md) — 프로토콜 타입(existential)을 `any` 키워드로 명시하도록 한 제안 (Swift 5.6)
