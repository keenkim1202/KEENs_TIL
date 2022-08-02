# DispatchGroup

> DispatchGroup `Class`  
> : A group of tasks that you monitor as a single unit.

```swift
class DispatchGroup: DispatchObject
```

- 여러 테스크들(tasks)을 그룹으로 묶어서 동시에 수행하고자할 때 사용한다.
- 하나의 `task`를 `{ }` 를 이용해 block으로 정의하고, 그 block을 그룹에 참가(enter)시킨다.
- 테스크들의 세트/묶음을 `group` 이라고 표현한다.

- 여러개의 `work item`들을 하나의 그룹으로 묶고, 같은 큐(queue) 혹은 다른 큐들에 비동기적(asyncronous)으로 수행하도록 스케쥴할 수 있다.
  - `class` DispatchWorkItem : 이 클래스는 task의 캡슐화를 하는데 이용합니다. 즉, task를 세분화하여 만들어두고 DispatchQueue로 실행을 시키게 된다.
  - 이 클래스의 인스턴스를 work item이라고 부른다.

- 만약 그룹안의 모든 work item들이 수행을 끝마치면 그룹은 completion handler를 수행한다.
- 혹은 그룹안에 있는 모든 task들이 수행을 끝마칠때까지 동기적으로 기다려줄 수도 있다.

----

## 대표적인 메서드

### [enter()](https://developer.apple.com/documentation/dispatch/dispatchgroup/1452803-enter)

 > 해당 그룹에 block이 들어가졌음을(entered) 명시적으로 나타낸다.

- 파라미터로 group을 받는데, dispatch group을 업데이트하기 위해 사용되며, `NULL`이 될 수 없다.

```
Dispatch Group 에 task를 추가하여(enter) +1 시킨다.
```

</br>

### [leave](https://developer.apple.com/documentation/dispatch/dispatchgroup/1452872-leave)

> 그룹 안에서 수행이 끝난 블록을 명시적으로 나타낸다. (수행이 끝났으므로 해당 그룹을 떠남을 의미)

- `enter`와 마찬가지로, `NULL`이 될 수 없다.

```
Dispatch Group 에 task를 빼내어(leave) -1 시킨다.
```

</br>

### [wait()](https://developer.apple.com/documentation/dispatch/dispatchgroup/2016090-wait)

> 이전에 제출된 work가 끝나기를 동기적으로 기다린다.

</br>

### [notify(qos: flags: queue: excute:)](https://developer.apple.com/documentation/dispatch/dispatchgroup/2016066-notify)

> 현재 그룹이 모든 테스크 수행을 끝내면 execute 인자의 clossure에 작성되어 있는 툭정 행동을 수행할 것을 알린다.

```
Dispatch Group 에 들어있는 task가 0이 되었을 때 실행되는 함수이다.
```

- qos : 해당 work가 수행될 서비스의 퀄리티를 정한다.(quality of service)
- flags : work가 어떻게 수행될 것인지에 대한 옵션을 지정해줄 수 있다.
    - 옵션종류 : assignCurrentContext, barrier, detached, enforceQoS, inheritQoS, noQoS
    - 옵션별 상세 설명은 이 [링크](https://developer.apple.com/documentation/dispatch/dispatchworkitemflags)를 참고해보자.
- queue : 그룹의 수행이 모두 완료되었을 때에 알림받을 큐
- work : 그룹의 수행이 완료되었을 때 dispatch queue에서 수행될 work

----

## 사용방법
### 설명
- main은 UI를 그리는 작업을 해야하기 때문에 `main.sync`를 제외한 다른 비동기적인 혹은 백그라운드에서 의 작업 `dispatchQueue` 블록에 작성한다.
- `someGroup.enter()`를 하고 바로 아래의 함수를 행 그룹에 추가한다. (3까지 반복)
- 그렇게 `DispatchQueue.main.async { }` 블록의 끝에 도달한 후 group에 들어온 task를 순서대로 실행한다. (task1, task2, task3 순서)
- task1 수행이 완료되고 `compeltion()`을 통해 넘어온 문자열을 `result`라는 이름으로 받아 해당 블록을 실행한다.
- 그룹 안의 모든 task의 실행이 끝난 후 group은 `notify()`를 통해 main에 모든작업이 끝났음을 알리며, 모든작업이 끝난 후 해주고 싶은 추가적인 작업을 해준다. (아래 코드이 경우는 print문 출력)


### 예제 코드
```swift

func someWork(number: Int, completion: @escaping (String) -> Void) {
    completion("현재 \(number) 작업을 수행합니다.")
}

func someGroupTasks() {
    DispatchQueue.main.async { // background에서 비동기적으로 작업을 수행하기 위해 async로 수행
        let someGroup = DispatchGroup() // group 생성
        
        print("---- task1 enter ----")
        someGroup.enter() // group에 task + 1

        // 현재 그룹에 들어와 있는 상태로 실행할 작업을 작성
        someWork(number: 1) { result in
            print(result)
            someGroup.leave() // group에 task - 1
            print("---- task1 leave ----")
        }

        print("---- task2 enter ----")
        someGroup.enter()
        someWork(number: 2) { result in
            print(result)
            someGroup.leave()
            print("---- task2 leave ----")
        }
        
        print("---- task3 enter ----")
        someGroup.enter()
        someWork(number: 3) { result in
            print(result)
            someGroup.leave()
            print("---- task3 leave ----")
        }
        
        someGroup.notify(queue: .main) {
         print("Group의 모든 작업이 끝났습니다.")
        }
    }
}

someGroupTasks()

```

### 실행결과
```
---- task1 enter ----
현재 1 작업을 수행합니다.
---- task1 leave ----
---- task2 enter ----
현재 2 작업을 수행합니다.
---- task2 leave ----
---- task3 enter ----
현재 3 작업을 수행합니다.
---- task3 leave ----
Group의 모든 작업이 끝났습니다.
```

</br>

### 실제 사용 예시를 보고 싶다면? 아래의 블로그 글을 참고하세요!
- [다수의 반복적인 네트워크 통신 처리를 완료한 후 화면을 갱신해주고 싶을 때](https://nareunhagae.tistory.com/65)

</br>

----

참고자료
- [Apple Developer - DispatchGroup](https://developer.apple.com/documentation/dispatch/dispatchgroup)
