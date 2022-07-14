# PresentedViewController
> `Instance Property` presentedViewController
> The view controller that is presented by this view controller, or one of its ancestors in the view controller hierarchy.

```swift
var presentedViewController: UIViewController? { get }
```

- 지금 ViewController가 띄우고 있는 VieController
- `present(_: animated: completion:)` 메서드를 통해 vc(⬛️)를 모달형식으로 보여주고자 할 때, 
- 이 메서드를 부른 vc(⬛️)가 보여주고 있는 vc(🟩)에 대해 이 프로퍼티를 가지고 있다. (즉, 현재 vc가 띄울 vc)
- 만약 현재 vc(⬛️)가 다른 vc(🟩 이 없는 경우)를 모달형식으로 띄워주고 있지 않다면 이 프로퍼티는 `nil` 이다.

# PresentingViewController
> `Instance Property` presentingViewController
> The view controller that presented this view controller.

```swift
var presentingViewController: UIViewController? { get }
```

- 지금 ViewController를 띄우는 VieController
- `present(_: animated: completion:)` 메서드를 통해 vc(⬛️)를 모달형식으로 보여주고자 할 때, 
- 이 메서드에 의해 불려진 vc(🟧)에 대해 이 프로퍼티를 가지고 있다. (즉, 현재 vc를 띄운 vc)
- 만약 현재 vc(⬛️)를 띄운 부모들(ancestors) 중 그 누구도 모달형식으로 띄워지지 않았다면 이 프로퍼티는 `nil` 이다.

# parent
> `Instance Property` parent
> The parent view controlelr of the recipient.

- 만약 수용자의 `container view controller`의 자식(child)이라면, 이 프로퍼티는 자신이 포함되어 있는 `view controller`를 들고 있다.
- 만약 수용자가 부모가 없다면, 이 프로퍼티는 `nil` 이다.
- (여기서 수용자(recipient)는 이 프로퍼티를 부르고 있는 뷰컨을 말하는 것 같다.)

- `iOS 5.0` 이후로, 만약 부모 vc이 없거나 다른 뷰에 의해 띄워진 뷰의 경우, `presenting view controller` 가 리턴된다.
- 따라서, `iOS 5.0` 이후 부터는 parent를 쓸 필요없이 `presentingViewController` 프로퍼티를 사용하면 된다.

</br>

![presented_presenting 001](https://user-images.githubusercontent.com/59866819/179002674-e0e5c5f5-77a6-4b1b-a223-b8ba3b36e6eb.png)

</br>

# 요약
각각의 사각형을 뷰컨이라고 하자.  
🟧 가 ⬛️ 를 present 하고 있고, ⬛️ 가 🟩 를 present 하고 있다.  

</br>

그때,  
- ⬛️ 를 띄우고 있는 그 하위 뷰컨 : 🟧 (presnetingViewController)
- ⬛️ 가 띄우고 있는 그 상위 뷰컨 : 🟩 (presentedViewController)

</br>

⬛️ 의 parent는 🟧 이다.  
- 그리고 그 parent 는 iOS 5.0 이후 부터 부모가 없거나 다른 뷰에 의해 띄워진 경우 presenting view controlelr 를 리턴해주므로, 
- presentingViewController 프로퍼티를 사용하면 동일한 효과를 낼 수 있다.
