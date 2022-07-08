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

## WKScriptMessageHandler, WKUIDelegate

```swift
extension SomeViewController: WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(#function, message.name)
        switch message.name {
        case "outLink":
            
            let body = message.body
            print(body, type(of: body))
            guard let outLinkDict = body as? [String: String] else { return }
            print("dict: \(outLinkDict)")
            
            let baseUrl: String = "http://somebaseurl.com"

            guard
                let path = outLinkDict["path"],
                let title = outLinkDict["title"]
            else { return }
            
            let url = baseUrl + path
            let naviTitle = title
            // do something ...
            
        default:
            break
        }
    }
```
- 웹 뷰에서 브릿지로 객체를 보내줬을 때 파싱해서 사용하는 방법

</br>


```swift
extension WebAlarmTalkViewController: WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(#function, message.name)
        switch message.name {
        case "outLink":
            guard let bodyString = message.body as? String,
                  let bodyData = bodyString.data(using: .utf8) else { return }

            guard let outlinkInfo = try? JSONDecoder().decode(Outlink.self, from: bodyData) else { return }
            
            let baseUrl: String = "http://somebaseurl.com"
            
            let url = baseUrl + outlinkInfo.path
            let naviTitle = outlinkInfo.title
            // do something ...
            
        default:
            break
        }
    }
}
```
- 웹 뷰에서 브릿지로 문자열 타입의 JSON 형태를 보내줬을 때 파싱해서 사용하는 방법

</br>

```swift
    /// 웹 상에서 뒤로 갈 수 있다면 이전 화면으로, 가장 첫 진입 화면이라면 메뉴로 pop 하는 함수 (leftBaButtonItem)
    @objc func onNaviBack(_ sender: UIBarButtonItem) {
        if let webView = webView, webView.canGoBack {
            webView.goBack()

            // TIP : 이전 페이지 스택에 남기지 않고 뒤로가기 시, 최초 진입 페이지를 보여주고 싶을 때 주석 사용
            // let firstNavigationItem = webView.backForwardList.backList.first!
            // webView.go(to: firstNavigationItem)
            // load(url: firstNavigationItem.url)
            naviTitle = "이것은 타이틀"
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
```
- 웹뷰 내에서 쌓인 페이지들의 스택이 비었을 때(즉, 최초 진입 페이지에 도달했을 때 뷰컨을 pop 해주는 방법

</br>

```swift
```

</br>

```swift
```

</br>

```swift
```

</br>

```swift
```

</br>
