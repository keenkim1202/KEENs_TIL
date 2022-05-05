# App Life-Cycle

앱의 실행부터 종료까지의 주기를 말한다.

사용자가 발생시키는 이벤트에 따라 처리되며, 5가지의 상태가 있다.

- `Not Running` : 아무것도 실행하지 않은 상태. or 실행중이지만 시스템에 의해 종료된 상태
- `InActive` : 앱이 forgroud 상태로 돌아가지만, 이벤트를 받지 안는 상태
- `Active` : 일반적으로 앱이 돌아가는 상태. 이벤트를 받는 단계
- `Background` : suspend로 진입하기 전에 거치는 단계. 통화 같이 계속 앱이 실행되는 경우에는 backgorund에서 동작하고, 보통의 앱은 background를 스처 suspend 된다.
- `Suspended` : 앱이 background 상태이며, 아무코도 실행하지 않는상태. 시스템이 임의로 backgorund에서 susepnd로 만들고 리소스가 해제된다.

```
background에서 inactive로 가게하면 앱의 데이터가저장되어있으면 해당 화면을 보여준다.
```

# View Life-Cycle

앱은 하나 이상의 뷰로 구성되어있으며, 각각의 뷰는 생명주기를 갖는다.

순환적으로 발생하기 떄문에 화면 전환에 따라 로직을 적절한 곳에서 실행시켜야 한다.

- `loadView` : 뷰를 만들고메모리에 올린다. 이후 viewDidLoad가 호출된다.
- `viewDidLoad` : VC가 메모리에 로드된 후 호출된다. 딱 1번만 실행되기에 리소스 초기화 작업을 주로 한다.
- `viewWillAppear` : 뷰가 생성되기 직전에 실행된다. 뷰가 나타나기 전에 실행해야하는 작업을 한다.
- `viewDidAppear` : 뷰가 생서된 후 실행한다. 데이터를 받아 보여주거나 애니메이션 작업 등을 할 수 있다. (viewWIllAppear에 넣어줬다가 반영안되는 경우도 있음)
- `viewWillDisappear` : 뷰가 사라지기 직전에 실행
- `viewDidDisappaear` : 뷰가 사라진 후 실행
- `viewDidUnload` : 메모리에서 해제될 떄 실행
