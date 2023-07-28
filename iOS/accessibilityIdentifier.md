# Accessibility Identifier 설정방법

> TIP: Xcode 의 `accessibility inspector`를 사용하면 원하는 요소에 `accessibility identifier`가 정상적으로 부여/인식 되는지 확인할 수 있다.

- 복잡한 뷰에 대해 `accessibility identifier`를 부여하고자 할때, 그냥 부여하면 정상적으로 인식이 되지 않는 경우가 있다.
- `@ViewBuilder를` 사용하여 복잡한 뷰에 대해 `accessibility identifier`를 부여할 수 있다.
- 처음에는 `View`에 바로 `extension을` 작성하였으나, `accessibility inspector`를 통해 확인해보았을 때 정상인식되지 않아 `ViewModifier`를 만들어 주는 방식을 사용했다.

```swift
import SwiftUI

struct AccessibilityIdentifierModifier: ViewModifier {
    let accessibilityIdentifier: String?

    @ViewBuilder
    func body(content: Content) -> some View {
        if let identifier = accessibilityIdentifier {
            content.accessibility(identifier: identifier)
        } else {
            content
        }
    }
}

extension View {
    func setAccessibilityIdentifier(_ accessibilityIdentifier: String?) -> some View {
        return self.modifier(AccessibilityIdentifierModifier(accessibilityIdentifier: accessibilityIdentifier))
    }
}

```
