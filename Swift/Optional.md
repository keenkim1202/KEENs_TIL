
# 옵셔널이란 무엇인지, 옵셔널값을 unwrap하는 방법에는 무엇이 있는가
  <br>

  - 옵셔널은 변수의 값이 `nil` 일 수 있다는 것을 표현하는 것이다.
  - 반대로 Optional이 아니라면(non-optional) 해당 값은 nil이 될 수 없음을 의미한다.

  ```swift
  var name: String? // ? 키워드를 사용

  var age: Int // 컴파일 에러
  var age = nil // 컴파일 에러
  ```

  - Optional 키워드를 사용하지 않았다면 값을 입력하라는 에러가 발생하고, 이후에도 `nil`을 넣으려고 하면 컴파일 에러가 발생한다.
  - `nil`을 가질 가능성이 있는 값은 컴파일 단계에서 에러를 발생시키기 때문에 unwrapping, binding 과정이 필요하다.

    <details>
      <summary> 1) Optional Unwrapping </summary>
      <br>

      ```swift
      var number: Int? = 10

      if number {
      let double = number! + number! // forced unwrapping
      }
      ```

      - `!` 키워드를 통해 강제로 값을 꺼내온다.
      - 만약 if로 `nil` 체크를 하지 않고 `!`를 사용한다면 런타임 에러가 발생할 수 있으므로, `!` 사용은 최대한 피하는게 좋다.

    </details>

    <details>
      <summary> 2) Optional Binding </summary>
      <br>

      - 변수에 값이 있을지 없을지 모르는 상황에서 Optional을 우리는 사용해야 하지만 그 값을 안전하게 추출하기 위해서 사용하는 방법이 Optional Binding이다.
      - Optional Binding에는 `if let`, `guard let` 두 가지가 있다.
      <br>
      
      **[ if let ]**
      ```swift
      // if let
      var number: Int? = 10

      if let number = number {
      print("number is \(number)") // number에 값이 있는 경우
      } else { // number에 값이 없는 경우
      print("number does not exist.")
      }
      ```

      - `Optional`값을 새로운 상수로 받고, if문의 괄호 안에서는 `non-optional`값을 사용한다.
      - 새로 선언된 상수는 `non-optional` 값이기 때문에 `!` 키워드를 사용할 필요가 없다.
      <br>
      
      **[ guard let ]**
      ```swift
      // guard let
      var number: Int? = 10

      guard let number = number else { return }
      ```

      - `Bool` 타입의 값으로 `guard`문을 동작시킬 수 있지만, 옵셔널 바인딩 역할도 가능하다.
      - `guard` 문은 항상 `else` 구문이 따라오고, `else` 블록 내부 코드에 자신보다 상위 코드 블록을 종료하는 코드가 반드시 들어가게 된다.
      - 코드 블록 종료 시 `return, break, continue, throw` 등 **“제어문 전환 명령어”**를 사용한다.

    </details>

    <details>
      <summary> 3) guard VS if let 특징 비교 </summary>
      <br>

      **[ guard문의 특징 ]**
      - 반드시 ‘제어문 전환 명령어'를 넣어주어야 한다.
      - 요구사항 조건 코드를 if let 보다 훨씬 간결하고 읽기 좋게 구성이 가능하다.
      - 예외 사항만 처리하고 싶을 때 좋다. ← [예외처리의 예시](https://dev200ok.blogspot.com/2020/03/swift-guard-let-if-let_24.html)
      - 함수 전체에서 optional로 추출된 상수나 함수를 사용할 수 있다.
      <br>
      
      **[ guard문 사용시 주의 사항 ]**
      - 제어문 전환 명령어를 쓸 수 없는 상황이라면 사용이 불가능하다.
      - 함수, 메서드, 반복문 등 특정 블록 내부에 위치하지 않는다면 사용이 제한된다.
      <br>
      
      **[ if let의 특징 ]**
      - 성공과 실패 2가지로 나누어서 원하는 작업이 가능하다.
      - 지역 변수로만 사용이 가능하다.
      - else문을 생략할 수 있다.
      - 옵셔널 바인딩된 상수는 그 블록 안에서만 변수 사용이 가능하다.
      <br>
      
      **[[ 언제 사용하면 좋을까? ]](https://www.hackingwithswift.com/quick-start/understanding-swift/when-to-use-guard-let-rather-than-if-let)**
      - guard : 예외 사항만 처리하고자할 때 사용하면 좋다.
      - if let : 조건을 가지고 나누어 처리할 때 사용하면 좋다.

    </details>

    <details>
      <summary> 4) Coalescing Nil Values </summary>
      <br>

      ```swift
      var number: Int? = 10
      print(number ?? 0) // number가 nil일 경우 0을 대신 출력
      ```

      - `Optional Int`타입의 number에 값이 들어있다면 unwrapping하고, `nil`일 경우 default값으로 `??` 뒤에 적힌 값을 반환하는 operator 이다.
    </details>