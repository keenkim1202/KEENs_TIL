# PresentedViewController
> `Instance Property` presentedViewController
> The view controller that is presented by this view controller, or one of its ancestors in the view controller hierarchy.

```swift
var presentedViewController: UIViewController? { get }
```

- 지금 ViewController가 띄우고 있는 VieController
- `present(_: animated: completion:)` 메서드를 통해 vc를 모달형식으로 보여주고자 할 때, 
- 이 메서드를 부른 vc가 보여주고 있는 vc에 대해 이 프로퍼티를 가지고 있다. (즉, 현재 vc가 띄울 vc)
- 만약 현재 vc가 다른 vc를 모달형식으로 띄워주고 있지 않다면 이 프로퍼티는 `nil` 이다.

# PresentingViewController
> `Instance Property` presentingViewController
> The view controller that presented this view controller.

```swift
var presentingViewController: UIViewController? { get }
```

- 지금 ViewController를 띄우는 VieController
- `present(_: animated: completion:)` 메서드를 통해 vc를 모달형식으로 보여주고자 할 때, 
- 이 메서드에 의해 불려진 vc에 대해 이 프로퍼티를 가지고 있다. (즉, 현재 vc를 띄운 vc)
- 만약 현재 vc를 띄운 부모들(ancestors) 중 그 누구도 모달형식으로 띄워지지 않았다면 이 프로퍼티는 `nil` 이다.

# parent
> `Instance Property` parent
> The parent view controlelr of the recipient.

- 만약 수용자의 `container view controller`의 자식(child)이라면, 이 프로퍼티는 자신이 포함되어 있는 `view controller`를 들고 있다.
- 만약 수용자가 부모가 없다면, 이 프로퍼티는 `nil` 이다.
- (여기서 수용자(recipient)는 이 프로퍼티를 부르고 있는 뷰컨을 말하는 것 같다.)

- `iOS 5.0` 이후로, 만약 부모 vc이 없거나 다른 뷰에 의해 띄워진 뷰의 경우, `presenting view controller` 가 리턴된다.
- 따라서, `iOS 5.0` 이후 부터는 parent를 쓸 필요없이 `presentingViewController` 프로퍼티를 사용하면 된다.
