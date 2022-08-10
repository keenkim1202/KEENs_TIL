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
 
## 문자열은 값타입이다. (구조체나 열거형과 마찬가지로)
- 새로운 문자열을 만들면 해당 문자열 값은 함수나 메서드에 전달될 때 복사되어 전달된다.
- 값이 복사되어 전달되기 때문에 해당 문자열이 어디에 전달되거나 원본값을 직접적으로 변경하지 않는 이상 본래의 값을 유지할 수 있다.
- 각각의 Character에 for - in 문을 사용하여 접근할 수 있다.
 
- 스위프트의 Character 타입은 하나의 `extended grapheme cluster`를 나타낸다.
- `extended grapheme cluster`는 하나 혹은 다수의 `Unicode scalar`들의 `sequence`가 결합되어 사람이 읽을 수 있는 형태의 하나의 `Character` 로 제공한다.

```
* Grapheme Cluster
: 화면에 보이는 문자의 단위.

* Extended Grapheme Cluster
: 사람이 읽을 수 있는 하나의 글자 단위. 언어마다 하나의 글자가 여러 개의 unicode scalar를 가질 수 있고, 각 글자마자 메모리에 적재되는 크기가 다를 수 있다.
```


 
## 공식문서의 예시를 참고하면

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
- 한글도 마찬가지다.

## 문자열은 왜 index값을 통해 바로 접근이 불가능할까?

```swift
// ex)
let someString: String = "hello"
someString[2] // error
```

- c, c++ 과 같은 언어의 경우, 문자열 타입은 정수의 index값을 통해 문자에 접근이 가능하며, 각각의 index마다 동일한 크기의 데이터 값을 가지고 있다.
- Swift의 String은 유니코드 표준을 준수하고 있다.
- Character 타입의 데이터는 위에서 언급한대로 `extended grapheme clusters` 로 표현되어있다.
- 위의 예시1, 예시2와 같이 사람이 읽을 수 있는 하나의 글자를 표현하는데 여러개의 unicode scalar 값이 필요로 한다.
- 하지만 unicode scalar외 갯수와 상관 없이 하나의 Character를 나타낸다.

위의 이유로 `someeString[2]` 와 같은 식으로 접근을 하려고 한다면, Swift는 정확히 어떤 `Character`를 원하고 어떻게 접근해야하는지 모른다.
(정수의 index값을 통해 메모리를 배열처럼 보고 index 번째를 찾는 것이기 때문이다.)

```
결론: 
- Swift는 한 글자마자 여러 개의 unicode scalar값을 가질 수 있기 떄문에, 각각의 Character는 메모리를 점유하는 크기가 다르다. 
- 때문에 C, C++ 과 같이 각각의 Character들이 같은 크기의 메모리를 점유하는 것과 달리 index값을 통해 String의 index번째 Character에 접근할 수 없다.
```


