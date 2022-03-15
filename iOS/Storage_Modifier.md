# Storage Modifier
: Strong, Weak, Unowned

Swift는 ARC를 통해 메모리 관리가 이루어진다.  
ARC는 개발자가 직접 코드를 작성하여 메모리를 관리해야 하는 부분을 컴파일 시점에서 retain/release 코드를 적절히 삽입해주어, 실행 중에 별도의 메모리 관리를 하지 않도록 도와준다.  
하지만 메모리 참조 순환이 발생할 위험이 있으므로 개발자가 명시적으로 직접 관리해주어야 한다.

## 참조 카운드 (RC, Retain Count)
> 특정 주소값을 참조하고 있는 인스턴스의 카운트를 세는 역할을 한다.

- 단어에서 확인할 수 있듯이 `참조 타입`에만 해당된다.  
(구조체, 열거형 과 같은 `값 타입`에는 해당하지 않는다.)

- 클래스의 인스턴스가 생성되면 Heap 영역에 메모리가 할당되고, 초기 인스턴스의 RC값은 1(자기자신)이 된다.
- 해당 인스턴스를 참조하고 있는 다른 객체를 선어한 경우 RC 카운트가 증가하게 된다.

- RC값이 0이 되는 경우(더 이상 해당 인스턴스를 참조하지 않는 경우) 에만 메모리에서 해제가 가능하다.
- 자동으로 메모리에서 해제시켜주지 않으므로, 이처럼 RC값이 0이 되지 않는 경우 메모리에 계속 남아있게 되고, 메모리 누수가 발생한다.
```
이러한 메모리 누수 방지를 위해 Weak, Unwoned와 같은 타입을 사용할 수 있다.
```

## Strong
- `Strong` 타입의 변수는 인스턴스 생성 시 RC를 증가시킨다.
- Swift에서는 대부분 강한 참조를 사용하고 있다.  
 (프로퍼티 선언 시 default값이 Strong)
 - 일반적인 Linear Reference Flow를 따를 경우 문제가 되지 않는다.  
 (부모 객체가 메모리에서 해제되고 RC를 감소시키면 모든 자식 객체들도 사라진다.)
 ```Swift
class Person {
    var nickname: String

    init(nickname: String) {
        self.nickname = nickname
        print("이 사람의 별명은 \(nickname) 입니다.")
    }

    deinit {
        print("이 사람의 별명은 더이상 \(nickname) 이 아닙니다.")
    }
}

do {
    let keen = Person(nickname: "팀쿡이 데려갈 인재")
}
 ```
 - `do` 구문 안에서 `Person` 객체가 생성되고, scope가 종료되는 순간 객체는 메모리에서 해제된다.
 ```
 // 출력 결과
 이 사람의 별명은 팀쿡이 데려갈 인재 입니다.
 이 사람의 별명은 더이상 팀쿡이 데려갈 인재 이 아닙니다
 ```

> 강한 참조 순환 (Strong Reference Cycle)
- `Strong` 으로 선언한 경우, 클래스 인스턴스 사이에 강한 참조 순환이 발생할 수 있다.
- `Person` 객체가 `Macbook`을 소유하는 경우를 예로 들어보자.

```Swift
class Person {
    var nickname: String
    var macbook: Macbook?

    init(nickname: String) {
        self.nickname = nickname
        print("이 사람의 별명에 \(nickname)이 할당되었습니다.")
    }

    deinit {
        print("이 사람의 별명에 \(nickname)이 할당 해제되었습니다.")
    }
}

class Macbook {
    var model: String
    var owner: Person?

    init(model: String) {
        self.model = model
        print("이 맥북의 모델은 \(model)이 할당되었습니다.")
    }

    deinit {
        print("이 맥북의 모델은 \(model)이 할당 해제되었습니다.")
    }
}

do {
    let m1 = Macbook(model: "Macbook Pro M1")
    let keen = Person(nickname: "팀쿡이 데려갈 인재")

    m1.owner = keen // m1은 keen을 참조
    keen.macbook = m1 // keen은 m1을 참조
}
```
- `Person`과 `Macbook`은 서로 강한 참조를 하고 있다.
- `do` 구문이 끝나더라도 두 인스턴스는 메모리에서 해제되지 못한다.
- 위와 같이 서로를 참조하고 있기 때문에 메모리에서 해제되지 못하는 경우를 `강한 참조 순환` 이라고 한다.

</br>

```
// 출력 결과
이 맥북의 모델은 Macbook Pro M1이 할당되었습니다.
이 사람의 별명에 팀쿡이 데려갈 인재이 할당되었습니다.
```
-> 위와 같은 문제 해결을 위한 방법이 'Weak' 이다.

## Weak
- `Strong`과 다르게 RC를 증가시키지 않는다.
- `ARC`에서 메모리가 해제되면 같이 사라지게 된다.
- 자동으로 `nil`값을 가지게 되므로 `weak`이 `Optional` 타입이라는 것을 유추할 수 있다.
- 위의 강한순환참조 예시에서 프로퍼티를 Weak으로 변경하면, 정상적으로 메모리에서 해제되는 것을 확인할 수 있다.
```Swift
class Person {
    weak var macbook: Macbook?
    // code ...
}

class Macbook {
    weak var owner: Person?
    // code ...
}

// ...
```

</br>

출력 결과는 다음과 같다.
```
// 출력 결과
이 맥북의 모델은 Macbook Pro M1이 할당되었습니다.
이 사람의 별명에 팀쿡이 데려갈 인재이 할당되었습니다.
이 사람의 별명에 팀쿡이 데려갈 인재이 할당 해제되었습니다.
이 맥북의 모델은 Macbook Pro M1이 할당 해제되었습니다.
```
## Unowned
- Weak과 거의 유사하다.
- RC를 증가시키지 않는다.
- Weak과 다른점은 Optional 타입이 아니라는 것이다.
    - Optional 타입이 아니므로 메모리 해제시 자동으로 nil값을 가질 수 없다. 
    - 때문에 nil이 아님을 보장할 수 있는 경우에만 사용해야 한다.

> 애플에 따르면,,,  
> 참조 코드가 동시에 메모리에서 해제되는 경우 사용하기 좋다고 한다.



<details>
<summary> 참고링크 </summary>
 
- [Storage Modifier](https://velog.io/@ellyheetov/Strong-Weak-Unowned)
- [Strong & Weak & Unwoend with examples](https://www.advancedswift.com/strong-weak-unowned-in-swift/)
- [강한참조 vs 약한참조](https://jmkim0213.github.io/ios/swift/2019/02/08/weak_Vs_unowned.html)

</details>