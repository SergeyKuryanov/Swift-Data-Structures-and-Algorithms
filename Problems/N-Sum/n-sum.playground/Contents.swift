func twoSumDic(_ nums: [Int], target: Int) -> [Int] {
    guard nums.count >= 2 else { return [] }

    var cache = [Int : Int]()

    for index in 0..<nums.count {
        let value = nums[index]
        let difference = target - value

        if let secondIndex = cache[difference] {
            return [index, secondIndex]
        } else {
            cache[value] = index
        }
    }

    return []
}

func twoSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 2 else { return [] }

    var nums = nums.sorted()

    var result = [[Int]]()

    var firstIndex = 0
    var secondIndex = nums.count - 1

    while firstIndex < secondIndex {
        let sum = nums[firstIndex] + nums[secondIndex]

        if sum < target {
            firstIndex += 1
        } else if sum > target {
            secondIndex -= 1
        } else {
            result.append([nums[firstIndex], nums[secondIndex]])

            repeat { firstIndex += 1 }
                while firstIndex < secondIndex && nums[firstIndex] == nums[firstIndex - 1]

            repeat { secondIndex -= 1 }
                while secondIndex > firstIndex && nums[secondIndex] == nums[secondIndex + 1]
        }
    }

    return result
}

twoSum([2,7,11,15], 9)

func threeSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 3 else { return [] }

    var nums = nums.sorted()

    var result = [[Int]]()

    for firstIndex in 0..<nums.count - 2 {
        if firstIndex > 0 && nums[firstIndex] == nums[firstIndex - 1] { continue }

        var secondIndex = firstIndex + 1
        var thirdIndex = nums.count - 1

        while secondIndex < thirdIndex {
            let sum = nums[firstIndex] + nums[secondIndex] + nums[thirdIndex]

            if sum < target {
                secondIndex += 1
            } else if sum > target {
                thirdIndex -= 1
            } else {
                result.append([nums[firstIndex], nums[secondIndex], nums[thirdIndex]])

                repeat { secondIndex += 1 }
                    while secondIndex < thirdIndex && nums[secondIndex] == nums[secondIndex - 1]

                repeat { thirdIndex -= 1 }
                    while thirdIndex > secondIndex && nums[thirdIndex] == nums[thirdIndex + 1]
            }
        }
    }

    return result
}

func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 4 else { return [] }

    var nums = nums.sorted()

    var result = [[Int]]()

    for firstIndex in 0..<nums.count - 3 {
        if firstIndex > 0 && nums[firstIndex] == nums[firstIndex - 1] { continue }

        for secondIndex in firstIndex + 1..<nums.count - 2 {
            if secondIndex > firstIndex + 1 && nums[secondIndex] == nums[secondIndex - 1] { continue }

            var thirdIndex = secondIndex + 1
            var fourIndex = nums.count - 1

            while thirdIndex < fourIndex {
                let sum = nums[firstIndex] + nums[secondIndex] + nums[thirdIndex] + nums[fourIndex]

                if sum < target {
                    thirdIndex += 1
                } else if sum > target {
                    fourIndex -= 1
                } else {
                    result.append([nums[firstIndex], nums[secondIndex], nums[thirdIndex], nums[fourIndex]])

                    repeat { thirdIndex += 1 }
                        while thirdIndex < fourIndex && nums[thirdIndex] == nums[thirdIndex - 1]

                    repeat { fourIndex -= 1 }
                        while fourIndex > thirdIndex && nums[fourIndex] == nums[fourIndex + 1]
                }
            }
        }
    }

    return result
}

let nums = [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 4, 5, 6, 7, 8, 9, 10]

twoSumDic(nums, target: 3)

twoSum(nums, 3)
threeSum(nums, 3)
fourSum(nums, 0)

func fourSumDic(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 4 else { return [] }

    var result = [[Int]]()
    var nums = nums.sorted()

    var cache = [Int: [[Int]]]()
    var results = Set<String>()

    for firstIndex in 0..<nums.count - 3 {
        if firstIndex > 0 && nums[firstIndex] == nums[firstIndex - 1] { continue }

        for secondIndex in firstIndex + 1..<nums.count - 2 {
            if secondIndex > firstIndex + 1 && nums[secondIndex] == nums[secondIndex - 1] { continue }

            let sum = nums[firstIndex] + nums[secondIndex]
            var indices = cache[sum, default: [[Int]]()]
            indices.append([firstIndex, secondIndex])
            cache[sum] = indices
        }
    }

    for thirdIndex in 2..<nums.count - 1 {
        for fourIndex in thirdIndex + 1..<nums.count {

            let sum = nums[thirdIndex] + nums[fourIndex]

            if let sums = cache[target - sum] {
                for indices in sums {
                    let firstIndex = indices.first!
                    let secondIndex = indices.last!
                    guard thirdIndex > secondIndex else { continue }

                    let numbers = [nums[firstIndex], nums[secondIndex], nums[thirdIndex], nums[fourIndex]]
                    let key = "\(numbers)"

                    if results.contains(key) { continue }
                    
                    result.append(numbers)
                    results.insert(key)
                }
            }
        }
    }

    return result
}

fourSumDic(nums, 3)
