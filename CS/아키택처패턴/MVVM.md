# MVVM 패턴
mvvm은 `view`를 `비즈니스로직`이나 `model`로 부터 분리시켜 `view`가 어느 특정 모델에 종속되지 않도록 해주는 패턴이다.


<img src="https://user-images.githubusercontent.com/59866819/159967196-8dbe2b8e-9603-4802-ba2d-db92259e76d3.png">

: Model + View + ViewModel

## 구성요소
- Model
    - 데이터, 네트워크 로직, 비즈니스 로직 등을 담고, 데이터를 캡슐화하는 역할
    - `view`, `viewModel` 은 신경쓰지 않는다. 
    - 데이터를 어떻게 가지고 있을지에 대해서만 신경쓰고, 어떻게 보여질지는 신경쓰지 않는다.
    -   MVC 와 유사.
- View
    - 사용자가 화면에서 보이는 것들에 대한 구조, 배치 등을 다룬다.
    - `model` 을 직접 알고 있으면 안 된다.
    - `viewModel` 로부터 가져온 데이터로 표현한다.
    - 사용자로부터 이벤트를 수신하고, 그에 대한 처리를 `viewModel`에 넘긴다.
- ViewModel
    - `view`로 부터 전달받은 요청을 처리할 로직을 담고 있다.
    - `model` 에 변화가 생기면 `view`에 notification을 보낸다. (데이터변화를 `view`가 알 수 있게)
    - `view`와 `model` 사이의 중계자 역할. presentation logic을 처리한다.
    - MVC의 `controller`와 유사.
- ViewController
    - `View Life-Cycle`을 처리하고, 데이터를 UI 구성요소에 `bind`할 때만 `viewModel`, `view`와 통신한다.
## MVC와 차이점
> 구성요소간의 의존성
- MVC  
    - 기본적으로 `view`와 `model`은 다른 구성요소들을 알지 못하며, `controller`는 `view`와 `model`을 모두 알고있는 형태로 구현되어야 한다.

- MVVM
    - `view`는 `viewModel`을 알고 있고, 소유한다.
    - `viewModel`은 `model`만 알고 있도록 구현한다.
    - `model`은 다른 구성요소를 알지 못하도록 마들어야 한다. (= MVC와 같음)

> view가 데이터를 보여주는 방식
- MVC
    - `model`에 `view`를 Observer로 둥록하여 데이터를 설정하는 방식 (`model`이 `view`를 알고 있는 형태)
    - `viewController`가 `model`의 변경을 알아차리고 직접 `view`에 데이터를 설정해주는 방식(aapple의 MVC)
- MVVM
    - `view`와 `viewModel`의 `binding`을 통해 스스로 데이터를 보여준다.
    - `view`에 데이터를 보여주기 위한 설정 책임을 `view` 스스로가 가진다)

> user interaction
- MVC
    - 사용자 상호작용에 대해 `view`가 `controller`에 처리를 부탁하기 위해 `delegate pattern, target-action` 등을 사용
- MVVM
    - `view`와 `viewModel`을 알고 있으므로 필요할 때 `viewModel`의 메서드를 호출하는 방식으로 구현 가능 (필수는 아님)


## Apple의 MVC 
- `ViewController` 가 `view`에 대한 설정뿐만 아니라 `View Life-Cycle` 관리 등등 `view`와 밀접한 관계이다.
- MVVM에서의 `viewModel`은 `view`를 알지 못하며 `view``를 설정하는 코드가 전혀 안들어간다.  
(데이터 변경에 대한 `view` 업데이트는 온전히 `view`의 책임인 것)
- `UIKit - MVC` : event driven
    - 이벤트에 따라 특정 로직이 실행되고, 그에 따라 view가 바뀐다.
- `SwiftUI - MVVM` : data driven
    - 데이터의 변경에 따라 로직이 실행도고, 그에 따라 view가 바뀐다.

## MVVM 장점
- Distribution (책임 분배)
    - `view`는 바인딩을 통해 `viewModel`로 부터 보여줄 데이터를 가져온 뒤 직접 업데이트한다.
    - MVC에 비해 `controller`의 역할이 줄어든 것
- Testability (테스트 용이성)
    - `viewModel`은 `view`에 대해 모른다.
    - 그렇기에 `viewModel`을 쉽게 테스트할 수 있도록 해준다.
- easy og use (사용 편리성)
    - `view`를 수동으로 업데이트하는 MVP보다 바인딩을 사용하는 경우 MVVM이 훨씬 간단하다.   
    (100% 언제나 그렇지는 않음. 간단한 프로젝트를 하는 경우는 굳이 MVVM을 사용하면 더 복잡해보일 수 있다.)

## MVVM 한계
- 간단한 프로젝트에 사용하기에는 과하다.
- 바인딩에 관한 툴이 없으면 boilerplate 코드 가 발생할 수 있다.
- 큰 프로그램의 경우, 데이터 바인딩을 많이 쓰면 메모리를 많이 쓰게 된다.
- `presentaion logic`이 늘어나고 SRP가 지켜지지 않으면 `viewModel`도 비대해질 수 있다.
- 정해진 답이 없이 사람마다 구현 방식이 다르다.   
(본인만의 스타일을 만들거나 혹은 회사 스타일에 맞춰면 됨)



<details>
<summary> 참고 링크 </summary>
 
- [iOS에서의 MVC와 MVVM](https://velog.io/@nnnyeong/iOS-MVC-MVVM-Architecture-Pattern)
- [iOS에서의 MVVM](https://velog.io/@ictechgy/MVVM-%EB%94%94%EC%9E%90%EC%9D%B8-%ED%8C%A8%ED%84%B4)

</details>
