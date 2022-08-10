# 문자열(String) 타입에 대하여

## 문자열이란
-  문자(Character) 값들의 컬렉션이다.
-  Unicode-compliant 하고 빠르다.
-  `+` 연산자를 통해 두 문자열을 결합할 수 있다.
-  Foundation의 `NSStirng` 클래스와 연결된 타입이기에 Foundation을 import 하면 사용이 가능하다.
 
 ```
 * 리터럴이란?
 : 소스코드의 고정된 값을 의미하는 용어이다. 데이터(값) 자체를 뜻한다.
 ```

- string literal은 쌍따옴표(double quotation)으로 둘러 쌓인 `Character`들의 `sequence` 이다.
 
</br>
 
## 문자열은 값타입이다. (구조체나 열거형과 마찬가지로)
- 새로운 문자열을 만들면 해당 문자열 값은 함수나 메서드에 전달될 때 복사되어 전달된다.
- 값이 복사되어 전달되기 때문에 해당 문자열이 어디에 전달되거나 원본값을 직접적으로 변경하지 않는 이상 본래의 값을 유지할 수 있다.
- 각각의 Character에 for - in 문을 사용하여 접근할 수 있다.
 
- 스위프트의 Character 타입은 하나의 `Extended Grapheme Cluster`를 나타낸다.
- `Extended Grapheme Cluster`는 하나 혹은 다수의 `Unicode scalar`들의 `sequence`가 결합되어 사람이 읽을 수 있는 형태의 하나의 `Character` 로 제공한다.

```
* Grapheme Cluster
: 화면에 보이는 문자의 단위.

* Extended Grapheme Cluster
: 사람이 읽을 수 있는 하나의 글자 단위. 언어마다 하나의 글자가 여러 개의 unicode scalar를 가질 수 있고, 각 글자마자 메모리에 적재되는 크기가 다를 수 있다.
```

</br>

## 문자열은 왜 index값을 통해 바로 접근이 불가능할까?

```swift
// ex)
let someString: String = "hello"
someString[2] // error
```

- C, C++ 과 같은 언어의 경우, 문자열 타입은 정수의 index값을 통해 문자에 접근이 가능하며, 각각의 index마다 동일한 크기의 데이터 값을 가지고 있다.
- 반면 Swift의 `String`은 유니코드 표준을 준수하고 있다.
- `Character` 타입의 데이터는 위에서 언급한대로 `extended grapheme clusters` 로 표현되어있다.

</br>

### 공식문서의 예시를 참고하면

```swift
/* 예시 1 */
let eAcute: Character = "\u{E9}"                         // é
let combinedEAcute: Character = "\u{65}\u{301}"          // e followed by
// eAcute is é, combinedEAcute is é
```
- combinedEAcute는 두개의 Unicode Scalar "\u{65}\u{301}" 가 Unicode-aware text-rendering system 에 의해 e에  ́를 더하여 é 라는 하나의 Character가 된다.

```swift
/* 예시 2 */
let precomposed: Character = "\u{D55C}"                  // 한
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"   // ᄒ, ᅡ, ᆫ
// precomposed is 한, decomposed is 한
```
<img width="358" src="https://user-images.githubusercontent.com/59866819/183962838-a65d033f-bb6e-41ca-a84b-6b93e0f30fc6.png">

- 한글도 마찬가지다.
- 유니코드 상으로 '한'을 나타내는 "\u{D55C}" 와 ㅎ, ㅏ, ㄴ 을 합친  "\u{1112}\u{1161}\u{11AB}" 는 모두 "한"이라는 하나의 Character를 나타낸다.
```
"한글최고" 라는 문자열에서 "한" 이라는 Character에 대해 인덱스로 접근하고자 한다면 Swift 입장에서는 굉장히 모호할 것이다.
```

- 위의 예시1, 예시2와 같이 사람이 읽을 수 있는 하나의 글자를 표현하는데 여러개의 `unicode scalar` 값이 필요로 한다.
- 하지만 `unicode scalar`외 갯수와 상관 없이 하나의 `Character`를 나타낸다.

위의 이유로 `someeString[2]` 와 같은 식으로 접근을 하려고 한다면, Swift는 정확히 어떤 `Character`를 원하고 어떻게 접근해야하는지 모른다.
(정수의 index값을 통해 메모리를 배열처럼 보고 index 번째를 찾는 것이기 때문이다.)

</br>

## 만약 index를 통해 Character에 접근하고자 한다면?
```swift
// ex) someString의 4번째 Character 'o' 에 접근하고자 할 때

let someString: String = "hello, world!"
let index: String.Index = someString.index(someString.startIndex, offsetBy: 4)
someString[index] // 'o'
```
- Swift에서는 index를 정수(Int) 타입으로 받지 않고, `String.Index` 타입으로 받는다.
- 관련 프로퍼티/메서드들을 간단히 소개하면 아래와 같다.
  - `startIndex` : the index of the first character. (처음 문자의 인덱스)
  - `endIndex` : the index 'after' the last character. (마지막 문자 다음 인덱스)
  - `index(after: String.Index)` : index of the character directly 'after' the given index. (주어진 인덱스 바로 전 문자)
  - `index(after: String.Index)` : index of the character directly 'before' the given index. (주어진 인덱스 바로 다음 문자)
  - `index(String.Index, offsetBy: String.IndexDistance)` 
    - offsetBy value can be positive or negative and starts from the given index. (offsetBy 인자는 양수, 음수 둘다 가능하며 주어진 인덱스로부터 시작하여 얼마나 떨어진 곳의 문자인지를 나타낸다.)

```swift
let someString: String = "hello, world!"
let index: String.Index = someString.index(someString.startIndex, offsetBy: 4)
someString[index]        // 'o'

someString.startIndex // 문자열의 처음 문자의 index
someString.endIndex // 문자열의 마지막 문자의 index가 아닌 문자열의 끝을 가리키기에 그대로 사용 시 fatal error 발생 (Fatal error: String index is out of bounds)
someString.index(before: someString.endIndex) // 문자열의 마지막에 접근하고 싶을 때는 아래와 같이 접근 (혹은 offsetBy를 음수로 지정)

someString[someString.index(before: someString.endIndex)]
someString.index(someString.startIndex, offsetBy: n) // 문자열의 n번째 문자

```
</br>

## 정리
```
* String.Index 란?
: 문자열 안의 문자 혹은 코드 유닛의 위치.
Swift 에서 문자열의 index를 표현하기 위해 사용되는 특수한 타입이다.
```

### String을 Int타입의 index로 접근할 수 없는 이유, 대신 String.Index 타입이 필요한 이유는
- 정수(Int)값을 통해 `String`의 `Charater`에 접근하면 편하겠지만,
- 위에서 언급했듯, Swift의 Charater 타입은 `Extended Grapheme Cluster` 로 표현되어있다.
- Swift는 한 글자가 여러 개의 Unicode Scalar값을 가질 수 있기 때문에, 각각의 Character는 메모리를 점유하는 크기가 다르다. 
- 그 말은 특정 Charater의 index를 계산하기 모호하다는 뜻이다.
- 때문에 C, C++ 과 같이 각각의 Character들이 같은 크기의 메모리를 점유하는 것과 달리 index값을 통해 String의 index번째 Character에 접근할 수 없다.
- 따라서 애플이 만든 특수한 타입 `String.Index`를 통해 String의 Character에 접근하거나 `for - in` 문을 통해 접근할 수 있다.
