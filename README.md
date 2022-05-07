# 🧙🏻‍♀️ KEENs_TIL

> Write what i've learned today.
- 이틀에 최소 하나 이상의 내용을 작성/수정을 목표로 합니다. 
  - [블로그](https://nareunhagae.tistory.com/)에 정리하는 경우도 있습니다.
  - 블로그에 정리한 내용은 `Blog` 태그가 붙어있습니다.
- 주제는 iOS/Swift/CS/ETC 등 개발의 전반적인 영역에 대한 내용을 작성합니다.  
 (메인은 iOS/Swift 이므로 그와 관련된 내용이 주로 작성될 예정)

# INDEX
## ETC
- [Rx](https://github.com/keenkim1202/RxSwift_Practice)


## [swift](Swift)
- [Optional](Swift/Optional.md)
- [Collection Type](Swift/Collection_Type.md)
- [Class & Struct](https://nareunhagae.tistory.com/59)
  - [override & overlaod](Swift/Override&Overload.md)
- 타입과 자료형
- Generic
- [Enumeration](Swift/Enumeration.md)
- Function
- Control Flow
- Protocol
- Codable & Encodable
- Concurrency
  - [동기 / 비동기 / 직렬 / 동시의 차이](iOS/Sync_Async.md)
  - [기존방법과_async_await의차이](Swift/기존방법과_async_await의차이.md)
  - [GCD](iOS/GCD&Operation.md)
  - [Operation](iOS/GCD&Operation.md)
  - Async/Await
- [final](Swift/final.md)
- Closure
  - [Escaping Closure](Swift/EscapingClosure.md) 
- [타입캐스팅: as, as!, as?](Swift/typeCasting.md)
- [Components vs Split 비교](https://nareunhagae.tistory.com/8?category=1217059) `Blog`
- [protocol 지향 언어로써의 Swift 특징](Swift/protocol지향언어.md)


## [iOS](iOS)
- [View Life-Cycle](iOS/viewLifeCycle.md)
  - [laodView()와 viewDidLoad() 의 차이는?](iOS/loadView_vs_viewDidLoad.md)
- [App Life-Cycle](iOS/appLifeCycle.md)
- [ARC & GC](iOS/ARC_vs_GC.md)
  - [ARC & Retain Cycle 예제](https://nareunhagae.tistory.com/61) `Blog` 
- [Storage Modifier (Strong, Weak, Unowned)](iOS/Storage_Modifier.md)
- [SceneDelegate란?](iOS/SceneDelegate.md)


## [Algorithm](CS/알고리즘)
- [완전탐색(BruteForce)](CS/알고리즘/완전탐색.md)
- [탐욕법(Greedy)](CS/알고리즘/탐욕법(Greedy).md)
- [BFS  & DFS](CS/알고리즘/DFS&BFS.swift)
  - [예제 + 개념 설명](https://nareunhagae.tistory.com/56) `Blog`
  - BFS (Breath First Search)
  - DFS (Depth First Search)
- 이진탐색(Linear Search)
- 그래프
- 트리

## Data Structure
- [Trie](https://nareunhagae.tistory.com/54) `Blog`


## Design Pattern
- [Delegate](https://github.com/keenkim1202/DelegateEx)
- Observer
- Protocol
- Singleton

## [Architecture Pattern](CS/아키택처패턴)
- [MVC](CS/아키택처패턴/MVC.md)
- [MVVM](CS/아키택처패턴/MVVM.md)
- MVP
- MVVM-C
- VIPER

## Pragramming Paradigm
- [OOP와 FP 비교](CS/패러다임/OOP_vs_FP.md)
- OOP: Object Oriented Programming (객체 지향 프로그래밍)
- FP: Functional Programming (함수형 프로그래밍)
- RP: Reactive Programming (반응형 프로그래밍)

## [OS](CS/운영체제)
- [Thread & Process](CS/운영체제/Thread&Process.md)


## [Network](CS/네트워크)
- [TCP & UDP](CS/네트워크/TCP&UDP.md)
- [HTTP/HTTPS](CS/네트워크/HTTP와HTTPS.md)
  - [HTTP와 Socket](CS/네트워크/HTTP와Socket.md)
  - [HTTP Method](CS/네트워크/HTTPMethod.md)
- [OSI 7 Layer](CS/네트워크/OSI_7_Layer.md)
- [캡슐화](CS/네트워크/캡슐화&역캡슐화.md)


## [Database](CS/데이터베이스)
- [DB가 필요한 이유](CS/데이터베이스/db가필요한이유.md)


## [ETC](CS/ETC)
- [Framework와 Library란?](CS/ETC/Framework&Library.md)
- [아키택처패턴과 디자인패턴이란?](CS/ETC/아키택처패턴과_디자인패턴이란?.md)
- [tableView vs collectionView 언제 무엇을 사용할까?](https://nareunhagae.tistory.com/19?category=1217062) `Blog`
- [github에 올리면 안되는 APIKEY 숭기기](https://nareunhagae.tistory.com/44?category=1217058) `Blog`


## Trouble Shooting
- TableView
  - [TableViewCell 안의 버튼 액션이 작동하지 않을 때](https://nareunhagae.tistory.com/52) `Blog`
- CollectionView
  - [cell 안의 imageView를 원으로 만들었는데 찌그러질 때](https://nareunhagae.tistory.com/33?category=1217062) `Blog`
  - [CollectionView cell 커스텀 시 크기 조절이 잘 안될 때](https://nareunhagae.tistory.com/47?category=1217062) `Blog`
- ScrollView
  - [최상단으로 스크롤 시에만 보이는 뷰 구현(아래로 스크롤 시 사라지는 뷰)](https://nareunhagae.tistory.com/63?category=1217062) `Blog`
- masksToBounds 와 clipsToBounds
  - [masksToBounds: view 위에 있는 레이블이 view의 너비와 상관없이 안잘리게 하고싶을 때](https://nareunhagae.tistory.com/40?category=1217062) `Blog`
  - [clipsToBounds: view안에 있는 imageView를 둥글게 하고 싶을 때](https://nareunhagae.tistory.com/39?category=1217062) `Blog`
- AutoLayout
  - [StackView: 내가 원하는 컴포넌트를 크게 하고 싶을 때](https://nareunhagae.tistory.com/37?category=1217062) `Blog`
- Swift
  - [문자열을 원하는 길이 만큼씰 자르려면?](https://nareunhagae.tistory.com/9?category=1217062) `Blog`
  - [Extension: 랜덤한 색상을 사용하고 싶을 때](https://nareunhagae.tistory.com/42?category=1217058) `Blog`
