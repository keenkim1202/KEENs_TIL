# == vs ===

- `==` : 값을 비교하는 연산자

```swift
let a: Int = 3
let b: Int = 3
let c = a

a == b // true : 상수/변수 안에 들어있는 값이 같은지 비교하기 때문
a == c // true
```

</br>

- `===` : 참조 값을 비교하는 연산자

```swift
class Person {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let 철수 = Person(name: "철수", age: 22)
let 철수쌍둥이동생 = Person(name: "철수", age: 22)
let 철수복제인간 = 철수

철수 === 철수쌍둥이동생 // false : 각각의 객체를 생성하였기에 참조하고 있는 메모리 주소가 다르기 때문
철수 === 철수복제인간 // true : 철수와 철수복제인간은 같은 메모리 주소를 참조 하고 있기 때문
```