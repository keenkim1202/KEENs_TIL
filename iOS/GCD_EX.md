# GCD 관련 요약 설명 및 예제 코드
# GCD란?
- GCD는 특정 코드 블록으로 된 Task들을 `FIFO Queue`들에 넘겨주면 이들을 관리하고 제공하는 녀석이다.
- Task 를 만들어 GCD에 넘기면, 시스템에서 알아서 Thread를 할당하여 실행시켜 준다.
```
간단하게 말하면, Queue 를 이용해서 실행해야할 작업들을 알아서 관리해주는 녀석이다.  
💡 자세한 내용은 'GCD & Operation' 을 참고하자!
```

## Queue란?
- 자료구조에 나오는 그 Queue가 맞음.
- FIFO (First In First Out) 
- 즉, 들어온 순서대로 Task를 처리하고, 제일 처음 들어온 Task가 제일 먼저 나가는 구조를 띄는 자료구조를 말한다.

## 요약 설명
- GCD에서 사용하는 Queue는 DispatchQueue의 타입으로 선언 되어있고 아래의 3가지가 있다.

### Main Queue
- Main Thread에서 작동하는 Queue
- 주로 UI 관련 작업을 한다.

### Global Queue
- 시스템에 의해 관리되는 Concurrent Queue
- Queue에 들어가는 Task 우선순위를 Qos를 통해 표현할 수 있다.
- Qos = Quality Of Service : global에서 수행될 Task들의 우선순위에 대한 표현

 Qos 높은 순위부터 순서대로 보면
- `userInteractive`
 : main thread와 같이 바로 수행해야 될 작업에 사용
- `userInitiated`
 : 사용자가 결과를 기다리는 작업 (중요도가 높을 때)
- `default`
 : 덜 중요한 작업
- `utility`
 : 오래 걸리는 혹은 무거운 작업 (ex. 네트워킅 처리, 파일 불러오기)
- `background`
 : 사용자에게 당장은 필요없는 작업 (ex. 위치 업데이트, 영상 다운로드)

### Custom Queue
- 개발자가 직접 생성해서 사용하는 queue
- `ConcurrentQueue`, `SerialQueue`로 생성 가능


## 예제 코드
- Network 작업을 통해 데이터를 받아와 화면에 보여주고자 할 때
```swift
DispatchQueue.global().async {
  // 1) some networking code...
  
  DispatchQueue.main.async {
    // 2) some UI update code..
  }
}
```
1) 데이터 통신을 통해 데이터를 받아오는 작업을 global queue 에서 해줍니다.  
`e.g.` 데이터로부터 이미지를 받아오거나 API 를 통해 특정 쿼리에 대한 정보를 받아오는 작업

2) 받아온 데이터를 사용자가 보는 화면(UI)에 보여줍니다.  
`e.g.` imageView에 다운 받은 이미지를 대입, tableView를 갱신하여 가져온 데이터를 바탕으로 UI에 반영

### global().sync
```swift
DispatchQueue.global().sync {
    for i in 1..<6 {
        print(i)
    }
    print("---global sync done---")
}
for i in 10..<16 {
    print(i)
}
```

> 실행 결과

```
1
2
3
4
5
---global sync done---
10
11
12
13
14
15
```

> 설명

- global queue(main 이외의 다른 큐)에 sync(동기)로 작업을 할당하도록 생성하였다.
- 그러므로 `global().sync` 블록 안에 있는 작업이 다 끝나야 다른 작업을 실행한다.

### Custom Serial Queue
```swift
  let customQueue = DispatchQueue(label: "custom") // serial한 customQueue 생성
  customQueue.sync {
      for i in 1..<6 {
          print(i)
      }
      print("---custom serial done---")
  }
  for i in 10..<16 {
      print(i)
  }
```
> 실행결과
- global sync 와 동일

> 설명
-  `Custom Queue`의 default는 `serial` 이다.

### global().async
```swift
  DispatchQueue.global().async { // A
      for i in 1..<6 {
          print(i)
      }
      print("---global async 1 done---")
  }
  
  DispatchQueue.global().async { // B
      for i in 10..<16 {
          print(i)
      }
      print("---global async 2 done---")
  }
  
  for i in 100..<106 { // C
      print(i)
  }
```

> 실행결과

```
1️⃣ 1
3️⃣ 100
2️⃣ 10
2️⃣ 11
3️⃣ 101
1️⃣ 2
3️⃣ 102
1️⃣ 3
3️⃣ 103
1️⃣ 4
3️⃣ 104
1️⃣ 5
3️⃣ 105
2️⃣ 12
2️⃣ 13
---global async 1 done---
2️⃣ 14
2️⃣ 15
---global async 2 done---
```

> 설명

- 실행할 때 마다 결과는 다르게 나온다.
- global에서 async(비동기)로 작업을 할당하도록 생성하였다.
- C가 실행중일 때, 두개의 global에 async하게 할당된 작업은 concurrent(동시에)하게 작업이 실행되므로 A, B, C가 랜덤하게 출력된다.

### Serial Async 
 ```swift
   let customQueue = DispatchQueue(label: "custom") // serial한 customQueue 생성
  
  customQueue.async { // A
      for i in 1..<6 {
          print("1️⃣", i)
      }
      print("---global async 1 done---")
  }
  
  customQueue.async { // B
      for i in 10..<16 {
          print("2️⃣", i)
      }
      print("---global async 2 done---")
  }
  
  for i in 100..<106 { // C
      print("3️⃣", i)
  }
 ```

 > 실행결과
```
1️⃣ 1
3️⃣ 100
3️⃣ 101
3️⃣ 102
3️⃣ 103
3️⃣ 104
3️⃣ 105
1️⃣ 2
1️⃣ 3
1️⃣ 4
1️⃣ 5
---global async 1 done---
2️⃣ 10
2️⃣ 11
2️⃣ 12
2️⃣ 13
2️⃣ 14
2️⃣ 15
---global async 2 done---
```

 > 설명
 - async(비동기)로 처리하되 serial(직렬)하게 A, B를 실행한다.
- 따라서 A가 끝나야 B가 실행이 가능하다.
- 따라서 A, C 혹은 B, C는 섞여 나올 수 있어도 A, B는 섞여 나오지 않는다.