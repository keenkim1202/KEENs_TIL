
// 이진탐색 예제
// 출처: 이코테 - 나동빈 저

import Foundation

// 1번
/*
 전자매장에는 부품이 N개 있다.
 각 부품은 정수 형태의 고유한 번호가 있다. 어느날 손님이 M개 종류의 부품을 대량으로 구매하겠다며 당일 날 견적서를 요청했다.
 나는 떄를 놓치지 않고 손님이 문의한 부품 M개 종류를 모두 확인해서 견적서를 작성해야 한다.
 이때 가게 안에 부품이 모두 있는지 확인하는 프로그램을 작성하라.
 
 가게가 현재 보유한 부품이 총 5개일 때 부품의 번호는 다음와 같다.
 N = 5
 [8, 3, 7, 9, 2]
 
 손님은 총 3개의 부품이 있는지 확인 요청했는데 부품 번호는 다음과 같다.
 M = 3
 [5, 7, 9]
 
 손님이 요청한 부품 번호의 순서대로 부품을 확인해 부품이 있으면 yes, 없으면 no를 출력하라.
 */

func binarySearch(array: [Int], target: Int) -> Int? {
    var start = 0
    var end = array.count - 1
    
    while start <= end {
        let mid = (start + end) / 2
        
        if array[mid] == target {
            return mid
        } else if array[mid] > target {
            end = mid - 1
        } else {
            start = mid + 1
        }
    }
    
    return nil
}

// 가게가 보유한 부품배열 : array
// 손님이 요청한 부품 배열 : targets
func sol1(array: [Int], targets: [Int]) -> [String] {
    let array = array.sorted()
    var result: [String] = []
    
    for target in targets {
        let index = binarySearch(array: array, target: target)
        
        if index != nil {
            result.append("yes")
        } else {
            result.append("no")
        }
    }
    
    return result
}

sol1(array: [8, 3, 7, 9, 1], targets: [5, 7, 9])


// 2번
/*
 떡볶이의 떡을 만드는데, 떡의 길이가 일정하지 않다.
 대신에 한 봉지 안에 들어가는 떡의 총 길이는 절단기로 잘라서 맞춘다.
 절단기에 높이 H를 지정하면 줄지어진 떡을 한번에 절단한다.
 높이가 H보다 긴 떡은 H 윗부분이 잘릴 것이고, 낮은 떡은 잘리지 않는다.
 
 예를 들어, 높이가 19, 14, 10, 17인 떡이 나란히 있고,
 절단기 높이를 15로 하면 잘린 떡의 길이는 4, 0, 0, 2 일 것이다.
 손님이 왔을 때 요청한 총 길이가 M일 때,
 적어도 M 만큼의 떡을 얻기 위해 설정할 수 있는 절단기의 높이의 최댓값을 구하라.
 */

// 떡볶이들의 높이 배열 : array
// 손님이 요청한 떡 길이 : target
func sol2(array: [Int], target: Int) -> Int {
    let array = array.sorted()
    var result: Int = 0
    
    var start = 0
    // var end = array.count - 1
    var end = array.max()!
    
    while start <= end {
        let mid = (start + end) / 2
        var total: Int = 0 // 손님이 가져갈 떡 길이의 합
        
        for elem in array {
            if elem > mid {
                total += (elem - mid) // 잘랐을 때 남은 떡의 길이 연산
            }
        }
        
        if total < target { // 떡의 양이 부족한 경우 더 많이 자르기 위해 왼쪽을 탐색
            end = mid - 1
        } else { // 떡의 양이 충분한 경우 덜 자르기 위해 오른쪽을 탐색
            result = mid // 최대한 덜 자른 경우를 찾기 위해 result에 현재 mid를 저장
            start = mid + 1
        }
    }
    
    return result
}

sol2(array: [19, 14, 10, 17], target: 6) // 15
