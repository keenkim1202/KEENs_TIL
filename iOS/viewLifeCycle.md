# View Life-Cycle

앱은 하나 이상의 뷰로 구성되어있으며, 각각의 뷰는 생명주기를 갖는다.

순환적으로 발생하기 때문에 화면 전환에 따라 로직을 적절한 곳에서 실행시켜야 한다.

총 6가지가 있는데, 이 6가지 전에 가장먼저 실행되는

- `loadView` : 뷰를 만들고메모리에 올린다. 이후 viewDidLoad가 호출된다.
- `viewDidLoad` : VC가 메모리에 로드된 후 호출된다. 딱 1번만 실행되기에 리소스 초기화 작업을 주로 한다.
- `viewWillAppear` : 뷰가 생성되기 직전에 실행된다. 뷰가 나타나기 전에 실행해야하는 작업을 한다.
- `viewDidAppear` : 뷰가 생성된 후 실행한다. 데이터를 받아 보여주거나 애니메이션 작업 등을 할 수 있다. (viewWillAppear에 넣어줬다가 반영안되는 경우도 있음)
- `viewWillDisappear` : 뷰가 사라지기 직전에 실행
- `viewDidDisappaear` : 뷰가 사라진 후 실행
- `viewDidUnload` : 메모리에서 해제될 때 실행


## 참고

[View 레이아웃 그리는 주기](https://github.com/keenkim1202/KEENs_TIL/blob/main/iOS/view_draw_layout_cycle.md)
