# rootViewController 란?

[공식문서](https://developer.apple.com/documentation/uikit/uiwindow/1621581-rootviewcontroller)

</br>

> `Instance Proeprty`   
> The root view controller for the window.


```
윈도우를 위한 root view controller 이다. (이름 그대로임)
```

- `rootViewController`는 윈도우의 `content view`를 제공한다.
- `viewController`를 이 프로퍼티에 할당함으로써, `viewController`의 `view`를 윈도우의 `content view`로 설정한다.

## window 란?
> `Class`  
> The backdrop for your app's user interface and the object that despatches events to your views.

```
UIWindow는 나의 뷰에서 일어나는 이벤트를 처리하고 UI와 객체의 뒷바탕을 제공한다.
```

쉽게 말하면, 뷰에서 발생한 이벤트들을 분기(이벤트가 일어나야할 객체로 전달)하고 앱의 컨텐츠를 보여주는 메인 window를 제공합니다. 

- window는 눈에는 보이지 않지만, 앱의 view를 그리는데 매우 중요한 역할을 한다.
- 화면에 표시되는 모든 view들은 window로 묶여 있고, 각각의 window는 다른 view들과 독립적이다.
- 앱에서 이벤트를 받으면 처음에는 해당 view객체로 전달되고, 이벤트가 해당 view로 전달된다.
- window는 vc를 이용해 방향 변경을 구현한다.


## 스토리보드 사용 시
- 스토리 보드를 사용하면 window객체가 자동 생성되기 때문에 직접 구현할 일은 없다.

```swift
// SceneDelegate.swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let _ = (scene as? UIWindowScene) else { return }
  }
  
  ...
  
}
```

→ sceneDelegate파일을 살펴보면 UIWIndow를 상속받은 window가 있는 것을 볼 수 있다.

