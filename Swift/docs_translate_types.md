# Types

> Swift 공식 문서 번역:   
> The Swift Prgramming Language Swift 5.7 [원문보기](https://docs.swift.org/swift-book/ReferenceManual/Types.html)

---

## Index
- Type Annotation
- Type Identifier

---

Swift에는 두 종류의 타입이 있다.  
`named type`은 정의할 때 특정 이름을 지어줄 수 있는 타입이다.  
`named type`은 `classes, structures, enumerations, protocols`를 포함한다.

</br>

예를 들어,  
사용자 정의 클래스 (`user-defined class`) `MyClass` 의 인스턴스는 `MyClass` 타입을 가진다.

게다가 `user-defined named type`은 Swift standard libarary는 흔하게 사용하는 named type들을 정의한다.  
예를 들면 `arrays, dictionaries, optional values` 를 나타내는 것을 포함한다.

</br>

Data type들은 보통 다른 언어들에서 기본(basic, primitive)으로 여겨진다 - 숫자, 문자, 문자열들은 나타내는 타입들과 같은 - 이것들은 사실 `named type` 으로, Swift standard library 에 구조체(structure)로 정의 되어있고 적용되어 있다.   
그들은 `named type`이기 때문에, `extension`을 정의하고 활용하여 당신의 프로그램에서 필요에 맞추어 그들의 행동을 확장 할 수도 있다.

`compound type`은 Swift 언어 그 자체로 정의된 이름이 없는 타입이다.  
`compound type`은 두가지가 있다. 함수타입(function type)과 튜플타입(tuple type).  
`compound type`은 `named type`과 다른 `compound type`을 포함할 수 있다.

</br>

예를 들어,  
tuple type `(Int, (Int, Int))` 는 두 요소를 포함하고 있다.
처음은 `Int` 라는 named type, 두번째는 다른 compound type인 `(Int, Int)` 이다.

</br>

당신은 named type이나 compound type 주위를 괄호로 묶어줄 수 있다.  
하지만, 타입 주변에 괄호를 추가한다고 어떠한 효과를 가지는 것은 아니다.
예를 들어 `(Int)` 는 `Int` 와 동일하다.

이 챕터에서는 Swift 언어 자기 자신에서 타입이 어떻게 정의되어있는지, Swift의 타입추론(type inference behavior)이 어떻게 묘사되고 있는지 알아볼 것이다.


---

## Type Annotation

type annotation은 명확하게 변수(`variable`) 혹은 표현식(`expression`)을 지정한다.  
type annotation은 콜론 (`:`) 으로 시작하며 type으로 끝난다.  
예시는 아래와 같다.

```swift
let someTuple: (Double, Double) = (3.14159, 2.71828)
func someFunction(a: Int) { /* ... */ }
``` 

첫번째 에시에서 보면, `someTuple` 이라는 표현식은 `(Double, Double)` 튜플 타입임을 가짐을 지정한다.  
두번째 예시를 보면, `someFunction` 이라는 함수의 파라미터는 `Int` 타입을 가짐을 지정한다.

</br>

type annotation은 타입 앞에 타입의 속성(type attributes)에 대한 리스트도 옵션으로 포함할 수 있다.  
```
ex) 
@escaping, @autoclosure
```
---

## Type Identifier
`type identifier`는 named type 또는 이름이 지어진 `type alias` 또는 `compound type`을 의미한다.  

</br>

대부분의 경우 type identifier는 identifier로써 같은 이름을 가진 `named type`을 의미한다.  
예를 들어 `Int`는 `Int` 라는 named type을 직접적으로 나타내는 type identifier 이고, `Dictionary<String, Int>`는 `Dictionary<String, Int>` 라는 named type을 나타낸다.

</br>

type identifer가 나타내는 타입과 이름이 같지 않은 경우는 두 가지가 있다.  
첫번째 경우는, type identifer가 named 혹은 compound type의 type alias를 나타내는 경우이다.  
그 대신에 아래의 예시 처럼 type annotation에 사용된 `Point` 는 `(Int, Int)` 튜플 타입을 나타낸다.

```swift
typealias Point = (Int, Int)
let origin: Point = (0, 0)
```

</br>

두번째 경우는, type identifier가 named type들을 다른 모듈 혹은 중첩된 다른 타입을 나타내기 위해 dot(`.`) syntax 을 사용하는 경우이다.
예를 들어, 아래 코드의 type identifier는 `ExampleModule`이라는 모듈 안에 정의된 `MyType`이라는 named type을 의미한다.
```swift
var someValue: ExampleModule.MyType
```

---

## Tuple Type


---

## Function Type


---

## Array Type


---

## Dictionary Type


---

## Optional Type


---

## Implicitly Unwrapped Optional Type


---

## Protocol Composition Type


---

## Opaque Type


---

## Metatype Type


---

## Any Type


---

## Self Type


---

## Type Inheritance Clause


---

## Type Inference
