# 체크할 부분
- 13버전 기준으로 `sceneDelegate`, `appDelegate`가 나누어진 부분
- 메모릭 부족해지면 백그라운드에서 서스팬드 → 종료

### App State

1. `Not Running`
-  실행되지 않았거나, 시스템에 의해 종료된 상태
2. `Inactive`
- 실행 중이지만 이벤트를 받고있지 않은 상태. 
- 예를들어, 앱 실행 중 미리알림 또는 일정 얼럿이 화면에 덮여서 앱이 실질적으로 이벤트는 받지 못하는 상태등을 뜻합니다.
3. `Active`
- 어플리케이션이 실질적으로 활동하고 있는 상태.
4. `Background`
- 백그라운드 상태에서 실질적인 동작을 하고 있는 상태. 
- 예를 들어 백그라운드에서 음악을 실행하거나, 걸어온 길을 트래킹 하는 등의 동 뜻합니다.
6. `suspended`
- 백그라운드 상태에서 활동을 멈춘 상태. 
- 빠른 재실행을 위하여 메모리에 적재된 상태지만 실질적으로 동작하고 있지는 않습니다. 
- 메모리가 부족할때 비로소 시스템이 강제종료하게 됩니다.

대부분의 상태 전환은 AppDelegate객체의 메소드 호출을 거칩니다.   
AppDelegate 객체는 `UIResponder`, `UIApplicationDelegate`를 상속 및 델리게이트 참조하고 있습니다.  
`UIApplicationDelegate`은 `UIApplication` 객체의 작업에 개발자가 접근할 수 있도록 하는 메소드들을 담고 있습니다.

### App Delegate

- `application: willFinishLaunchingWithOptions` : 어플리케이션이 최초 실행될 때 호출되는 메소드
- `application: didFinishLaunchingWithOptions` : 어플리케이션이 실행된 직후 사용자의 화면에 보여지기 직전에 호출
- `applicationDidBecomeActive` : 어플리케이션이 Active 상태로 전환된 직후 호출
- `applicationWillResignActive` : 어플리케이션이 Inactive 상태로 전환되기 직전에 호출
- `applicationDidEnterBackground` : 어플리케이션이 백그라운드 상태로 전환된 직후 호출
- `applicationWillEnterForeground` : 어플리케이션이 Active 상태가 되기 직전에, 화면에 보여지기 직전의 시점에 호출.
- `applicationWillTerminate` : 어플리케이션이 종료되기 직전에 호출
