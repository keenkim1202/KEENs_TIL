# View Layout Cycle

### 화면에 뷰가 뜨기까지의 생명주기 상세 순서

<img width="700" src="https://user-images.githubusercontent.com/59866819/188416332-ff7f8055-7d00-4d83-9460-e19a91076281.png">


>  `requiresConstraintBasedLayout` > `loadView` > `viewDidLoad` > `viewWillAppear` >    

> `updateConstraints` > `instrinsicContentSize` > `updateViewConstraints` >    

> `viewWillLayoutSubviews` > `layoutSubviews` > `viewDidLayoutSubviews` >   

> `drawRect` >   

> `viewDidAppear`
