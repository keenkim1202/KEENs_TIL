# present/dismiss 를 push/pop 처럼을 좀 더 스무스 하게 하고 싶을 때

아래와 같이 `UIViewControllerAnimatedTransitioning`를 상속 받는 두개의 클래스를 생성하여 사용한다.

## PresentTransition
```swift
import UIKit

class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var animator: UIViewImplicitlyAnimating?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if self.animator != nil {
            return self.animator!
        }
        
        let container = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)!
        let fromViewInitFrame = transitionContext.initialFrame(for: fromVC)
        var fromViewFinalFrame = fromViewInitFrame
        fromViewFinalFrame.origin.x = -fromViewFinalFrame.width
        
        let fromView = fromVC.view!
        let toView = transitionContext.view(forKey: .to)!
        
        var toViewInitialFrame = fromViewInitFrame
        toViewInitialFrame.origin.x = toView.frame.size.width
        
        toView.frame = toViewInitialFrame
        container.addSubview(toView)
        
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), curve: .easeInOut) {
            toView.frame = fromViewInitFrame
            fromView.frame = fromViewFinalFrame
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
        
        self.animator = animator
        return animator
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.animator = nil
    }
}
```

## DismissTransition
```swift
import UIKit

class DismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var animator: UIViewImplicitlyAnimating?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if self.animator != nil {
            return self.animator!
        }
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        var fromViewInitFrame = transitionContext.initialFrame(for: fromVC)
        fromViewInitFrame.origin.x = 0
        
        var fromViewFinalFrame = fromViewInitFrame
        fromViewFinalFrame.origin.x = fromViewFinalFrame.width
        
        let fromView = fromVC.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!
        
        var toViewInitialFrame = fromViewInitFrame
        toViewInitialFrame.origin.x = -toView.frame.size.width
        toView.frame = toViewInitialFrame
        
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), curve: .easeInOut) {
            toView.frame = fromViewInitFrame
            fromView.frame = fromViewFinalFrame
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
        
        self.animator = animator
        return animator
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.animator = nil
    }
}
```

## 사용법
## FirstViewController
- present 할 때
```swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onPresent(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondViewController
        secondVC.modalPresentationStyle = .custom
        secondVC.transitioningDelegate = self
        
        self.present(secondVC, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
```

## SecondViewController
- dismiss 할 떄

```swift
import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }    
}

```
