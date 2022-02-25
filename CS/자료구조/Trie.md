# Trie
```
문자열 검색 문제에 특화된 트리 형태의 자료구조. 
원하는 문자열을 O(m) (m = 문자열의 길이) 시간복잡도로 찾을 수 있다.
```

- struct Trie 내의 Trie 포인터 배열을 가지고 해당 키에 맞는 포인터로 이어지는 구조.
- Trie는 검색 후보 문자열을 하나의 트리로 만들어서, 한번의 검색 O(m) 만으로 문자열의 존재 여부를 검색 가능하다.

## 주의
- 항상 첫번째 root 노드는 빈칸이다.
- 트라이 객체마다 트라이 포인터 배열을 경우의 수만큼 가져야 하므로 공간복잡도가 매우 커질 수 있다.
- 공간복잡도 : O(key의 경우의수 * 포인터 크기 * 전체 트라이에 존재하는 노드 수)

## 필수
1) 다음 두 가지를 가지고 있어야 한다.
```
- child (자식 노드를 담는 배열)
- isTerminal (어떤 단어의 마지막에 해당하는 노드인지 여부를 나타낸다.)
```
- 노드를 탐색하다가 isTermial == true이면 지금까지 거친노드를 연결한 온전한 단어가 존재한다는 뜻이다.
2) class로 구현해야 한다.
- struct는 자기 자신의 타입을 갖지 못함.
-> 노드(trie)는 child, isTerminal을 가지는데, child는 trie 배이므로 자기 자신을 가져야 한다.

## Trie class 구현
```swift
class  Trie {
    private var child: [Trie?] = Array(reapeating: nil, count: 26) // 알파벳 갯수 만큼 count
    private var isTerminla = false
}
```
- child[0] = a, child[1] = b .... 를 의미한다.
- `child[0] == nil` : 지금의 알파벳 다음 알파벳으로 a가 올 수 없다.
- `child[0] != nil` : 지금의 알파벳 다음에는 a가 존재하며 연결되어 있다.

## Trie에 단어 저장
```swift
// 외부에서 편하게 사용하기 위해 작성
func insert(_ s: String) {
    let array: [Character] = Array(s)
    insertCharacter(array, 0)
}

// 입력받은 s를 Character 배열로 만들어, s의 길이 만큼 trie의 child에 접근하여 재귀호출하는 함수
private func insertCharacter(_ array: [Character], _ index: Int) {
    // 모든 단어를 탐색했다면 isTerminal을 true로 변경
    if array.count == index {
        self.isTerminal = true
        return
    }

    let charIndex = toNumber(array[index])

    if child[charIndex] == nil {
        child[charIndex] = Trie()
    }

    child[charIndex]?.insertCharacter(array, index + 1)
}

// subscript에 사용하기 위해 문자를 0-25 사이의 숫자로 바꾸어 리턴하는 함수
func toNumber(_ cha : Character ) -> Int {
    return Int(cha.asciiValue! - Character("a").asciiValue!)
}
```

## 특정 단어 찾기
```swift
// 외부에서 편하게 사용하기 위해 작성
func find(_ s: String) -> Bool {
    let array: [Character] = Array(s)
    return find(Character(array, 0))
}

// 탐색하다가 특정단어가 없다면 child[charIndex] == nil 이므로, falase 리턴
// 특정 단어를 다 탐색 후 isTerminal이 true이면 해당한어를 찾았기에 true 리턴
private func findCharacter(_ array: [Character], _ index: Int) -> Bool {
    if array.count == index {
        if isTerminal { return true }
        return false
    }

    let charIndex = toNumber(array[index])
    if child[charIndex] == nil { return false }

    return child[charIndex]!.findCharacter(array, index + 1)
}
```

## 장점
- 검색 시간이 단축된다.
    - 여러번의 쿼리를 요구하는 문제에서 O(m)의 시간복잡도로 결과를 얻을 수 있다.

## 단점
- 문자열의 수가 많아지거나 길어질수록 메모리를 많이 차지한다.
    - 이유: 각 노드의 child가 알파벳 갯수만큼을 항상 가지고 있기 때문

## 응용
- 원하는 prefix를 가진 단어의 존재 여부 파악하기
- 단어의 입력 순서 기억하기

## 참조 링크
- [문자열검색Trie](https://jcsoohwancho.github.io/2019-11-03-%EB%AC%B8%EC%9E%90%EC%97%B4-%EA%B2%80%EC%83%89(2)-Trie/)