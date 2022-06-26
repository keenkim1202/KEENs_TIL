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

## 결론
> `loadView 관련 공식 문서` :   
> Your custom implementation of this method should not call super.  
> If you use Interface Builder to create your views and initialize the view controller, you must not override this method.

- loadView()는 
- `viewController`에서 `root view`를 그리는 메서드이고, `viewDidLoad()` 이전에 실행된다.
- 뷰를 직접 초기화 해주어야 한다.
- 코드로 직접 뷰 컨트롤러를 그리는 경우에만 사용해야 한다. (custom view 대입 등)
  ```swift
  override loadView() {
    self.view = customView
  }
  ```
  
## 주의할 점!
- 커스텀뷰를 대입하여 사용할 때는 `super.loadView()`를 쓰면 안된다.
  - IB(Inetface Builder)를 사용하여 구현하는 경우는 super.loadView()를 호출해야 하자만, 커스텀뷰를 사용하는 경우는 IB로 뷰를 생성할 필요가 없기 때문이다.
  - IB로 뷰를 생성한 다음에 다시 내가 만든 커스텀뷰를 대입한다? -> 낭비


## 용도에 따른 사용
- `loadView`는 뷰 컨트롤러의 기본 `view`를 custom view로 사용하고자 할 때 유용하다.
- `loadView`에서는 새로운 view를 생성해서 `return`해주는 것을 코드를 까보면 알 수 있다.
- 반면에 기본 `UIView`를 ciewController의 기본 `view`로 사용하고, 그 위에 무언가 얹어서 쓰거나 뷰가 생성된 이후에 어떤 세팅을 해서 사용하고 싶다면 `viewDidLoad`에서 하면 된다.

  > 공식문서

  [loadView()란?](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview)

  [viewDidLoad()란?](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621495-viewdidload)
  
  > 참고 링크
  
  [loadView에서 super.loadView()를 부르면 안되는 이유](https://stackoverflow.com/questions/9105450/should-super-loadview-be-called-from-loadview-or-not)
