# What's new in Swift - WWDC26

- 영상 링크 : https://developer.apple.com/videos/play/wwdc2026/262 

# Everyday Language Improvements
## Concurrency 진단 개선
- Task 안의 에러 처리 / cancellation / 에러 전파에 대한 진단 메시지가 더 명확해짐

## weak let
- 이제 weak 참조를 let 으로 선언 가능 (불변 weak 참조)

```swift
	  final class Spacecraft: Sendable {
		  weak let dockedAt: SpaceStation?
	  }
```

## ~Sendable marker
- 타입을 명시적으로 non-Sendable 로 표시 가능

```swift
	  class Mission: ~Sendable { }
	  class CrewedMission: Mission, @unchecked Sendable { }
```

## 접근 제어 반영 memberwise init
- 컴파일러가 access level 에 맞는 init 변형을 자동 생성
- 기본값 가진 private 프로퍼티는 public init 에서 제외됨

# anyAppleOS availability
- 여러 플랫폼 availability 체크를 한 줄로 압축
- AS-IS
	- `@available(macOS 27, iOS 27, watchOS 27, tvOS 27, visionOS 27, *)`
- TO-BE
	- `@available(anyAppleOS 27, *)`
- `#if os(anyAppleOS)` 디렉티브에서도 동작

# @diagnose Attribute
- 선언 단위로 진단을 세밀하게 제어 (무시 / 경고 / 에러 승격)

```swift
	  @diagnose(DeprecatedDeclaration, as: ignored, reason: "Flying with surplus hardware")
	  func makeApolloSoyuzMission() -> Mission { }

	  @diagnose(StrictMemorySafety, as: warning)
	  func uplinkCommand(from receiver: inout Receiver, to computer: inout Computer) { }

	  @diagnose(ErrorInFutureSwiftVersion, as: error)
	  func fetchPosition() -> (x: Double, y: Double, z: Double) { }
```

# Module Selectors (::)
- 이름 충돌 시 어느 모듈의 타입/멤버인지 명확히 지정

```swift
	  import Rocket
	  import GiftShopToys

	  let rocket1 = SaturnV()          // 모호함
	  let rocket3 = Rocket::SaturnV()  // 명확함

	  // 멤버에도 적용 가능
	  launchPadTechnician.HumanResources::fire()  // vs Chemistry::fire()
```

# Library Updates
- 업데이트되는 라이브러리 4개
	- Standard Library: 새 타입 / 유틸리티
	- Swift Testing: 테스트 기능 강화
	- Subprocess: 1.0 도달
	- Foundation: Progress 추적, Swift 마이그레이션 지속

# Standard Library
## withTaskCancellationShield
- 특정 작업을 cancellation 으로부터 보호 (중간에 끊기면 안되는 작업)

```swift
	  func sendSOS() {
		  withTaskCancellationShield {
			  radio.send(makeSOSPacket())
		  }
	  }
```

## Dictionary.mapKeyedValues()
- 키는 유지하고 value 만 매핑

```swift
	  missions.mapKeyedValues { mission, launchWindow in
		  makeDisplayName(for: mission, in: launchWindow)
	  }
```

## FilePath 타입
- 경로를 컴포넌트 단위로 다룸

```swift
	  var path: FilePath = "/var/www/static"
	  path.components.append("WWDC")
	  print(path.components)  // ["var", "www", "static", "WWDC"]
```

# Swift Testing Updates
## Issue severity
- 이슈에 severity 지정 가능 (예: .warning 은 실패시키지 않음)

```swift
	  Issue.record("remaining fuel below 10%", severity: .warning)
```

## Test cancellation
- 조건에 따라 테스트를 중간에 취소

```swift
	  if rocket.engineType == .solid {
		  try Test.cancel("\(rocket.name) has solid fuel")
	  }
```

## XCTest 상호운용
- Swift Testing 에서 XCTest assertion 호출 가능
- XCTest 에서 @Test 함수 실행 가능

# Subprocess 1.0
- 정제된 API, 에러 처리 개선, 출력 라인 단위 스트리밍, 크로스 플랫폼 확대

```swift
	  let result = try await Subprocess.run(
		  .name("ls"),
		  input: .none,
		  output: .sequence,
		  error: .string(limit: 4096)
	  ) { execution in
		  execution.standardOutput.strings().filter { $0.hasSuffix(".obj") }
	  }

	  for try await objectFile in result.closureOutput {
		  print("Object file: \(objectFile)")
	  }
```

# Foundation
## ProgressManager
- 진행률 추적 + 메타데이터 + Observation 통합
- subprogress 로 하위 작업에 카운트 분배

```swift
	  let manager = ProgressManager(totalCount: 100)
	  try await rocket.launch(mission.subprogress(assigningCount: 100))

	  func launch(_ progress: consuming Subprogress? = nil) async throws {
		  let stage = progress?.start(totalCount: 3)
		  try await ignite();         stage?.complete(count: 1)
		  try await liftoff();        stage?.complete(count: 1)
		  try await stageSeparation(); stage?.complete(count: 1)
	  }
```

# Beyond Apple Platforms
- Swift 가 web / Android / embedded 로 확장, interoperability 개선

# Swift-C Interoperability (@c attribute)
- Swift 함수를 C 에 직접 노출 -> C→Swift 점진적 마이그레이션 가능

```swift
	  @C
	  func swiftFunction() { }
```

# Swift-Java
- Java 에서 async / throwing Swift 함수 호출 가능
- constrained extension 지원
- Java 클래스가 Swift 프로토콜 채택 가능

# Editor support
- Swift VSCode extension 이 OpenVSX 마켓플레이스에 등록
- Swiftly 로 toolchain 관리 통합
- Cursor, VSCodium 등 호환

# WebAssembly & JavaScriptKit
- Swift -> WebAssembly 컴파일
- JavaScriptKit: 안전한 Swift↔JS 브리징이 최대 40x 빨라짐

# Embedded Swift
- existential type 지원
- untyped throws 지원
- DWARF debug info 개선 -> 제약된 하드웨어에서 coredump 디버깅

# Performance Tuning
- 두 축: optimizer 명시적 제어 / ownership system 확장(불필요한 복사 제거)

# Optimizer Control: @inline & @specialized
## @inline

```swift
@inline(always)  // 강제 인라인
func makeInts(randomized: Bool) -> [256 of Int] { }

@inline(never)   // 인라인 금지
func makeInts(randomized: Bool) -> [256 of Int] { }
```
- `[256 of Int]` 같은 고정 크기 배열 문법 등장

## @specialized
- 특정 타입 파라미터에 대해 generic specialization 을 명시적으로 요청
	- 속성 내부에서 일부 또는 모든 제네릭 매개변수를 제약하는 where 절 작성
	- Swift가 그걸 바탕으로 함수의 특수화 버전을 생성
	- 느린 제네릭 함수가 있는데 한 두가지 특정 타입으로 많이 사용된다면, 이걸 사용해서 Swift에 그 타입들을 우선시해야 한다고 알릴 수 있음

```swift
@specialized(where Values == [UInt8])
func histogram<Values>(of values: Values) -> [256 of Int] where Values: Sequence<UInt8> { }
```

# Ownership System & Noncopyable Types
- Equatable / Comparable / Hashable 가 noncopyable / non-escapable 타입에서도 동작
- associated type 도 ~Copyable, ~Escapable 가능

```swift
protocol Iterable<Element, Failure>: ~Copyable, ~Escapable {
    associatedtype Element: ~Copyable
    associatedtype IterableIterator: IterableIteratorProtocol<Element, Failure>, ~Copyable, ~Escapable
    associatedtype Failure: Error = Never
}
```

# Iterable Protocol & Borrow/Mutate Accessors

- Swift 에서 많은 성능 문제는 불필요한 데이터 복사로 귀결됨
	- 다른 곳에서 같은 데이터가 필요할 때 새 저장소에 데이터를 복사함
	- 복사로 인해 성능 저가하 되는 경우, 특정 상황에서는 복사가 불피료하다는 것을 인식해야 함
	- 저장소가 할당된 상태로 유지될 것을 알고, 두 컴포넌트가 모두 Swift 베타성 규칙을 따른다면
		- 둘 다 접근 가능한 데이터를 변형하지 않으므로 데이터를 복사할 필요가 없음.
		- 기존 저장소에 대한 접근 권한만 부여하면 됨
- 복사를 피하는 가장 간단한 방법은 데이터를 객체에 넣어 그 객체를 다른 컴포넌트에 전달하는 것
	- 대부분 충분하지만 문제를 완전히 없애지는 못함
	- 결국 객체는 reference counting 이 있어서, 객체를 전달하면 참조 카운트가 바뀌기 때문
	- 객체를 해제하고 보유하는 것은 큰 값을 복사하는 것보다 오버헤드가 적지만, 성능에 민감한 코드에서는 여전히 느릴 수 있음.
- 객체가 옵션이 아닐 때, 전통적으로 저장소에 대한 UnsafePointer를 전달해야 함
	- 하지만 이름 그대로 unsafe 함. 
		- 객체2가 참조하고 있는데, 객체1이 저장소 구조를 바꾸거나 deallocate 할 수도 있음
	- 두 컴포넌트가 모두 특정 규칙을 따라야 안전하기 떄문
	- 컴파일러는 그 규칙을 모르고 확인도 할 수 없음
- 저장소를 안전하게 공유하기 위한 보장 집합을 Borrow로 정의함.
	- 컴포넌트2가 저장소를 borrow 동안, 두 컴포넌트는 모두 읽기만 가능하고 쓰기는 불가능
	- 컴포넌트2가 저장소 사용을 완료해야 컴포넌트1이 제어권을 되찾음
- Mutate 와 비슷하지만 접근을 완전히 차단한다는 점에서 다름.
	- 이건 다른 컴포넌트가 저장소에 접근하는 것이 완전히 차단됨
	- 반쯤 업데이트된 데이터를 읽거나, 다른 컴포넌트가 변경사항을 쓰는 시점에 따라 달라지는 동작을 방지함
- Borrow, Mutate 둘다 Swift 컴파일 시간에 두 컴포넌트가 규칙을 따르는지 검증 가능

- computed property 에서 borrow / mutate accessor 로 비싼 복사 제거

```swift
@safe public struct UniqueBox<Value: ~Copyable>: ~Copyable {
    private let valuePointer: UnsafeMutablePointer<Value>
    public var value: Value {
        borrow { valuePointer.pointee }
        mutate { &valuePointer.pointee }
    }
}
```

# Iterate witthout copying
- Swift 6.4 의 for 루프가 새로운 Iterable 프로토콜을 지원함
- Sequence 프로토콜
	- 시퀀스에서 요소를 복사해 내는 방식으로 동작
- Iterable 프로토콜
	- 복사말고 borrow 할 수 있게 함
	- 복사 불가능한 요소와도 동작한다는 의미
	- 객체나 COW 타입을 다룰 때 참조 카운팅을 수행할 필요가 없음
	- 루프 중에 error를 던질 수도 있음 (async sequence)
	- 하지만, borrow 한 객체는 베타성 검사로 인해 루프를 도는 동안 Iterable읋 변형할 수 없음
- for 루프틑 Sequence 프로토콜이 있다면 이것을 우선시하고, 그렇지 않으면 Iterable 로 대체함
- 공통점
	- Sequence 처럼 Iterable은 이터레이터를 생성해 for 루프가 요소를 가져오게 함
- 차이점
	- 시퀀스와 달리 요소를 batch로 가져옴
	- 이터레이터에세 요소들의 span을 요청해 하나씩 처리
	- 그 다음 또 다른 span을 요청해서 처리
	- 요소가 없어지면 빈 span을 반환해 for 루프 종료
	- 이 batch 구조로 루프를 훨씬 더 효율적으로 만들고, 특히 한 번에 모든 것을 큰 span 으로 반환할 수 있는 타입에서 효과적. 


# The problem witth existing accessors
## get and set copy values

```swift
@safe struct UniqueBox<Value>: ~Copyable {
	private let valuePointer: UnsafeMutablePointer<Value>
	
	init(_ value: consuming Value) {
		valuePointer = UnsafeMutablePointer.allocate(capacity: 1)
		valuePointer.initialize(to: value)
	}
	
	var value: Value {
		get { valuePointer.pointee }
		set { valuePointer.pointee = newValue }
	}
	
	deinit {
		valuePointer.deinitialize(count: 1)
		valuePointer.deallocate()
	}
}
```
- 이 UniqueBox 구조체를 예시로 살펴보자.
	- 큰 값에 대한 포인터를 자동으로 관리하고, 접근하기 위한 계산 프로퍼티인 value 를 제공한다.
	- 위의 작성된 코드는 value 프로퍼티에 심각한 성능 문제가 있음.
- 무슨 문제?
	- Uniquebox 에 256개의 Int 로 구성된 InlineArray를 넣는다고 가정해보자.
	- InlineArray는 인라인이므로 64비트 기기에서 2KB 구조체가 됨 (복사하고 싶지 않은 크기임)
	- 그런데 get, set 이 데이터를 복사해 동작해서 문제임
	- 배열에서 Int 하나를 바꾸려면, 전체를 복사했다가 값을 바꾸고 다시 넣어야함
- 해결책
	- borrow, mutate 쓰기 (예시 코드 펼쳐보기)
		```swift
			var value: Value {
				borrow { valuePointer.pointee }
				mutate { &valuePointer.pointee }
			}
		```
		- borrow 접근자는 복사없이 공유 저장소에 대해 읽기 전용 접근을 제공
		- mutate 접근자는 독점적 접근을 제공해 제자리(in place)에서 수정할 수 있음
		- 이 접근자들은 복사 불가능한 값도 처리할 수 있음
- Swift는 아무것도 복사하지 않고 원본 배열의 요소를 직접 변형할 수 있음

# New Standard Library Types: UniqueBox, UniqueArray, Ref
## Safe alternatives to unsafe code
- UniqueBox: 단일 소유권 wrapper
	- UnsafeMutablePointer.allocate 대신 사용
- UniqueArray: 단일 소유권 배열
	- UnsafeMutableBufferPointer.allocate 대신 사용
	- 일반 Swift Array와 비슷하지만 복사 불가능하다는 점이 다름
	- 즉, 복사 불가능한 값을 저장할 수 있고, 고정 크기에 제한받지 않고 참조 카운팅 오버헤드를 피할 수 있음
- withTemporaryAllocation(of:capacity:_:)
	- UnsafeMutableBufferPointer 대신 사용
	- OutputSpan을 사용해 임시 메모리가 안전하게 처리되도록 함
- Continuation
	- UnsafeContinuation 대신 사용
	- 한 번만 재개할 수 있음을 컴파일 시간에 검사함
	- UnsafeContinuation만큼 효율적이면서 CheckedContinuation 보다 더 안전하게 만듬
## The Ref and MutableRef types
- Ref / MutableRef: 반복 접근 제거용 안전한 참조 타입
	- borrow나 변형을 위한 컨테이너 같은 것
	- 변수에 저장하고 함수에 전다랗고 반환하며 제네릭 타입에서도 사용할 수 있음
	- 저장소를 빌림으로써 읽기 점근에서 Ref 타입 인스턴스를 만들 수 있음
	- 쓰기 접근에서 MutableRef 타입 인스턴스를 접두사 & 를 사용해 만들 수 있음
- 코드예시 (dictionary lookup 을 루프 밖으로 hoisting)

```swift
func updateCount<Key: Hashable>(
        for key: Key, 
        from sets: [Set<Key>], 
        in counts: inout [Key: Int]
    ) {
        // as-is (1)
        for set in sets {
            if set.contains(key) {
                counts[key, default: 0] += 1
            }
        }
        // as-is (2)
        func updateCountImpl(count: inout Int) {
            for set in sets {
                if set.contains(key) {
                    count += 1
                }
            }
        }
        updateCountImpl(count: &counts[key, default: 0])
        // to-be
        var countRef = MutableRef(&counts[key, default: 0])
        for set in sets {
            if set.contains(key) { 
                countRef.value += 1
            } 
        }
    }
}
```

- as-is (1)
	- key는 항상 같음에도 불구하고 증가 시킬 때마다 딕셔너리 키를 조회함. 
- as-is (2)
	- 보통 이런 반복 작업은 루프 밖으로 빼서 한 번만 수행하도록 하는 것이 좋지만, 지금까지는 딕셔너리 조회를 하고 잠시 열어두는 유일한 방법은 루프를 함수로 옮기고 조회를 inout 매개변수로 전달하는 것임.
- to-be
	- 이제 루프 시작 전에 한 번 딕셔너리 조회에서 MutableRef를 만들 수 있음
	- 딕셔너리 항목을 변형할 때 사용함
	- Ref는 탈출 불가능하므로 변수가 범위를 벗어날 때 Swift는 접근이 끝나는 시점을 알 수 있음

# The Future of Swift
- Swift Build 등 오픈소스 진행
- 새 workgroup: Build / Networking / Windows / Android
- forums.swift.org 에서 커뮤니티 참여 가능
