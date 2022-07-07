# @unknown default

- swift 5에서 소개된 개념이다.
- enum 에서 사용된다.


- switch문을 통해 알려진 경우들을 커버하지만 CLAuthorizationStatus와 같이 미래에 추가될 수도 있는 알려지지 않은 값들을 가질 수도 있다.
- 그런 경우를 대비할 수 있는 코드이다.

## 미리 준비해야하는 이유?
- API 확장 프로세스 때문
- 새로운 케이스를 추가해야 하는 경우에 대비되지 않은 코드로 인해 문제가 생기는 것 = `a source breaking change`

## enum에는 2가지가 있다
frozen enum
- 더 이상 변화가 일어나지 않은 고정된 enum
non forzen enum
- 추후에 변화가 일어날 수 있는 enum

```
후자의 경우는 @unknown 키워드가 필요하다.
```

## 그냥 default와의 차이점
- default와 일반적으로는 동일하게 작용한다.
- 큰 차이점: 알려진 모든 요소들이 match되지 않는 경우 아래와 같이 컴파일러가 경고할 것
```
⚠️ Switch must be exhaustive
```
