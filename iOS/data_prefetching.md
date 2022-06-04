# API call Pagination 구현 시 Prefetching 작업이 Smooth 하지 않을 때
: collectionView에서 unsplash API를 통해 이미지를 불러오는 작업을 할 때 발생한 이슈 (tableView도 마찬가지)

## Touble
- 처음엔 `PrefetchDataSource`를 사용하여 구현하였다. 그런데 빠르게 스크롤하여 `collectionView`의 최하단에 도달하는 경우 prefetch 가 되지 않았다.
- 다시 약간 위로 스크롤 후 아래로 스크롤 해야 prefetch 작업이 이루어졌다.
- 위의 코드는 다음과 같다.
```swift
override viewDidLoad() {
  super.viewDidLoad()
  
  collectionView.prefetchDataSource = self
}

...

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if unsplashList.count - 1 == indexPath.item {
                page += 1
                fetchImages(page: page)
            }
        }
    }
}
```

## Shooting
- 그래서 현재 스크롤 위치를 기준으로 데이터를 Prefetch 해오도록 코드를 수정하였다.
- `scrollViewDidScroll(_ scrollView:)` 함수에서   
`collectionView의 cntentView의 origin y의 offset` 이  
`contentView의 높이 - bound 즉, 자신만의 상대적 좌표계를 기준으로 계산한 collectionView에서의 높이` 보다 크거나 같은지를 비교하여  
현재 스크롤하고 있는 위치가 컬렉션뷰의 최하단에 도착하면 api 호출을 하도록 구현하였다.

(*헷갈린다면 view에서의 frame / bound 그리고 origin과 offset의 개념을 체크해보세요.)

- 위의 코드는 다음과 같다.
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.bounds.size.height) {
        page += 1
        fetchImages(page: page)
    }
}
```

## Conclusion
- `prefetchDataSource`를 `tableView`에서 사용할 때는 마지막 index에 도달하기 전에 prefetch 작업을 해주면 되었었는데, `collectionView`는 cell을 어떻게 구성하느냐에 따라 화면 최하단에 보여질 index의 갯수가 달라진다.
- `prefetchDataSource` 보다 `scrollViewDidScroll`를 사용하는 것이 현재 프로젝트에서 좀 더 smooth 하게 스크롤, data fetching 되는 것 같다고 느껴졌다.
- `prefetchDataSource`에서도 조금 수정하면 이 부분을 보완할 수 있을 것 같지만, 지금은 간단하게 이미지 다운로드 시 비동기 처리 부분을 연습하기 위해 만든 프로젝트 이므로 추후에 해결방법을 추가작성 해보려 한다.
