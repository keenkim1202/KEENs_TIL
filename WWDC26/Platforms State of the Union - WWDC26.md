# Platforms State of the Union - WWDC26

- 영상 링크 : https://developer.apple.com/videos/play/wwdc2026/102

# Keypoint

## 재컴파일 시 강제로 바뀜 → 반드시 확인
- **Liquid Glass 강제 적용**
	- 구 디자인 opt-out 지원 제거. Xcode 27 로 재컴파일하면 자동으로 새 디자인 적용됨
	- 커스텀 컨트롤이 Liquid Glass 와 충돌하지 않는지, 접근성 설정(투명도 감소·대비 증가)에서 깨지지 않는지 점검 필요
- **iOS 앱 Resizability 자동 opt-in**
	- 최신 SDK 로 rebuild 하면 iPad / iPhone Mirroring 에서 리사이즈 대상이 됨
	- SwiftUI / Auto Layout / size class 기반이면 대체로 OK, **커스텀 뷰는 auto layout + trait collection 으로 갱신 필요**
	- 고정 device/orientation 가정 대신 "동적 size·aspect ratio" 전제로 레이아웃 검토 → resizable simulator/Previews 로 테스트
- **SwiftUI state 의 macro 전환**
	- state 가 lazy + macro 로 바뀜 → 최초 로드 시에만 초기화(성능↑). 단 init 에서 기본값 재할당 시 에러 발생 가능
	- 자세한 마이그레이션 주의점은 [[What's new in SwiftUI - WWDC26]] 참고
- **Apple silicon-only**
	- Mac App Store 에 silicon-only 바이너리 출시 가능 (iOS 직접 영향은 적지만 Catalyst/Mac 빌드 시 체크)

## 코드 변경 없이 좋아지는 것 (그냥 챙기면 이득)
- SwiftUI 속도 개선: 중첩 stack 레이아웃 최대 2배, state lazy 초기화
- AsyncImage 자동 HTTP 캐싱 (스크롤 재로드 문제 해소)
- Swift/UIKit/SwiftUI 공통 foundation → 전반적 성능 향상

## 새로 활용할 수 있는 것 (기능 추가 검토)
- **Foundation Models framework** — on-device AI 를 인프라/토큰 비용·프라이버시 트레이드오프 없이 도입
	- 멀티모달(텍스트+이미지), Vision 통합(OCR·바코드), 서버 모델(Claude·Gemini) 교체 가능
	- 첫 다운로드 200만 미만이면 PCC 의 Apple 모델을 cloud API 비용 0 으로 사용 → 진입장벽 낮음
	- Dynamic Profiles 로 한 세션에서 모델/도구/지시 동적 전환
- **App Intents + Siri 통합** — 앱 발견·재유입 채널 확보
	- `@AppEntity`(콘텐츠) → Spotlight semantic index, `@AppIntent`(액션) → 자연어 실행
	- View Annotations API 로 온스크린 콘텐츠("이 사진") 참조·실행
	- 시스템 정의 schema 라 향후 언어/방언 확장 시 코드 변경 없이 혜택
- **SwiftUI 신규 인터랙션/툴바** — resizability 와 직접 연결
	- `.reorderable()` + `.reorderContainer()` (드래그 재정렬), 임의 컨테이너 swipe actions
	- toolbar: `visibilityPriority`, overflow menu, `topBarPinnedTrailing` → 가변 크기에서 툴바 정리
- **Swift 6.4 일상 개선**
	- `anyAppleOS` 로 멀티플랫폼 availability 축약, defer 내 async/await 허용
	- "type check in reasonable time" 에러 대폭 개선, 영역별 warning 억제/승격
	- 상세는 [[What's new in Swift - WWDC26]] 참고

## 도구/워크플로 변화
- **Xcode 27**: 30% 작아짐, 설정 iCloud 동기화, 새 프로젝트 즉시 시작, 테마, Xcode Cloud 2배 빠름
- **Previews**: 임의 property 의 variant 를 grid 로 한눈에
- **Device Hub**: Simulator 대체(동적 리사이즈 테스트, 물리 디바이스 통합 관리)
- **Agentic coding**: `/plan` 협업, 시뮬레이터 자동 테스트, 로컬라이즈, crash 분석·수정까지

# Summary
- 내용: WWDC26 Platforms State of the Union. 올해 릴리스(27 버전)의 개발자 대상 핵심 변화 총정리
- 큰 축 3개: 1) Apple Intelligence 2) 플랫폼 개선(Design / Swift / SwiftUI) 3) 개발자 생산성(Xcode)
- 주요 키워드
	- Foundation Models framework (멀티모달 + 서버 모델 + Dynamic Profiles)
	- Core AI (on-device 모델 실행 신규 프레임워크)
	- App Intents + Siri (Spotlight semantic index, View Annotations)
	- Liquid Glass 디자인 개선 / iOS 앱 resizability
	- SwiftUI 인터랙션·속도·신기능 / Swift 6.4
	- Xcode 27 (agentic coding, Device Hub, 테마, Previews variants)

# 1. Apple Intelligence
## Apple Foundation Models
- Google 협업, Gemini 기술 기반으로 최신 Apple Foundation Models 제작
- on-device + Private Cloud Compute(PCC) 에서 구동
- 앱에서도 Foundation Models framework 로 사용 가능

## Foundation Models framework 확장
- 멀티모달 prompt: 텍스트 + 이미지 입력 지원
	- 이미지를 prompt 에 첨부하기만 하면 됨
	- Vision framework 통합 -> OCR, 바코드 리더 등 on-device 도구를 모델이 활용
- 서버 모델 호출 지원
	- Claude, Gemini 등 server model 을 tool calling / guided generation 과 함께 사용
	- 모델 제공자는 Language Model 프로토콜 준수하는 Swift package 만들면 됨 -> 원하는 모델로 교체 가능
- 비용 정책
	- 첫 App Store 다운로드 200만 미만 개발자는 PCC 의 Apple Foundation Model 을 cloud API 비용 없이 사용 가능
	- iCloud+ 구독자는 확장된 접근 권한

## Dynamic Profiles
- 적응형 AI 경험을 적은 코드로 만드는 새 declarative API
- 기존 LanguageModelSession 을 고정 모델/도구/지시 대신 계속 업데이트 가능
- Swift result builder 문법으로 여러 Profile 정의, 한 세션에서 전환
	- 예: 브레인스토밍(PCC, temperature 높임) / 튜토리얼 생성(PCC, reasoning deep) / 용어 설명(on-device 로 서버 호출 절약)
- 모든 Profile 이 같은 continuous transcript 공유 -> 적은 prompting 으로 더 많은 맥락
- 매 모델 turn 마다 body 재계산 -> instructions/tools 도 동적으로 교체
- agent / skill 같은 상위 추상화의 빌딩 블록으로 설계됨
- 오픈소스 Swift package 제공 (skills, context 관리 유틸 등 사전 제작 도구)

## 지원 도구
- Evaluations framework: prompt 테스트 / 기능 신뢰성 검증
- Foundation Models instrument 업그레이드 (모델 동작 시각화·디버깅)
- FM 커맨드라인 도구 (터미널에서 prompt)
- Python SDK, 이미지 tool calling, Core Spotlight 기반 RAG 도구(앱 전용·비공개)
- 올여름 framework 오픈소스화 -> 같은 Swift API 를 서버에서도 실행 (end-to-end AI 워크플로)

## Core AI (신규 프레임워크)
- on-device 모델 탑재·실행에 최적화된 새 프레임워크
- memory-safe Swift API, 세밀한 튜닝(model specialization, custom GPU kernel 등)
- PyTorch 모델을 Core AI runtime 용으로 변환·최적화하는 Python 도구
- ahead-of-time 컴파일, 전용 instruments, tensor 값을 원본 Python 소스까지 추적하는 visual debugger
- compute 규모에 맞춰 확장 (iPhone 의 compact vision model ~ Mac 의 수십억 파라미터 LLM)
- 서버 의존성 0, 토큰 비용 0, Apple silicon 최적화. Siri 포함 시스템 Apple Intelligence 도 구동

## App Intents + Siri
- App Intents framework 로 앱을 Apple Intelligence 에 연결
- 핵심 OS 기술 활용: Spotlight semantic index, app toolbox, system orchestrator(프라이버시 보호하며 조율)
- App Intents schemas
	- entity schema: 앱이 다루는 콘텐츠/개념 기술 -> Spotlight semantic index 기여 -> 개인 맥락 이해
	- intent schema: 앱이 수행 가능한 액션 기술 -> 사용자가 자연어로 요청, 특정 문구 학습 불필요
	- 시스템 정의라 향후 언어/방언 지원 확장 시 코드 변경 없이 혜택
- 코드: `@AppEntity` 매크로(콘텐츠), `@AppIntent` 매크로(액션), IndexedEntity 프로토콜로 Spotlight 인덱싱
- View Annotations API: 화면의 view 를 entity 에 연결 -> "두 번째 메시지", "이 사진" 처럼 온스크린 참조·실행
- 데모: Siri 가 메시지 기반으로 origami night 참석자 파악, 메시지 전송, 사진 전송 등 수행

## 기타
- MLX (array framework): Metal 4, GPU Neural Accelerators 지원, Thunderbolt RDMA 로 여러 Mac 분산 학습, 오픈소스

# 2. 플랫폼 개선
## Design (Liquid Glass)
- 가독성 향상: 뒤 콘텐츠를 더 효과적으로 확산(diffuse)
- 깊이/구분감: 어두운 edge + 밝은 specular highlight 추가
- 개인화: 설정에 slider 추가 (ultra clear ~ fully tinted)
- 기존 Liquid Glass 앱은 재컴파일 없이 자동 적용, 접근성 설정(투명도 감소·대비 증가)에도 적응
- macOS 27: "show borders" 환경 값 지원(iOS 처럼), 사이드바 edge 까지 확장 + accent color 복원, 모든 윈도우 동일한 corner radius
- 스크롤 시 상단 uniform toolbar 자동 적용 (scroll edge effect API 로 커스텀)
- 아이콘: 기본은 숨김이나 핵심 액션은 아이콘 표시 API, 더 선명한 렌더링 + refraction
- Icon Composer: 여러 Liquid Glass 레이어로 아이콘 디자인, 이전 릴리스 미리보기

## 앱 적응성 (Resizability)
- iOS 앱이 iPad / iPhone Mirroring 등 큰 화면에서 리사이즈 지원
- 최신 SDK 로 rebuild 하면 자동 opt-in
- SwiftUI / Auto Layout / size class 대응 중이면 이미 준비된 셈. 커스텀 뷰는 auto layout + trait collection 으로 갱신 필요
- resizable iOS simulator + Previews 로 다양한 화면 크기 테스트
- coding agent 용 resizability 이슈 탐지·수정 skill 제공

## SwiftUI
- 인터랙션
	- reorderable container: `.reorderable()`(ForEach) + `.reorderContainer()`(부모) -> 드래그 재정렬, grid/stack 등 모든 컨테이너
	- swipe actions: `.swipeActions()`(행) + `.swipeActionsContainer()`(스크롤 컨테이너)
	- text selection: iOS 는 full-fidelity 선택, macOS 는 custom text renderer / vibrancy / 세로쓰기
- 속도 (코드 변경 없이 적용)
	- SwiftUI/AppKit/UIKit 아키텍처 통합 -> 공통 foundation
	- 중첩 stack 레이아웃 최대 2배 빠르게 (불필요한 측정 short-circuit)
	- state: lazy 화 + dynamic property → macro 전환 -> 최초 로드 시에만 초기화
	- AsyncImage: 표준 HTTP 캐싱으로 자동 캐싱
- 신기능
	- toolbar: `visibilityPriority`(중요 항목 우선 노출), overflow menu container, `topBarPinnedTrailing`(trailing 고정), prominent tab role
	- document-based 앱: 새 document infrastructure, first-class URL access(필요한 부분만 읽고 변경분만 쓰기), observable configuration
	- Spatial Preview framework: Mac 앱의 3D 모델을 Apple Vision Pro 로 스트리밍해 실시간 미리보기·편집·공유
	- content builders 로 type checking 성능 개선, alert binding API, cross-fade transition 조정

## Swift (6.4)
- Swift 는 앱 ~ 서버 ~ 임베디드 펌웨어까지 전 스택 대상. C/C++ 의 후계자 + 고수준 개발 모두 지향
- Linux / Windows / Android / web 도구는 Swift.org 에서 제공
- 상호운용 사례: Flighty(서버), GoodNotes(Swift for WebAssembly, 10만+ 라인 재사용), Frameo(Swift-Java)
- Apple 내부 Swift 채택 확대: Foundation/AppKit/UIKit, WebKit(safe C++ interop 으로 점진 교체), QUIC(SwiftNIO 로 오픈소스 예정), TrueType 폰트 엔진, 그리고 27 릴리스부터 커널 일부도 Swift
- 6.4 일상 개선
	- 특정 코드 영역에서 warning 억제 / warning 을 error 로 승격
	- 여러 Apple 플랫폼 availability 를 `anyAppleOS` 로 축약
	- defer 블록 내 async 호출 / await 가능해짐
	- "compiler unable to type check in reasonable time" 에러 대폭 개선 (컴파일 성공 또는 더 구체적인 에러)

## 전환 정리 (제거되는 것)
- macOS Tahoe 가 Intel Mac 마지막 지원 -> Apple silicon 단일 아키텍처
	- Mac App Store 에 Apple silicon-only 바이너리 출시 가능 (다운로드 크기↓, 테스트 단순화)
- 구 디자인 opt-out 지원 제거 -> Xcode 27 로 재컴파일 시 Liquid Glass 자동 적용

# 3. 개발자 생산성 (Xcode)
## 올해 두 축
- 인텔리전스(agentic coding) + 일상 경험(Xcode 사용감)
- 개선: 프로젝트 로딩 빠름, top crash/spin 수정, 디버그 세션 안정·빠른 expression 평가, 콘솔 로깅 개선
- Xcode 27: 30% 작아짐, Apple silicon-only, agent/문서 등은 백그라운드 다운로드

## 경험 개선
- 설정 iCloud 자동 저장 -> 새 Mac 에서 import (Git config 포함)
- 새 프로젝트: 파일명/bundle ID/셋업 없이 바로 에디터로 진입
- 커스터마이즈 가능 toolbar, document title 에 들어간 activity view
- 테마: 색이 에디터뿐 아니라 앱 전체에 적용, light/dark 모두 지원, 프로젝트별 다른 테마
- Xcode Cloud: 저장소 접근 허용만으로 시작, 빌드 최대 2배 빠름, Apple Vision Pro / Metal 앱 지원
- Previews: 임의 property 의 variant 를 grid 로 한눈에 (예: enum 4개 상태)
- Device Hub: Simulator 대체. 고fidelity(핀치 줌, 두 손가락 스크롤, 동적 리사이즈), 시스템 설정 테스트, 물리 디바이스도 같은 곳에서 관리·실행

## Agentic Coding (Xcode 27)
- 코딩 에이전트가 에디터에 파일처럼 열림, 모든 답변이 Swift/SwiftUI/Apple framework 에 grounded
- 에이전트 도구: 프로젝트 이해, 문서 검색, 빌드·테스트 + 신규(variant Previews 렌더, 시뮬레이터 상호작용, 로컬라이즈, 디버깅)
- 워크플로
	- `/plan` 으로 코드 작성 전 구현·설계 협업 (다이어그램, 마크다운 렌더, 명료화 질문, 수정 가능)
	- 구현 시 코드·Previews 변경 실시간 표시, 도중 수정 가능
	- 검증: 테스트 실행, playground 로 API 실험, light/dark·방향·텍스트 크기·로컬라이제이션 Previews 확인
	- 시뮬레이터에서 tap/swipe/type 으로 직접 테스트 후 스크린샷·요약 제공
- 개선 작업: 새 API 채택, 접근성, 로컬라이즈(맥락 기반 번역), Organizer 의 top crash 분석·재현·수정·검증
- 기반: Apple 엔지니어/디자이너 전문성이 skills + 문서 + MCP 도구의 corpus 로 내장
	- specialist 개념 (SwiftUI / accessibility / universal sizing / testing / performance)
	- Plugins 포맷으로 통합: skills(마크다운), MCP 도구, 그리고 Agent Client Protocol(ACP) 로 원하는 에이전트 탑재
	- 커맨드라인 또는 git URL 붙여넣기로 설치, Figma/GitHub 는 원클릭
- 에이전트 통합: Anthropic, OpenAI, Google 내장 + ACP 로 호환 에이전트. (ACP + Gemini 는 Xcode 26 업데이트로 오늘 제공)

## 기타 개발자 도구
- Reality Composer Pro 3: RealityKit 기반으로 재구축, 캐릭터 애니메이션·사실적 조명·라이브 프리뷰(Mac Virtual Display)
- 게임: Game Porting Toolkit 대규모 업데이트(coding agent AI skill 로 포팅 시간 단축), Metal 커맨드라인 도구

# 마무리
- 100+ 세션 공개 (Apple Developer 앱/웹/YouTube + 올해 신규 Bilibili)
- Group Labs, 온라인 패널, Q&A, Developer Forums
- Developer Center: Cupertino/Shanghai/Singapore/Bengaluru + 올가을 Berlin 신규 오픈