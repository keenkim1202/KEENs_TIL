# Alamofire 에서 response data 와 request url 출력하는 방법

```swift
import Alamofire
let url: Stirng = "" // 요청할 base url 작성
let networkHeader: [String: String] = [:] // 필요로 하는 헤더 작성
let params: [String: String] = [:] // 필요로 하는 파라미터 작성

Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.httpBody, headers: networkHeader).responseObject { (response: DataResponse<SomeObjectType>) in
    // request URL 출력하기
    print("* REQUEST URL: \(String(describing: response.request))")
    
    // reponse data 출력하기
    if
        let data = response.data,
        let utf8Text = String(data: data, encoding: .utf8) {
        print("Reponse Data: \(utf8Text)") // encode data to UTF8
    }
    
    switch response.result {
    case .success:
        guard let message: CampaignDefaultVO = response.result.value else { return }
        // some code ...
        
    case .failure(let err):
        self.showAlert(msg: err.localizedDescription)
    }
}
```
