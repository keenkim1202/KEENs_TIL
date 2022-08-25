# 뷰에 원하는 방향에만 그림자 넣기

- 뷰를 그리다가 사방이 아니라 일부 방향에만 그림자를 넣어주고 싶었다.
- 그림자를 넣어줄 방향에 대한 `enum`을 하나 만들고, `case`에 따라 `switch`문을 통해 분기처리를 하여 `offset`값을 조정하여 원하는 방향에만 그림자 효과를 주었다.

```swift
import UIKit


extension UIView {
    /// 그림자 방향
    enum ShadowDirection {
        case bottom
        case top
        case left
        case right
    }
    
    /// 사방에 그림자를 넣는 함수
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    /// 원하는 한 방향에만 그림자를 넣는 함수
    func addShadow(direction: ShadowDirection, size: Int, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 0) {
        var offSetValue = CGSize()
        
        switch direction {
        case .bottom:
            offSetValue = CGSize(width: 0, height: size)
        case .top:
            offSetValue = CGSize(width: 0, height: -size)
        case .left:
            offSetValue = CGSize(width: -size, height: 0)
        case .right:
            offSetValue = CGSize(width: size, height: 0)
        }
        
        addShadow(offset: offSetValue, color: color, opacity: opacity, radius: radius)
    }
    
    /// 원하는 방향들에 그림자를 넣는 함수
    func addShadow(directions: [ShadowDirection], size: Int, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 0) {
        var offSetValue = CGSize()
        
        for direction in directions {
            switch direction {
            case .bottom:
                offSetValue = CGSize(width: 0, height: size)
            case .top:
                offSetValue = CGSize(width: 0, height: -size)
            case .left:
                offSetValue = CGSize(width: -size, height: 0)
            case .right:
                offSetValue = CGSize(width: size, height: 0)
            }
            
            addShadow(offset: offSetValue, color: color, opacity: opacity, radius: radius)
        }
    }
}
```
