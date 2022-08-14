# mutating 키워드

- Swift의 구조체는 값 타입(`value type`)의 불변 객체 (`immutable object`) 이다.
    - 값 타입 프로퍼티들을 인스턴스 메서드에 의해 수정될 수 없다.
- `mutating` 키워드를 메서드 앞에 붙이면 구조체나 열거형 인스턴스에서 프로퍼티를 수정할 수 있게 된다.
    - struct 안에 포함된 어느것이든 상태를 바꾸고자 할 때 사용하는 키워드이다.

</br>

- `mutating` 키워드가 붙은 메서드를 실행하면 스위프트는 새로운 구조체를 생성해 변경된 프로퍼티의 값을 할당하고 반환해 현재 구조체를 대체한다.
    - 즉, 실질적으로 새로운 `struct` 객체를 만들어 원래 있던 자리에 그대로 넣어준다. (바꿔치기)
    - (함수의 파라미터에 `inout` 키워드를 사용하는 것과 비슷하다.)
    - 구조체의 불변성을 지키기 위해 이런 방법을 사용한다.

</br>

- `mutating` 키워드는 해당 메서드를 호출하는 `caller`에게 값이 바뀔 것이다 라는 것을 알도록 한다.
    - 이 개념을 이해하기는 쉬운 예로 숫자 연산을 들 수 있다.
    - 예를 들어 `3 + 2` 이라는 연산을 수행하면 `3`이 `5`가 되지 않는다. 
    - 연산을 수행한 후 `5` 라는 새로운 값을 갖게 되는 것이다.
- mutating 함수들은 모두 같은 규칙 하에 작동한다.
    - 상수(`constant`)에 대해 mutating 함수를 호출할 수 없다.

```swift
struct SomeStruct {
    var value: Int = 0
    
    mutating func increaseValue(increament: Int) { // increament 만큼 value를 증가시키는 함수
        self = SomeStruct(value: value + increament)
    }
}
```

</br>

## 구조체 인스턴스를 상수(constant)로 선언하면 어떻게 될까?

```swift
// 상수로 선언한 객체
let constantStruct = SomeStruct()
variableStruct.value // 0
// constantStruct.increaseValue(increament: 10) // error : change 'let' to 'var' to make it mutable
```

- 이유: 그 이유는 상수로 선언된 객체에 새로운 값을 할당하는 것이 불가능하기 때문이다.
- 그렇기 때문에 mutating 함수는 오직 변수(`variable`) 에서 사용할 수 있다.

</br>

## 변수(variable)로 바꾸어 선언하면 어떻게 될까?
```swift
// 변수로 선언한 객체
var variableStruct = SomeStruct()
variableStruct.value // 0

variableStruct.increaseValue(increament: 20)
variableStruct.value // 20
```
- `increaseValue(increament:)` 함수를 실행한 후 결과물로 나온 `value`가 20인 인스턴스를 `variableStruct`에 대체가 가능하므로 잘 작동한다.

</br>

## 전체 코드

```swift
struct SomeStruct {
    var value: Int = 0
    
    mutating func increaseValue(increament: Int) { // increament 만큼 value를 증가시키는 함수
        self = SomeStruct(value: value + increament)
    }
}

// 상수로 선언한 객체
let constantStruct = SomeStruct()
variableStruct.value // 0
// constantStruct.increaseValue(increament: 10) // error : change 'let' to 'var' to make it mutable

// 변수로 선언한 객체
var variableStruct = SomeStruct()
variableStruct.value // 0

variableStruct.increaseValue(increament: 20)
variableStruct.value // 20
```