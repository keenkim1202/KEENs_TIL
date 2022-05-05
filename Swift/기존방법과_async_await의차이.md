  기존의 비동기작업 시, 비동기처리, 분기처리 등의 클로저가 중첩된 형태로 작성하게 된다.

그렇게 되면...

- 가독성이 떨어지고

    ```swift
    // deeply-nested closures
    func processImageData1(completionBlock: (_ result: Image) -> Void) {
    	loadWebResource("dataprofile.txt") {
    		dataResource in loadWebResource("imagedata.dat") {
    			imageResource in decodeImage(dataResource, imageResource) {
    				imageTmp in dewarpAndCleanupImage(imageTmp) {
    					imageResult in completionBlock(imageResult)
    				}
    			}
    		}
    	 }
    }

    processImageData1 { image in
    	display(image)
    }
    ```

- 콜백은 오류처리를 어렵고 장황하게 만든다.

    ```swift
    // Using a `switch` statement for each callback:
    func processImageData2c(completionBlock: (Result<Image, Error>) -> Void) {
    	loadWebResource("dataprofile.txt") {
    		dataResourceResult in
    			switch dataResourceResult {
    			case .success(let dataResource):
    				loadWebResource("imagedata.dat") { imageResourceResult in
    					switch imageResourceResult {
    					case .success(let imageResource):
    						decodeImage(dataResource, imageResource) { imageTmpResult in
    							switch imageTmpResult {
    							case .success(let imageTmp):
    								dewarpAndCleanupImage(imageTmp) { imageResult in
    									completionBlock(imageResult)
    								}
    							case .failure(let error):
    								completionBlock(.failure(error))
    							}
    						}
    					case .failure(let error):
    						completionBlock(.failure(error))
    					}
    			}
    		case .failure(let error):
    			completionBlock(.failure(error))
    		}
    	}
    }

    processImageData2c { result in
    	switch result {
    		case .success(let image):
    			display(image)
    		case .failure(let error):
    			display("No image today", error)
    	}
    }
    ```


위의 문제를 해결하기 위해 `async-await proposal`은 swift의 `coroutine` 모델을 도입했다.

비동기 함수의 semetics를 정의하였으나 동시성을 제공하지는 않는다.
비동기 함수에서 `await`으로 흐름을 제어함으로써 동기적인 코드가 작성 가능하다.

```
- 비동기 코드가 마치 동기 코드인 것 처럼 작성할 수 있다.
- 클로저를 활용한 코드보다 상대적으로 가독성이 좋다.
```
