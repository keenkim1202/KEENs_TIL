# MVC

<img src="https://user-images.githubusercontent.com/59866819/159966596-530bdde7-61aa-4fe5-9cfc-bb3357fe5179.png">

: Model + View + Controller
- `View`와 `Model` 사이에서 `Controller`가 양쪽을 모두 업데이트 한다.
- `View`는 그저 화면에 요소를 나타내기만 한다.
- `Model`은 앱에서 사용되는 데이터를 읽고 쓰는 역할만 한다.
```
예를 들어,  
- 서버에서 받아온 json 데이터를 파싱하고, 원하는 형태로 변형하여 View에 띄우는 과정  
- 사용자와의 interaction을 통해 들어온 정보 혹은 변경된 정보를 model에 반영하는 과정  
등 화면에 보이는 것과 데이터 이외의 것은 모두 ViewController에서 담당하다보니,   

우스겟 소리로 MVC를 Massive View Controller 라고 부르기도 한다.
```
- `controller`가 비대해진 다는 것은 테스트 하기에도 어렵다는 단점이 있다.

## 요소
- `Model` : Business logic, Data를 담당하는 부분
- `View` : 사용자의 입장에서 화면에 보여지는 부분 (presentation)
- `Controller` : `Model`과 `View`의 중간 다리. 
    - `Model`의 변화를 `View`에 갱신
    - `View`의 입력을 받아 `Model`에 반영

</br>


<details>
<summary> 참고 링크 </summary>
 
- [iOS에서의 MVC와 MVVM](https://velog.io/@nnnyeong/iOS-MVC-MVVM-Architecture-Pattern)

</details>
