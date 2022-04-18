# SceneDelegate 에 대하여

- iOS13 부터 생겨난 것으로 이전에는 AppDelegate만 존재했다.  
- AppDelgate의 역할을 process 생명주기(시작과 종료)와 UI 생명주기(UI 상태)를 관리할 수 있다.  
→ 이전까지는 앱은 오직 하나의 프로세스와 그에 따른 하나의 UI만 가졌기 떄문이다.  

</br>

- iOS13부터 window의 개념이 scene으로 대체되었는데, 아이패드에서 한 화면에 두개의 창을 띄우듯이 여러개의 scene을 가질 수 잇게되었다.  
- AppDelegate에서 Session 생명주기에 대한 역할이 추가되어 scene session의 생성 삭제를 알리는 메서드가 추가되었고, 앱에서 생성한 모든 scene의 정보를 관리한다.
