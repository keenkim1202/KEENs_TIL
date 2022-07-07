# WebView 관련 메서드

## WKNavigationDelegate
```swift
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) { }
```
- 웹 페이지 탐색 여부를 결정하는 함수 (특정한 액션 정보를 바탕으로 새로운 컨텐츠로 navigate 하는 것에 delegate에게 허락을 구하는 함수)
-  handler는 1번만 호출되어야 하므로 통과할 때 decisionHandler(.allow) 처리.
- (ex. 이외의 특정 조건일 때 .cancel 후 return)

</br>

```swift
func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }
```
- 웹 뷰가 컨텐츠 탐색을 시작할 때 호출되는 함수 (main frame에서 navigation이 시작되었다는 것을 delegate에게 알리는 함수)

</br>

```swift
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { }
```
- 웹 뷰가 콘텐츠 받기를 완료 혹은 실패했을 때 호출되는 함수 (navigation이 완료되었다고 delegate에게 알리는 함수)

</br>

```swift
```

</br>
