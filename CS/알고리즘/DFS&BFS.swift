/*
 BFS / DFS 문제 구분
 // 차이
 BFS -> 너비 우선 순회 (queue)
 - 현재 나의 위치에서 가장 가까운 노드를 먼저 방문하는 것
 - 방문하면 현재 위치는 pop해주고 방문한 곳은 체크
 - 방문할 곳은 queue에 넣는 과정
 -> 미로탐색은 최단거리만 가지고 탈출하는 것이기에 BFS가 적합
 DFS -> 깊이 우선 순회 (stack, recursive)
 - 이동할 때마다 가중치가 붙어서 이동하거나, 이동에 제약이 있는 경우 DFS로 구현하는 것이 좋다.
 - 탐색 시간은 더 걸리겠지만, 가중치에 대한 변수를 지속해 관리할 수 있다는 장점이 있어서 코드 구현이 편리하다.
 */

import Foundation

// queue
public struct Queue<T> {
  fileprivate var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func enquque(_ element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public var front: T? {
    return array.first
  }
}

let graph = [
    [], // 0
    [2,3], // 1
    [1,4,5], // 2
    [1,6,7], // 3
    [2], // 4
    [2], // 5
    [3], // 6
    [3,8], // 7
    [7] // 8
]

var visited = Array.init(repeating: false, count: graph.count)

// dfs
func dfs(start: Int) {
  visited[start] = true // 시작점
  
  print(start, terminator: " ")
  
  for i in graph[start] { // 왼쪽부터 순회
    if !visited[i] {
      // print(visited)
      dfs(start: i)
    }
  }
}

// dfs(start: 1)

var queue = Queue<Int>()
// bfs
func bfs(start: Int) {
  queue.enquque(start) // 시작점 큐에 넣기
  visited[start] = true // 시작점 방문으로 체크
  
  while !queue.isEmpty {
    guard let elem = queue.dequeue() else { return }
    print(elem, terminator: " ")
    
    for i in graph[elem] {
      if !visited[i] {
        queue.enquque(i)
        visited[i] = true
      }
    }
  }
}

// bfs(start: 1)
