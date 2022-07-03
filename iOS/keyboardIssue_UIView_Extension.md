## 키보드의 움직임에 따라 버튼을 움직이도록 하는 extension

```swift
/// 키보드가 올라옴에 따라 버튼을 움직이기
extension UIView {
    /// 키보드 위로 올라올 버튼의 높이
    static var buttonUpperKeyboardHeight: CGFloat = 0
    
    /// 기존 버튼의 높이
    public var defaultButtonHeight: CGFloat {
        get {
            return UIButton.buttonUpperKeyboardHeight
        }
        set {
            UIButton.buttonUpperKeyboardHeight = newValue
            onKeyboard()
        }
    }
    
    /// sageArea의 bottom값을 리턴하는 함수
    private var safeAreaBottom: CGFloat {
        if let window = UIApplication.shared.windows.first {
            return window.frame.height - window.safeAreaLayoutGuide.layoutFrame.height - window.safeAreaLayoutGuide.layoutFrame.minY
        }
        
        return 0
    }
    
    /// 키보드가 올라오면 버튼을 위로 올려주는 함수
    public func onKeyboard(scrollView: UIScrollView? = nil, keyboardHeight: CGFloat = 0) {
        guard
            let bottomConstraint = self.findConstraint(layoutAttribute: .bottom),
            let heightConstraint = findHeightConstraint()
        else { return }
        
        var isOnSuperView: Bool = self.superview?.isEqual(bottomConstraint.firstItem) == true
        var currentButtonHeight: CGFloat = self.frame.height
        
        if UIButton.buttonUpperKeyboardHeight > 0 {
            currentButtonHeight = UIButton.buttonUpperKeyboardHeight
        } else {
            currentButtonHeight = self.frame.height
            isOnSuperView = false
        }
        
        UIView.animate(withDuration: 0.21, animations: { [weak self] in
            guard let `self` = self else { return }
            
            if keyboardHeight > 0 {
                bottomConstraint.constant = keyboardHeight - (isOnSuperView ? 0 : self.safeAreaBottom)
                heightConstraint.constant = currentButtonHeight
                
                scrollView?.contentInset.bottom = keyboardHeight + UIButton.buttonUpperKeyboardHeight
                scrollView?.scrollIndicatorInsets.bottom = keyboardHeight  + UIButton.buttonUpperKeyboardHeight
            } else {
                bottomConstraint.constant = 0
                heightConstraint.constant = currentButtonHeight + (isOnSuperView ? self.safeAreaBottom : 0)
                
                scrollView?.contentInset.bottom = 0
                scrollView?.scrollIndicatorInsets.bottom = 0
            }
            
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// 뷰의 제약조건을 찾는 함수
    private func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in (superview?.constraints ?? []) where isMatchItem(constraint: constraint, layoutAttribute: layoutAttribute) {
            return constraint
        }
        
        return nil
    }
    
    /// 주어진 조건과 맞는지 체크하는 함수
    private func isMatchItem(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let isFirstMatch = constraint.firstItem as? UIView == self && constraint.firstAttribute == layoutAttribute
        let isSecondMatch = constraint.secondItem as? UIView == self && constraint.secondAttribute == layoutAttribute
        return isFirstMatch || isSecondMatch
    }
    
    /// 뷰의 height 제약조건을 찾는 함수
    private func findHeightConstraint() -> NSLayoutConstraint? {
        return constraints.last(where: {
            $0.firstItem as? UIView == self && $0.firstAttribute == .height && $0.relation == .equal
        })
    }
}
```
