# What's new in SwiftUI - WWDC26

- 영상 링크: https://developer.apple.com/videos/play/wwdc2026/269
- 내용: SwiftUI 최신 추가 기능 소개
- iOS 27 UI 대응의 기본값. SwiftUI 앱 개발시 체크하는게 좋음.

# 주요 키워드
- Document 프로토콜
- 디스크 직접 접근
- snapshot 기반 diffing
- 리스트, 그리드, 섹션 재정렬 API
- toolbar visibility priority
- 자동 축소 toolbar
- presentation API 확장
- AsyncImage 캐싱
- Observable lazy state 추기화
# Document-based apps
## Document creation context
- DocumentCreationSource API
	- NewDocumentButton - SwiftUI 가 context 파라미터를 통해 document 생성 클로저로 source 를 전달
	- source가 "photo"면 document가 photo picker를 띄움. 
	- 클릭 한번으로 손쉽게 가능해짐

## Disk read & writing performance improvements
- 문서 기반 앱은 많은 데이터를 읽고 씀. 자주 업데이트해야하는 복잡한 UI가 있을 수도 있음 -> 이런 부분을 최적화하는 방법 제공
- 앱의 body에 첫번째 Scene으로 DocumentGroup 을 선언하여 dㅐㅂ의 document architecture 에 맞게 설정
- StickerDocument 
	- Observable을 채택
	- WritableDocument 프로토콜 채택
		- 앱이 쓸 수 있는 형식 목록
		- 쓰기용 현재 문서 콘텐츠를 반환하는 snapshot
			- 특정 시점의 문서 스냅샷으로 역할을 함
		- writer 제공
			- DocumentWriter 프로토콜 준수함.
			- 지정된 형식으로 문서를 디스크에 쓰는 법 알고 있음
- WritableDocument
	- 지원되는 콘텐츠 유형 목록을 필요로 함 - writableContentTytpes
	- snapshot 제공
	- DocumentWriter 프로토콜
		- write(snapshot:to:previous:progress:)
- ReadableDocument
	- 지원되는 콘텐츠 유형 목록을 필요로 함 - readableContentTytpes
	- snapshot을 apply하는 방법을 알고 있음
	- DocumentReader 프로토콜
		- read(snapshot:from:progress:)
		- 디스크 관련 무거운 작업 모두 처리함
## First-class support for direct document URL access
- PNG, Core Graphics 처럼 앱을 가지고 있지 않은 외부에 보낼 수 있도록, 다른 포멧으로 보내는 것을 가능하게 함 
- writableContentType 에 외부로 보낼 형식을 추가하고 write 함수에서 content.draw() 

# AsyncImage
- 인터넷에서 이미지 에셋을 로드하는 훌륭한 방법
- AS-IS
	- 지금까지 이미지를 메모리에 로드하지 않고, 다시 위로 스크롤하면 재로드 함
- TO-BE
	- 표준 HTTP 캐싱을 지원하여 이미지가 기본적으로 캐시 됨
	- 서버의 캐시 헤더를 따르며 코드 변경 없이 작동함
	- 모든 앱에서 자동으로 활성화 됨
	- Xcode 27 로 만든 앱은 새로운 API를 활용하여 다운로드 방식을 커스텀할 수 있음
		- cachePolicy, asyncImageURLSession() 활용

```
			  @Observable class StickerStore {
				  Static let imageSession: URLSession = {
					  let config = URLSessionConfiguration.default
					  config.urlCache = URLCache(
						memoryCapaciyy: 64 * 1024 * 1024,
						disCapacity: 256 * 1024 * 1024)
					return URLSession(configuration: config)
				  }()
			  }
			  
			  ForEach(pets) { pet in
				  AsyncImage(request: URLRequest(
					  url: pet.imageURL,
					  cachePolicy: .returnCacheDataElseLoad)) // here
			  }
			  .asyncImageURLSession(StickerStore.imageSession) // here
```

# Observable class

```
@Observable class StickerStore {}

struct StickerStoreView: View {
	@State private var store = StickerStore()
	
	init() {}
	
	var body: some View {}
}
```

- StickerStoreView 가 초기화될 때 StickerStore 클래스 새 인스턴스가 생성되고 State 변수에 할당
- 이 인스턴스는 뷰의 수명동안 유지됨
- 그런데 부모뷰가 업데이트 되면서 StickerStoreView 가 다시 초기화되면?
- AS-IS
	- 초기화할 때마다 StickerStore 의 새 인스턴스가 만들어짐.
	- 하지만 원래 인스턴스가 여전히 State변수에 저장되어 있음.
	- 그래서 새로 만들어진거 버려짐.
	- 뷰가 초기화될 때마다 생성하고 버리기를 반복함. (클래스의 주 저장 인스턴스가 유지되고 있음에도)
- TO-BE
	- State 프로퍼티를 사용하여 초기화되고 저장되는 클래스가 lazy가 됨
	- 한번만 초기화된다는 의미
	- @State 가 Dynamic property -> Macro 로 바뀌면서 가능해진 현상
	- Observable이 처음 도입된 시점까지 back port 됨
	- 
- state 가 macro 가 되면서 코드 업데이트가 필요한 부분이 있을 수 있음
	- State에 기본값을 지정한 경우, init 에서 기본값을 대입하려 하면 error 발생
		- 해결: 불필요한 기본값 할당을 제거
	- 더 자세한 내용은 문서를 확인할 것

# complex, deeply nested view error
- "The compiler is unable to type-check this expression in reasonable time"에러 발생 이유?
- 예를 들어 Section, Group, ForEach가 중첩된 구조라고 생각하면 각각의 타입을 추론하기 위해 컴파일러는 후보군을 모두 넣어보면서 체크함. 중첩의 중첩의 중첩되 구조의 타입을 체크하다보면 content 도달하기 까지 체크해야하는 타입이 매우 많음.
	- Section -> View, TableRowContent 둘 중 하나로 초기화될 수 있음
	- Section 이 Group을 가지고 있어서 컴파일러는 Section이 생성하는 콘텐츠 유형을 알 수 없음. 중첩된 Group의 콘텐츠 유형 파악이 필요함.
	- Group -> View, TableRowContent, Scene, ToolbarContent, Commands, ... 옵션 더 많음
	- ForEarch 내부에서도 마찬가지.
	- 이 중첩된 경우의 수를 모두 시도하면 타입 검사 비용이 점점 커짐.
	- 그런데 이 결정 트리에서 실제로 유효한 경로를 하나뿐임.
- 이렇게 복잡한 선택 대신 빌더들이 생성 유형에 제약 받지 않고 컨텐츠를 조합하기만 한다면?
- 가장 일반적인 빌더 집합이 이제 단일 initializer를 공유하며 단 하나의 명확한 경로만 남김
	- 여러 다른 빌더 유형이 @ContentBuilder 하나로 통합되었기 때문에 가능한 일
- @ContentBuilder 
	-  모든 최소 배포 타켓에서 사용 가능
		- 내부적으로는 기존 ViewBuilder의 진화이기 떄문
	- Xcode 27 에서 타입 체킹 성능을 크게 향상시킴

# Agent Coding
- Xcode 27의 Coding Assistant에서 접근 가능한 새로운 스킬
	- SwiftUI Specialist Skill
		- SwiftUI 모범 사례를 따르는데 도움을 줌
	- What's New In SwiftUI Skill
		- 새로운 API 도입 안내
- "xcrun agent skills export" 로 다른 agent로 내보내서 사용 가능
	- 워크플로에 가져올 수 있는 마크다운 파일 생성됨

