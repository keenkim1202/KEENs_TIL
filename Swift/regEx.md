# 정규 표현식

> 정규표현식 (Regular Expression)  
: 정규표현식 또는 정규식은 특정한 규칙을 가진 문자열의 집합을 표현하는 데 사용하는 언어이다.

> `Class` [NSRegularExpression](https://developer.apple.com/documentation/foundation/nsregularexpression)
: An immutable representation of a compiled regular expression that you apply to Unicode Strings.  
(유니코드 문자열들에 내가 적용한 컴파일된 정규표현식의 불변 표현이다.)

## Swfit에서의 regEx 특징
- swift의 NSReguularExpression은 ICU (International Components for Unicode) 를 준수하고 있다.
- 특수기호를 사용하고자 할 때 앞에 `\` 를 붙인다.
-   regex에서 `\` 가 사용되는 기호는 `\\` 이렇게 백슬래시를 2개 사용해주어야 한다.
    - ex1 ) `.` 을 정규표현식에 넣고 싶다면 `\.`
    - ex2 ) `\.`을 정규표현식에 넣고 싶다면  `\\.`

## 사용 예시
- 보통 회원가입 혹은 로그인 시에 사용자가 올바른 형식으로 입력값을 주었는지 체크할 때 사용된다.
    - 이메일, 닉네임, 비밀번호 등

## 참고할만한 메서드
- [numberOfMatches(in:options:range:)](https://developer.apple.com/documentation/foundation/nsregularexpression/1414308-numberofmatches)
    - 주어진 범위의 문자열에서 정규표현식과 일치하는 건의 갯수를 세는 메서드도 제공한다.


</br>
</br>
</br>

-----

## 기호 설명
- ^ : 시작
- $ : 끝
- {0,} : 0자 이상
- {0,10} : 0자 이상 10자 이하
- [] : 대괄호 안에 있는 문자중 임의의 문자

</br>

- A-Z : 영어 대문자
- a-z : 영어 소문자
- 0-9 : 숫자
- ~!@#$%^&* : 특수문자 (넣을 것만 골라 작성해도 됨)
- 가-힣 : 한글

</br>

- () : 문자를 묶음 처리
- (.) : 임의의 문자
- \1 : 앞의 부분식 (슬래시가 들어간 기호의 경우 \를 하나 더 붙여 표기해야 함.)

```
ex. (.)\\1{3,} : 앞과 동일한 문자 3개 이상 필요
```
</br>

- *: {0,} 0이상
- +: {1.} 1이상
- ?: {0,1} 0이상 1이하

</br>

## 예제 코드

```
ex. [a-z]+ : 영어 소문자 1개 이상
```

```swift
// 전화번호
// 010 으로 시작하며 가운데 4자리 끝 4자리
let phoneRegEx = "^010-?([0-9]{4})-?([0-9]{4})"

// 이메일
// 영어 대소문자, 숫자, 특수문자(._%+-) 다음에 @ 가 오고,
// 그 다음 영어 대소문자, 숫자, 특수문자(._)가 온 후 . 잉 오고,
// 영어 대문자가 오는 형식으로 구성되어있으며, 최소 2자이다.
let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

// 아이디
// 영어 대소문자, 숫자로 구성되어있으며, 최소 5자 - 최대 13자
let idRegEx = "[A-Za-z0-9]{5,13}"

// 닉네임
// 한글, 영어 대소문자, 숫자로 구성되어있으며, 최소 2자 - 최대 7자
let nickRegEx = "[가-힣A-Za-z0-9]{2,7}"

// 비밀번호
// 영어 대소문자, 숫자, 특수문자(!_@$%^&+=) 필수로 구성되어있으며, 최소 8자 - 최대 20자
let pwRegEx = "[A-Za-z0-9!_@$%^&+=]{8,20}"

// 영어 대소문자, 숫자는 필수로 구성되어있으며, 특수문자는 있어도 없어도 상관 없음, 최소 8자 - 최대 20자
let pwRegEx = "[A-Za-z0-9(@$#!%*?&)?]{8,20}"

// extension을 활용한 메서드
extension String {
    func isPhoneValid() -> Bool {
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", "^010-?([0-9]{4})-?([0-9]{4})")
        return phoneNumberTest.evaluate(with: self)
    }
}
```

- [WWDC22 : Meet Swift RegEx](https://developer.apple.com/wwdc22/110357)
- [공식문서: NSRegularExpression](https://developer.apple.com/documentation/foundation/nsregularexpression)
