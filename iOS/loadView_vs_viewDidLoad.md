# loadView() 와 viewDidLoad() 의 차이
  > loadView()

  뷰 컨트롤러가 자신의 메인 뷰 (`self.view`)를 로드할 때 호출되는 메서드이다.

  즉, 그 메인 뷰를 생성하려고 호출하는 메서드 인것. 그래서 이 메서드 안에서 새로운 뷰를 만들어서 반환해줘도 된다.
  ```
  스토리보드를 사용하는 경우, 스토리보드에 있는 뷰를 가져와 사용할 테니 굳이 사용할 필요가 없다.)
  ```
  
  </br>

  > viewDidLoad()

  위의 뷰가 모두 생성되고 메모리에 올라간 후 호출되는 메서드 이다.

  즉 뷰컨트롤러의 메인 뷰가 생성된 이후 하고 싶은 작업에 대해서 작성하면 되는 메서드이다.

  ```
  간단하게 말하면,
  loadView()는 뷰가 로드되기 시작할 때 불려지고, viewDidLoad()는 뷰 로드가 완료된 후 불려진다.
  ```

</br>

  > 공식문서

  [loadView()란?](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview)

  [viewDidLoad()란?](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621495-viewdidload)
