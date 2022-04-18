# KEENs_TIL

> Write what i've learned today.
- 이틀에 최소 하나 이상의 내용을 작성/수정을 목표로 합니다.
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
- Enumeration
- Function
- Control Flow
- Protocol
- Codable & Encodable
- Concurrency
  - GCD
  - Operation
  - Async/Await


## [iOS](iOS)
- [App Life-Cycle](iOS/appLifeCycle.md)
- [ARC & GC](iOS/ARC_vs_GC.md)
- [Storage Modifier](iOS/Storage_Modifier.md)


## [Algorithm](CS/알고리즘)
- [완전탐색(BruteForce)](CS/알고리즘/완전탐색.md)
- [탐욕법(Greedy)](CS/알고리즘/탐욕법(Greedy).md)
- [BFS  & DFS](CS/알고리즘/DFS&BFS.swift)
  - BFS (Breath First Search)
  - DFS (Depth First Search)


## Design Pattern
- Delegate
- Observer
- Protocol
- Singleton

## [Architecture Pattern](CS/아키택처패턴)
- [MVC](CS/아키택처패턴/MVC.md)
- [MVVM](CS/아키택처패턴/MVVM.md)
- MVP
- MVVM-C
- VIPER


## [OS](CS/운영체제)
- [Thread & Process](CS/운영체제/Thread&Process.md)


## [Network](CS/네트워크)
- [TCP & UDP](CS/네트워크/TCP&UDP.md)
- [HTTP](CS/네트워크/HTTP.md)
- [OSI 7 Layer](CS/네트워크/OSI_7_Layer.md)
- [캡슐화](CS/네트워크/캡슐화&역캡슐화.md)

## ISSUE 해결
<details>
 <summary> 스크롤 시 사라지는 뷰 만드는 방법 </summary>
 
 - 상단의 작은 뷰와 웹뷰로 화면이 구성되어있음
 - 아래로 스크롤을 하면 안보이고, 다시 위로 스크롤하면 보이는 뷰를 넣고 싶었음
 - view의 상단 제약조건의 contentOffset을 빼주어 구현함. (함께 있는 뷰가 UIScrollView를 상속받고 있다면 아래의 방법으로 적용 가능)
 
  ```swift
 class SomeView: UIView {
    // 변수 선언
    var topConstraint: Constraint? = nil
    ...

    // 제약조건 설정

    func setConstraints() {
      infoView.snp.makeConstraints {
        $0.leading.trailing.top.equalTo(safeArea)
        $0.height.equalTo(110)
        self.topConstraint = $0.top.equalTo(safeArea).constraint
      }
    }
 }

  // 스크롤 될 때 뷰 올라가게 하기
  extension SomeView: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
     guard let topConstraint = topConstraint else { return }

     if scrollView.contentOffset.y > 0 {
       if scrollView.contentOffset.y < 110 {
         topConstraint.update(offset: -scrollView.contentOffset.y)
       } else {
         topConstraint.update(offset: -110)
       }
     } else {
       topConstraint.update(offset: 0)
     }
   }
 }
  ```

</details>
