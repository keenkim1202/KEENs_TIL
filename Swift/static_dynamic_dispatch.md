# Static Dispatch & Dynamic Dispatch

디스패치는 **어떤 메서드를 실제로 실행할지 결정하는 과정**이다. 결정 시점에 따라 정적 디스패치와 동적 디스패치로 나뉜다.

## Static Dispatch (정적 디스패치, Direct Call)

- **컴파일 타임에** 호출할 함수를 결정하고, 런타임에는 그 주소로 곧장 호출한다.
- 호출 대상이 정해져 있으므로 인라이닝 등 컴파일러 최적화가 가능해 성능상 유리하다.
- 값 타입(struct, enum)의 메서드는 상속이 없어 기본적으로 정적 디스패치를 사용한다.

## Dynamic Dispatch (동적 디스패치, Indirect Call)

- **런타임에** 호출할 함수를 결정한다.
- 결정 과정에서 테이블을 한 번 거쳐야 하므로 정적 디스패치보다 비용이 크고, 컴파일러 최적화(인라이닝 등)가 제한된다.
- class는 상속·오버라이딩 가능성이 있어 기본적으로 동적 디스패치를 사용한다.

## 동적 디스패치를 구현하는 테이블

동적 디스패치는 호출 시점에 테이블을 한 번 거쳐 실제 구현을 찾는다. 사용하는 테이블이 두 가지다.

### vTable (Virtual Dispatch Table) — 클래스 상속에서 사용

> 📌 메서드 오버라이딩에 따라 실행 시점에 어떤 메서드를 실행할지 결정하는, 동적 디스패치를 지원하기 위한 메커니즘.

- 클래스마다 자신의 메서드 함수 포인터들을 모아둔 배열(vTable)을 가진다.
- 메서드를 호출하면 이 vTable을 참조해 실제 실행할 함수를 런타임에 찾아간다.
- 컴파일러는 하위 클래스에서 오버라이딩될 가능성이 있는지 알 수 없으므로, 그럴 가능성이 있는 메서드는 무조건 vTable을 거쳐 참조한다.

### Witness Table — 프로토콜 채택에서 사용

> 📌 특정 타입이 특정 프로토콜을 어떻게 구현했는지 매핑해, 프로토콜 메서드의 디스패치를 지원하기 위한 메커니즘.

- 타입이 프로토콜을 채택할 때마다 그 (타입 × 프로토콜) 조합을 위한 witness table이 만들어진다.
- 프로토콜 타입(existential)으로 값을 다룰 때, 어떤 구현을 호출할지 결정하기 위해 witness table을 거친다.
- 단, 프로토콜 익스텐션에 정의했지만 프로토콜 요구사항으로 선언되지 않은 메서드는 **정적 디스패치**된다. (구체 타입이 같은 이름의 메서드를 가져도 프로토콜 타입으로 호출하면 익스텐션 구현이 불리는 함정의 원인)

## 타입별 기본 디스패치 방식

| 타입 | 기본 디스패치 |
| --- | --- |
| Struct / Enum (값 타입) | Static |
| Class (참조 타입) | Dynamic (vTable) |
| Protocol 요구사항 | Dynamic (Witness Table) |
| Protocol Extension (요구사항 아님) | Static |

## Swift의 4가지 디스패치 방식

엄밀히 보면 Swift는 4가지 디스패치 방식을 가진다.

1. **Inline** — 정적 디스패치의 극한 최적화. 호출 자체를 없애고 함수 본문을 호출 지점에 펼쳐 넣는다.
2. **Static (Direct)** — 컴파일 타임에 주소가 결정되어 곧장 호출.
3. **Table (vTable / Witness Table)** — 테이블을 한 번 거쳐 런타임에 구현을 찾음. class 메서드와 프로토콜 요구사항의 기본 방식.
4. **Message (objc_msgSend)** — Objective-C 런타임을 통한 디스패치. 가장 느리지만 가장 유연(KVO, swizzling 가능).

> 비용 순서: **Inline < Static < Table < Message**
> 차이는 나노초 단위지만, 자주 호출되는 hot path(게임 루프·실시간 처리 등)에서는 누적 효과가 의미 있다.

## 프로토콜 본문 vs 익스텐션 전용 메서드의 디스패치 함정

프로토콜 요구사항으로 선언된 메서드는 witness table을 통한 동적 디스패치지만, 익스텐션에만 정의된 메서드는 정적 디스패치된다. 그래서 **같은 이름의 메서드라도 변수의 타입이 무엇이냐에 따라 다른 구현이 호출**될 수 있다.

```swift
protocol Greeter {
    func greet()              // 프로토콜 요구사항 → witness table (동적)
}

extension Greeter {
    func greet() { print("Hello") }    // 요구사항 구현 (동적)
    func farewell() { print("Bye") }   // 익스텐션에만 존재 → 정적
}

struct EnglishGreeter: Greeter {
    func greet() { print("Hi") }
    func farewell() { print("Goodbye") }
}

let g: Greeter = EnglishGreeter()
g.greet()      // "Hi"  → 동적 디스패치 (실제 타입의 구현)
g.farewell()   // "Bye" → 정적 디스패치 (변수 타입 Greeter 기준)

let g2: EnglishGreeter = EnglishGreeter()
g2.farewell()  // "Goodbye" → 정적 디스패치 (변수 타입 EnglishGreeter 기준)
```

> 의도와 다른 메서드가 불릴 수 있으므로, 다형성이 필요한 메서드는 반드시 **프로토콜 본문에 요구사항으로 선언**해야 한다.

## 동적 → 정적으로 최적화하는 방법 (성능 개선)

상속/오버라이딩 가능성을 컴파일러에게 없다고 알려주면, 동적 디스패치를 정적 디스패치로 바꿔 성능을 높일 수 있다.

- **`final`**: 더 이상 오버라이딩될 수 없음을 명시 → 정적 디스패치로 전환된다.
- **`private` / `fileprivate`**: 접근 범위가 좁아 컴파일러가 오버라이딩 없음을 확신할 수 있어 자동으로 `final`처럼 취급(정적 디스패치)될 수 있다.
- **`static`**: 타입 메서드는 정적 디스패치된다.
- **Whole Module Optimization (WMO)**: 모듈 전체를 분석해 오버라이딩되지 않는 메서드를 자동으로 정적 디스패치로 최적화한다.

```swift
class ViewController {
    final func setup() { ... }   // final → 정적 디스패치
}
```

## `dynamic` 키워드와 Objective-C 런타임

- `dynamic` 키워드를 붙이면 Objective-C 런타임을 통한 **메시지 디스패치**를 강제한다.
- 가장 느린 방식이지만 KVO, method swizzling 등 런타임 기능을 사용하려면 필요하다.
- `@objc dynamic`은 Objective-C에 노출 + 메시지 디스패치를 의미한다.

## 정리

- 값 타입은 정적 디스패치라 빠르고, class는 상속 가능성 때문에 기본적으로 동적 디스패치(vTable)를 쓴다.
- 오버라이딩이 필요 없는 메서드라면 `final`/`private`/`static`을 활용해 정적 디스패치로 전환하면 성능 이점을 얻을 수 있다.

관련: [Class & Struct](Class_vs_Struct.md), [protocol 지향 언어로써의 Swift 특징](protocol지향언어.md), [final](final.md)
