// 탐욕법(Greedy) 예제 3문 풀이
// 출처: 이것이 코딩테스트 (한빛미디어, 나동빈)

import Foundation

// 1번
/*
 // 책 87p.g. 에제 3-1
 거스름돈의 종류는  500, 100, 50, 10. 각각 무한대로 존재한다고 가정.
 단, 거슬러 줘야 할 돈 N은 항상 10의 배수.
 각 동전의 거슬러 줘야하는 갯수를 구하라.

 * point: 가장큰 단위의 화폐부터 구하는 것.
 */

let coins: [Int] = [500, 100, 50, 10]

func sol(_ input: Int) -> [Int] {
  var array: [Int] = []
  var rem: Int = input
  
  for coin in coins {
    array.append(rem / coin)
    rem = rem % coin
  }
  
  return array
}


// 2번
/*
 // 3-2번: 큰수의 법칙
 
 n: 배열의 길이, m: 더할 횟수, k: 최대 반복횟수
 n = array.count
 
 배열의 원소를 m번 더해서 나올 수 있는 가장 큰 수를 찾는 것
 가 원소는 연속해서 최대 k번 반복할 수 있다.
 
 ex. [4, 5, 6] m: 8, k: 3
 6 + 6 + 6 + 5 + 6 + 6 + 6 + 5
 */

func sol2(array: [Int], m: Int, k: Int) -> Int {
  var answer: Int = 0
  var count: Int = m
  
  var sortedArray = array.sorted()
  let firstNum = sortedArray.popLast()! // 가장 큰 수
  let secondNum = sortedArray.popLast()! // 두번째로 큰 수
  
  while count != 0 {
    for _ in 0..<k {
      if count == 0 {
        break
      }
      
      answer += firstNum
      count -= 1
    }
    
    if count == 0 {
      break
    }
    
    answer += secondNum
    count -= 1
  }
  
  return answer
}

func sol2_2(array: [Int], m: Int, k: Int) -> Int {
  var answer: Int = 0
  
  var sortedArray = array.sorted()
  let firstNum = sortedArray.popLast()!
  let secondNum = sortedArray.popLast()!
  
  var count = (m / (k + 1)) * k
  count += m % (k + 1)
  
  answer += count * firstNum
  answer += (m - count) * secondNum

  return answer
}


// 3번
/*
 // 96페이지 3-3 문제: 숫자 카드 게임
 행에서 가장 작은 수들을 뽑고, 그들 중 가장 큰 수를 리턴.
 */

func sol3(metric: [[Int]])  -> Int {
  var array: [Int] = []
  
  for m in metric {
    array.append(m.min()!)
  }
  
  return array.max()!
}


func sol3_2(metric: [[Int]])  -> Int {
  var result: Int = 0
  
  for m in metric { // [1, 2, 3]
    result = max(result, m.min()!)
  }
  
  return result
}


// 4번
/*
 // 99 페이지 3-4번: 1이 될 때까지
  N 이 1이 될 떄까지 다음의 두 과정을 반복적으로 수행.
  1,2번 과정을 최소 수행 횟수를 구하라.
 
  1: N  -1
  2: N / K
 */

func sol4(n: Int, k: Int) -> Int {
  var count: Int = 0
  var rem: Int = n
  
  while rem != 1 {
    if rem % k == 0 {
      rem = rem / k
    } else {
      rem -= 1
    }
    
    count += 1
  }
  
  return count
}
