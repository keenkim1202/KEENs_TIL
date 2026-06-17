# Class & Struct

## 값 타입(Value Type) vs 참조 타입(Reference Type)

Struct는 값 타입, Class는 참조 타입이다. 이 차이에서 메모리, 복사 동작, 메모리 관리, 동시성까지 대부분의 차이가 갈린다.

| 구분 | Struct (구조체) | Class (클래스) |
| --- | --- | --- |
| 타입 종류 | 값 타입 (Value Type) | 참조 타입 (Reference Type) |
| 저장 위치 | 주로 Stack | 인스턴스는 Heap, 참조는 Stack |
| 복사 방식 | 값 전체를 복사 (독립된 복사본) | 참조(주소)만 복사 (인스턴스 공유) |
| 상속 | 불가능 | 가능 |
| 가변성 | `let`으로 선언하면 프로퍼티 변경 불가 | `let`이어도 내부 `var` 프로퍼티 변경 가능 |
| 비교 | `==` (Equatable 구현 시 값 비교) | `===` (같은 인스턴스인지 식별성 비교) |
| ARC 대상 | 아니다 | 맞다 (참조 카운팅) |

```swift
struct PointStruct { var x = 0 }
class  PointClass  { var x = 0 }

var s1 = PointStruct()
var s2 = s1        // 값 복사 → 별개의 인스턴스
s2.x = 10
print(s1.x)        // 0  (영향 없음)

let c1 = PointClass()
let c2 = c1        // 참조 복사 → 같은 인스턴스를 가리킴
c2.x = 10
print(c1.x)        // 10 (같이 변경됨)
```

값 타입은 복사되어 서로 독립적이기 때문에 의도치 않은 side-effect가 적고, 결과를 예측하기 쉽다.

## 메모리 관점 (Stack vs Heap)

- **Struct**: 
	- 일반적으로 Stack에 할당된다. 
	- Stack은 할당/해제가 빠르고(포인터 이동만 하면 됨) ARC 오버헤드가 없다.
- **Class**: 
	- 인스턴스는 Heap에 할당되고 참조(포인터)만 Stack에 둔다. 
	- Heap 할당은 비용이 크고, ARC를 통한 참조 카운팅 관리가 필요하다.

다만 **Struct가 항상 Stack에 올라가는 것은 아니다.**
- Struct가 Class를 프로퍼티로 가지면, 그 Class 인스턴스는 Heap에 있다.
- 클로저에 캡처되거나, 크기가 커서 컴파일러가 박싱하는 경우 Heap에 올라갈 수 있다.
- `Array`, `String`, `Dictionary` 같은 표준 컬렉션은 struct지만 내부 버퍼는 Heap에 둔다.

### 크기가 큰 Struct가 Heap에 올라가는 경우

- Stack과 Struct는 본래 잘 맞지만, Struct의 크기가 커지면 컴파일러가 그 값을 Heap에 박싱하고 Stack에는 포인터만 두도록 바꿀 수 있다.
- **왜 그렇게 동작하나**:
	- **Stack은 용량이 제한적이다.** 
		- (iOS 메인 스레드 기준 약 1MB) 큰 값을 Stack에 그대로 쌓으면 다른 함수 호출에 쓸 공간이 부족해지고, 심하면 스택 오버플로우로 이어진다.
	- **값 타입은 전달/할당 때마다 전체가 복사된다.** 
		- 큰 Struct를 매번 통째로 복사하면 사용하지 않는 필드까지 복사되어 비용이 누적된다. 
		- 큰 값은 Heap에 한 번 두고 포인터로 다루는 편이 효율적이다.
- **언제 결정되나**: 
	- 이 동작은 **컴파일러가 값의 크기와 사용 패턴을 보고 런타임 비용을 줄이기 위해 내리는 최적화 결정**이다. 개발자가 `@frozen` 등으로 직접 위치를 지정하는 개념이 아니다.
- **그래서 큰 데이터를 값 타입으로 다뤄야 한다면**:
	- 컴파일러의 암묵적 박싱에 기대기보다 표준 컬렉션처럼 **Copy-on-Write를 직접 구현**하거나(내부에 class 박스를 두는 방식)
	- 애초에 그 데이터를 **class로 감싸 참조로 공유**하는 설계를 고려한다.

관련: [스택 영역과 힙 영역(Stack & Heap)](../CS/운영체제/Stack&Heap.md), [Stack & Heap (Swift 관점)](Stack_Heap.md)

## ARC & 메모리 관리

- 값 타입(struct)은 ARC 대상이 아니므로 순환 참조(Retain Cycle)가 발생하지 않는다.
- 참조 타입(class)은 ARC로 관리되므로, 두 인스턴스가 서로를 strong하게 참조하면 메모리 누수가 발생한다.
  - delegate 패턴이나 클로저 캡처에서 `weak`, `unowned`로 참조를 끊어주는 이유가 이것이다.
- 그래서 메모리 관리 부담을 줄이고 싶을 때 struct 기반 설계가 유리하다.

관련: [ARC & GC](../iOS/ARC_vs_GC.md), [Storage Modifier (Strong, Weak, Unowned)](../iOS/Storage_Modifier.md)

## mutating 키워드

- struct는 값 타입이라 메서드 내부에서 자신의 프로퍼티를 바꾸려면 `mutating` 키워드가 필요하다.
- `mutating` 메서드는 실질적으로 새 인스턴스를 만들어 기존 자리를 대체하는 방식으로 동작한다.
- `let`으로 선언한 struct 인스턴스에서는 `mutating` 메서드를 호출할 수 없다.
- class는 참조 타입이라 `mutating` 없이도 내부 프로퍼티를 수정할 수 있다.

```swift
struct Counter {
    var count = 0
    mutating func increase() { count += 1 }  // mutating 필요
}
```

자세히: [mutating 키워드에 대하여](mutating.md)

## 초기화 차이

- **Struct**: 프로퍼티에 기본값이 없어도 컴파일러가 멤버와이즈 이니셜라이저를 자동으로 만들어준다.
- **Class**: 멤버와이즈 이니셜라이저가 없어 직접 `init`을 작성해야 한다. 지정 이니셜라이저 / 편의 이니셜라이저, 상속에 따른 초기화 규칙 등 고려할 것이 더 많다.

```swift
struct User { var name: String; var age: Int }
let u = User(name: "Keen", age: 30)   // 자동 생성된 init 사용

class Person {
    var name: String
    init(name: String) { self.name = name }  // 직접 작성 필요
}
```

## 상속 vs 프로토콜

- class만 클래스 상속이 가능하다. struct는 상속이 불가능하므로, 대신 프로토콜 채택과 익스텐션으로 기능을 확장/공유한다.
- Swift는 프로토콜 지향 언어(POP)를 지향하기 때문에, 상속 대신 프로토콜과 컴포지션을 선호하는 흐름이 자연스럽다.

관련: [protocol 지향 언어로써의 Swift 특징](protocol지향언어.md), [override & overload 란?](Override&Overload.md), [Static Dispatch & Dynamic Dispatch](static_dynamic_dispatch.md)

## 언제 무엇을 쓸까 (Apple 가이드라인)

Apple은 기본적으로 struct 사용을 권장하고, 다음의 경우에 class를 쓰라고 안내한다. (공식 문서: [Choosing Between Structures and Classes](https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes))

**Struct (기본 선택)**
- 비교적 단순한 데이터 값을 캡슐화할 때
- 복사했을 때 참조가 아니라 독립된 복사본을 기대할 때
- 저장 프로퍼티들도 값 타입이라 함께 복사되길 원할 때
- 상속이 필요 없을 때

**Class**
- 식별성(identity)이 중요할 때 — 같은 인스턴스인지를 `===`로 구분해야 할 때
- Objective-C와의 상호운용이 필요할 때 (`UIView`, `UIViewController` 등 UIKit 요소)
- 상속 계층 구조가 필요할 때
- 인스턴스 생명주기 동안 공유된 가변 상태를 여러 곳에서 함께 다뤄야 할 때

이 기준으로 보면 SwiftUI의 `View`가 struct인 것도 이해가 된다. 값 타입이라 복사가 가볍고, 상태가 바뀔 때마다 View를 빠르게 다시 생성하고 비교(diffing)할 수 있어 선언형 UI에 적합하다. 반대로 UIKit의 `UIView`는 식별성·상속·공유 가변 상태가 필요하므로 class다.

## 성능 / Copy-on-Write (CoW)

값 타입은 복사 비용이 걱정될 수 있지만, Swift 표준 컬렉션(`Array`, `Dictionary`, `String` 등)은 Copy-on-Write로 최적화되어 있다.
- 복사 시점에는 실제 복사를 하지 않고 버퍼를 공유하다가, 수정(쓰기)이 일어나는 순간에만 실제 복사가 발생한다.
- 단, 직접 만든 struct에는 CoW가 자동 적용되지 않는다. 큰 데이터를 값 타입으로 다룰 때는 이 비용을 고려해야 하며, 필요하면 내부에 class 박스를 두고 `isKnownUniquelyReferenced`로 직접 CoW를 구현할 수 있다.

## 동시성 관점

- 값 타입은 복사되어 공유 상태가 없으므로 데이터 레이스에서 상대적으로 안전하다.
- 참조 타입은 여러 스레드가 같은 인스턴스를 공유하므로 동기화(락, 직렬 큐, actor 등)가 필요하다.
- Swift Concurrency의 `Sendable`도 값 타입(struct)이 만족시키기 더 쉽다.

관련: [Thread-Safe란?](../CS/운영체제/ThreadSafe.md)

## 정리

- struct는 값 타입으로 복사되어 side-effect가 적고 동시성에 안전하며 ARC 부담이 없다.
- class는 참조 타입으로 식별성·상속·공유 가변 상태가 필요할 때 쓰며 ARC로 관리된다.
- Apple은 기본적으로 struct를 권장하고, identity / 상속 / Objective-C interop이 필요할 때 class를 선택한다.

---

📎 원본 블로그 글: [Class & Struct (나른하개)](https://nareunhagae.tistory.com/59)
