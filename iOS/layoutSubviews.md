# Layout Subviews Methods

레이아웃이 결정되기 전, 후에 레이아웃과 관련된 부가적인 작업들을 수행할 수 있도록 하는 메서드가 존재한다.

ViewController에서 레이아웃이 결정되는 과정
- `viewWillLayoutSubviews()` 메서드 호출
- ViewController의 contentView가 `layoutSubviews()` 메서드 호출
- 레아아웃 정보의 변경사항을 뷰에 반영
- `viewDidLayoutSubviews()` 메서드 호출

## viewWillLayoutSubviews()
- 뷰의 bounds가 변하는 뷰는 하위 뷰들의 위치를 조정한다.
- 레이아웃이 결정되기 전에 다음과 같은 작업을 수행하고자 할 때 이 메서드를 override 하여 사용한다.
  - 뷰를 추가하거나 제거 하는 작업
  - 뷰의 크기나 위치를 업데이트하는 작업
  - 제약조건을 업데이트하는 작업
  - 뷰와 관련된 기타 프로퍼티 업데이트 작업

## layoutSubviews()
- 현재 레이아웃 정보들을 바탕으로 새로운 레이아웃을 계산하고 반영한다.
- 이후 뷰 계층구조를 순회하면서 하위 모든 뷰들이 이 메서드를 호출한다.
- 뷰의 크기가 변경될 떄마다 이에 대응하여 하위 뷰들의 크기와 위치가 변경되어야 한다.
  - autoLayout을 통해 autoresizongMask 프로퍼티를 설정하여 상위 뷰의 크기가 변경되었을 떄 어떻게 대응할지 규칙을 정할 수 있다.
- 뷰의 크기에 변동이 생기면 하위 뷰들의 autoresizing을 적용하는데, 변경사항들을 반영하기 위해서 `layoutSubviews()` 메서드를 호출한다.

## viewDidLayoutSubviews()
- 레이아웃이 결정되고 나서 아래와 같은 일을 수행하고자할 때 이 메서드를 override 하여 사용한다.
  - 다른 뷰의 content 업데이트 작업
  - 뷰의 크기나 위치 최종 조정 작업
  - 테이블뷰의 데이터 reload 작업
