 ## 타입 캐스팅(Type Casting) 이란?
  > 인스턴스의 타입을 확인하거나 클래스 계층의 다른 부모 클래스/자식 클래스로 취급하는 방법이다.

  ## 업 캐스팅
  > 자식 클래스 -> 부모 클래스로 형변환 / 부모 클래스의 프로퍼티와 메서드를 사용하기 위한 방법이다.
  - `as` : 타입 변환이 확실하게 가능한 경우에만 사용한다. (그 외에는 컴파일 에러 발생)

```swift
class Food { // 부모 클래스
    let calories: Double

    init(calories: Double) {
        self.calories = calories
    }
}

class Hamburger: Food { // 자식 클래스
    let name: String

    init(calories: Double, name: String) {
        self.name = name
        super.init(calories: calories)
    }
}

let cheeseBurger = Hamburger(calories: 446, name: "cheeseburger")
let upcastedBurger = cheeseBurger as Food

print(upcastedBurger.calories)
print(upcastedBurger.name) // 컴파일 에러 (업캐스팅 되었으므로 name 프로퍼티에는 접근 불가능하다.)
```

  ## 다운 캐스팅
  > 부모 클래스 -> 자식 클래스로 형변환 / 자식 클래스의 프로퍼티와 메서드를 사용하기 위한 방법이다.
  - `as?` (옵셔널 캐스팅) : 변환이 성공하면 옵셔널 값을 가지며, 실패시에는 nil을 반환한다.
  - `as!` (강제 캐스팅) : 변환이 성공하면 언래핑된 값을 가지며, 실패시 런타임 에러가 발생한다.


```swift
let downcastedBurger = cheeseBurger as? Food // as? 를 통해 다운캐스팅
print(downcastedBurger) // nil

let forcedDowncastedBurger = cheeseBurger as! Food // as! 를 통해 다운캐스팅
print(forcedDowncastedBurger) // 런타임 에러
```