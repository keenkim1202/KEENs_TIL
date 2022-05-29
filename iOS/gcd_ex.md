# GCD 관련 요약 설명 및 예제 코드


## 요약 설명
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


