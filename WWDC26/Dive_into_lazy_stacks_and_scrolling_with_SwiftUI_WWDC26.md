# Dive into lazy stacks and scrolling with SwiftUI - WWDC26

- 영상 링크 : https://developer.apple.com/videos/play/wwdc2026/321

# Summary
- 내용: SwiftUI `LazyVStack` / `LazyHStack` 의 내부 동작과, 부드러운 스크롤을 만들기 위한 레이아웃·상태·prefetching·programmatic scrolling 최적화 가이드
- 핵심 메시지
	- lazy stack 은 모든 subview 를 즉시 평가/렌더링하지 않고, visible rect 를 채우는 데 필요한 view 만 로드함
	- off-screen 영역의 크기와 위치는 정확한 값이 아니라 추정값이므로, 절대 content size / content offset 에 의존하면 불안정해질 수 있음
	- `ForEach` 의 각 데이터가 항상 “하나의 안정적인 subview” 로 resolve 되도록 만드는 것이 성능과 스크롤 정확도에 중요함
	- view 가 화면에 나타난 뒤 레이아웃을 크게 바꾸면 prefetching 효과가 사라지고 스크롤 hitch / 위치 보정 문제가 생길 수 있음

# Lazy stack layout
- `LazyVStack` 은 `VStack` 과 달리 전체 view 를 전부 만들지 않음
	- visible rect 를 위에서 아래로 채울 만큼만 subview 를 배치
	- 스크롤되며 새 view 가 필요해지면 추가하고, 화면 밖으로 나간 view 는 lazy stack 에서 제거
- 장점: 긴 목록/커스텀 스크롤 콘텐츠에서 초기 로딩과 메모리 사용을 줄일 수 있음
- 비용: 아직 로드하지 않은 off-screen subview 의 크기를 정확히 알 수 없음
	- 높이는 이미 배치한 view 의 평균 크기와 남은 subview 수로 추정
	- 스크롤하면서 새로운 view 의 실제 크기를 알게 되면 전체 content height 추정값이 바뀔 수 있음
	- orientation change 처럼 기존 view 크기가 달라지는 상황에서도 lazy stack 은 topmost visible view 를 anchor 로 유지하고, 위쪽 공간 추정치를 점진적으로 보정함
- `LazyVStack` 의 ideal width 는 모든 subview 의 최대 width 가 아니라 첫 번째 subview 기준
	- 모든 view 를 로드하지 않기 때문에 전체 최대 너비를 계산할 수 없음

## Nested lazy stacks
- 세로 `LazyVStack` 안에 가로 `ScrollView` + `LazyHStack` 을 넣는 패턴은 유효함
	- nested scroll view 를 실제로 스크롤하지 않는 사용자에게는 내부 콘텐츠를 모두 만들 필요가 없으므로 성능상 이점이 있음
- 단, `LazyHStack` 의 ideal height 도 첫 번째 subview 기준
	- 각 photo 에 설명 텍스트가 있고 줄 수가 다르면 긴 텍스트가 잘릴 수 있음
	- 해결: row/item 높이를 고정하거나, 텍스트 line limit + reserved space 를 명시
- section header 를 고정하려면 `LazyVStack(pinnedViews: [.sectionHeaders])` 와 `Section` 을 사용

## Scroll transition 주의점
- lazy stack 은 “원래 frame 기준으로 화면에 들어오는 view” 를 로드함
- `scrollTransition` 에서 rotation/scale/offset 등으로 view 를 원래 frame 밖으로 밀어내면 문제가 생길 수 있음
	- 실제로는 보여야 하는데 lazy stack 은 off-screen 이라고 판단해 view 가 사라질 수 있음
- 원칙: transition 이 원래 보이지 않아야 할 view 를 visible rect 안으로 끌어오거나, 보여야 할 view 를 원래 frame 밖으로 크게 밀어내지 않도록 설계

# Scroll position 다루기
- lazy stack 의 content offset / content size 는 추정 기반이라 절대값에 의존하면 UI 조건이 흔들릴 수 있음
	- 예: `geo.contentOffset.y <= 100` 으로 “Showcase 로 이동” 버튼 노출 여부를 판단하면, lazy stack 의 추정값 보정에 따라 기준 위치가 바뀔 수 있음
- 더 안정적인 방식: 현재 visible subview 를 기준으로 판단
	- `onScrollTargetVisibilityChange(idType:threshold:)` 로 어떤 item 이 일정 비율 이상 보이는지 확인
	- 버튼 노출 여부를 absolute offset 이 아니라 visible IDs 로 결정

# Subview loading
- lazy stack 이 로드하는 subview 는 코드에서 작성한 view struct 와 1:1 로 항상 대응하지 않음
- 단순한 `ForEach(steps) { StepView(step:) }` 구조에서는 각 `StepView` 가 하나의 resolved subview 로 동작
- 하지만 `StepView.body` 최상위에 `StepDiagram`, `StepInstructions` 처럼 여러 view 를 직접 반환하면
	- lazy stack 은 `StepView` 하나가 아니라 내부의 여러 resolved subview 를 따로 다룰 수 있음
	- `StepView` 자체는 이 subview 들을 만들기 위해 평가됨

## Dynamic number of subviews 피하기
- leaf view 에서 조건문으로 0개 또는 1개의 subview 를 반환하는 패턴은 lazy stack 에 불리함
	- 예: `if step.isVisible(in: detailLevel) { ... }`
- lazy stack 은 visible subview 를 index 로 주소 지정함
	- 어떤 `StepView` 가 0개 view 를 만들 수도 있으면 index 계산이 불안정해짐
	- 환경값이 바뀌었을 때 이전 item 들이 다시 나타날 수 있으므로, off-screen `StepView` 를 예상보다 오래 유지해야 함
	- 결과적으로 off-screen view 의 body evaluation / state 유지가 늘어날 수 있음
- 해결: view level filtering 대신 data level filtering 사용
	- SwiftData 라면 `@Query` 의 `#Predicate` 로 필요한 `Step` 만 가져오기
	- lazy stack 이 view 를 만들어 보지 않아도 subview 수와 index 를 알 수 있게 해야 함
- optional unwrapping 도 같은 문제가 될 수 있음
	- 예: leaf view 안에서 `if let token { ... }`
	- 인증 상태가 없다면 lazy stack 내부에서 item 을 비우기보다 상위 계층에서 `ContentUnavailableView` 등을 보여주는 편이 좋음

# Prefetching
- lazy stack 은 smooth scrolling 을 위해 view 가 화면에 나타나기 전 일부 작업을 미리 수행함
	- body evaluation
	- layout
	- nested lazy stack 의 일부 준비 작업
- 목적: 새 view 를 화면에 올리는 작업을 여러 frame 에 나눠 수행해서 frame deadline 을 넘기지 않게 하는 것
- 중요한 특징
	- `body` 는 prefetch 단계에서 먼저 호출될 수 있음
	- `onAppear` 는 실제 view 가 화면에 배치될 때 호출됨
	- 스크롤 방향이 바뀌면 prefetch 로 body 만 평가되고 `onAppear` 는 호출되지 않을 수도 있음

## onAppear 사용 기준
- `onAppear` 는 infinite scrolling 에 적합함
	- 예: 마지막 `ProgressView` 가 나타날 때 `pager.fetchPage()` 호출
- 하지만 개별 row/view 의 기본 설정을 전부 `onAppear` 에서 하는 것은 좋지 않음
	- view 가 화면에 올라온 뒤 크기와 주요 content 가 바뀌면 prefetch 로 준비한 layout 이 버려짐
	- lazy stack 이 필요한 것보다 더 많은 view 를 로드하거나 스크롤이 흔들릴 수 있음
- 권장: 가능한 한 initializer 에서 view/state/model 을 “화면에 나타나기 전부터 합리적인 상태” 로 준비
	- `StepViewModel(id:)`
	- `DiagramLoader(id:)`
- 네트워크 diagram 로딩처럼 미리 시작해도 되는 작업은 `task` 보다 loader 초기화 시점에 cache 기반 로딩을 시작하면 prefetch 이점을 더 활용할 수 있음

# State management
- lazy stack 은 화면 밖 view 를 즉시 메모리에서 제거하지 않고, 다시 스크롤될 가능성에 대비해 몇 번의 update 동안 유지할 수 있음
- 하지만 결국 삭제되면 해당 view 의 `@State` 도 함께 사라짐
- 따라서 스크롤 후에도 유지되어야 하는 중요한 상태를 leaf view 의 `@State` 에 두면 안 됨
	- 예: `StepView` 내부의 `@State var isHighlighted`
- 해결: model object 나 상위 view state 로 올리고 `@Binding` 으로 전달
	- 예: `ContentView` 가 `@State var highlighted: Set<Step.ID>` 를 소유하고, `StepView` 에 binding 전달

# Programmatic scrolling
- `ScrollPosition` + `.scrollPosition($scrollPosition)` 로 lazy stack 안의 off-screen target 에도 programmatic scroll 가능
	- 예: `scrollPosition.scrollTo(id: "showcase-header")`
- off-screen target 으로 스크롤할 때 lazy stack 은 target 위치를 추정함
	- animated scroll 중에는 매 frame 추정 위치를 업데이트
- 성능을 좋게 하려면
	- `ForEach` 의 각 item 이 항상 하나의 subview 로 resolve 되게 만들기
	- ID 기반 scroll target 을 찾을 때 view 를 직접 construct 하지 않아도 되게 하기
	- item 수를 빠르게 셀 수 있게 data level filtering 사용
- programmatic scrolling 을 방해하는 패턴
	- leaf view 에서 조건문으로 dynamic number of views 생성
	- view 가 appear 된 뒤 `onGeometryChange` 로 측정값을 state 에 저장하고, 그 state 로 다시 layout 을 바꾸는 패턴
- `onGeometryChange` 로 subtitle 높이를 측정한 뒤 diagram height 를 바꾸면
	- lazy stack 이 처음 측정한 높이와 실제 appear 이후 높이가 달라짐
	- 아래 content 를 밀어내고 target scroll position 을 흐트러뜨릴 수 있음
- 해결: 가능한 SwiftUI layout primitive 를 사용하고, 부족하면 `Layout` 프로토콜로 custom layout 작성

# 정리
- lazy stack 은 보이는 영역만 로드하고 나머지는 추정하기 때문에 빠르지만, 절대 좌표/전체 크기/동적 subview 수에 취약함
- `ScrollView` 안에서 `LazyVStack` 을 쓸 때는 “화면에 보이는 view 만 정확하고, 나머지는 추정된다”는 전제를 항상 기억해야 함
- 따라서 lazy stack 을 일반 `VStack` 처럼 전체 content 크기와 모든 child view 를 정확히 알고 있는 container 로 다루면 안 됨
- 좋은 lazy stack 설계 원칙
	- absolute content offset / content size 에 의존하지 않기
	- leaf view 에서 conditional filtering 하지 말고 data source 에서 필터링하기
	- 각 `ForEach` item 이 안정적으로 하나의 subview 를 만들게 하기
	- `onAppear` 전에 필요한 state/model 을 준비해서 prefetching 이 버려지지 않게 하기
	- view 가 화면에 나타난 뒤 layout 크기를 바꾸지 않기
	- 오래 유지되어야 하는 상태는 leaf view 의 `@State` 가 아니라 model / parent state 로 올리기

## 주의할 점
- 절대 scroll offset / content size 에 UI 로직을 강하게 묶지 않기
	- lazy stack 의 offset 과 size 는 스크롤 중 계속 보정될 수 있음
	- 특정 y 좌표 기준으로 버튼 표시, 애니메이션, 로딩 조건 등을 만들면 위치가 흔들릴 수 있음
- row 내부에서 조건문으로 view 를 숨기거나 0개 view 를 반환하지 않기
	- `if isVisible { RowContent() }` 같은 구조는 lazy stack 이 subview 개수와 index 를 예측하기 어렵게 만듦
	- off-screen view 가 예상보다 오래 살아남거나 불필요하게 다시 평가될 수 있음
- `onAppear` 에서 row 의 기본 구조와 크기를 크게 바꾸지 않기
	- lazy stack 이 prefetch 로 미리 계산한 layout 이 무효화됨
	- 스크롤 hitch, 추가 layout pass, programmatic scroll 위치 오차로 이어질 수 있음
- row 가 화면에 나타난 뒤 `onGeometryChange` 결과로 다시 높이를 바꾸는 패턴을 조심하기
	- 처음 측정한 높이와 appear 이후 높이가 달라지면 아래 content 를 밀어내고 scroll position 이 틀어질 수 있음
- 오래 유지되어야 하는 상태를 row 내부 `@State` 에만 두지 않기
	- lazy stack 은 화면 밖 view 를 나중에 제거할 수 있고, 그때 row 의 state 도 함께 사라짐

## 사용해야 할 방식
- row/view 의 크기를 예측 가능하게 만들기
	- 가능하면 `frame(height:)`, `frame(minHeight:)`, `aspectRatio`, `containerRelativeFrame` 등으로 주요 영역의 크기 기준을 명확히 지정
	- 이미지, 다이어그램, 썸네일처럼 크기가 중요한 영역은 데이터 로딩 전후에도 같은 공간을 차지하게 만들기
	- 텍스트는 `lineLimit`, `fixedSize`, reserved space 등을 사용해서 줄 수 변화로 row 높이가 크게 출렁이지 않게 하기
	- 로딩 전에는 `ProgressView` 만 작게 보여주고, 로딩 후 큰 콘텐츠로 교체하는 식의 레이아웃 변화는 피하기
- 동적 높이가 필요하면 “나타난 뒤 측정해서 바꾸기”보다 “처음부터 계산 가능한 규칙”으로 만들기
	- 예: subtitle 높이를 `onGeometryChange` 로 잰 뒤 diagram 높이를 다시 바꾸는 방식은 피하기
	- 화면 폭, 데이터 타입, text line limit 같은 입력값으로 row layout 이 결정되게 만들기
	- 복잡한 계산이 필요하면 `Layout` 프로토콜로 한 번의 layout pass 안에서 배치 규칙을 정의
- 하나의 데이터는 하나의 안정적인 row 로 표현하기
	- `ForEach` 안에서 조건에 따라 row 가 사라지거나 여러 top-level view 로 쪼개지지 않게 하기
	- 여러 UI 조각이 필요하면 `VStack`, `HStack`, `Grid`, custom `Layout` 등으로 감싸서 하나의 row view 로 만들기
	- 예: `StepDiagram` 과 `StepInstructions` 를 top-level 로 따로 반환하기보다 `StepRow` 내부에서 하나의 layout 으로 묶기
- data level 에서 먼저 필터링하기
	- 보여줄 데이터만 `ForEach` 에 전달
	- SwiftData 를 쓴다면 `@Query` + `#Predicate` 로 필터링
	- lazy stack 이 view 를 만들지 않아도 item 수와 index 를 알 수 있게 만들기
- scroll 관련 판단은 absolute offset 대신 visible item 기준으로 하기
	- `onScrollTargetVisibilityChange` 로 어떤 item 이 보이는지 확인
	- “특정 위치에 도달했는가”보다 “특정 item 이 보이는가”를 기준으로 UI 상태를 결정
- row 가 나타나기 전에 필요한 준비를 끝내기
	- view model, loader, cache key 등은 initializer 에서 구성
	- `onAppear` 는 infinite scrolling 처럼 “정말 화면에 나타났을 때 해야 하는 일”에 제한
- 유지되어야 하는 상태는 parent/model 로 올리고 binding 으로 전달하기
	- 선택 상태, highlight 상태, 편집 상태 등은 row 내부가 아니라 상위 view 또는 model 에 저장
- 복잡한 높이 계산은 `onGeometryChange` 로 사후 보정하기보다 SwiftUI layout primitive 또는 `Layout` 프로토콜로 풀기
- programmatic scroll 이 필요하면 `ScrollPosition` 을 사용하되, target item 구조를 안정적으로 유지하기
	- target 을 찾기 위해 off-screen view 를 많이 만들 필요가 없는 구조가 가장 빠르고 부드러움

## 한 줄 결론
- `LazyVStack` 은 “전체 목록을 정확히 배치하는 컨테이너”가 아니라 “보이는 범위만 점진적으로 배치하는 추정 기반 컨테이너”이므로, 데이터는 미리 정제하고 row 의 크기·구조·상태를 처음부터 예측 가능하게 만든 뒤 scroll 판단은 visible item 중심으로 해야 함
