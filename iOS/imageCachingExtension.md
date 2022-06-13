## Image 를 캐싱하는 Extension 코드

- 이미지를 캐싱할 때 Kingfisher 라이브러리를 사용하는 방법이 가장 간단하지만, 
- 라이브러리에 대한 의존도를 낮추고 스위프트 기본 제공 라이브러리를 사용해서 캐싱을 구현하고자 한다면 
- 아래와 같은 `URLSession`과 `NSCache`를 활용하여 구현한 `Extension`을 작성하여 사용하면 용이하다.

> ImageLoader.swift

```swift
import UIKit

enum ImageLoaderError: Error {
    case unknown
    case invalidURL
}

struct ImageLoader {
    let url: String

    func load(completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        if let url = URL(string: self.url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard (response as? HTTPURLResponse)?.statusCode == 200,
                      error == nil,
                      let data = data,
                      let image = UIImage(data: data) else {
                    completion(.failure(.unknown))
                    return
                }

                completion(.success(image))
            }.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }
}

```

> UIImageView++Extension.swift

```swift
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadThumbnail(urlSting: String?) {
        guard let urlSting = urlSting else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        ImageLoader(url: urlSting).load() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                imageCache.setObject(image, forKey: urlSting as AnyObject)
                DispatchQueue.main.async {
                    self.image = image
                }
                
            case .failure(_):
                self.image = UIImage(named: "indicator")
            }
        }
    }
}
```
